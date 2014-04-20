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
-(void)submitProfileChange
{
    
}

- (void)setUpViewComponents
{
    // set up place holders by retrieving info from parse
    self.nameSet.placeholder = [[PFUser currentUser] username];
    self.emailSet.placeholder = [[PFUser currentUser] email];
    self.educationSet.placeholder = @"Carnegie Mellon University";
    
    // set up image
    
    
    // set up uploadImage button
    [self setUpButton];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
            break;
        case 1:
            [self takePhoto];
            break;
        case 2:
            [self chooseExistingPhoto];
            break;
    }
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