/**
 * The MIT License (MIT)
 * Copyright (c) 2014 DeNA Co., Ltd.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#import <UIKit/UIKit.h>
#import <Twitter/Twitter.h>
#import <Social/Social.h>
#import <MessageUI/MessageUI.h>

typedef enum{
    ACTN_SHT_PUSHED_NOT_PUSHED = 0,
    ACTN_SHT_PUSHED_LINE,
    ACTN_SHT_PUSHED_TWITTER_ANDOVER_IOS6,
    ACTN_SHT_PUSHED_FACEBOOK_ANDOVER_IOS6,
    ACTN_SHT_PUSHED_TWITTER_UNDER_IOS6,
    ACTN_SHT_PUSHED_FACEBOOK_UNDER_IOS6,
    ACTN_SHT_PUSHED_MAIL,
    ACTN_SHT_PUSHED_INNER_MAIL,
} ACTIONSHEET_PUSHED_STATUS;

@interface PostMessageSNS : NSObject
{
}

+ (ACTIONSHEET_PUSHED_STATUS)getPushedButtonActionSheet;

+(BOOL)postMessage2ActionSheet: (NSString*)title
                       message: (NSString*)message
                           url: (NSString*)url
                         appId: (NSString*)facebookAppId
                viewController: (id)viewController
                     onSuccess: (void(^)())successCB
                      onCancel: (void(^)())cancelCB;

+(BOOL)postMessage2LINE: (NSString*)message
                    url: (NSString*)url
              onSuccess: (void(^)())successCB;

+(BOOL)postMessage2Twitter: (NSString*)message
                       url: (NSString*)url
            viewController: (id)viewController
                 onSuccess: (void(^)())successCB
                  onCancel: (void(^)())cancelCB;

+(BOOL)postMessage2Facebook: (NSString*)title
                    message: (NSString*)message
                        url: (NSString*)url
                      appId: (NSString*)appId
             viewController: (id)viewController
                  onSuccess: (void(^)())successCB
                   onCancel: (void(^)())cancelCB;

+(BOOL)postMessage2Mail: (NSString*)title
                message: (NSString*)message
                    url: (NSString*)url
              onSuccess: (void(^)())successCB;

+(BOOL)postMessage2InnerMail: (UIViewController*)viewControllerToPresent
                       title: (NSString*)title
                     message: (NSString*)message
                         url: (NSString*)url
                   onSuccess: (void(^)())successCB
                    onCancel: (void(^)())cancelCB;



+(BOOL)postMessage2TwitterWithImage: (NSString*)message
                                url: (NSString*)url
                          imagePath: (NSString*)imagePath
                     viewController: (id)viewController
                          onSuccess: (void(^)())successCB
                           onCancel: (void(^)())cancelCB;

+(BOOL)postMessage2FacebookWithImage: (NSString*)title
                             message: (NSString*)message
                                 url: (NSString*)url
                           imagePath: (NSString*)imagePath
                      viewController: (id)viewController
                           onSuccess: (void(^)())successCB
                            onCancel: (void(^)())cancelCB;

+(BOOL)postMessage2FacebookWithImageURL: (NSString*)title
                                message: (NSString*)message
                                    url: (NSString*)url
                                  appId: (NSString*)appId
                               imageURL: (NSString*)imageURL
                              onSuccess: (void(^)())successCB
                               onCancel: (void(^)())cancelCB;

+(BOOL)postMessage2InnerMailWithImage: (UIViewController*)viewControllerToPresent
                                title: (NSString*)title
                              message: (NSString*)message
                            imagePath: (NSString*)imagePath
                                  url: (NSString*)url
                            onSuccess: (void(^)())successCB
                             onCancel: (void(^)())cancelCB;


@end
