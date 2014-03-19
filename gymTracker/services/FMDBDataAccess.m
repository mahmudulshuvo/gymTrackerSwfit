#import "FMDBDataAccess.h"
#import "Utility.h"
#import "LineChartVO.h"

@implementation FMDBDataAccess

+ (NSMutableArray *) getEquipments
{
    NSMutableArray *equipments = [NSMutableArray new];
    
    FMDatabase *db = [FMDatabase databaseWithPath:[Utility sharedInstance].databasePath];
    
    [db open];
    
    FMResultSet *results = [db executeQuery:@"SELECT * FROM equipment order by equipment_name ASC"];
    
    while([results next])
    {
        Equipment *equipment = [Equipment new];
        equipment.id = [NSNumber numberWithInt:[results intForColumn:@"id"]];
        equipment.equipmentName = [results stringForColumn:@"equipment_name"];
        equipment.imageName = [results stringForColumn:@"image_name"];
        
        [equipments addObject:equipment];
    }
    
    [db close];
    
    return equipments;
}

+ (BOOL) createEquipment:(Equipment *) equipment
{
    FMDatabase *db = [FMDatabase databaseWithPath:[Utility sharedInstance].databasePath];
    
    [db open];
    
    BOOL success =  [db executeUpdate:@"INSERT INTO equipment (equipment_name, image_name) VALUES (?,?);",
                     equipment.equipmentName, equipment.imageName, nil];
    
    [db close];
    
    return success;
}

+ (BOOL) updateEquipment:(Equipment *) equipment
{
    FMDatabase *db = [FMDatabase databaseWithPath:[Utility sharedInstance].databasePath];
    
    [db open];
    
    BOOL success = [db executeUpdate:[NSString stringWithFormat:@"UPDATE equipment SET equipment_name = '%@', image_name = '%@' where id = %@", equipment.equipmentName, equipment.imageName, equipment.id]];
    
    [db close];
    
    return success;
}

+ (BOOL) deleteEquipment:(Equipment *) equipment
{
    FMDatabase *db = [FMDatabase databaseWithPath:[Utility sharedInstance].databasePath];
    
    [db open];
    
    BOOL success = [db executeUpdate:[NSString stringWithFormat:@"delete from equipment where id = %@", equipment.id]];
    
    [db close];
    
    return success;
}

+ (NSMutableArray *) getWorkoutsByDate:(NSString *)date
{
    NSMutableArray *workouts = [NSMutableArray new];
    
    FMDatabase *db = [FMDatabase databaseWithPath:[Utility sharedInstance].databasePath];
    
    [db open];
    
    FMResultSet *results = [db executeQuery:[NSString stringWithFormat:@"SELECT workout_set_1, workout_set_2, workout_set_3, workout_set_4, workout_set_5, equipment_name, image_name FROM workout, equipment where workout_date = '%@' and workout.equipment_id = equipment.id order by equipment_name ASC", date]];
    
    while([results next])
    {
        Workout *workout = [Workout new];
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
    
    FMDatabase *db = [FMDatabase databaseWithPath:[Utility sharedInstance].databasePath];
    
    [db open];
    
    FMResultSet *results = [db executeQuery:[NSString stringWithFormat:@"SELECT workout_set_1,  workout_set_2, workout_set_3, workout_set_4, workout_set_5, workout_date FROM workout where equipment_id = %@ AND workout_date BETWEEN '%@' and '%@' order by workout_date ASC", equipmentId, strFromdate, strToDate]];
    
    while([results next])
    {
        LineChartVO *lineChartVO = [LineChartVO new];
        lineChartVO.workoutSets = [NSNumber numberWithDouble:[results doubleForColumn:@"workout_set_1"] +               [results doubleForColumn:@"workout_set_2"] + [results doubleForColumn:@"workout_set_3"] +
                                   [results doubleForColumn:@"workout_set_4"] + [results doubleForColumn:@"workout_set_5"]];
        lineChartVO.workoutDate = [results stringForColumn:@"workout_date"];
        
        [workouts addObject:lineChartVO];
    }
    
    [db close];
    
    return workouts;
}

+ (Workout *) loadWorkoutByEquipmentIdAndDate:(NSNumber *) equipmentId date:(NSString *) date
{
    FMDatabase *db = [FMDatabase databaseWithPath:[Utility sharedInstance].databasePath];
    
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
    FMDatabase *db = [FMDatabase databaseWithPath:[Utility sharedInstance].databasePath];
    
    [db open];
    
    BOOL success =  [db executeUpdate:@"INSERT INTO workout (workout_set_1, workout_set_2, workout_set_3, workout_set_4, workout_set_5, workout_date, equipment_id) VALUES (?, ?, ?, ?, ?, ?, ?);",
                     workout.workoutSet1, workout.workoutSet2, workout.workoutSet3, workout.workoutSet4, workout.workoutSet5, workout.workoutDate, workout.equipmentId, nil];
    
    [db close];
    
    return success;
}

+ (BOOL) updateWorkout:(Workout *) workout
{
    FMDatabase *db = [FMDatabase databaseWithPath:[Utility sharedInstance].databasePath];
    
    [db open];
    
    BOOL success = [db executeUpdate:[NSString stringWithFormat:@"UPDATE workout SET workout_set_1 = %@, workout_set_2 = %@, workout_set_3 = %@, workout_set_4 = %@, workout_set_5 = %@ where id = %@", workout.workoutSet1, workout.workoutSet2, workout.workoutSet3, workout.workoutSet4, workout.workoutSet5, workout.id]];
    
    [db close];
    
    return success;
}

+ (BOOL) deleteWorkout:(Workout *) workout
{
    FMDatabase *db = [FMDatabase databaseWithPath:[Utility sharedInstance].databasePath];
    
    [db open];
    
    BOOL success = [db executeUpdate:[NSString stringWithFormat:@"delete from workout where id = %@", workout.id]];
    
    [db close];
    
    return success;
}

+ (Settings *) getSettings
{
    FMDatabase *db = [FMDatabase databaseWithPath:[Utility sharedInstance].databasePath];
    
    [db open];
    
    FMResultSet *results = [db executeQuery:@"SELECT * FROM settings"];
    Settings *settings;
    
    while([results next])
    {
        settings = [Settings new];
        settings.id = [NSNumber numberWithInt:[results intForColumn:@"id"]];
        settings.weight = [results stringForColumn:@"weight"];
        settings.sets = [NSNumber numberWithInt:[results intForColumn:@"sets"]];
    }
    
    [db close];
    
    return settings;
}

+ (BOOL) updateSettings:(Settings *) settings
{
    FMDatabase *db = [FMDatabase databaseWithPath:[Utility sharedInstance].databasePath];
    
    [db open];
    
    BOOL success = [db executeUpdate:[NSString stringWithFormat:@"UPDATE settings SET weight = '%@', sets = %@ where id = %@", settings.weight, settings.sets, settings.id]];
    
    [db close];
    
    return success;
}

+ (NSArray *) getWorkoutDates
{
    NSMutableArray *workouts = [NSMutableArray new];
    
    FMDatabase *db = [FMDatabase databaseWithPath:[Utility sharedInstance].databasePath];
    
    [db open];
    
    FMResultSet *results = [db executeQuery:@"SELECT DISTINCT workout_date FROM workout order by workout_date ASC"];
    
    while([results next])
    {
        [workouts addObject:[results stringForColumn:@"workout_date"]];
    }
    
    [db close];
    
    return workouts;
}

@end
