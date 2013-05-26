//
// VTFollowOnTwitter.h
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

#import <Foundation/Foundation.h>

/**
 `VTFollowOnTwitter` is the central object to interact with Twitter.
 */

@interface VTFollowOnTwitter : NSObject

/**
 Sends a “follow me” request.
 
 @param username The Twitter username (a.k.a. handle) to follow.
 @param fromPreferredUsername The Twitter username (a.k.a. handle) to be used for the request. If `nil`, a single account has to be configured.
 @param success A block object to be executed when the request operation finishes successfully. This block has no return value and takes no arguments.
 @param multipleAccounts A block object to be executed when multiple accounts are configured, and no preferred account is specified. This block has no return value and takes one argument: an array of `NSString` containing the available usernames.
 @param failure A block object to be executed when the request operation finishes unsuccessfully. This block has no return value and takes one arguments: the `NSError` object describing the error that occurred.
 */
+ (void)followUsername:(NSString *)username
 fromPreferredUsername:(NSString *)fromPreferredUsername
               success:(void(^)())success
      multipleAccounts:(void(^)(NSArray *usernames))multipleAccounts
               failure:(void(^)(NSError *error))failure;

@end
