#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Image : NSManagedObject

@property (nonatomic, retain) NSString * imageName;
@property (nonatomic, retain) NSData * imageData;

@end
