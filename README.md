# VTFollowOnTwitter

_Ready to use “Follow me on Twitter” native implementation._

![Platform iOS](https://img.shields.io/badge/platform-iOS-blue.svg)
[![CocoaPods compatible](https://img.shields.io/cocoapods/v/VTFollowOnTwitter.svg)](https://cocoapods.org/pods/VTFollowOnTwitter)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![CocoaPods documentation](https://img.shields.io/cocoapods/metrics/doc-percent/VTFollowOnTwitter.svg)](http://cocoadocs.org/docsets/VTFollowOnTwitter)
[![MIT license](http://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/vtourraine/VTFollowOnTwitter/raw/master/LICENSE)

## How To Get Started

Instead of adding the source files directly to your project, you may want to consider using [CocoaPods](http://cocoapods.org/) to manage your dependencies. Follow the instructions on the CocoaPods site to install the gem, and specify VTFollowOnTwitter as a dependency in your Podfile:

```
pod 'VTFollowOnTwitter', '~> 0.5'
```

You can also download VTFollowOnTwitter source files, and add them to your project, with ARC enabled. Don’t forget to add the `Accounts` and `Social` frameworks in your target configuration.


## Example Usage

The main method needs the Twitter username to follow.

``` objc
[VTFollowOnTwitter followUsername:@"test"
            fromPreferredUsername:nil
                          success:^{ /* Good */ }
                 multipleAccounts:^(NSArray *usernames) { /* Need specific username */ } 
                          failure:^(NSError *error) { /* Not good */ }];
```

Your controller need to handle the case where the user has more than one Twitter account configured. For instance, you can use a `UIActionSheet` to present the choice if necessary.

``` objc
@interface VTViewController : UIViewController

- (IBAction)followOnTwitter:(id)sender;

@end

// ---
@interface VTViewController () <UIActionSheetDelegate>

- (void)followOnTwitterFromUsername:(NSString *)fromUsername;

@end


@implementation VTViewController

- (IBAction)followOnTwitter:(id)sender {
    [self followOnTwitterFromUsername:nil];
}

- (void)followOnTwitterFromUsername:(NSString *)fromUsername {
    NSString *username = @"StudioAMANgA";

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
        [[[UIAlertView alloc] initWithTitle:@"Request Error" message:[NSString stringWithFormat:@"Sorry, something went wrong.\n%@", [error localizedDescription]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        [self followOnTwitterFromUsername:[[actionSheet buttonTitleAtIndex:buttonIndex] stringByReplacingOccurrencesOfString:@"@" withString:@""]];
    }
}

@end
```


## Requirements

VTFollowOnTwitter requires iOS 6.0 and above, with the `Accounts` and `Social` frameworks, Xcode 6.3 and above, and uses ARC.


## Credits

VTFollowOnTwitter was created by [Vincent Tourraine](http://www.vtourraine.net).


## License

VTFollowOnTwitter is available under the MIT license. See the LICENSE file for more info.
