
#import <AppSupport/CPDistributedMessagingCenter.h>
#import <rocketbootstrap/rocketbootstrap.h>

#import "CTUtil.h"

@implementation CTUtil
@synthesize timezones, timezoneIds, moreTimezones, timezoneDict, dateFormatter, defaults, messagingCenter, loadedContactsData, unsyncedContacts, prefs;

+ (void)load{
	[self sharedInstance];
}

+ (CTUtil *)sharedInstance{

    static CTUtil *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CTUtil alloc] init];

        sharedInstance.timezones = @[@"not set", @"(UTC-11:00) Pacific/Pago Pago", @"(UTC-10:00) Pacific/Honolulu", @"(UTC-10:00) Pacific/Tahiti", @"(UTC-09:00) America/Anchorage", @"(UTC-08:00) America/Los Angeles", @"(UTC-07:00) America/Denver", @"(UTC-06:00) America/Chicago", @"(UTC-05:00) America/New York", @"(UTC-04:00) America/Halifax", @"(UTC-03:00) America/Argentina/Buenos Aires", @"(UTC-02:00) America/Sao Paulo", @"(UTC-01:00) Atlantic/Azores", @"(UTC+00:00) Europe/London", @"(UTC+01:00) Europe/Berlin", @"(UTC+02:00) Europe/Helsinki", @"(UTC+03:00) Europe/Istanbul", @"(UTC+04:00) Asia/Dubai", @"(UTC+04:30) Asia/Kabul", @"(UTC+05:00) Indian/Maldives", @"(UTC+05:30) Asia/Calcutta", @"(UTC+05:45) Asia/Kathmandu", @"(UTC+06:00) Asia/Dhaka", @"(UTC+06:30) Indian/Cocos", @"(UTC+07:00) Asia/Bangkok", @"(UTC+08:00) Asia/Hong Kong", @"(UTC+08:30) Asia/Pyongyang", @"(UTC+09:00) Asia/Tokyo", @"(UTC+09:30) Australia/Darwin", @"(UTC+10:00) Australia/Brisbane", @"(UTC+10:30) Australia/Adelaide", @"(UTC+11:00) Australia/Sydney", @"(UTC+12:00) Pacific/Nauru", @"(UTC+13:00) Pacific/Auckland", @"(UTC+14:00) Pacific/Kiritimati"];

		sharedInstance.moreTimezones = @[@"not set", @"(UTC-11:00) Pacific/Niue", @"(UTC-11:00) Pacific/Pago Pago", @"(UTC-10:00) Pacific/Honolulu", @"(UTC-10:00) Pacific/Rarotonga", @"(UTC-10:00) Pacific/Tahiti", @"(UTC-09:30) Pacific/Marquesas", @"(UTC-09:00) Americas/Anchorage", @"(UTC-09:00) Pacific/Gambier", @"(UTC-08:00) Americas/Los Angeles", @"(UTC-08:00) Americas/Tijuana", @"(UTC-08:00) Americas/Vancouver", @"(UTC-08:00) Americas/Whitehorse", @"(UTC-08:00) Pacific/Pitcairn", @"(UTC-07:00) Americas/Denver", @"(UTC-07:00) Americas/Phoenix", @"(UTC-07:00) Americas/Mazatlan, Chihuahua", @"(UTC-07:00) Americas/Dawson Creek", @"(UTC-07:00) Americas/Edmonton", @"(UTC-07:00) Americas/Hermosillo", @"(UTC-07:00) Americas/Yellowknife", @"(UTC-06:00) Americas/Belize", @"(UTC-06:00) Americas/Chicago", @"(UTC-06:00) Americas/Mexico City", @"(UTC-06:00) Americas/Regina", @"(UTC-06:00) Americas/Tegucigalpa", @"(UTC-06:00) Americas/Winnipeg", @"(UTC-06:00) Americas/Costa Rica", @"(UTC-06:00) Americas/El Salvador", @"(UTC-06:00) Pacific/Galapagos", @"(UTC-06:00) Americas/Guatemala", @"(UTC-06:00) Americas/Managua", @"(UTC-05:00) Americas/Cancun", @"(UTC-05:00) Americas/Bogota", @"(UTC-05:00) Pacific/Easter Island", @"(UTC-05:00) Americas/New York", @"(UTC-05:00) Americas/Iqaluit", @"(UTC-05:00) Americas/Toronto", @"(UTC-05:00) Americas/Guayaquil", @"(UTC-05:00) Americas/Havana", @"(UTC-05:00) Americas/Jamaica", @"(UTC-05:00) Americas/Lima", @"(UTC-05:00) Americas/Nassau", @"(UTC-05:00) Americas/Panama", @"(UTC-05:00) Americas/Port-au-Prince", @"(UTC-05:00) Americas/Rio Branco", @"(UTC-04:00) Americas/Halifax", @"(UTC-04:00) Americas/Barbados", @"(UTC-04:00) Atlantic/Bermuda", @"(UTC-04:00) Americas/Boa Vista", @"(UTC-04:00) Americas/Caracas", @"(UTC-04:00) Americas/Curacao", @"(UTC-04:00) Americas/Grand Turk", @"(UTC-04:00) Americas/Guyana", @"(UTC-04:00) Americas/La Paz", @"(UTC-04:00) Americas/Manaus", @"(UTC-04:00) Americas/Martinique", @"(UTC-04:00) Americas/Port of Spain", @"(UTC-04:00) Americas/Porto Velho", @"(UTC-04:00) Americas/Puerto Rico", @"(UTC-04:00) Americas/Santo Domingo", @"(UTC-04:00) Americas/Thule", @"(UTC-03:30) Americas/St Johns", @"(UTC-03:00) Americas/Araguaina", @"(UTC-03:00) Americas/Asuncion", @"(UTC-03:00) Americas/Belem", @"(UTC-03:00) Americas/Argentina/Buenos Aires", @"(UTC-03:00) Americas/Campo Grande", @"(UTC-03:00) Americas/Cayenne", @"(UTC-03:00) Americas/Cuiaba", @"(UTC-03:00) Americas/Fortaleza", @"(UTC-03:00) Americas/Godthab", @"(UTC-03:00) Americas/Maceio", @"(UTC-03:00) Americas/Miquelon", @"(UTC-03:00) Americas/Montevideo", @"(UTC-03:00) Antarctica/Palmer", @"(UTC-03:00) Americas/Paramaribo", @"(UTC-03:00) Americas/Punta Arenas", @"(UTC-03:00) Americas/Recife", @"(UTC-03:00) Antarctica/Rothera", @"(UTC-03:00) Americas/Bahia", @"(UTC-03:00) Americas/Santiago", @"(UTC-03:00) Atlantic/Stanley", @"(UTC-02:00) Americas/Noronha", @"(UTC-02:00) Americas/Sao Paulo", @"(UTC-02:00) Atlantic/South Georgia", @"(UTC-01:00) Atlantic/Azores", @"(UTC-01:00) Atlantic/Cape Verde", @"(UTC-01:00) Americas/Scoresbysund", @"(UTC+00:00) Africa/Abidjan", @"(UTC+00:00) Africa/Accra", @"(UTC+00:00) Africa/Bissau", @"(UTC+00:00) Atlantic/Canary Islands", @"(UTC+00:00) Africa/Casablanca", @"(UTC+00:00) Americas/Danmarkshavn", @"(UTC+00:00) Europe/Dublin", @"(UTC+00:00) Africa/El Aaiun", @"(UTC+00:00) Atlantic/Faroe", @"(UTC+00:00) Europe/Lisbon", @"(UTC+00:00) Europe/London", @"(UTC+00:00) Africa/Monrovia", @"(UTC+00:00) Atlantic/Reykjavik", @"(UTC+01:00) Africa/Algiers", @"(UTC+01:00) Europe/Amsterdam", @"(UTC+01:00) Europe/Andorra", @"(UTC+01:00) Europe/Berlin", @"(UTC+01:00) Europe/Brussels", @"(UTC+01:00) Europe/Budapest", @"(UTC+01:00) Europe/Belgrade", @"(UTC+01:00) Europe/Prague", @"(UTC+01:00) Africa/Ceuta", @"(UTC+01:00) Europe/Copenhagen", @"(UTC+01:00) Europe/Gibraltar", @"(UTC+01:00) Africa/Lagos", @"(UTC+01:00) Europe/Luxembourg", @"(UTC+01:00) Europe/Madrid", @"(UTC+01:00) Europe/Malta", @"(UTC+01:00) Europe/Monaco", @"(UTC+01:00) Africa/Ndjamena", @"(UTC+01:00) Europe/Oslo", @"(UTC+01:00) Europe/Paris", @"(UTC+01:00) Europe/Rome", @"(UTC+01:00) Europe/Stockholm", @"(UTC+01:00) Europe/Tirane", @"(UTC+01:00) Africa/Tunis", @"(UTC+01:00) Europe/Vienna", @"(UTC+01:00) Europe/Warsaw", @"(UTC+01:00) Europe/Zurich", @"(UTC+02:00) Asia/Amman", @"(UTC+02:00) Europe/Athens", @"(UTC+02:00) Asia/Beirut", @"(UTC+02:00) Europe/Bucharest", @"(UTC+02:00) Africa/Cairo", @"(UTC+02:00) Europe/Chisinau", @"(UTC+02:00) Asia/Damascus", @"(UTC+02:00) Asia/Gaza", @"(UTC+02:00) Europe/Helsinki", @"(UTC+02:00) Asia/Jerusalem", @"(UTC+02:00) Africa/Johannesburg", @"(UTC+02:00) Africa/Khartoum", @"(UTC+02:00) Europe/Kiev", @"(UTC+02:00) Africa/Maputo", @"(UTC+02:00) Europe/Kaliningrad", @"(UTC+02:00) Asia/Nicosia", @"(UTC+02:00) Europe/Riga", @"(UTC+02:00) Europe/Sofia", @"(UTC+02:00) Europe/Tallinn", @"(UTC+02:00) Africa/Tripoli", @"(UTC+02:00) Europe/Vilnius", @"(UTC+02:00) Africa/Windhoek", @"(UTC+03:00) Asia/Baghdad", @"(UTC+03:00) Europe/Istanbul", @"(UTC+03:00) Europe/Minsk", @"(UTC+03:00) Europe/Moscow", @"(UTC+03:00) Africa/Nairobi", @"(UTC+03:00) Asia/Qatar", @"(UTC+03:00) Asia/Riyadh", @"(UTC+03:00) Antarctica/Syowa", @"(UTC+03:30) Asia/Tehran", @"(UTC+04:00) Asia/Baku", @"(UTC+04:00) Asia/Dubai", @"(UTC+04:00) Indian/Mahe", @"(UTC+04:00) Indian/Mauritius", @"(UTC+04:00) Europe/Samara", @"(UTC+04:00) Indian/Reunion", @"(UTC+04:00) Asia/Tbilisi", @"(UTC+04:00) Asia/Yerevan", @"(UTC+04:30) Asia/Kabul", @"(UTC+05:00) Asia/Aqtau", @"(UTC+05:00) Asia/Aqtobe", @"(UTC+05:00) Asia/Ashgabat", @"(UTC+05:00) Asia/Dushanbe", @"(UTC+05:00) Asia/Karachi", @"(UTC+05:00) Indian/Kerguelen", @"(UTC+05:00) Indian/Maldives", @"(UTC+05:00) Antarctica/Mawson", @"(UTC+05:00) Asia/Yekaterinburg", @"(UTC+05:00) Asia/Tashkent", @"(UTC+05:30) Asia/Colombo", @"(UTC+05:30) Asia/Kolkata", @"(UTC+05:45) Asia/Kathmandu", @"(UTC+06:00) Asia/Almaty", @"(UTC+06:00) Asia/Bishkek", @"(UTC+06:00) Indian/Chagos", @"(UTC+06:00) Asia/Dhaka", @"(UTC+06:00) Asia/Omsk", @"(UTC+06:00) Asia/Thimphu", @"(UTC+06:00) Antarctica/Vostok", @"(UTC+06:30) Indian/Cocos", @"(UTC+06:30) Asia/Yangon", @"(UTC+07:00) Asia/Bangkok", @"(UTC+07:00) Indian/Christmas", @"(UTC+07:00) Antarctica/Davis", @"(UTC+07:00) Asia/Saigon", @"(UTC+07:00) Asia/Hovd", @"(UTC+07:00) Asia/Jakarta", @"(UTC+07:00) Asia/Krasnoyarsk", @"(UTC+08:00) Asia/Brunei", @"(UTC+08:00) Asia/Shanghai", @"(UTC+08:00) Asia/Choibalsan", @"(UTC+08:00) Asia/Hong Kong", @"(UTC+08:00) Asia/Kuala Lumpur", @"(UTC+08:00) Asia/Macau", @"(UTC+08:00) Asia/Makassar", @"(UTC+08:00) Asia/Manila", @"(UTC+08:00) Asia/Irkutsk", @"(UTC+08:00) Asia/Singapore", @"(UTC+08:00) Asia/Taipei", @"(UTC+08:00) Asia/Ulaanbaatar", @"(UTC+08:00) Australia/Perth", @"(UTC+08:30) Asia/Pyongyang", @"(UTC+09:00) Asia/Dili", @"(UTC+09:00) Asia/Jayapura", @"(UTC+09:00) Asia/Yakutsk", @"(UTC+09:00) Pacific/Palau", @"(UTC+09:00) Asia/Seoul", @"(UTC+09:00) Asia/Tokyo", @"(UTC+09:30) Australia/Darwin", @"(UTC+10:00) Antarctica/Dumont d'Urville", @"(UTC+10:00) Australia/Brisbane", @"(UTC+10:00) Pacific/Guam", @"(UTC+10:00) Asia/Vladivostok", @"(UTC+10:00) Pacific/Port Moresby", @"(UTC+10:00) Pacific/Chuuk", @"(UTC+10:30) Australia/Adelaide", @"(UTC+11:00) Antarctica/Casey", @"(UTC+11:00) Australia/Hobart", @"(UTC+11:00) Australia/Sydney", @"(UTC+11:00) Pacific/Efate", @"(UTC+11:00) Pacific/Guadalcanal", @"(UTC+11:00) Pacific/Kosrae", @"(UTC+11:00) Asia/Magadan", @"(UTC+11:00) Pacific/Norfolk", @"(UTC+11:00) Pacific/Noumea", @"(UTC+11:00) Pacific/Pohnpei", @"(UTC+12:00) Pacific/Funafuti", @"(UTC+12:00) Pacific/Kwajalein", @"(UTC+12:00) Pacific/Majuro", @"(UTC+12:00) Asia/Kamchatka", @"(UTC+12:00) Pacific/Nauru", @"(UTC+12:00) Pacific/Tarawa", @"(UTC+12:00) Pacific/Wake", @"(UTC+12:00) Pacific/Wallis", @"(UTC+13:00) Pacific/Auckland", @"(UTC+13:00) Pacific/Enderbury", @"(UTC+13:00) Pacific/Fakaofo", @"(UTC+13:00) Pacific/Fiji", @"(UTC+13:00) Pacific/Tongatapu", @"(UTC+14:00) Pacific/Apia", @"(UTC+14:00) Pacific/Kiritimat"];

		sharedInstance.timezoneDict = @{@"not set" : @"not set", @"Pacific/Niue" : @"(UTC-11:00) Pacific/Niue", @"Pacific/Pago_Pago" : @"(UTC-11:00) Pacific/Pago Pago", @"Pacific/Honolulu" : @"(UTC-10:00) Pacific/Honolulu", @"Pacific/Rarotonga" : @"(UTC-10:00) Pacific/Rarotonga", @"Pacific/Tahiti" : @"(UTC-10:00) Pacific/Tahiti", @"Pacific/Marquesas" : @"(UTC-09:30) Pacific/Marquesas", @"America/Anchorage" : @"(UTC-09:00) Americas/Anchorage", @"Pacific/Gambier" : @"(UTC-09:00) Pacific/Gambier", @"America/Los_Angeles" : @"(UTC-08:00) Americas/Los Angeles", @"America/Tijuana" : @"(UTC-08:00) Americas/Tijuana", @"America/Vancouver" : @"(UTC-08:00) Americas/Vancouver", @"America/Whitehorse" : @"(UTC-08:00) Americas/Whitehorse", @"Pacific/Pitcairn" : @"(UTC-08:00) Pacific/Pitcairn", @"America/Denver" : @"(UTC-07:00) Americas/Denver", @"America/Phoenix" : @"(UTC-07:00) Americas/Phoenix", @"America/Mazatlan" : @"(UTC-07:00) Americas/Mazatlan, Chihuahua", @"America/Dawson_Creek" : @"(UTC-07:00) Americas/Dawson Creek", @"America/Edmonton" : @"(UTC-07:00) Americas/Edmonton", @"America/Hermosillo" : @"(UTC-07:00) Americas/Hermosillo", @"America/Yellowknife" : @"(UTC-07:00) Americas/Yellowknife", @"America/Belize" : @"(UTC-06:00) Americas/Belize", @"America/Chicago" : @"(UTC-06:00) Americas/Chicago", @"America/Mexico_City" : @"(UTC-06:00) Americas/Mexico City", @"America/Regina" : @"(UTC-06:00) Americas/Regina", @"America/Tegucigalpa" : @"(UTC-06:00) Americas/Tegucigalpa", @"America/Winnipeg" : @"(UTC-06:00) Americas/Winnipeg", @"America/Costa_Rica" : @"(UTC-06:00) Americas/Costa Rica", @"America/El_Salvador" : @"(UTC-06:00) Americas/El Salvador", @"Pacific/Galapagos" : @"(UTC-06:00) Pacific/Galapagos", @"America/Guatemala" : @"(UTC-06:00) Americas/Guatemala", @"America/Managua" : @"(UTC-06:00) Americas/Managua", @"America/Cancun" : @"(UTC-05:00) Americas/Cancun", @"America/Bogota" : @"(UTC-05:00) Americas/Bogota", @"Pacific/Easter" : @"(UTC-05:00) Pacific/Easter Island", @"America/New_York" : @"(UTC-05:00) Americas/New York", @"America/Iqaluit" : @"(UTC-05:00) Americas/Iqaluit", @"America/Toronto" : @"(UTC-05:00) Americas/Toronto", @"America/Guayaquil" : @"(UTC-05:00) Americas/Guayaquil", @"America/Havana" : @"(UTC-05:00) Americas/Havana", @"America/Jamaica" : @"(UTC-05:00) Americas/Jamaica", @"America/Lima" : @"(UTC-05:00) Americas/Lima", @"America/Nassau" : @"(UTC-05:00) Americas/Nassau", @"America/Panama" : @"(UTC-05:00) Americas/Panama", @"America/Port-au-Prince" : @"(UTC-05:00) Americas/Port-au-Prince", @"America/Rio_Branco" : @"(UTC-05:00) Americas/Rio Branco", @"America/Halifax" : @"(UTC-04:00) Americas/Halifax", @"America/Barbados" : @"(UTC-04:00) Americas/Barbados", @"Atlantic/Bermuda" : @"(UTC-04:00) Atlantic/Bermuda", @"America/Boa_Vista" : @"(UTC-04:00) Americas/Boa Vista", @"America/Caracas" : @"(UTC-04:00) Americas/Caracas", @"America/Curacao" : @"(UTC-04:00) Americas/Curacao", @"America/Grand_Turk" : @"(UTC-04:00) Americas/Grand Turk", @"America/Guyana" : @"(UTC-04:00) Americas/Guyana", @"America/La_Paz" : @"(UTC-04:00) Americas/La Paz", @"America/Manaus" : @"(UTC-04:00) Americas/Manaus", @"America/Martinique" : @"(UTC-04:00) Americas/Martinique", @"America/Port_of_Spain" : @"(UTC-04:00) Americas/Port of Spain", @"America/Porto_Velho" : @"(UTC-04:00) Americas/Porto Velho", @"America/Puerto_Rico" : @"(UTC-04:00) Americas/Puerto Rico", @"America/Santo_Domingo" : @"(UTC-04:00) Americas/Santo Domingo", @"America/Thule" : @"(UTC-04:00) Americas/Thule", @"America/St_Johns" : @"(UTC-03:30) Americas/St Johns", @"America/Araguaina" : @"(UTC-03:00) Americas/Araguaina", @"America/Asuncion" : @"(UTC-03:00) Americas/Asuncion", @"America/Belem" : @"(UTC-03:00) Americas/Belem", @"America/Argentina/Buenos_Aires" : @"(UTC-03:00) Americas/Argentina/Buenos Aires", @"America/Campo_Grande" : @"(UTC-03:00) Americas/Campo Grande", @"America/Cayenne" : @"(UTC-03:00) Americas/Cayenne", @"America/Cuiaba" : @"(UTC-03:00) Americas/Cuiaba", @"America/Fortaleza" : @"(UTC-03:00) Americas/Fortaleza", @"America/Godthab" : @"(UTC-03:00) Americas/Godthab", @"America/Maceio" : @"(UTC-03:00) Americas/Maceio", @"America/Miquelon" : @"(UTC-03:00) Americas/Miquelon", @"America/Montevideo" : @"(UTC-03:00) Americas/Montevideo", @"Antarctica/Palmer" : @"(UTC-03:00) Antarctica/Palmer", @"America/Paramaribo" : @"(UTC-03:00) Americas/Paramaribo", @"America/Punta_Arenas" : @"(UTC-03:00) Americas/Punta Arenas", @"America/Recife" : @"(UTC-03:00) Americas/Recife", @"Antarctica/Rothera" : @"(UTC-03:00) Antarctica/Rothera", @"America/Bahia" : @"(UTC-03:00) Americas/Bahia", @"America/Santiago" : @"(UTC-03:00) Americas/Santiago", @"Atlantic/Stanley" : @"(UTC-03:00) Atlantic/Stanley", @"America/Noronha" : @"(UTC-02:00) Americas/Noronha", @"America/Sao_Paulo" : @"(UTC-02:00) Americas/Sao Paulo", @"Atlantic/South_Georgia" : @"(UTC-02:00) Atlantic/South Georgia", @"Atlantic/Azores" : @"(UTC-01:00) Atlantic/Azores", @"Atlantic/Cape_Verde" : @"(UTC-01:00) Atlantic/Cape Verde", @"America/Scoresbysund" : @"(UTC-01:00) Americas/Scoresbysund", @"Africa/Abidjan" : @"(UTC+00:00) Africa/Abidjan", @"Africa/Accra" : @"(UTC+00:00) Africa/Accra", @"Africa/Bissau" : @"(UTC+00:00) Africa/Bissau", @"Atlantic/Canary" : @"(UTC+00:00) Atlantic/Canary Islands", @"Africa/Casablanca" : @"(UTC+00:00) Africa/Casablanca", @"America/Danmarkshavn" : @"(UTC+00:00) Americas/Danmarkshavn", @"Europe/Dublin" : @"(UTC+00:00) Europe/Dublin", @"Africa/El_Aaiun" : @"(UTC+00:00) Africa/El Aaiun", @"Atlantic/Faroe" : @"(UTC+00:00) Atlantic/Faroe", @"Europe/Lisbon" : @"(UTC+00:00) Europe/Lisbon", @"Europe/London" : @"(UTC+00:00) Europe/London", @"Africa/Monrovia" : @"(UTC+00:00) Africa/Monrovia", @"Atlantic/Reykjavik" : @"(UTC+00:00) Atlantic/Reykjavik", @"Africa/Algiers" : @"(UTC+01:00) Africa/Algiers", @"Europe/Amsterdam" : @"(UTC+01:00) Europe/Amsterdam", @"Europe/Andorra" : @"(UTC+01:00) Europe/Andorra", @"Europe/Berlin" : @"(UTC+01:00) Europe/Berlin", @"Europe/Brussels" : @"(UTC+01:00) Europe/Brussels", @"Europe/Budapest" : @"(UTC+01:00) Europe/Budapest", @"Europe/Belgrade" : @"(UTC+01:00) Europe/Belgrade", @"Europe/Prague" : @"(UTC+01:00) Europe/Prague", @"Africa/Ceuta" : @"(UTC+01:00) Africa/Ceuta", @"Europe/Copenhagen" : @"(UTC+01:00) Europe/Copenhagen", @"Europe/Gibraltar" : @"(UTC+01:00) Europe/Gibraltar", @"Africa/Lagos" : @"(UTC+01:00) Africa/Lagos", @"Europe/Luxembourg" : @"(UTC+01:00) Europe/Luxembourg", @"Europe/Madrid" : @"(UTC+01:00) Europe/Madrid", @"Europe/Malta" : @"(UTC+01:00) Europe/Malta", @"Europe/Monaco" : @"(UTC+01:00) Europe/Monaco", @"Africa/Ndjamena" : @"(UTC+01:00) Africa/Ndjamena", @"Europe/Oslo" : @"(UTC+01:00) Europe/Oslo", @"Europe/Paris" : @"(UTC+01:00) Europe/Paris", @"Europe/Rome" : @"(UTC+01:00) Europe/Rome", @"Europe/Stockholm" : @"(UTC+01:00) Europe/Stockholm", @"Europe/Tirane" : @"(UTC+01:00) Europe/Tirane", @"Africa/Tunis" : @"(UTC+01:00) Africa/Tunis", @"Europe/Vienna" : @"(UTC+01:00) Europe/Vienna", @"Europe/Warsaw" : @"(UTC+01:00) Europe/Warsaw", @"Europe/Zurich" : @"(UTC+01:00) Europe/Zurich", @"Asia/Amman" : @"(UTC+02:00) Asia/Amman", @"Europe/Athens" : @"(UTC+02:00) Europe/Athens", @"Asia/Beirut" : @"(UTC+02:00) Asia/Beirut", @"Europe/Bucharest" : @"(UTC+02:00) Europe/Bucharest", @"Africa/Cairo" : @"(UTC+02:00) Africa/Cairo", @"Europe/Chisinau" : @"(UTC+02:00) Europe/Chisinau", @"Asia/Damascus" : @"(UTC+02:00) Asia/Damascus", @"Asia/Gaza" : @"(UTC+02:00) Asia/Gaza", @"Europe/Helsinki" : @"(UTC+02:00) Europe/Helsinki", @"Asia/Jerusalem" : @"(UTC+02:00) Asia/Jerusalem", @"Africa/Johannesburg" : @"(UTC+02:00) Africa/Johannesburg", @"Africa/Khartoum" : @"(UTC+02:00) Africa/Khartoum", @"Europe/Kiev" : @"(UTC+02:00) Europe/Kiev", @"Africa/Maputo" : @"(UTC+02:00) Africa/Maputo", @"Europe/Kaliningrad" : @"(UTC+02:00) Europe/Kaliningrad", @"Asia/Nicosia" : @"(UTC+02:00) Asia/Nicosia", @"Europe/Riga" : @"(UTC+02:00) Europe/Riga", @"Europe/Sofia" : @"(UTC+02:00) Europe/Sofia", @"Europe/Tallinn" : @"(UTC+02:00) Europe/Tallinn", @"Africa/Tripoli" : @"(UTC+02:00) Africa/Tripoli", @"Europe/Vilnius" : @"(UTC+02:00) Europe/Vilnius", @"Africa/Windhoek" : @"(UTC+02:00) Africa/Windhoek", @"Asia/Baghdad" : @"(UTC+03:00) Asia/Baghdad", @"Europe/Istanbul" : @"(UTC+03:00) Europe/Istanbul", @"Europe/Minsk" : @"(UTC+03:00) Europe/Minsk", @"Europe/Moscow" : @"(UTC+03:00) Europe/Moscow", @"Africa/Nairobi" : @"(UTC+03:00) Africa/Nairobi", @"Asia/Qatar" : @"(UTC+03:00) Asia/Qatar", @"Asia/Riyadh" : @"(UTC+03:00) Asia/Riyadh", @"Antarctica/Syowa" : @"(UTC+03:00) Antarctica/Syowa", @"Asia/Tehran" : @"(UTC+03:30) Asia/Tehran", @"Asia/Baku" : @"(UTC+04:00) Asia/Baku", @"Asia/Dubai" : @"(UTC+04:00) Asia/Dubai", @"Indian/Mahe" : @"(UTC+04:00) Indian/Mahe", @"Indian/Mauritius" : @"(UTC+04:00) Indian/Mauritius", @"Europe/Samara" : @"(UTC+04:00) Europe/Samara", @"Indian/Reunion" : @"(UTC+04:00) Indian/Reunion", @"Asia/Tbilisi" : @"(UTC+04:00) Asia/Tbilisi", @"Asia/Yerevan" : @"(UTC+04:00) Asia/Yerevan", @"Asia/Kabul" : @"(UTC+04:30) Asia/Kabul", @"Asia/Aqtau" : @"(UTC+05:00) Asia/Aqtau", @"Asia/Aqtobe" : @"(UTC+05:00) Asia/Aqtobe", @"Asia/Ashgabat" : @"(UTC+05:00) Asia/Ashgabat", @"Asia/Dushanbe" : @"(UTC+05:00) Asia/Dushanbe", @"Asia/Karachi" : @"(UTC+05:00) Asia/Karachi", @"Indian/Kerguelen" : @"(UTC+05:00) Indian/Kerguelen", @"Indian/Maldives" : @"(UTC+05:00) Indian/Maldives", @"Antarctica/Mawson" : @"(UTC+05:00) Antarctica/Mawson", @"Asia/Yekaterinburg" : @"(UTC+05:00) Asia/Yekaterinburg", @"Asia/Tashkent" : @"(UTC+05:00) Asia/Tashkent", @"Asia/Colombo" : @"(UTC+05:30) Asia/Colombo", @"Asia/Kolkata" : @"(UTC+05:30) Asia/Kolkata", @"Asia/Kathmandu" : @"(UTC+05:45) Asia/Kathmandu", @"Asia/Almaty" : @"(UTC+06:00) Asia/Almaty", @"Asia/Bishkek" : @"(UTC+06:00) Asia/Bishkek", @"Indian/Chagos" : @"(UTC+06:00) Indian/Chagos", @"Asia/Dhaka" : @"(UTC+06:00) Asia/Dhaka", @"Asia/Omsk" : @"(UTC+06:00) Asia/Omsk", @"Asia/Thimphu" : @"(UTC+06:00) Asia/Thimphu", @"Antarctica/Vostok" : @"(UTC+06:00) Antarctica/Vostok", @"Indian/Cocos" : @"(UTC+06:30) Indian/Cocos", @"Asia/Yangon" : @"(UTC+06:30) Asia/Yangon", @"Asia/Bangkok" : @"(UTC+07:00) Asia/Bangkok", @"Indian/Christmas" : @"(UTC+07:00) Indian/Christmas", @"Antarctica/Davis" : @"(UTC+07:00) Antarctica/Davis", @"Asia/Saigon" : @"(UTC+07:00) Asia/Saigon", @"Asia/Hovd" : @"(UTC+07:00) Asia/Hovd", @"Asia/Jakarta" : @"(UTC+07:00) Asia/Jakarta", @"Asia/Krasnoyarsk" : @"(UTC+07:00) Asia/Krasnoyarsk", @"Asia/Brunei" : @"(UTC+08:00) Asia/Brunei", @"Asia/Shanghai" : @"(UTC+08:00) Asia/Shanghai", @"Asia/Choibalsan" : @"(UTC+08:00) Asia/Choibalsan", @"Asia/Hong_Kong" : @"(UTC+08:00) Asia/Hong Kong", @"Asia/Kuala_Lumpur" : @"(UTC+08:00) Asia/Kuala Lumpur", @"Asia/Macau" : @"(UTC+08:00) Asia/Macau", @"Asia/Makassar" : @"(UTC+08:00) Asia/Makassar", @"Asia/Manila" : @"(UTC+08:00) Asia/Manila", @"Asia/Irkutsk" : @"(UTC+08:00) Asia/Irkutsk", @"Asia/Singapore" : @"(UTC+08:00) Asia/Singapore", @"Asia/Taipei" : @"(UTC+08:00) Asia/Taipei", @"Asia/Ulaanbaatar" : @"(UTC+08:00) Asia/Ulaanbaatar", @"Australia/Perth" : @"(UTC+08:00) Australia/Perth", @"Asia/Pyongyang" : @"(UTC+08:30) Asia/Pyongyang", @"Asia/Dili" : @"(UTC+09:00) Asia/Dili", @"Asia/Jayapura" : @"(UTC+09:00) Asia/Jayapura", @"Asia/Yakutsk" : @"(UTC+09:00) Asia/Yakutsk", @"Pacific/Palau" : @"(UTC+09:00) Pacific/Palau", @"Asia/Seoul" : @"(UTC+09:00) Asia/Seoul", @"Asia/Tokyo" : @"(UTC+09:00) Asia/Tokyo", @"Australia/Darwin" : @"(UTC+09:30) Australia/Darwin", @"Antarctica/DumontDUrville" : @"(UTC+10:00) Antarctica/Dumont d'Urville", @"Australia/Brisbane" : @"(UTC+10:00) Australia/Brisbane", @"Pacific/Guam" : @"(UTC+10:00) Pacific/Guam", @"Asia/Vladivostok" : @"(UTC+10:00) Asia/Vladivostok", @"Pacific/Port_Moresby" : @"(UTC+10:00) Pacific/Port Moresby", @"Pacific/Chuuk" : @"(UTC+10:00) Pacific/Chuuk", @"Australia/Adelaide" : @"(UTC+10:30) Australia/Adelaide", @"Antarctica/Casey" : @"(UTC+11:00) Antarctica/Casey", @"Australia/Hobart" : @"(UTC+11:00) Australia/Hobart", @"Australia/Sydney" : @"(UTC+11:00) Australia/Sydney", @"Pacific/Efate" : @"(UTC+11:00) Pacific/Efate", @"Pacific/Guadalcanal" : @"(UTC+11:00) Pacific/Guadalcanal", @"Pacific/Kosrae" : @"(UTC+11:00) Pacific/Kosrae", @"Asia/Magadan" : @"(UTC+11:00) Asia/Magadan", @"Pacific/Norfolk" : @"(UTC+11:00) Pacific/Norfolk", @"Pacific/Noumea" : @"(UTC+11:00) Pacific/Noumea", @"Pacific/Pohnpei" : @"(UTC+11:00) Pacific/Pohnpei", @"Pacific/Funafuti" : @"(UTC+12:00) Pacific/Funafuti", @"Pacific/Kwajalein" : @"(UTC+12:00) Pacific/Kwajalein", @"Pacific/Majuro" : @"(UTC+12:00) Pacific/Majuro", @"Asia/Kamchatka" : @"(UTC+12:00) Asia/Kamchatka", @"Pacific/Nauru" : @"(UTC+12:00) Pacific/Nauru", @"Pacific/Tarawa" : @"(UTC+12:00) Pacific/Tarawa", @"Pacific/Wake" : @"(UTC+12:00) Pacific/Wake", @"Pacific/Wallis" : @"(UTC+12:00) Pacific/Wallis", @"Pacific/Auckland" : @"(UTC+13:00) Pacific/Auckland", @"Pacific/Enderbury" : @"(UTC+13:00) Pacific/Enderbury", @"Pacific/Fakaofo" : @"(UTC+13:00) Pacific/Fakaofo", @"Pacific/Fiji" : @"(UTC+13:00) Pacific/Fiji", @"Pacific/Tongatapu" : @"(UTC+13:00) Pacific/Tongatapu", @"Pacific/Apia" : @"(UTC+14:00) Pacific/Apia", @"Pacific/Kiritimat" : @"(UTC+14:00) Pacific/Kiritimat"};

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
	BOOL isUsingMoreTimezones = [loadedPrefs objectForKey:@"isUsingMoreTimezones"] ? [[loadedPrefs objectForKey:@"isUsingMoreTimezones"] boolValue] : NO;

	[prefs setObject:[NSNumber numberWithBool:isEnabled] forKey:@"isEnabled"];
	[prefs setObject:[NSNumber numberWithBool:isNavTimeEnabled] forKey:@"isNavTimeEnabled"];
	[prefs setObject:[NSNumber numberWithBool:isGroupDetailTimeEnabled] forKey:@"isGroupDetailTimeEnabled"];
	[prefs setObject:[NSNumber numberWithBool:isSingleDetailTimeEnabled] forKey:@"isSingleDetailTimeEnabled"];
	[prefs setObject:[NSNumber numberWithBool:isUsingMoreTimezones] forKey:@"isUsingMoreTimezones"];
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

- (NSArray *)getTimezonesArray{
	return [self prefsBoolForKey:@"isUsingMoreTimezones"] ? moreTimezones : timezones;
}

- (NSString *)tzIDForTimezoneText:(NSString *)arg1{

	for (NSString *key in timezoneDict){
		if ([arg1 isEqualToString:timezoneDict[key]]){
			return key;
		}
	}

	return nil;
}

- (NSString *)timezoneTextForTZID:(NSString *)arg1{
	return timezoneDict[arg1];
}

- (NSInteger)indexForTimezoneText:(NSString *)arg1{
	NSInteger valIndex = 0;

	NSArray *timezoneList = [self getTimezonesArray];

	for (NSString *tzText in timezoneList){
		if ([arg1 isEqualToString:tzText]){
			return valIndex;
		} else {
			valIndex++;
		}
	}

	return -1;
}

- (NSInteger)indexForTZID:(NSString *)arg1{

	NSString *timezoneText = [self timezoneTextForTZID:arg1];

	return timezoneText ? [self indexForTimezoneText:timezoneText] : -1;
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
