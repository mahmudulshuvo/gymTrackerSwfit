//
//  Workout.h
//  gymTracker
//
//  Created by Third Bit on 3/5/14.
//  Copyright (c) 2014 Third Bit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Workout : NSManagedObject

@property (nonatomic, retain) NSNumber * workoutSet1;
@property (nonatomic, retain) NSNumber * workoutSet2;
@property (nonatomic, retain) NSNumber * workoutSet3;
@property (nonatomic, retain) NSDate * workoutDate;
@property (nonatomic, retain) NSManagedObject *equipment;

@end
