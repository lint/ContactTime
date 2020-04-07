#include "CTPRootListController.h"
#import <Preferences/PSSpecifier.h>

@implementation CTPRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}

	return _specifiers;
}

- (id)readPreferenceValue:(PSSpecifier*)specifier {
	NSString *path = [NSString stringWithFormat:@"/User/Library/Preferences/%@.plist", specifier.properties[@"defaults"]];
	NSMutableDictionary *settings = [NSMutableDictionary dictionary];
	[settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:path]];
	return (settings[specifier.properties[@"key"]]) ?: specifier.properties[@"default"];
}

- (void)setPreferenceValue:(id)value specifier:(PSSpecifier*)specifier {
	NSString *path = [NSString stringWithFormat:@"/User/Library/Preferences/%@.plist", specifier.properties[@"defaults"]];
	NSMutableDictionary *settings = [NSMutableDictionary dictionary];
	[settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:path]];
	[settings setObject:value forKey:specifier.properties[@"key"]];
	[settings writeToFile:path atomically:YES];
	CFStringRef notificationName = (__bridge CFStringRef)specifier.properties[@"PostNotification"];

	if (notificationName) {
		CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), notificationName, NULL, NULL, YES);
	}
}

- (void)openGitHub{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/lint/ContactTime"] options:@{} completionHandler:nil];
}

- (void)openRedditMessage{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://old.reddit.com/message/compose?to=apieceoflint&subject=&message="] options:@{} completionHandler:nil];
}

- (void)openEmail{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto:apieceoflint@protonmail.com"] options:@{} completionHandler:nil];
}

- (void)openDonation{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://paypal.me/sllint"] options:@{} completionHandler:nil];
}

- (void)clearData{

	UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Clear Data" message:@"Do you really want to clear all saved data?" preferredStyle:UIAlertControllerStyleAlert];

	UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
	UIAlertAction *clearDataAction = [UIAlertAction actionWithTitle:@"Clear data" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
		CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.lint.contacttime.message/cleardata"), NULL, NULL, YES);
	}];

	[alertController addAction:clearDataAction];
	[alertController addAction:cancelAction];

	[self presentViewController:alertController animated:YES completion:nil];
}

@end
