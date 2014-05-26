//
//  ContactsCellDetail.m
//  inTouch
//
//  Created by yigu on 4/24/14.
//  Copyright (c) 2014 yigu. All rights reserved.
//

#import "ContactsCellDetail.h"

@interface ContactsCellDetail ()

@end

@implementation ContactsCellDetail

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setUpViewComponents];
}

- (void)setUpViewComponents
{
    self.title = @"Detail";
    
    
    // set up the image to round
    self.contactImage.layer.cornerRadius = 100;
    self.contactImage.clipsToBounds = YES;

    
    PFUser *user = [PFQuery getUserObjectWithId:self.contactId];
    
    self.contactImage.image = [self downloadImage:user];
    self.contactName.text = user[@"username"];
    self.contactEmail.text = user[@"email"];
    self.contactEducation.text = user[@"education"];
}

- (UIImage *)downloadImage: (PFUser *)user
{
    UIImage *cellimage = nil;
    
    PFFile *profileImage = user[@"Photo"];
    NSData *imageData = [profileImage getData];
    cellimage = [UIImage imageWithData:imageData];
    
    return cellimage;
}

@end
