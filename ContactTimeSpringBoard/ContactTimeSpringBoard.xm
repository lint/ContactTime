
#import "../Util/CTUtil.h"
#import "Classes/CTSBServer.h"

CTSBServer *ctSBServer;

static void loadPrefs(){
	[[%c(CTUtil) sharedInstance] reloadPrefs];
}

static void clearData(){
	[ctSBServer setShouldClearData:YES];
}

%ctor{

	ctSBServer = [%c(CTSBServer) sharedInstance];

	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)clearData, CFSTR("com.lint.contacttime.message/cleardata"), NULL, CFNotificationSuspensionBehaviorCoalesce);
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)loadPrefs, CFSTR("com.lint.contacttime.prefs/prefschanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);

	%init;
}
