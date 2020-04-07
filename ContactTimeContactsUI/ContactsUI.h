
/* -- ContactsUI -- */

@interface CNCardGroup
@property(assign, nonatomic) BOOL addSpacerFromPreviousGroup;
- (id)initWithContact:(id)arg1;
- (void)addAction:(id)arg1 withTitle:(id)arg2;
- (id)addActionWithTitle:(id)arg1 target:(id)arg2 selector:(SEL)arg3;
+ (id)groupForContact:(id)arg1;
@end

@interface CNContact
@property(strong, nonatomic) NSString *identifier;
- (BOOL)isUnknown;
@end

@interface CNMutableContact : CNContact
@end

@interface CNContactContentViewController : UIViewController <UITableViewDataSource>
@property(strong, nonatomic) UITableView *tableView;
@property(strong, nonatomic) CNContact *contact;
@property(assign, nonatomic) BOOL allowsDeletion;
- (void)updateDoneButton;
- (BOOL)_modelHasChanges;

//custom elements
@property(strong, nonatomic) CNCardGroup *ctInfoGroup;
@property(strong, nonatomic) CNCardGroup *ctEditingGroup;
@property(strong, nonatomic) id ctInfoTableViewCell;
@property(strong, nonatomic) id ctEditingTableViewCell;
@property(assign, nonatomic) NSInteger ctInfoSection;
@property(assign, nonatomic) NSInteger ctEditingSection;
@property(assign, nonatomic) BOOL overridingSysHasChanges;
- (void)createCTCellsIfNecessary;
- (void)updateCTLabels;
@end

@interface CNContactView
@end

@interface CNContactAction
@property(strong, nonatomic) UIColor *color;
@end

@interface CNContactCell : UITableViewCell
@end

@interface CNPropertySimpleCell : CNContactCell
@property(strong, nonatomic) UILabel *labelLabel;
@property(strong, nonatomic) UILabel *valueLabel;
@end

@interface CNLabeledCell : CNContactCell
@property(strong, nonatomic) NSString *labelString;
@property(strong, nonatomic) UIView *labelView;
@end

@interface CNDatePickerContainerView : UIView
@property(strong, nonatomic) UIDatePicker *datePicker;
@end

@interface CNRepeatingGradientSeparatorView : UIView
@end

/* -- Safari Web View -- */

@interface SFSafariViewController : UIViewController
- (id)initWithURL:(id)arg1 configuration:(id)arg2;
- (id)initWithURL:(id)arg1;
@end
