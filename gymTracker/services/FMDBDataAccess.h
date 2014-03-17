#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "Equipment.h"
#import "Workout.h"
#import "Settings.h"

@interface FMDBDataAccess : NSObject

+ (NSMutableArray *) getEquipments;
+ (BOOL) createEquipment:(Equipment *) equipment;
+ (BOOL) updateEquipment:(Equipment *) equipment;
+ (BOOL) deleteEquipment:(Equipment *) equipment;

+ (NSMutableArray *) getWorkoutsByDate:(NSString *)date;
+ (NSMutableArray *) getWorkoutsByEquipmentId:(NSNumber *) equipmentId;
+ (Workout *) loadWorkoutByEquipmentIdAndDate:(NSNumber *) equipmentId date:(NSString *) date;
+ (BOOL) createWorkout:(Workout *) workout;
+ (BOOL) updateWorkout:(Workout *) workout;
+ (BOOL) deleteWorkout:(Workout *) workout;

+ (Settings *) getSettings;
+ (BOOL) updateSettings:(Settings *) settings;

+ (NSArray *) getWorkoutDates;

@end
