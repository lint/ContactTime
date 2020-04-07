
@class CPDistributedMessagingCenter;

@interface CTSBServer : NSObject
@property(strong, nonatomic) CPDistributedMessagingCenter *messagingCenter;
@property(strong, nonatomic) NSUserDefaults *defaults;
@property(assign, nonatomic) BOOL shouldClearData;
- (void)saveContactsData:(NSString *)name withUserInfo:(NSDictionary *)userInfo;
- (NSDictionary *)getContactsData:(NSString *)name withUserInfo:(NSDictionary *)userInfo;
- (NSDictionary *)testConnection:(NSString *)name withUserInfo:(NSDictionary *)userInfo;
- (void)willClearData:(NSString *)name withUserInfo:(NSDictionary *)userInfo;
@end
