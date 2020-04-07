
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@class CPDistributedMessagingCenter;

@interface CTUtil : NSObject
@property(strong, nonatomic) NSArray *timezones;
@property(strong, nonatomic) NSArray *timezoneIds;
@property(strong, nonatomic) NSDateFormatter *dateFormatter;
@property(strong, nonatomic) NSUserDefaults *defaults;
@property(strong, nonatomic) CPDistributedMessagingCenter *messagingCenter;
@property(strong, nonatomic) NSDictionary *loadedContactsData;
@property(strong, nonatomic) NSMutableArray *unsyncedContacts;
@property(strong, nonatomic) NSMutableDictionary *prefs;
+ (void)load;
+ (id)sharedInstance;
- (void)saveContactsData;
- (void)loadContactsData;
- (BOOL)contactsDataWasModified;
- (BOOL)testConnection;
- (void)applicationEnteredForeground;
- (void)applicationEnteredBackground;
- (BOOL)hasUnsyncedData;
- (void)addUnsyncedContact:(NSString *)arg1;
- (BOOL)isContactUnsynced:(NSString *)arg1;
- (void)reloadPrefs;
- (BOOL)prefsBoolForKey:(NSString *)arg1;
- (NSString *)stringForKey:(NSString *)arg1;
- (void)setObject:(id) arg1 forKey:(NSString *)arg1;
- (NSString *)tzIDForTimezoneText:(NSString *)arg1;
- (NSString *)timezoneTextForTZID:(NSString *)arg1;
- (NSString *)timeStringForTZID:(NSString *)arg1;
- (NSDate *)dateForTZID:(NSString *)arg1;
- (NSInteger)indexForTimezoneText:(NSString *)arg1;
- (NSInteger)indexForTZID:(NSString *)arg1;
- (NSInteger)timeDifferenceForTZID:(NSString *)arg1;
- (NSString *)formattedTimeStringForDate:(NSDate *)arg1;
- (CGFloat)timeUntilNextMin;
@end

@interface UIColor (stuff)
+ (UIColor *)systemBlueColor;
+ (UIColor *)labelColor;
@end
