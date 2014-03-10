#import <Foundation/Foundation.h>

@interface Utility : NSObject

+ (void) showAlert:(NSString *) title message:(NSString *) msg;
+ (NSDate *)dateAtBeginningOfDayForDate:(NSDate *)inputDate;
+ (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)newSize;

@end