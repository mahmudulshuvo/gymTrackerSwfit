#import "PNLineChartDataItem.h"

//------------------------------------------------------------------------------------------------
// private interface declaration
//------------------------------------------------------------------------------------------------
@interface PNLineChartDataItem ()

@property (readwrite) CGFloat y; // should be within the y range

- (id)initWithY:(CGFloat)y;

@end

//------------------------------------------------------------------------------------------------
// public interface implementation
//------------------------------------------------------------------------------------------------
@implementation PNLineChartDataItem

+ (PNLineChartDataItem *)dataItemWithY:(CGFloat)y
{
    return [[PNLineChartDataItem alloc] initWithY:y];
}

- (id)initWithY:(CGFloat)y
{
    if ((self = [super init]))
    {
        self.y = y;
    }
    return self;
}

@end
