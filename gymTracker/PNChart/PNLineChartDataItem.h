#import <Foundation/Foundation.h>

@interface PNLineChartDataItem : NSObject

@property (readonly) CGFloat y; // should be within the y range

+ (PNLineChartDataItem *)dataItemWithY:(CGFloat)y;

@end
