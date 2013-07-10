//
// VTFollowOnTwitter.m
//
// Copyright (c) 2013 Vincent Tourraine (http://www.vtourraine.net)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "VTFollowOnTwitter.h"

#import <Accounts/Accounts.h>
#import <Social/Social.h>

@interface VTFollowOnTwitter ()

+ (void)followWithURLSchemeUsername:(NSString *)username;

@end


@implementation VTFollowOnTwitter

+ (void)followUsername:(NSString *)username
 fromPreferredUsername:(NSString *)fromPreferredUsername
               success:(void(^)())success
      multipleAccounts:(void(^)(NSArray *usernames))multipleAccounts
               failure:(void(^)(NSError *error))failure
{
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType   = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {
        if (granted) {
            NSArray *accountsArray = [accountStore accountsWithAccountType:accountType];
            
            if ([accountsArray count] == 0) {
                if (failure) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        failure(error);
                    });
                }
            }
            else {
                ACAccount *twitterAccount;
                
                if (fromPreferredUsername) {
                    for (ACAccount *account in accountsArray) {
                        if ([account.username isEqualToString:fromPreferredUsername]) {
                            twitterAccount = account;
                            break;
                        }
                    }
                    
                    if (!twitterAccount) {
                        if (failure) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                failure(nil);
                            });
                        }
                        return;
                    }
                }
                else if ([accountsArray count] == 1)
                    twitterAccount = accountsArray[0];
                else {
                    if (multipleAccounts) {
                        NSMutableArray *usernames = [NSMutableArray array];
                        for (ACAccount *account in accountsArray) {
                            [usernames addObject:account.username];
                        }
                        dispatch_async(dispatch_get_main_queue(), ^{
                            multipleAccounts(usernames);
                        });
                    }
                    return;
                }
                
                NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
                [tempDict setValue:username forKey:@"screen_name"];
                [tempDict setValue:@"true" forKey:@"follow"];
                
                SLRequest *postRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                            requestMethod:SLRequestMethodPOST
                                                                      URL:[NSURL URLWithString:@"https://api.twitter.com/1.1/friendships/create.json"]
                                                               parameters:tempDict];
                
                
                [postRequest setAccount:twitterAccount];
                
                [postRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                    if (error) {
                        if (failure) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                failure(error);
                            });
                        }
                    }
                    else {
                        if (success) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                success();
                            });
                        }
                    }
                }];
            }
        }
        else {
            if (failure) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    failure(error);
                });
            }
        }
    }];
}

+ (void)followWithURLSchemeUsername:(NSString *)username
{
    NSArray *urls = @[@"twitter://user?screen_name={username}", // Twitter
                      @"tweetbot:///user_profile/{username}", // TweetBot
                      @"echofon:///user_timeline?{username}", // Echofon
                      @"twit:///user?screen_name={username}", // Twittelator Pro
                      @"x-seesmic://twitter_profile?twitter_screen_name={username}", // Seesmic
                      @"x-birdfeed://user?screen_name={username}", // Birdfeed
                      @"tweetings:///user?screen_name={handle}", // Tweetings
                      @"simplytweet:?link=http://twitter.com/{handle}", // SimplyTweet
                      @"icebird://user?screen_name={handle}", // IceBird
                      @"fluttr://user/{handle}", // Fluttr
                      @"http://twitter.com/{handle}"];
    
    for (NSString *candidate in urls) {
        NSURL *url = [NSURL URLWithString:[candidate stringByReplacingOccurrencesOfString:@"{username}" withString:username]];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
            return;
        }
    }
}

@end
