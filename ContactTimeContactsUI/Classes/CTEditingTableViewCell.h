
#import "../ContactsUI.h"

@interface CTEditingTableViewCell : CNContactCell <UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>
@property(strong, nonatomic) UILabel *label;
@property(strong, nonatomic) NSArray *timezones;
@property(strong, nonatomic) NSArray *timezoneIds;
@property(strong, nonatomic) UIPickerView *picker;
@property(strong, nonatomic) UITextField *textField;
@property(strong, nonatomic) UILabel *textFieldDisplayLabel;
@property(strong, nonatomic) CNRepeatingGradientSeparatorView *vertSeparatorView;
@property(strong, nonatomic) CNContactContentViewController *contactViewController;
@property(strong, nonatomic) NSString *origTZText;
@property(strong, nonatomic) NSString *currTZText;
@property(assign, nonatomic) BOOL pickerHasChanges;
- (void)cellWasSelected;
@end
