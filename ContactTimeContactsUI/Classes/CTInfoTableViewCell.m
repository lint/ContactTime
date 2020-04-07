
#import "CTInfoTableViewCell.h"

@implementation CTInfoTableViewCell
@synthesize titleLabel, tzLabel;

- (id)initWithStyle:(UITableViewCellStyle)arg1 reuseIdentifier:(NSString *)arg2{

	self = [super initWithStyle:arg1 reuseIdentifier:arg2];

	if (self){
		titleLabel = [[UILabel alloc] init];
		tzLabel = [[UILabel alloc] init];

		titleLabel.text = @"Timezone";
		tzLabel.text = @"CT_PLACEHOLDER";

		[self addSubview:titleLabel];
		[self addSubview:tzLabel];
	}

	return self;
}

@end
