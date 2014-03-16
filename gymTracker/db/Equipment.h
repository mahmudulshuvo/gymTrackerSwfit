#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Equipment : NSObject

@property (nonatomic, strong) NSNumber * id;
@property (nonatomic, strong) NSString * equipmentName;
@property (nonatomic, strong) NSString * imageName;
@property (nonatomic, strong) NSNumber * workoutId;

@end
