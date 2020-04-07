
#import "../ContactTimeContactsUI/ContactsUI.h"

@class CTDetailsTimeLabel;

@interface CKEntity
@property(strong, nonatomic) CNContact *cnContact;
@end

@interface CKConversation
@property(strong, nonatomic) NSArray *recipients;
@property(strong, nonatomic) CKEntity *recipient;
- (BOOL)isGroupConversation;

//custom elements
@property(strong, nonatomic) id ctNavCanvasViewController;
@end

@interface CKLabel : UILabel
@end

@interface CKNavigationBarCanvasView : UIView
@property(assign, nonatomic) CGFloat preferredHeight;
@property(assign, nonatomic) BOOL isShowingControls;
@property(strong, nonatomic) UIView *titleView;
+ (CGFloat)heightWithoutButtonViews;
+ (CGFloat)heightWithoutButtonViewsContactless;
@end

@interface CKNavbarCanvasViewController : UIViewController
@property(strong, nonatomic) CKConversation *conversation;
@property(strong, nonatomic) CKNavigationBarCanvasView *canvasView;
@property(strong, nonatomic) CKLabel *defaultLabel;
@property(assign, nonatomic) BOOL editing;
@property(strong, nonatomic) NSString *navbarTitle;
- (BOOL)_canShowAvatarView;
- (void)updateTitle:(id) arg1 animated:(BOOL) arg2;

//custom elements
@property(strong, nonatomic) NSTimer *firstMinTimer;
@property(strong, nonatomic) NSTimer *ctTimer;
@property(strong, nonatomic) UILabel *ctLabel;
@property(strong, nonatomic) NSString *ctTZID;
@property(assign, nonatomic) BOOL shouldShowCTNavLabel;
- (void)updateCTTimeData;
- (void)updateCTTimeLabel;
- (void)updateCTTimeLabelFrame;
- (void)createAndStartTimers;
- (void)createCTTimer;
- (void)stopTimers;
@end

@interface CKDetailsController : UIViewController
@property(strong, nonatomic) CKConversation *conversation;

//custom elements
@property(strong, nonatomic) NSTimer *ctTimer;
@property(strong, nonatomic) NSTimer *firstMinTimer;
@property(strong, nonatomic) NSMutableArray *ctLabels;
- (void)createAndStartTimers;
- (void)createCTTimer;
- (void)updateCTTimeData;
- (void)updateCTTimeLabels;
- (void)stopTimers;
@end

@interface CKDetailsContactsStandardTableViewCell : UITableViewCell
@property(strong, nonatomic) CNContact *contact;
@property(strong, nonatomic) CKLabel *nameLabel;
@property(strong, nonatomic) id delegate;
@property(strong, nonatomic) UILabel *locationLabel;
@property(assign, nonatomic) BOOL showsLocation;

//custom elements
@property(strong, nonatomic) CTDetailsTimeLabel *ctTimeLabel;
@end
