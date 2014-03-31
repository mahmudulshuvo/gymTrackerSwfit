#import <Foundation/Foundation.h>
#import "Settings.h"

@interface Utility : NSObject

@property (nonatomic, strong) NSString *documentDir;
@property (nonatomic, strong) NSString *databaseName;
@property (nonatomic, strong) NSString *databasePath;
@property (nonatomic, strong) Settings *settings;
@property (nonatomic, strong) NSDateFormatter *dbDateFormat;
@property (nonatomic, strong) NSDateFormatter *userFriendlyDateFormat;
@property (nonatomic, strong) NSDateFormatter *dateOnlyDateFormat;
@property (nonatomic, strong) UIImage *noImage;
@property (nonatomic, strong) NSMutableArray *equipmentsList;
@property (nonatomic, strong) NSMutableArray *measurementsList;

+ (void) showAlert:(NSString *) title message:(NSString *) msg;
+ (NSDate *)dateAtBeginningOfDayForDate:(NSDate *)inputDate;
+ (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)newSize;

+ (Utility *) sharedInstance;

@end