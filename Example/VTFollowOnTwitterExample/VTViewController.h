//
//  VTViewController.h
//  VTFollowOnTwitterExample
//
//  Created by Terenn on 7/6/13.
//  Copyright (c) 2013-2015 Vincent Tourraine. All rights reserved.
//

@import UIKit;

@interface VTViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;

- (IBAction)followMe:(id)sender;

@end
