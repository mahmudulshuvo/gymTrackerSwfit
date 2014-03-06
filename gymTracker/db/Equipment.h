#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Workout;

@interface Equipment : NSManagedObject

@property (nonatomic, retain) NSString * equipmentName;
@property (nonatomic, retain) NSString * imageName;
@property (nonatomic, retain) NSSet *workout;
@end

@interface Equipment (CoreDataGeneratedAccessors)

- (void)addWorkoutObject:(Workout *)value;
- (void)removeWorkoutObject:(Workout *)value;
- (void)addWorkout:(NSSet *)values;
- (void)removeWorkout:(NSSet *)values;

@end
