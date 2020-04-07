
#import <AppSupport/CPDistributedMessagingCenter.h>
#import <rocketbootstrap/rocketbootstrap.h>

#import "CTSBServer.h"

@implementation CTSBServer
@synthesize messagingCenter, defaults, shouldClearData;

+ (void)load{
	[self sharedInstance];
}

+ (instancetype)sharedInstance{
	static CTSBServer* sharedInstance = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^
	{
		sharedInstance = [CTSBServer new];
	});

	return sharedInstance;
}

- (instancetype)init{
	if ((self = [super init])){

		defaults = [[NSUserDefaults alloc] initWithSuiteName:@"com.lint.contacttime.data"];
		shouldClearData = NO;

		messagingCenter = [%c(CPDistributedMessagingCenter) centerNamed:@"com.lint.contacttime.messagingcenter"];
		rocketbootstrap_distributedmessagingcenter_apply(messagingCenter);
		[messagingCenter runServerOnCurrentThread];

		[messagingCenter registerForMessageName:@"com.lint.contacttime.message/savecontactdata" target:self selector:@selector(saveContactsData:withUserInfo:)];
		[messagingCenter registerForMessageName:@"com.lint.contacttime.message/getcontactdata" target:self selector:@selector(getContactsData:withUserInfo:)];
		[messagingCenter registerForMessageName:@"com.lint.contacttime.message/testrbsconnection" target:self selector:@selector(testConnection:withUserInfo:)];
		//[messagingCenter registerForMessageName:@"com.lint.contacttime.message/cleardata" target:self selector:@selector(clearData:withUserInfo:)];
	}

	return self;
}

- (void)saveContactsData:(NSString *)name withUserInfo:(NSDictionary *)userInfo{

	NSMutableDictionary *data = [[defaults objectForKey:@"ctData"] mutableCopy];

	if (!data){
		data = [[NSMutableDictionary alloc] init];
	}

	[data addEntriesFromDictionary:userInfo];
	[defaults setObject:data forKey:@"ctData"];
}

- (NSDictionary *)getContactsData:(NSString *)name withUserInfo:(NSDictionary *)userInfo{

	NSDictionary *data = [defaults objectForKey:@"ctData"];

	if (!data || shouldClearData){
		shouldClearData = NO;
		data =  @{};
		[defaults setObject:data forKey:@"ctData"];
	}

	return data;
}

- (NSDictionary *)testConnection:(NSString *)name withUserInfo:(NSDictionary *)userInfo{
	return @{@"test" : @"YES"};
}

- (void)willClearData:(NSString *)name withUserInfo:(NSDictionary *)userInfo{
	shouldClearData = YES;
}

@end
