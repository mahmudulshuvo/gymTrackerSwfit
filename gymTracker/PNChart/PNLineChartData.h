#import <Foundation/Foundation.h>

@class PNLineChartDataItem;

typedef PNLineChartDataItem *(^LCLineChartDataGetter)(NSUInteger item);

/**
*
*/
@interface PNLineChartData : NSObject

@property (strong) UIColor *color;

@property NSUInteger itemCount;

@property (copy) LCLineChartDataGetter getData;

@end
