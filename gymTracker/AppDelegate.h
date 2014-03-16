#import <UIKit/UIKit.h>
#import "Settings.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic,strong) NSString *databaseName;
@property (nonatomic,strong) NSString *databasePath;
@property (nonatomic,strong) Settings *settings;

@end
