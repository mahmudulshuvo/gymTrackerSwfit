#import <Foundation/Foundation.h>

@protocol PNChartDelegate <NSObject>

/**
 * When user click on the chart line
 *
 */
- (void)userClickedOnLinePoint:(CGPoint )point lineIndex:(NSInteger)lineIndex;

/**
 * When user click on the chart line key point
 *
 */
- (void)userClickedOnLineKeyPoint:(CGPoint )point lineIndex:(NSInteger)lineIndex andPointIndex:(NSInteger)pointIndex;


@end
