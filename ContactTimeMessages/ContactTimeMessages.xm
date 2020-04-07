
#import "Messages.h"
#import "../Util/CTUtil.h"
#import "Classes/CTDetailsTimeLabel.h"


%hook CKConversation
//provides connection from CKDetailsController to CKNavbarCanvasViewController
%property(strong, nonatomic) id ctNavCanvasViewController;
%end


%hook CKNavbarCanvasViewController
%property(strong, nonatomic) NSTimer *firstMinTimer;
%property(strong, nonatomic) NSTimer *ctTimer;
%property(strong, nonatomic) UILabel *ctLabel;
%property(strong, nonatomic) NSString *ctTZID;
%property(assign, nonatomic) BOOL shouldShowCTNavLabel;

- (void)dealloc{

	[self stopTimers];

	[self setCtLabel:nil];
	[self setCtTZID:nil];

	[[NSNotificationCenter defaultCenter] removeObserver:self];

	%orig;
}

- (void)setDelegate:(id)arg1{
	%orig;

	if (!arg1){
		[self stopTimers];
		[[NSNotificationCenter defaultCenter] removeObserver:self];
	}
}

- (id)initWithConversation:(id)arg1 navigationController:(id)arg2{
	id orig = %orig;

	[arg1 setCtNavCanvasViewController:self];
	[self setShouldShowCTNavLabel:YES];

	UILabel *label = [[UILabel alloc] init];
	[self setCtLabel:label];

	if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"13.0")){
		label.textColor = [UIColor labelColor];
	} else if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"12.0")){
		label.textColor = [UIColor blackColor];
	} else {
		label.textColor = [UIColor grayColor];
	}

	label.font = [UIFont boldSystemFontOfSize:12];
	label.text = @"--:-- XX";
	label.textAlignment = NSTextAlignmentCenter;

	if ([arg1 isGroupConversation]){
		[self setShouldShowCTNavLabel:NO];
		label.hidden = YES;
	}

	[self updateCTTimeData];

	NSNotificationCenter *notifCenter = [NSNotificationCenter defaultCenter];

	[notifCenter addObserver:self selector:@selector(stopTimers) name:@"com.lint.contacttime.message/stoptimers" object:nil];
	[notifCenter addObserver:self selector:@selector(updateCTTimeData) name:@"com.lint.contacttime.message/updatenavdata" object:nil];
	[notifCenter addObserver:self selector:@selector(updateCTTimeLabel) name:UIDeviceOrientationDidChangeNotification object:nil];

	return orig;
}

- (void)viewDidLoad{
	%orig;

	UILabel *label = [self ctLabel];

	if (label){
		[[self canvasView] addSubview:label];
	}
}

- (void)viewDidLayoutSubviews{
	%orig;

	if (!SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"12.0")  && [self shouldShowCTNavLabel]){
		UIView *titleView = [[self canvasView] titleView];
		CGRect titleFrame = titleView.frame;
		titleView.frame = CGRectMake(titleFrame.origin.x, -4, titleFrame.size.width, titleFrame.size.height);
	}
}

- (void)configureForEditing:(BOOL)arg1{
	%orig;

	if ([self shouldShowCTNavLabel]){
		[self ctLabel].hidden = arg1;
	}
}

- (void) updateTitle:(id)arg1 animated:(BOOL)arg2{
	%orig;

	[self updateCTTimeLabel];
}

%new
- (void)updateCTTimeData{

	CNContact *contact = [[[self conversation] recipient] cnContact];

	if (contact){

		CTUtil *ctUtil = [%c(CTUtil) sharedInstance];
		NSString *savedTZID = [ctUtil stringForKey:[contact identifier]];
		UILabel *label = [self ctLabel];

		if (savedTZID && ![savedTZID isEqualToString:@"not set"]){

			[self setCtTZID:savedTZID];
			[self updateCTTimeLabel];
			[self createAndStartTimers];

			[self setShouldShowCTNavLabel:YES];
			label.hidden = NO;
		} else {

			[self setShouldShowCTNavLabel:NO];
			label.hidden = YES;
		}

		if ([[%c(CTUtil) sharedInstance] prefsBoolForKey:@"isNavTimeEnabled"]){
			[self setShouldShowCTNavLabel:YES];
			label.hidden = NO;
		} else {
			[self setShouldShowCTNavLabel:NO];
			label.hidden = YES;
		}
	}
}

%new
- (void)updateCTTimeLabel{

	if ([self ctLabel] && [self ctTZID]){
		[self ctLabel].text = [[%c(CTUtil) sharedInstance] timeStringForTZID:[self ctTZID]];
		[self updateCTTimeLabelFrame];
	}
}

%new
- (void)updateCTTimeLabelFrame{
	if ([self shouldShowCTNavLabel]){
		UILabel *label = [self ctLabel];

		CGRect titleFrame = [[self canvasView] titleView].frame;
		CGSize textSize = [[label text] sizeWithAttributes:@{NSFontAttributeName:[label font]}];
		CGFloat textWidthAdjusted = textSize.width + 12;
		CGFloat canvasViewWidth = [[self canvasView] frame].size.width;
		CGFloat canvasViewHeight;

		if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"12.0")){
			canvasViewHeight = [self _canShowAvatarView] ? [%c(CKNavigationBarCanvasView) heightWithoutButtonViews] : [%c(CKNavigationBarCanvasView) heightWithoutButtonViewsContactless];

			CGFloat labelXOrigin = (titleFrame.origin.x + titleFrame.size.width + canvasViewWidth - textWidthAdjusted) / 2;

			if (labelXOrigin + textWidthAdjusted < canvasViewWidth){
				label.frame = CGRectIntegral(CGRectMake(labelXOrigin, (canvasViewHeight - textSize.height) / 2, textWidthAdjusted, textSize.height));
			} else {
				label.frame = CGRectIntegral(CGRectMake(canvasViewWidth - textWidthAdjusted - 2, canvasViewHeight - textSize.height - 2, textWidthAdjusted, textSize.height));
			}
		} else {
			canvasViewHeight = [[self canvasView] frame].size.height;

			[[self canvasView] titleView].frame = CGRectMake(titleFrame.origin.x, -4, titleFrame.size.width, titleFrame.size.height);
			label.frame = CGRectIntegral(CGRectMake((canvasViewWidth - textWidthAdjusted) / 2, canvasViewHeight - textSize.height - 2, textWidthAdjusted, textSize.height));
		}
	}
}

%new
- (void)createAndStartTimers{

	CGFloat timeUntilFire = [[%c(CTUtil) sharedInstance] timeUntilNextMin];

	NSTimer *firstMinTimer = [self firstMinTimer];
	NSTimer *ctTimer = [self ctTimer];

	[firstMinTimer invalidate];
	[ctTimer invalidate];

	firstMinTimer = [NSTimer scheduledTimerWithTimeInterval:timeUntilFire repeats:NO block:^(NSTimer *timer){
		[self updateCTTimeLabel];
		[self performSelectorOnMainThread:@selector(createCTTimer) withObject:nil waitUntilDone:NO];
	}];

	[self setFirstMinTimer:firstMinTimer];
}

%new
- (void)createCTTimer{
	NSTimer *ctTimer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(updateCTTimeLabel) userInfo:nil repeats:YES];
	[self setCtTimer:ctTimer];
}

%new
- (void)stopTimers{

	[[self ctTimer] invalidate];
	[[self firstMinTimer] invalidate];

	[self setCtTimer:nil];
	[self setFirstMinTimer:nil];
}

%end


%hook CKDetailsContactsStandardTableViewCell
%property(strong, nonatomic) CTDetailsTimeLabel *ctTimeLabel;

- (void)layoutSubviews{
	%orig;

	CTDetailsTimeLabel *label = [self ctTimeLabel];

	if (label){

		UILabel *nameLabel = [self nameLabel];
		UILabel *locationLabel = [self locationLabel];
		CGSize textSize = [[label text] sizeWithAttributes:@{NSFontAttributeName:label.font}];
		CGFloat labelYOrigin = [self frame].size.height - textSize.height - 8;

		if ([self showsLocation]){

			CGRect nameFrame = nameLabel.frame;
			CGRect locFrame = locationLabel.frame;

			nameLabel.frame = CGRectMake(nameFrame.origin.x, nameFrame.origin.y - 8, nameFrame.size.width, nameFrame.size.height);
			locationLabel.frame = CGRectMake(locFrame.origin.x, locFrame.origin.y - 8, locFrame.size.width, locFrame.size.height);
		}

		label.frame = CGRectIntegral(CGRectMake(nameLabel.frame.origin.x, labelYOrigin, textSize.width + 12, textSize.height));
	}
}

%end


%hook CKDetailsController
%property(strong, nonatomic) NSTimer *ctTimer;
%property(strong, nonatomic) NSTimer *firstMinTimer;
%property(strong, nonatomic) NSMutableArray *ctLabels;

- (id)initWithConversation:(id)arg1{

	[self setCtLabels:[[NSMutableArray alloc] init]];

	NSNotificationCenter *notifCenter = [NSNotificationCenter defaultCenter];

	[notifCenter addObserver:self selector:@selector(stopTimers) name:@"com.lint.contacttime.message/stoptimers" object:nil];
	[notifCenter addObserver:self selector:@selector(updateCTTimeData) name:@"com.lint.contacttime.message/updatedetailsdata" object:nil];

	return %orig;
}

- (id)contactsManagerCellForIndexPath:(NSIndexPath *)arg1{
	id orig = %orig;

	CTUtil *ctUtil = [%c(CTUtil) sharedInstance];
	BOOL isSingleDetailTimeEnabled = [ctUtil prefsBoolForKey:@"isSingleDetailTimeEnabled"];
	BOOL isGroupDetailTimeEnabled = [ctUtil prefsBoolForKey:@"isGroupDetailTimeEnabled"];
	BOOL isGroupConversation = [[self conversation] isGroupConversation];

	if ((isGroupConversation && isGroupDetailTimeEnabled) || (!isGroupConversation && isSingleDetailTimeEnabled)){
		if ([orig isKindOfClass:[%c(CKDetailsContactsStandardTableViewCell)class]]){

			CNContact *contact = [orig contact];
			CTDetailsTimeLabel *label = [orig ctTimeLabel];

			if (!label){
				label = [[%c(CTDetailsTimeLabel) alloc] init];

				label.text = @"--:-- XX";
				label.textColor = [UIColor grayColor];
				label.font = [UIFont systemFontOfSize:[orig nameLabel].font.pointSize - 3];
				label.contactID = [contact identifier];

				NSString *tzID = [ctUtil stringForKey:[contact identifier]];

				if (tzID && ![tzID isEqualToString:@"not set"]){
					label.text = [ctUtil timeStringForTZID:tzID];
					label.tzID = tzID;
					label.hidden = NO;
				} else {
					label.hidden = YES;
				}

				[orig setCtTimeLabel:label];
				[orig addSubview:label];

				[[self ctLabels] addObject:label];
			}
		}
	}

	return orig;
}

- (void)dealloc{

	[self stopTimers];
	[self setCtLabels:nil];

	[[NSNotificationCenter defaultCenter] removeObserver:self];

	%orig;
}

- (void)viewDidAppear:(BOOL)arg1{
	%orig;

	[self updateCTTimeData];
}

- (void)viewDidDisappear:(BOOL)arg1{
	%orig;

	[self stopTimers];
	[[[self conversation] ctNavCanvasViewController] updateCTTimeData];
}

%new
- (void)updateCTTimeData{

	NSArray *labels = [self ctLabels];
	CTUtil *ctUtil = [%c(CTUtil) sharedInstance];
	BOOL shouldStartTimers = NO;

	for (CTDetailsTimeLabel *label in labels){

		NSString *savedTZID = [ctUtil stringForKey:[label contactID]];

		if (savedTZID && ![savedTZID isEqualToString:@"not set"]){
			shouldStartTimers = YES;
			label.tzID = savedTZID;
		}
	}

	if (shouldStartTimers){
		[self createAndStartTimers];
	}

	[self updateCTTimeLabels];
}

%new
- (void)updateCTTimeLabels{

	CTUtil *ctUtil = [%c(CTUtil) sharedInstance];
	NSArray *labels = [self ctLabels];

	for (CTDetailsTimeLabel *label in labels){
		NSString *tzID = label.tzID;

		if (tzID){
			label.hidden = NO;
			label.text = [ctUtil timeStringForTZID:tzID];
		} else {
			label.hidden = YES;
		}
	}
}

%new
- (void)createAndStartTimers{

	CGFloat timeUntilFire = [[%c(CTUtil) sharedInstance] timeUntilNextMin];

	NSTimer *firstMinTimer = [self firstMinTimer];
	NSTimer *ctTimer = [self ctTimer];

	[firstMinTimer invalidate];
	[ctTimer invalidate];

	firstMinTimer = [NSTimer scheduledTimerWithTimeInterval:timeUntilFire repeats:NO block:^(NSTimer *timer){
		[self updateCTTimeLabels];
		[self performSelectorOnMainThread:@selector(createCTTimer) withObject:nil waitUntilDone:NO];
	}];

	[self setFirstMinTimer:firstMinTimer];
}

%new
- (void)createCTTimer{
	NSTimer *ctTimer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(updateCTTimeLabels) userInfo:nil repeats:YES];
	[self setCtTimer:ctTimer];
}

%new
- (void)stopTimers{

	[[self ctTimer] invalidate];
	[[self firstMinTimer] invalidate];

	[self setCtTimer:nil];
	[self setFirstMinTimer:nil];
}

%end


%ctor{
	if ([[%c(CTUtil) sharedInstance] prefsBoolForKey:@"isEnabled"]){
		%init;
	}
}
