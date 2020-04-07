
#import "CTEditingTableViewCell.h"
#import "CTPickerRowView.h"
#import "../../Util/CTUtil.h"

@implementation CTEditingTableViewCell
@synthesize label, timezones, timezoneIds, picker, textField, textFieldDisplayLabel, vertSeparatorView, contactViewController, origTZText, currTZText, pickerHasChanges;

- (id)initWithStyle:(UITableViewCellStyle)arg1 reuseIdentifier:(NSString *)arg2{

	self = [super initWithStyle:arg1 reuseIdentifier:arg2];

	if (self){

		self.editingAccessoryType = UITableViewCellAccessoryDetailButton;

		timezones = [[%c(CTUtil) sharedInstance] timezones];

		label = [[UILabel alloc] initWithFrame:[[self contentView] frame]];
		textField = [[UITextField alloc] init];
		textFieldDisplayLabel = [[UILabel alloc] initWithFrame:textField.frame];
		picker = [[UIPickerView alloc] init];
		vertSeparatorView = [[%c(CNRepeatingGradientSeparatorView) alloc] initWithFrame:CGRectMake(0, 0, .5, 44)];
		pickerHasChanges = NO;

		[self addSubview:label];
		[self addSubview:vertSeparatorView];
		[self addSubview:textField];
		[textField addSubview:textFieldDisplayLabel];

		textField.tintColor = [UIColor clearColor];
		textField.font = [UIFont systemFontOfSize:11];
		textField.placeholder = @"timezone";
		textField.inputView = picker;

		textFieldDisplayLabel.font = [UIFont systemFontOfSize:11];

		if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"13.0")){
			textFieldDisplayLabel.textColor = [UIColor labelColor];
		} else {
			textFieldDisplayLabel.textColor = [UIColor blackColor];
		}

		picker.translatesAutoresizingMaskIntoConstraints = NO;
		picker.dataSource = self;
		picker.delegate = self;
	}

	return self;
}

- (void)layoutSubviews{
	[super layoutSubviews];

	CGRect contentViewFrame =  self.contentView.frame;
	CGSize textSize = [[label text] sizeWithAttributes:@{NSFontAttributeName:[label font]}];

	label.bounds = CGRectIntegral(CGRectMake(contentViewFrame.origin.x, contentViewFrame.origin.y, textSize.width + 16, contentViewFrame.size.height));
	label.frame = CGRectInset(label.bounds, 8, 8);

	vertSeparatorView.frame = CGRectMake(label.frame.origin.x + label.frame.size.width + 10, (contentViewFrame.size.height - 44 * .75) / 2, .5, 44 * .75);
	textField.frame = CGRectMake(vertSeparatorView.frame.origin.x + 10, contentViewFrame.origin.y, self.frame.size.width - vertSeparatorView.frame.origin.x - 10 - 15 - 28, contentViewFrame.size.height);
	textFieldDisplayLabel.frame = CGRectMake(0,0, textField.frame.size.width, textField.frame.size.height);
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
	return [timezones count];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)arg3 reusingView:(UIView *)arg4{

	if (arg4){
		return arg4;
	}

	CTPickerRowView *pickerRowView = [[%c(CTPickerRowView) alloc] init];
	pickerRowView.label.text = timezones[row];

	return pickerRowView;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{

	NSString *tzText = timezones[row];

	textField.text = @" ";
	textFieldDisplayLabel.text = tzText;
	currTZText = tzText;

	if ([currTZText isEqualToString:origTZText]){
		pickerHasChanges = NO;
	} else {
		pickerHasChanges = YES;
	}

	[contactViewController updateDoneButton];
}

- (void)cellWasSelected{
	[textField becomeFirstResponder];
}

@end
