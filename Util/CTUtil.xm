
#import <AppSupport/CPDistributedMessagingCenter.h>
#import <rocketbootstrap/rocketbootstrap.h>

#import "CTUtil.h"

@implementation CTUtil
@synthesize timezones, timezoneIds, dateFormatter, defaults, messagingCenter, loadedContactsData, unsyncedContacts, prefs;

+ (void)load{
	[self sharedInstance];
}

+ (CTUtil *)sharedInstance{

    static CTUtil *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CTUtil alloc] init];

        sharedInstance.timezones = @[@"not set", @"(UTC-11:00) Pacific/Pago Pago", @"(UTC-10:00) Pacific/Honolulu", @"(UTC-10:00) Pacific/Tahiti", @"(UTC-09:00) America/Anchorage", @"(UTC-08:00) America/Los Angeles", @"(UTC-07:00) America/Denver", @"(UTC-06:00) America/Chicago", @"(UTC-05:00) America/New York", @"(UTC-04:00) America/Halifax", @"(UTC-03:00) America/Argentina/Buenos Aires", @"(UTC-02:00) America/Sao Paulo", @"(UTC-01:00) Atlantic/Azores", @"(UTC+00:00) Europe/London", @"(UTC+01:00) Europe/Berlin", @"(UTC+02:00) Europe/Helsinki", @"(UTC+03:00) Europe/Istanbul", @"(UTC+04:00) Asia/Dubai", @"(UTC+04:30) Asia/Kabul", @"(UTC+05:00) Indian/Maldives", @"(UTC+05:30) Asia/Calcutta", @"(UTC+05:45) Asia/Kathmandu", @"(UTC+06:00) Asia/Dhaka", @"(UTC+06:30) Indian/Cocos", @"(UTC+07:00) Asia/Bangkok", @"(UTC+08:00) Asia/Hong Kong", @"(UTC+08:30) Asia/Pyongyang", @"(UTC+09:00) Asia/Tokyo", @"(UTC+09:30) Australia/Darwin", @"(UTC+10:00) Australia/Brisbane", @"(UTC+10:30) Australia/Adelaide", @"(UTC+11:00) Australia/Sydney", @"(UTC+12:00) Pacific/Nauru", @"(UTC+13:00) Pacific/Auckland", @"(UTC+14:00) Pacific/Kiritimati"];

		sharedInstance.timezoneIds = @[@"not set", @"Pacific/Pago_Pago", @"Pacific/Honolulu", @"Pacific/Tahiti", @"America/Anchorage", @"America/Los_Angeles", @"America/Denver", @"America/Chicago", @"America/New_York", @"America/Halifax", @"America/Argentina/Buenos_Aires", @"America/Sao_Paulo", @"Atlantic/Azores", @"Europe/London", @"Europe/Berlin", @"Europe/Helsinki", @"Europe/Istanbul", @"Asia/Dubai", @"Asia/Kabul", @"Indian/Maldives", @"Asia/Calcutta", @"Asia/Kathmandu", @"Asia/Dhaka", @"Indian/Cocos", @"Asia/Bangkok", @"Asia/Hong_Kong", @"Asia/Pyongyang", @"Asia/Tokyo", @"Australia/Darwin", @"Australia/Brisbane", @"Australia/Adelaide", @"Australia/Sydney", @"Pacific/Nauru", @"Pacific/Auckland", @"Pacific/Kiritimati"];

		NSDateFormatter *df = [NSDateFormatter new];
		[df setLocalizedDateFormatFromTemplate:@"jj:mm"];
		sharedInstance.dateFormatter = df;

		sharedInstance.defaults = [[NSUserDefaults alloc] initWithSuiteName:@"com.lint.contacttime.data"];

		CPDistributedMessagingCenter *center = [CPDistributedMessagingCenter centerNamed:@"com.lint.contacttime.messagingcenter"];
		rocketbootstrap_distributedmessagingcenter_apply(center);
		sharedInstance.messagingCenter = center;

		NSMutableArray *unsyncedContactsFromDefaults = [[sharedInstance.defaults objectForKey:@"ctUnsynced"] mutableCopy];
		if (!unsyncedContactsFromDefaults){
			unsyncedContactsFromDefaults = [[NSMutableArray alloc] init];
		}

		sharedInstance.unsyncedContacts = unsyncedContactsFromDefaults;

		sharedInstance.prefs = [[NSMutableDictionary alloc] init];

		[sharedInstance reloadPrefs];
		[sharedInstance loadContactsData];
    });

    return sharedInstance;
}

- (void)applicationEnteredForeground{

	[self loadContactsData];

	NSNotificationCenter *notifCenter = [NSNotificationCenter defaultCenter];
	[notifCenter postNotificationName:@"com.lint.contacttime.message/updatedetailsdata" object:nil];
	[notifCenter postNotificationName:@"com.lint.contacttime.message/updatenavdata" object:nil];
}

- (void)applicationEnteredBackground{

	if ([self contactsDataWasModified]){
		[self saveContactsData];
	}

	[[NSNotificationCenter defaultCenter] postNotificationName:@"com.lint.contacttime.message/stoptimers" object:nil];
}

- (BOOL)hasUnsyncedData{
	return [unsyncedContacts count] > 0;
}

- (void)addUnsyncedContact:(NSString *)arg1{
	[unsyncedContacts addObject:arg1];
}

- (BOOL)isContactUnsynced:(NSString *)arg1{

	for (NSString *key in unsyncedContacts){
		if ([key isEqualToString:arg1]){
			return YES;
		}
	}

	return NO;
}

- (void)setObject:(id)arg1 forKey:(NSString *)arg2{

	NSMutableDictionary *data = [[defaults objectForKey:@"ctData"] mutableCopy];

	if (!data){
		data = [[NSMutableDictionary alloc] init];
	}

	[data setObject:arg1 forKey:arg2];
	[defaults setObject:data forKey:@"ctData"];
}

- (void)saveContactsData{

	NSDictionary *data = [defaults objectForKey:@"ctData"];

	if (!data){
		data = @{};
	}

	if ([self testConnection]){
		[messagingCenter sendMessageName:@"com.lint.contacttime.message/savecontactdata" userInfo:data];
		unsyncedContacts = [[NSMutableArray alloc] init];
		[defaults setObject:unsyncedContacts forKey:@"ctUnsynced"];
	}
}

- (void)loadContactsData{

	if ([self hasUnsyncedData]){
		[self saveContactsData];
	}

	NSDictionary *data;
	NSDictionary *currentData = [defaults objectForKey:@"ctData"];

	if (!currentData){
		currentData = @{};
	}

	if ([self testConnection]){

		NSDictionary *savedData = [messagingCenter sendMessageAndReceiveReplyName:@"com.lint.contacttime.message/getcontactdata" userInfo:nil];

		if (savedData){
			data = savedData;
		} else {
			data = currentData;
		}

	} else {
		data = currentData;
	}

	loadedContactsData = data;
	[defaults setObject:data forKey:@"ctData"];
}

- (BOOL)contactsDataWasModified{
	if (loadedContactsData){
		return ![loadedContactsData isEqualToDictionary:[defaults objectForKey:@"ctData"]];
	} else {
		return NO;
	}
}

- (void)reloadPrefs{

	NSDictionary *loadedPrefs = [[NSDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.lint.contacttime.prefs.plist"];

	BOOL isEnabled = [loadedPrefs objectForKey:@"isEnabled"] ? [[loadedPrefs objectForKey:@"isEnabled"] boolValue] : YES;
    BOOL isNavTimeEnabled = [loadedPrefs objectForKey:@"isNavTimeEnabled"] ? [[loadedPrefs objectForKey:@"isNavTimeEnabled"] boolValue] : YES;
	BOOL isGroupDetailTimeEnabled = [loadedPrefs objectForKey:@"isGroupDetailTimeEnabled"] ? [[loadedPrefs objectForKey:@"isGroupDetailTimeEnabled"] boolValue] : YES;
	BOOL isSingleDetailTimeEnabled = [loadedPrefs objectForKey:@"isSingleDetailTimeEnabled"] ? [[loadedPrefs objectForKey:@"isSingleDetailTimeEnabled"] boolValue] : NO;

	[prefs setObject:[NSNumber numberWithBool:isEnabled] forKey:@"isEnabled"];
	[prefs setObject:[NSNumber numberWithBool:isNavTimeEnabled] forKey:@"isNavTimeEnabled"];
	[prefs setObject:[NSNumber numberWithBool:isGroupDetailTimeEnabled] forKey:@"isGroupDetailTimeEnabled"];
	[prefs setObject:[NSNumber numberWithBool:isSingleDetailTimeEnabled] forKey:@"isSingleDetailTimeEnabled"];
}

- (BOOL)prefsBoolForKey:(NSString *)arg1{
	return [[prefs objectForKey:arg1] boolValue];
}

- (BOOL)testConnection{

	NSDictionary *test = [messagingCenter sendMessageAndReceiveReplyName:@"com.lint.contacttime.message/testrbsconnection" userInfo:nil];
	NSString *testVal = [test objectForKey:@"test"];

	if (test && testVal){
		return [testVal isEqualToString:@"YES"];
	} else {
		return NO;
	}
}

- (CGFloat)timeUntilNextMin{

	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *components = [calendar components:(NSCalendarUnitSecond | NSCalendarUnitNanosecond) fromDate:[NSDate date]];
	NSInteger currentSecond = [components second];
	CGFloat currentNanosecond = [components nanosecond] / 1000000000.0;

	return 60 - (currentSecond + currentNanosecond);
}

- (NSString *)tzIDForTimezoneText:(NSString *)arg1{
	NSInteger valIndex = [self indexForTimezoneText:arg1];

	if (valIndex == -1){
		return nil;
	} else {
		return timezoneIds[valIndex];
	}
}

- (NSString *)timezoneTextForTZID:(NSString *)arg1{
	NSInteger valIndex = [self indexForTZID:arg1];

	if (valIndex == -1){
		return nil;
	} else {
		return timezones[valIndex];
	}
}

- (NSInteger)indexForTimezoneText:(NSString *)arg1{
	NSInteger valIndex = 0;

	for (NSString *tzText in timezones){
		if ([arg1 isEqualToString:tzText]){
			return valIndex;
		} else {
			valIndex++;
		}
	}

	return -1;
}

- (NSInteger)indexForTZID:(NSString *)arg1{
	NSInteger valIndex = 0;

	for (NSString *tzID in timezoneIds){
		if ([arg1 isEqualToString:tzID]){
			return valIndex;
		} else {
			valIndex++;
		}
	}

	return -1;
}

- (NSInteger)timeDifferenceForTZID:(NSString *)arg1{

	NSTimeZone *localTZ = [NSTimeZone localTimeZone];
	NSTimeZone *otherTZ = [NSTimeZone timeZoneWithName:arg1];
	NSInteger tzSecondsDifference = -1;

	if (otherTZ){

		NSInteger localTimeFromGMT = [localTZ secondsFromGMT];
		NSInteger otherTimeFromGMT = [otherTZ secondsFromGMT];

		tzSecondsDifference = otherTimeFromGMT - localTimeFromGMT;
	}

	return tzSecondsDifference;
}

- (NSDate *)dateForTZID:(NSString *)arg1{
	NSInteger timeDiff = [self timeDifferenceForTZID:arg1];
	return [NSDate dateWithTimeIntervalSinceNow:timeDiff];
}

- (NSString *)timeStringForTZID:(NSString *)arg1{
	NSDate *date = [self dateForTZID:arg1];
	return [dateFormatter stringFromDate:date];
}

- (NSString *)formattedTimeStringForDate:(NSDate *)arg1{
	return [dateFormatter stringFromDate:arg1];
}

- (NSString *)stringForKey:(NSString *)arg1{
	NSDictionary *dict = [defaults objectForKey:@"ctData"];
	return [dict objectForKey:arg1];
}

@end
