#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "Equipment.h"
#import "Workout.h"
#import "Settings.h"
#import "Measurement.h"
#import "MeasurementHistory.h"

@interface FMDBDataAccess : NSObject

+ (NSMutableArray *) getEquipments;
+ (BOOL) createEquipment:(Equipment *) equipment;
+ (BOOL) updateEquipment:(Equipment *) equipment;
+ (BOOL) deleteEquipment:(Equipment *) equipment;

+ (NSMutableArray *) getMeasurements;
+ (BOOL) createMeasurement:(Measurement *) measurement;
+ (BOOL) updateMeasurement:(Measurement *) measurement;
+ (BOOL) deleteMeasurement:(Measurement *) measurement;

+ (NSArray *) getWorkoutDates;
+ (NSMutableArray *) getWorkoutsByDate:(NSString *)date;
+ (NSMutableArray *) getWorkoutsByEquipmentId:(NSNumber *) equipmentId fromDate:(NSString *)strFromdate toDate:(NSString *)strToDate;
+ (Workout *) loadWorkoutByEquipmentIdAndDate:(NSNumber *) equipmentId date:(NSString *) date;
+ (Workout *) loadWorkout:(Workout *) workout;
+ (BOOL) createWorkout:(Workout *) workout;
+ (BOOL) updateWorkout:(Workout *) workout;
+ (BOOL) deleteWorkout:(Workout *) workout;

+ (NSArray *) getMeasurementHistoryDates;
+ (NSMutableArray *) getMeasurementHistoryByDate:(NSString *)date;
+ (NSMutableArray *) getMeasurementHistoryByMeasurementId:(NSNumber *) measurementId fromDate:(NSString *)strFromdate toDate:(NSString *)strToDate;
+ (MeasurementHistory *) loadMeasurementHistoryByMeasurementIdAndDate:(NSNumber *) measurementId date:(NSString *) date;
+ (MeasurementHistory *) loadMeasurementHistory:(MeasurementHistory *) measurementHistory;
+ (BOOL) createMeasurementHistory:(MeasurementHistory *) measurementHistory;
+ (BOOL) updateMeasurementHistory:(MeasurementHistory *) measurementHistory;
+ (BOOL) deleteMeasurementHistory:(MeasurementHistory *) measurementHistory;

+ (Settings *) getSettings;
+ (BOOL) updateSettings:(Settings *) settings;

@end
