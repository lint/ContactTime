
#import "../Util/CTUtil.h"
#import "ContactsUI.h"
#import "Classes/CTEditingTableViewCell.h"
#import "Classes/CTInfoTableViewCell.h"


%hook CNContactContentViewController
%property(strong, nonatomic) CNCardGroup *ctInfoGroup;
%property(strong, nonatomic) CNCardGroup *ctEditingGroup;
%property(strong, nonatomic) id ctInfoTableViewCell;
%property(strong, nonatomic) id ctEditingTableViewCell;
%property(assign, nonatomic) NSInteger ctInfoSection;
%property(assign, nonatomic) NSInteger ctEditingSection;
%property(assign, nonatomic) BOOL overridingSysHasChanges;

- (NSMutableArray *)displayGroups{

	NSMutableArray *orig = %orig;

	if (![self isEditing]){
		CNCardGroup *ctInfoGroup = [self ctInfoGroup];

		if (!ctInfoGroup){
			ctInfoGroup = [%c(CNCardGroup) groupForContact:[self contact]];
			[ctInfoGroup addActionWithTitle:@"CT_INFO_PLACEHOLDER" target:nil selector:nil];
			[ctInfoGroup setAddSpacerFromPreviousGroup:YES];

			[self setCtInfoGroup:ctInfoGroup];
		}

		if (![orig containsObject:ctInfoGroup] && ctInfoGroup){
			[orig addObject:ctInfoGroup];
		}

		[self setCtInfoSection:[orig indexOfObject:ctInfoGroup]];
	}

	return orig;
}

- (NSMutableArray *)editingGroups{

	NSMutableArray *orig = %orig;

	if ([self isEditing]){
		CNCardGroup *ctEditingGroup = [self ctEditingGroup];

		if (!ctEditingGroup){
			ctEditingGroup = [%c(CNCardGroup) groupForContact:[self contact]];;
			[ctEditingGroup addActionWithTitle:@"CT_EDITING_PLACEHOLDER" target:nil selector:nil];

			[self setCtEditingGroup:ctEditingGroup];
		}

		if (![orig containsObject:ctEditingGroup] && ctEditingGroup){
			if ([[self contact] isUnknown] || ![self allowsDeletion]){
				[orig insertObject:ctEditingGroup atIndex:[orig count]];
			} else {
				[orig insertObject:ctEditingGroup atIndex:[orig count] - 2];
			}
		}

		[self setCtEditingSection:[orig indexOfObject:ctEditingGroup]];
	}

	return orig;
}

- (id)tableView:(UITableView *)arg1 cellForRowAtIndexPath:(NSIndexPath *)arg2{

	if ([arg1 isKindOfClass:[%c(CNContactView) class]]){

		CTUtil *ctUtil = [%c(CTUtil) sharedInstance];
		NSString *contactID = [[self contact] identifier];
		NSString *savedTZID = [ctUtil stringForKey:contactID];
		NSString *savedTZText = [ctUtil timezoneTextForTZID:savedTZID];

		if (![self isEditing]){
			if ([arg2 section] == [self ctInfoSection] && [arg2 row] == 0){

				[self createCTCellsIfNecessary];

				CTInfoTableViewCell *cell = [self ctInfoTableViewCell];

				UILabel *titleLabel = cell.titleLabel;
				UILabel *tzLabel = cell.tzLabel;

				titleLabel.text = ([ctUtil isContactUnsynced:contactID] && savedTZText) ? @"Timezone (Not synced with SpringBoard)" : @"Timezone";
				titleLabel.font = [UIFont systemFontOfSize:14];

				if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"13.0")){
					titleLabel.textColor = [UIColor labelColor];
				} else {
					titleLabel.textColor = [UIColor blackColor];
				}

				if (savedTZText){
					tzLabel.text = savedTZText;
				} else {
					tzLabel.text = @"not set";
				}

				tzLabel.font = [UIFont systemFontOfSize:12];
				tzLabel.textColor = [UIColor grayColor];

				CGSize titleTextSize = [[titleLabel text] sizeWithAttributes:@{NSFontAttributeName:[titleLabel font]}];
				CGSize tzTextSize = [[tzLabel text] sizeWithAttributes:@{NSFontAttributeName:[tzLabel font]}];

				titleLabel.frame = CGRectIntegral(CGRectMake(15, 6, cell.frame.size.width - 15 - 15, titleTextSize.height));
				tzLabel.frame = CGRectIntegral(CGRectMake(15, titleLabel.frame.origin.y + titleLabel.frame.size.height + 2, cell.frame.size.width - 15 - 15, tzTextSize.height));

				return cell;
			}
		} else {
			if ([arg2 section] == [self ctEditingSection] && [arg2 row] == 0){

				[self createCTCellsIfNecessary];

				CTEditingTableViewCell *cell = [self ctEditingTableViewCell];

				cell.label.text = @"edit timezone";
				cell.label.font = [UIFont systemFontOfSize:14];
				cell.label.textColor = [UIColor systemBlueColor];

				return cell;
			}
		}
	}

	return %orig;
}

- (void)tableView:(UITableView *)arg1 didSelectRowAtIndexPath:(NSIndexPath *)arg2{

	CNContact *contact = [self contact];

	if ([arg1 isKindOfClass:[%c(CNContactView) class]] ){
		if (![self isEditing]){
			if ([arg2 section] == [self ctInfoSection] && [arg2 row] == 0){

				CTUtil *ctUtil = [%c(CTUtil) sharedInstance];
				NSString *savedTZID = [ctUtil stringForKey:[contact identifier]];

				NSString *message = @"CT_INFO_PLACEHOLDER";

				if (savedTZID && ![savedTZID isEqualToString:@"not set"]){

					NSInteger timeDiff = [ctUtil timeDifferenceForTZID:savedTZID];
					NSDate *date = [[NSDate date] dateByAddingTimeInterval:timeDiff];

					NSNumber *timeDiffFormatted = [NSNumber numberWithDouble:(long)timeDiff / 3600.];
					NSString *timeDiffString = [NSString stringWithFormat:@"%@%@", timeDiff > 0 ? @"+" : @"", timeDiffFormatted];
					NSString *timeString = [ctUtil formattedTimeStringForDate:date];

					message = [NSString stringWithFormat:@"Local Time: %@\nTime Difference: %@ hours", timeString, timeDiffString];
				}

				if ([[[self ctInfoTableViewCell] tzLabel].text isEqualToString:@"not set"]){
					message = @"No timezone found. Edit this contact to set their timezone.";
				}

				NSString *savedTZText = [ctUtil timezoneTextForTZID:savedTZID];
				[[self ctInfoTableViewCell] tzLabel].text = savedTZText ? savedTZText : @"not set";

				UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Timezone Info" message:message preferredStyle:UIAlertControllerStyleAlert];
				UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
				[alertController addAction:actionOk];
				[self presentViewController:alertController animated:YES completion:nil];
			}
		} else {
			if ([arg2 section] == [self ctEditingSection] && [arg2 row] == 0){

				[[self ctEditingTableViewCell] cellWasSelected];
			}
		}
	}

	%orig;
}

- (void)tableView:(UITableView *)arg1 accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)arg2{

	if ([arg1 isKindOfClass:[%c(CNContactView) class]] && [self isEditing]){
		if ([arg2 section] == [self ctEditingSection] && [arg2 row] == 0){

			UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Couldn't find their timezone?" message:@"Open www.timeanddate.com and search for their location to find the timezone. Note: due to daylight savings, the offsets, e.g. (UTC+00:00), may differ from those on the site. ContactTime's option labels are the non-DST version." preferredStyle:UIAlertControllerStyleAlert];

			UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
			UIAlertAction *openAction = [UIAlertAction actionWithTitle:@"Open Search" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
				SFSafariViewController *webViewController = [[%c(SFSafariViewController) alloc] initWithURL:[NSURL URLWithString:@"https://www.timeanddate.com/worldclock/search.html"]];
				[self presentViewController:webViewController animated:YES completion:nil];
			}];
			[alertController addAction:cancelAction];
			[alertController addAction:openAction];

			[self presentViewController:alertController animated:YES completion:nil];
		}
	}
}

- (void)toggleEditing:(id)arg1{

	NSString *contactID = [[self contact] identifier];
	CTUtil *ctUtil = [%c(CTUtil) sharedInstance];

	if ([self isEditing] && contactID){
		NSString *selectedTZText = [[[self ctEditingTableViewCell] textFieldDisplayLabel] text];
		NSString *selectedTZID = [ctUtil tzIDForTimezoneText:selectedTZText];

		if (selectedTZText && selectedTZID){
			[ctUtil setObject:selectedTZID forKey:contactID];

			if (![ctUtil testConnection]){
				[ctUtil addUnsyncedContact:contactID];
			}

			NSNotificationCenter *notifCenter = [NSNotificationCenter defaultCenter];
			[notifCenter postNotificationName:@"com.lint.contacttime.message/updatedetailsdata" object:nil];
			[notifCenter postNotificationName:@"com.lint.contacttime.message/updatenavdata" object:nil];
		}
	}

	[self updateCTLabels];

	%orig;
}

- (BOOL)_modelHasChanges{
	if ([self overridingSysHasChanges]){
		return YES;
	}
	return %orig;
}

- (void)updateDoneButton{
	BOOL sysHasChanges = [self _modelHasChanges];
	BOOL ctHasChanges = [[self ctEditingTableViewCell] pickerHasChanges];

	if (ctHasChanges && !sysHasChanges){
		[self setOverridingSysHasChanges:YES];
	}

	%orig;

	[self setOverridingSysHasChanges:NO];
}

- (void)setupWithOptions:(id)arg1 readyBlock:(id)arg2{

	%orig;

	if ([self isEditing] || (![self isEditing] && ![[self contact] isUnknown])){

		[self createCTCellsIfNecessary];
		[self updateCTLabels];
	}
 }

 %new
 - (void)createCTCellsIfNecessary{

	CTInfoTableViewCell *infoCell = [self ctInfoTableViewCell];
	CTEditingTableViewCell *editingCell = [self ctEditingTableViewCell];

	if (!infoCell){
		infoCell = [[%c(CTInfoTableViewCell) alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ctinfocell"];
		[self setCtInfoTableViewCell:infoCell];
	}

	if (!editingCell){
		editingCell = [[%c(CTEditingTableViewCell) alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cteditingcell"];
		[editingCell setContactViewController:self];
		[self setCtEditingTableViewCell:editingCell];
	}
}

%new
- (void)updateCTLabels{

	CTUtil *ctUtil = [%c(CTUtil) sharedInstance];

	NSString *contactID =  [[self contact] identifier];
	NSString *savedTZID = [ctUtil stringForKey:contactID];
	NSString *savedTZText = [ctUtil timezoneTextForTZID:savedTZID];

	CTInfoTableViewCell *infoCell = [self ctInfoTableViewCell];
	CTEditingTableViewCell *editingCell = [self ctEditingTableViewCell];

	infoCell.titleLabel.text = [ctUtil isContactUnsynced:contactID] ? @"Timezone (Not synced with system)" : @"Timezone";

	if (savedTZText){
		[editingCell.picker selectRow:[ctUtil indexForTimezoneText:savedTZText] inComponent:0 animated:NO];
		editingCell.textFieldDisplayLabel.text = savedTZText;
		editingCell.origTZText = savedTZText;
		editingCell.textField.text = @" ";

		infoCell.tzLabel.text = savedTZText;
	} else {
		[editingCell.picker selectRow:0 inComponent:0 animated:NO];
		editingCell.textFieldDisplayLabel.text = nil;
		editingCell.origTZText = @"not set";
		editingCell.textField.text = nil;

		infoCell.tzLabel.text = @"not set";
	}
}

%end


static void loadPrefs(){
	[[%c(CTUtil) sharedInstance] reloadPrefs];
}


%ctor{

	CTUtil *ctUtil = [%c(CTUtil) sharedInstance];
	if ([ctUtil prefsBoolForKey:@"isEnabled"]){

		[[NSNotificationCenter defaultCenter] addObserver:ctUtil selector:@selector(applicationEnteredForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:ctUtil selector:@selector(applicationEnteredBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];

		CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)loadPrefs, CFSTR("com.lint.contacttime.prefs/prefschanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);

		%init;
	}
}
