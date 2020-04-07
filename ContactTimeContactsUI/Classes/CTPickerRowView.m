
#import "CTPickerRowView.h"

@implementation CTPickerRowView
@synthesize label;

- (id)init{
	self = [super init];

	if (self){
		label = [[UILabel alloc] init];
		[self addSubview:label];
	}

	return self;
}

- (void)layoutSubviews{
	[super layoutSubviews];

	label.frame = CGRectInset(self.frame, 12, 0);
}

@end
