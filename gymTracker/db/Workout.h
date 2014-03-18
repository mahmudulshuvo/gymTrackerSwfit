#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Workout : NSObject

@property (nonatomic, strong) NSNumber * id;
@property (nonatomic, strong) NSNumber * workoutSet1;
@property (nonatomic, strong) NSNumber * workoutSet2;
@property (nonatomic, strong) NSNumber * workoutSet3;
@property (nonatomic, strong) NSNumber * workoutSet4;
@property (nonatomic, strong) NSNumber * workoutSet5;
@property (nonatomic, strong) NSString * workoutDate;
@property (nonatomic, strong) NSNumber * equipmentId;
@property (nonatomic, strong) NSString * equipmentName;
@property (nonatomic, strong) NSString * equipmentImageName;

@end
