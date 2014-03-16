#import <Foundation/Foundation.h>
#import "Settings.h"

@interface Utility : NSObject
{
    Settings *settings;
}

+ (NSString *) getDatabasePath;
+ (void) showAlert:(NSString *) title message:(NSString *) msg;
+ (NSDate *)dateAtBeginningOfDayForDate:(NSDate *)inputDate;
+ (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)newSize;

@end