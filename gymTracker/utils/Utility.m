#import "Utility.h"
#import "AppDelegate.h"

@implementation Utility

+ (void) showAlert:(NSString *)title message:(NSString *)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];

    [alert show];
}

+ (Utility *) sharedInstance
{
    static Utility *_sharedClient = nil;
    
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedClient = [self new];
        
        _sharedClient.dateOnlyDateFormat = [NSDateFormatter new];
        _sharedClient.dateOnlyDateFormat.dateFormat = @"dd";
        
        _sharedClient.dbDateFormat = [NSDateFormatter new];
        _sharedClient.dbDateFormat.dateFormat = @"yyyy-MM-dd";
        
        _sharedClient.userFriendlyDateFormat = [NSDateFormatter new];
        _sharedClient.userFriendlyDateFormat.dateFormat = @"MMM/dd/yyyy";
    });
    
    return _sharedClient;
}

+ (NSDate *)dateAtBeginningOfDayForDate:(NSDate *)inputDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    [calendar setTimeZone:timeZone];
    
    NSDateComponents *dateComps = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:inputDate];
    
    [dateComps setHour:0];
    [dateComps setMinute:0];
    [dateComps setSecond:0];
    
    NSDate *beginningOfDay = [calendar dateFromComponents:dateComps];
    return beginningOfDay;
}

+ (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)newSize
{
    float width = newSize.width;
    float height = newSize.height;
    
    UIGraphicsBeginImageContext(newSize);
    CGRect rect = CGRectMake(0, 0, width, height);
    
    float widthRatio = image.size.width / width;
    float heightRatio = image.size.height / height;
    float divisor = widthRatio > heightRatio ? widthRatio : heightRatio;
    
    width = image.size.width / divisor;
    height = image.size.height / divisor;
    
    rect.size.width  = width;
    rect.size.height = height;
    
    float offset = (width - height) / 2;
    if (offset > 0)
    {
        rect.origin.y = offset;
    }
    else
    {
        rect.origin.x = -offset;
    }
    
    [image drawInRect: rect];
    
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return smallImage;
}

@end