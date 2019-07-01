/*
 *
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 *
 */

#import "CDVOrientation.h"

static UIInterfaceOrientationMask _allowedOrientations = UIInterfaceOrientationMaskPortrait;

@implementation CDVOrientation

+ (UIInterfaceOrientationMask) allowedOrientations {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return UIInterfaceOrientationMaskAll;
    }
    else {
        return _allowedOrientations;
    }
}

-(void)screenOrientation:(CDVInvokedUrlCommand *)command
{
    [self.commandDelegate runInBackground:^{
        NSArray* arguments = command.arguments;
        NSString* orientation = [arguments objectAtIndex:1];
        UIInterfaceOrientation currentOrientation = [UIApplication sharedApplication].statusBarOrientation;
        UIInterfaceOrientation forcedOrientation = UIInterfaceOrientationUnknown;

        if ([orientation rangeOfString:@"portrait"].location != NSNotFound) {
          _allowedOrientations = UIInterfaceOrientationMaskPortrait;
            forcedOrientation = UIInterfaceOrientationPortrait;
        } else if([orientation rangeOfString:@"landscape"].location != NSNotFound) {
          _allowedOrientations = UIInterfaceOrientationMaskLandscape;
            forcedOrientation = UIInterfaceOrientationLandscapeLeft;
        } else {
          _allowedOrientations = UIInterfaceOrientationMaskAll;
        }
        if (forcedOrientation != UIInterfaceOrientationUnknown && forcedOrientation != currentOrientation) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
                [[UIDevice currentDevice] setValue:[NSNumber numberWithInt:forcedOrientation] forKey:@"orientation"];
            }];
        }
    }];
}

@end
