//
//  NearByCellDetail.m
//  inTouch
//
//  Created by yigu on 4/22/14.
//  Copyright (c) 2014 yigu. All rights reserved.
//

#import "NearByCellDetail.h"
#import "Parse/Parse.h"

@interface NearByCellDetail ()

@end

@implementation NearByCellDetail

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)setUpViewComponents
{
    self.title = @"Detail";
    
    PFUser *user = [PFQuery getUserObjectWithId:self.cellId];
    
    self.cellImage.image = [self downloadImage:user];
    self.cellName.text = user[@"username"];
    self.cellEmail.text = user[@"email"];
    self.cellEducation.text = user[@"education"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setUpViewComponents];
}

- (UIImage *)downloadImage: (PFUser *)user
{
    UIImage *cellimage = nil;
    
    PFQuery *storyQuery = [PFQuery queryWithClassName:@"Story"];
    
    [storyQuery whereKey:@"Author" equalTo:user];
    
    NSArray *storyObjects = [storyQuery findObjects];
    
    if([storyObjects count] != 0){
        
        PFObject *story = [storyObjects objectAtIndex:[storyObjects count] - 1];           // Store results
        PFFile *profileImage = story[@"media"];
        NSData *imageData = [profileImage getData];
        cellimage = [UIImage imageWithData:imageData];
    }
    
    return cellimage;
}


@end
