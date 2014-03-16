#import <UIKit/UIKit.h>
#import "PNColor.h"


#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

@interface PNCircleChart : UIView

-(void)strokeChart;
- (id)initWithFrame:(CGRect)frame andTotal:(NSNumber *)total andCurrent:(NSNumber *)current andClockwise:(BOOL)clockwise;

@property (nonatomic, strong) UIColor *strokeColor;
@property (nonatomic, strong) UIColor *labelColor;
@property (nonatomic, strong) NSNumber * total;
@property (nonatomic, strong) NSNumber * current;
@property (nonatomic, strong) NSNumber * lineWidth;
@property (nonatomic) BOOL clockwise;

@property(nonatomic,strong) CAShapeLayer * circle;
@property(nonatomic,strong) CAShapeLayer * circleBG;

@end
