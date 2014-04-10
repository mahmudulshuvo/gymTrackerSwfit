#import "FMDBDataAccess.h"
#import "Utility.h"
#import "LineChartVO.h"

@implementation FMDBDataAccess

Utility *utility;

+ (NSMutableArray *) getEquipments
{
    NSMutableArray *equipments = [NSMutableArray new];
    
    FMDatabase *db = [FMDatabase databaseWithPath:utility.databasePath];
    
    [db open];
    
    FMResultSet *results = [db executeQuery:@"SELECT * FROM equipment order by equipment_name ASC"];
    
    while([results next])
    {
        Equipment *equipment = [Equipment new];
        equipment.id = [NSNumber numberWithInt:[results intForColumn:@"id"]];
        equipment.equipmentName = [results stringForColumn:@"equipment_name"];
        equipment.imageName = [results stringForColumn:@"image_name"];
        equipment.measurementId = [NSNumber numberWithInt:[results intForColumn:@"measurement_id"]];
        
        [equipments addObject:equipment];
    }
    
    [db close];
    
    return equipments;
}

+ (BOOL) createEquipment:(Equipment *) equipment
{
    FMDatabase *db = [FMDatabase databaseWithPath:utility.databasePath];
    
    [db open];
    
    BOOL success =  [db executeUpdate:@"INSERT INTO equipment (equipment_name, image_name, measurement_id) VALUES (?, ?, ?);",
                     equipment.equipmentName, equipment.imageName, equipment.measurementId, nil];
    
    [db close];
    
    return success;
}

+ (BOOL) updateEquipment:(Equipment *) equipment
{
    FMDatabase *db = [FMDatabase databaseWithPath:utility.databasePath];
    
    [db open];
    
    BOOL success = [db executeUpdate:[NSString stringWithFormat:@"UPDATE equipment SET equipment_name = '%@', image_name = '%@', measurement_id = %@ where id = %@", equipment.equipmentName, equipment.imageName, equipment.measurementId, equipment.id]];
    
    [db close];
    
    return success;
}

+ (BOOL) deleteEquipment:(Equipment *) equipment
{
    FMDatabase *db = [FMDatabase databaseWithPath:utility.databasePath];
    
    [db open];
    
    [db executeUpdate:[NSString stringWithFormat:@"delete from workout where equipment_id = %@", equipment.id]];
    
    BOOL success = [db executeUpdate:[NSString stringWithFormat:@"delete from equipment where id = %@", equipment.id]];
    
    [db close];
    
    return success;
}

+ (NSMutableArray *) getMeasurements
{
    NSMutableArray *measurements = [NSMutableArray new];
    
    FMDatabase *db = [FMDatabase databaseWithPath:utility.databasePath];
    
    [db open];
    
    FMResultSet *results = [db executeQuery:@"SELECT * FROM measurement order by measurement_name ASC"];
    
    while([results next])
    {
        Measurement *measurement = [Measurement new];
        measurement.id = [NSNumber numberWithInt:[results intForColumn:@"id"]];
        measurement.measurementName = [results stringForColumn:@"measurement_name"];
        
        [measurements addObject:measurement];
    }
    
    [db close];
    
    return measurements;
}

+ (BOOL) createMeasurement:(Measurement *) measurement
{
    FMDatabase *db = [FMDatabase databaseWithPath:utility.databasePath];
    
    [db open];
    
    BOOL success =  [db executeUpdate:@"INSERT INTO measurement (measurement_name) VALUES (?);",
                     measurement.measurementName, nil];
    
    [db close];
    
    return success;
}

+ (BOOL) updateMeasurement:(Measurement *) measurement
{
    FMDatabase *db = [FMDatabase databaseWithPath:utility.databasePath];
    
    [db open];
    
    BOOL success = [db executeUpdate:[NSString stringWithFormat:@"UPDATE measurement SET measurement_name = '%@' where id = %@", measurement.measurementName, measurement.id]];
    
    [db close];
    
    return success;
}

+ (BOOL) deleteMeasurement:(Measurement *) measurement
{
    FMDatabase *db = [FMDatabase databaseWithPath:utility.databasePath];
    
    [db open];
    
    [db executeUpdate:[NSString stringWithFormat:@"delete from measurement_history where measurement_id = %@", measurement.id]];
    
    [db executeUpdate:[NSString stringWithFormat:@"UPDATE equipment SET measurement_id = NULL where measurement_id = %@", measurement.id]];
    
    BOOL success = [db executeUpdate:[NSString stringWithFormat:@"delete from measurement where id = %@", measurement.id]];
    
    [db close];
    
    return success;
}

+ (NSArray *) getWorkoutDatesByRange:(NSString *)strFromdate toDate:(NSString *)strToDate
{
    NSMutableArray *workouts = [NSMutableArray new];
    
    FMDatabase *db = [FMDatabase databaseWithPath:utility.databasePath];
    
    [db open];
    
    FMResultSet *results = [db executeQuery:[NSString stringWithFormat:@"SELECT DISTINCT workout_date FROM workout where workout_date BETWEEN '%@' and '%@' order by workout_date ASC", strFromdate, strToDate]];
    
    while([results next])
    {
        [workouts addObject:[results stringForColumn:@"workout_date"]];
    }
    
    [db close];
    
    return workouts;
}

+ (NSMutableArray *) getWorkoutsByDate:(NSString *)date
{
    NSMutableArray *workouts = [NSMutableArray new];
    
    FMDatabase *db = [FMDatabase databaseWithPath:utility.databasePath];
    
    [db open];
    
    FMResultSet *results = [db executeQuery:[NSString stringWithFormat:@"SELECT workout.id as id, workout_set_1, workout_set_2, workout_set_3, workout_set_4, workout_set_5, equipment_name, image_name FROM workout, equipment where workout_date = '%@' and workout.equipment_id = equipment.id order by equipment_name ASC", date]];
    
    while([results next])
    {
        Workout *workout = [Workout new];
        workout.id = [NSNumber numberWithDouble:[results intForColumn:@"id"]];
        workout.workoutSet1 = [NSNumber numberWithDouble:[results doubleForColumn:@"workout_set_1"]];
        workout.workoutSet2 = [NSNumber numberWithDouble:[results doubleForColumn:@"workout_set_2"]];
        workout.workoutSet3 = [NSNumber numberWithDouble:[results doubleForColumn:@"workout_set_3"]];
        workout.workoutSet4 = [NSNumber numberWithDouble:[results doubleForColumn:@"workout_set_4"]];
        workout.workoutSet5 = [NSNumber numberWithDouble:[results doubleForColumn:@"workout_set_5"]];
        workout.equipmentName = [results stringForColumn:@"equipment_name"];
        workout.equipmentImageName = [results stringForColumn:@"image_name"];
        
        [workouts addObject:workout];
    }
    
    [db close];
    
    return workouts;
}

+ (NSMutableArray *) getWorkoutsByEquipmentId:(NSNumber *) equipmentId fromDate:(NSString *)strFromdate toDate:(NSString *)strToDate;
{
    NSMutableArray *workouts = [NSMutableArray new];
    
    FMDatabase *db = [FMDatabase databaseWithPath:utility.databasePath];
    
    [db open];
    
    FMResultSet *results = [db executeQuery:[NSString stringWithFormat:@"SELECT workout_set_1,  workout_set_2, workout_set_3, workout_set_4, workout_set_5, workout_date FROM workout where equipment_id = %@ AND workout_date BETWEEN '%@' and '%@' order by workout_date ASC", equipmentId, strFromdate, strToDate]];
    
    while([results next])
    {
        LineChartVO *lineChartVO = [LineChartVO new];
        lineChartVO.value = [NSNumber numberWithDouble:[results doubleForColumn:@"workout_set_1"] +               [results doubleForColumn:@"workout_set_2"] + [results doubleForColumn:@"workout_set_3"] +
                                   [results doubleForColumn:@"workout_set_4"] + [results doubleForColumn:@"workout_set_5"]];
        lineChartVO.date = [results stringForColumn:@"workout_date"];
        
        [workouts addObject:lineChartVO];
    }
    
    [db close];
    
    return workouts;
}

+ (Workout *) loadWorkout:(Workout *) workout
{
    FMDatabase *db = [FMDatabase databaseWithPath:utility.databasePath];
    
    [db open];
    
    FMResultSet *results = [db executeQuery:[NSString stringWithFormat:@"SELECT equipment_id, workout_date from workout where id = %@", workout.id]];
    
    while([results next])
    {
        workout.workoutDate = [results stringForColumn:@"workout_date"];
        workout.equipmentId = [NSNumber numberWithDouble:[results intForColumn:@"equipment_id"]];
    }
    
    [db close];
    return workout;
}

+ (Workout *) loadWorkoutByEquipmentIdAndDate:(NSNumber *) equipmentId date:(NSString *) date
{
    FMDatabase *db = [FMDatabase databaseWithPath:utility.databasePath];
    
    [db open];
    
    FMResultSet *results = [db executeQuery:[NSString stringWithFormat:@"SELECT * from workout where workout_date = '%@' and equipment_id = %@", date, equipmentId]];
    Workout *workout;
    
    while([results next])
    {
        workout = [Workout new];
        workout.id = [NSNumber numberWithDouble:[results intForColumn:@"id"]];
        workout.workoutSet1 = [NSNumber numberWithDouble:[results doubleForColumn:@"workout_set_1"]];
        workout.workoutSet2 = [NSNumber numberWithDouble:[results doubleForColumn:@"workout_set_2"]];
        workout.workoutSet3 = [NSNumber numberWithDouble:[results doubleForColumn:@"workout_set_3"]];
        workout.workoutSet4 = [NSNumber numberWithDouble:[results doubleForColumn:@"workout_set_4"]];
        workout.workoutSet5 = [NSNumber numberWithDouble:[results doubleForColumn:@"workout_set_5"]];
        workout.workoutDate = [results stringForColumn:@"workout_date"];
        workout.equipmentId = [NSNumber numberWithDouble:[results intForColumn:@"equipment_id"]];
    }
    
    [db close];
    return workout;
}

+ (BOOL) createWorkout:(Workout *) workout
{
    FMDatabase *db = [FMDatabase databaseWithPath:utility.databasePath];
    
    [db open];
    
    BOOL success =  [db executeUpdate:@"INSERT INTO workout (workout_set_1, workout_set_2, workout_set_3, workout_set_4, workout_set_5, workout_date, equipment_id) VALUES (?, ?, ?, ?, ?, ?, ?);",
                     workout.workoutSet1, workout.workoutSet2, workout.workoutSet3, workout.workoutSet4, workout.workoutSet5, workout.workoutDate, workout.equipmentId, nil];
    
    [db close];
    
    return success;
}

+ (BOOL) updateWorkout:(Workout *) workout
{
    FMDatabase *db = [FMDatabase databaseWithPath:utility.databasePath];
    
    [db open];
    
    BOOL success = [db executeUpdate:[NSString stringWithFormat:@"UPDATE workout SET workout_set_1 = %@, workout_set_2 = %@, workout_set_3 = %@, workout_set_4 = %@, workout_set_5 = %@ where id = %@", workout.workoutSet1, workout.workoutSet2, workout.workoutSet3, workout.workoutSet4, workout.workoutSet5, workout.id]];
    
    [db close];
    
    return success;
}

+ (BOOL) deleteWorkout:(Workout *) workout
{
    FMDatabase *db = [FMDatabase databaseWithPath:utility.databasePath];
    
    [db open];
    
    BOOL success = [db executeUpdate:[NSString stringWithFormat:@"delete from workout where id = %@", workout.id]];
    
    [db close];
    
    return success;
}

+ (NSArray *) getMeasurementHistoryDatesByRange:(NSString *)strFromdate toDate:(NSString *)strToDate
{
    NSMutableArray *measurementHistories = [NSMutableArray new];
    
    FMDatabase *db = [FMDatabase databaseWithPath:utility.databasePath];
    
    [db open];
    
    FMResultSet *results = [db executeQuery:[NSString stringWithFormat:@"SELECT DISTINCT measurement_date FROM measurement_history where measurement_date BETWEEN '%@' and '%@' order by measurement_date ASC", strFromdate, strToDate]];
    
    while([results next])
    {
        [measurementHistories addObject:[results stringForColumn:@"measurement_date"]];
    }
    
    [db close];
    
    return measurementHistories;
}

+ (NSMutableArray *) getMeasurementHistoryByDate:(NSString *)date
{
    NSMutableArray *measurementHistories = [NSMutableArray new];
    
    FMDatabase *db = [FMDatabase databaseWithPath:utility.databasePath];
    
    [db open];
    
    FMResultSet *results = [db executeQuery:[NSString stringWithFormat:@"SELECT measurement_history.id as id, measurement_name, size FROM measurement_history, measurement where measurement_date = '%@' and measurement_history.measurement_id = measurement.id order by measurement_name ASC", date]];
    
    while([results next])
    {
        MeasurementHistory *measurementHistory = [MeasurementHistory new];
        measurementHistory.id = [NSNumber numberWithDouble:[results intForColumn:@"id"]];
        measurementHistory.size = [NSNumber numberWithDouble:[results doubleForColumn:@"size"]];
        measurementHistory.measurementName = [results stringForColumn:@"measurement_name"];
        
        [measurementHistories addObject:measurementHistory];
    }
    
    [db close];
    
    return measurementHistories;
}

+ (NSMutableArray *) getMeasurementHistoryByMeasurementId:(NSNumber *)measurementId fromDate:(NSString *)strFromdate toDate:(NSString *)strToDate
{
    NSMutableArray *measurementHistories = [NSMutableArray new];
    
    FMDatabase *db = [FMDatabase databaseWithPath:utility.databasePath];
    
    [db open];
    
    FMResultSet *results = [db executeQuery:[NSString stringWithFormat:@"SELECT size, measurement_date FROM measurement_history where measurement_history.measurement_id = %@ AND measurement_date BETWEEN '%@' and '%@' order by measurement_date ASC", measurementId, strFromdate, strToDate]];
    
    while([results next])
    {
        LineChartVO *lineChartVO = [LineChartVO new];
        lineChartVO.value = [NSNumber numberWithDouble:[results doubleForColumn:@"size"]];
        lineChartVO.date = [results stringForColumn:@"measurement_date"];
        
        [measurementHistories addObject:lineChartVO];
    }
    
    [db close];
    
    return measurementHistories;
}

+ (MeasurementHistory *)loadMeasurementHistory:(MeasurementHistory *)measurementHistory
{
    FMDatabase *db = [FMDatabase databaseWithPath:utility.databasePath];
    
    [db open];
    
    FMResultSet *results = [db executeQuery:[NSString stringWithFormat:@"SELECT measurement_id, measurement_date from measurement_history where id = %@", measurementHistory.id]];
    
    while([results next])
    {
        measurementHistory.measurementDate = [results stringForColumn:@"measurement_date"];
        measurementHistory.measurementId = [NSNumber numberWithDouble:[results intForColumn:@"measurement_id"]];
    }
    
    [db close];
    
    return measurementHistory;
}

+ (MeasurementHistory *)loadMeasurementHistoryByMeasurementIdAndDate:(NSNumber *)measurementId date:(NSString *)date
{
    FMDatabase *db = [FMDatabase databaseWithPath:utility.databasePath];
    
    [db open];
    
    FMResultSet *results = [db executeQuery:[NSString stringWithFormat:@"SELECT * from measurement_history where measurement_date = '%@' and measurement_history.measurement_id = %@", date, measurementId]];
    MeasurementHistory *measurementHistory;
    
    while([results next])
    {
        measurementHistory = [MeasurementHistory new];
        measurementHistory.id = [NSNumber numberWithDouble:[results intForColumn:@"id"]];
        measurementHistory.size = [NSNumber numberWithDouble:[results doubleForColumn:@"size"]];
        measurementHistory.measurementDate = [results stringForColumn:@"measurement_date"];
        measurementHistory.measurementId = [NSNumber numberWithDouble:[results intForColumn:@"measurement_id"]];
    }
    
    [db close];
    
    return measurementHistory;
}

+ (BOOL)createMeasurementHistory:(MeasurementHistory *)measurementHistory
{
    FMDatabase *db = [FMDatabase databaseWithPath:utility.databasePath];
    
    [db open];
    
    BOOL success =  [db executeUpdate:@"INSERT INTO measurement_history (size, measurement_date, measurement_id) VALUES (?, ?, ?);", measurementHistory.size, measurementHistory.measurementDate, measurementHistory.measurementId, nil];
    
    [db close];
    
    return success;
}

+ (BOOL)updateMeasurementHistory:(MeasurementHistory *)measurementHistory
{
    FMDatabase *db = [FMDatabase databaseWithPath:utility.databasePath];
    
    [db open];
    
    BOOL success = [db executeUpdate:[NSString stringWithFormat:@"UPDATE measurement_history SET size = %@  where id = %@", measurementHistory.size, measurementHistory.id]];
    
    [db close];
    
    return success;
}

+ (BOOL)deleteMeasurementHistory:(MeasurementHistory *)measurementHistory
{
    FMDatabase *db = [FMDatabase databaseWithPath:utility.databasePath];
    
    [db open];
    
    BOOL success = [db executeUpdate:[NSString stringWithFormat:@"delete from measurement_history where id = %@", measurementHistory.id]];
    
    [db close];
    
    return success;
}

+ (Settings *) getSettings
{
    FMDatabase *db = [FMDatabase databaseWithPath:utility.databasePath];
    
    [db open];
    
    FMResultSet *results = [db executeQuery:@"SELECT * FROM settings"];
    Settings *settings;
    
    while([results next])
    {
        settings = [Settings new];
        settings.id = [NSNumber numberWithInt:[results intForColumn:@"id"]];
        settings.weight = [results stringForColumn:@"weight"];
        settings.sets = [NSNumber numberWithInt:[results intForColumn:@"sets"]];
        settings.measurement = [results stringForColumn:@"measurement"];
    }
    
    [db close];
    
    return settings;
}

+ (BOOL) updateSettings:(Settings *) settings
{
    FMDatabase *db = [FMDatabase databaseWithPath:utility.databasePath];
    
    [db open];
    
    BOOL success = [db executeUpdate:[NSString stringWithFormat:@"UPDATE settings SET weight = '%@', sets = %@, measurement = '%@' where id = %@", settings.weight, settings.sets, settings.measurement, settings.id]];
    
    [db close];
    
    return success;
}

@end
