//
//  SelfDetailViewController.m
//  inTouch
//
//  Created by yigu on 4/19/14.
//  Copyright (c) 2014 yigu. All rights reserved.
//

#import "SelfDetailViewController.h"
#import <Parse/Parse.h>

@interface SelfDetailViewController ()

@end

@implementation SelfDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setUpNavi];
        
    }
    return self;
}

- (void)setUpNavi
{
    // set up title, left and right top buttons of the navigation
    self.title = @"Setting";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Submit" style:UIBarButtonItemStyleBordered target:self action:@selector(submitProfileChange)];
}

// tap the top right button of the navigation to submit the change
- (void)submitProfileChange
{
    PFUser *user = [PFUser currentUser];
    
    if(![self stringIsNilOrEmpty:self.nameSet.text])
    {
        user.username = self.nameSet.text;
    }
    
    if(![self stringIsNilOrEmpty:self.emailSet.text])
    {
        user.email = self.emailSet.text;
    }
    
    if(![self stringIsNilOrEmpty:self.educationSet.text])
    {
        user[@"education"] = self.educationSet.text;
    }
    
    if(!CGSizeEqualToSize(self.profileImage.image.size, CGSizeZero)){
        NSData *imageData = UIImageJPEGRepresentation(self.profileImage.image, 0.05f);
        [self uploadPhoto:imageData];
    }
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)uploadPhoto:(NSData *)imageData
{
    PFUser *user = [PFUser currentUser];
    
    PFFile *imageFile = [PFFile fileWithName:@"Image.jpg" data:imageData];
    
    // Save PFFile
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // Create a PFObject around a PFFile and associate it with the current user
            PFObject *userPhoto = [PFObject objectWithClassName:@"Story"];
            [userPhoto setObject:imageFile forKey:@"media"];
            
            // Set the access control list to current user for security purposes
            userPhoto.ACL = [PFACL ACLWithUser:user];
            
            [userPhoto setObject:user forKey:@"Author"];
            
            [userPhoto saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    
                }
                else{
                    // Log details of the failure
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
            }];
        }
        else{
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

-(BOOL)stringIsNilOrEmpty:(NSString*)aString
{
    return !(aString && aString.length);
}

- (void)setUpViewComponents
{
    PFUser *user = [PFUser currentUser];
    
    [user refresh];
    
    // set up place holders by retrieving info from parse
    self.nameSet.placeholder = user.username;
    self.emailSet.placeholder = user.email;
    self.educationSet.placeholder = user[@"education"];
    
    // set up image
    [self loadProfileImage];
    
    // set up uploadImage button
    [self setUpButton];
}

- (void)loadProfileImage
{
    PFQuery *storyQuery = [PFQuery queryWithClassName:@"Story"];
    
    [storyQuery whereKey:@"Author" equalTo:[PFUser currentUser]];
    
    [storyQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error && [objects count] != 0) {
            PFObject *story = [objects objectAtIndex:[objects count] - 1];           // Store results
            PFFile *profileImage = story[@"media"];
            NSData *imageData = [profileImage getData];
            self.profileImage.image = [UIImage imageWithData:imageData];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Retrieve failure" message:@"Unable to load or profile image does not exist" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }];
}

- (void)setUpButton
{
    self.uploadImageButton.layer.borderColor = [UIColor blackColor].CGColor;
    self.uploadImageButton.layer.borderWidth = 2.0;
    self.uploadImageButton.layer.cornerRadius = 10;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setUpViewComponents];
    
    // tap other place to dimiss keyboard
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}

-(void)dismissKeyboard {
    [self.view endEditing:YES];
}


- (IBAction)uploadImage:(UIButton *)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Remove Image" otherButtonTitles:@"Take Photo", @"Choose existing photo", nil];
    
    [actionSheet showInView:self.view];
    
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch(buttonIndex)
    {
        case 0:
            [self deletePhoto];
            break;
        case 1:
            [self takePhoto];
            break;
        case 2:
            [self chooseExistingPhoto];
            break;
    }
}

-(void)deletePhoto
{
    PFQuery *storyQuery = [PFQuery queryWithClassName:@"Story"];
    
    [storyQuery whereKey:@"Author" equalTo:[PFUser currentUser]];
    
    [storyQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error && [objects count] != 0) {
            PFObject *story = [objects objectAtIndex:[objects count] - 1];
            
            [story deleteInBackground];
            
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @"Current Image Deleted"
                                  message: @"Personal Profile Image has been deleted"\
                                  delegate: nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];

        }
    }];
}

- (void)takePhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    
    // allow photo resizing
    picker.allowsEditing = YES;
    
    // check if no camera
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }else{
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Device Failure"
                              message: @"Camera is not available"\
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        
    }
    
    [self presentViewController:picker animated:YES completion:NULL];
}

-(void)chooseExistingPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    
    // allow photo resizing
    picker.allowsEditing = YES;
    
    // choose photo from library
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *photoTaken = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.profileImage.image = photoTaken;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    // save the photo to the camera roll
    UIImageWriteToSavedPhotosAlbum(photoTaken,
                                   self,
                                   @selector(image:finishedSavingWithError:contextInfo:),
                                   nil);
}

// show alert to notify whether photo saved successfully or not
-(void)image:(UIImage *)image finishedSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    
    
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Save failed"
                              message: @"Failed to save image"\
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }else{
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Saved successfully"
                              message: @"The photo you take has been saved to your library"\
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        
    }
}




@end
