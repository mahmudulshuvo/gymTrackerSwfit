//
//  EquipmentDetailsViewController.h
//  gymTracker
//
//  Created by Third Bit on 3/5/14.
//  Copyright (c) 2014 Third Bit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EquipmentDetailsViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    UIImagePickerController *cameraPickerController;
}

@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@property (strong, nonatomic) IBOutlet UITextField *imageNameTextField;

- (IBAction)saveBtn:(id)sender;
- (IBAction)takePhoto:(id)sender;

@end
