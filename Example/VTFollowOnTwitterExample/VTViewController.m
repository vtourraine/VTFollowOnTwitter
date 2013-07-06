//
//  VTViewController.m
//  VTFollowOnTwitterExample
//
//  Created by Terenn on 7/6/13.
//  Copyright (c) 2013 Vincent Tourraine. All rights reserved.
//

#import "VTViewController.h"
#import <VTFollowOnTwitter.h>
@import Accounts;

@interface VTViewController () <UIActionSheetDelegate>

- (void)followOnTwitterFromUsername:(NSString *)fromUsername;

@end

@implementation VTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)followMe:(id)sender
{
    [self followOnTwitterFromUsername:nil];
}

- (void)followOnTwitterFromUsername:(NSString *)fromUsername
{
    NSString *username = self.usernameTextField.text;
    
    if ([username length] < 1) {
        return;
    }
    
    [VTFollowOnTwitter followUsername:username fromPreferredUsername:fromUsername success:^{
        [[[UIAlertView alloc] initWithTitle:@"Thanks!" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    } multipleAccounts:^(NSArray *usernames) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Which account do you want to follow us with?" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
        for (NSString *username in usernames)
            [actionSheet addButtonWithTitle:[@"@" stringByAppendingString:username]];
        [actionSheet addButtonWithTitle:@"Cancel"];
        [actionSheet setCancelButtonIndex:[usernames count]];
        [actionSheet showInView:self.view];
    } failure:^(NSError *error) {
        NSString *message;
        if ([error code] == ACErrorAccountNotFound)
            message = @"No Twitter account configured";
        else
            message = [NSString stringWithFormat:@"Sorry, something went wrong.\n%@", [error localizedDescription]];
        [[[UIAlertView alloc] initWithTitle:@"Request Error" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        NSString *fromUsername = [[actionSheet buttonTitleAtIndex:buttonIndex] stringByReplacingOccurrencesOfString:@"@" withString:@""];
        [self followOnTwitterFromUsername:fromUsername];
    }
}


@end
