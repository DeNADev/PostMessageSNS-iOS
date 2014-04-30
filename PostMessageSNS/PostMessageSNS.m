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

#import "PostMessageSNS.h"
@interface PostMessageSNS()<UIActionSheetDelegate, MFMailComposeViewControllerDelegate>

typedef void (^CallbackHandler)();

@property (strong, nonatomic) UIViewController* mPostMessageSNSViewController;
@property (strong, nonatomic) NSString* mPostMessageSNSTitle;
@property (strong, nonatomic) NSString* mPostMessageSNSMessage;
@property (strong, nonatomic) NSString* mPostMessageSNSURL;
@property (strong, nonatomic) NSString* mPostMessageSNSFacebookAppId;
@property (strong, nonatomic) CallbackHandler mPostMessageSNSSuccessCB;
@property (strong, nonatomic) CallbackHandler mPostMessageSNSCancelCB;
@property (nonatomic) ACTIONSHEET_PUSHED_STATUS mActionSheetStatus;

@end

@implementation PostMessageSNS

static PostMessageSNS* sharedInstance;
#pragma mark - life cycle
+ (void)createInstance
{
    if(!sharedInstance) 
    {
        sharedInstance = [[self alloc] init];
    }
}

#pragma mark - POSTMessageSNS
+ (ACTIONSHEET_PUSHED_STATUS)getPushedButtonActionSheet
{
    if(!sharedInstance) 
    {
        return ACTN_SHT_PUSHED_NOT_PUSHED;
    }
    
    return sharedInstance.mActionSheetStatus;
}

+(BOOL)postMessage2LINE: (NSString*)message
                    url: (NSString*)url
              onSuccess:(void(^)())successCB
{
    
    // エラーチェック
    if([message length] == 0)
    {
        return NO;
    }
    if([url length] == 0)
    {
        return NO;
    }
    
    NSString* temp = [NSString stringWithFormat:@"%@ %@", message, url];
    
    NSString* encodeTemp = [PostMessageSNS urlEncode:temp];
    
    NSString* urlScheme = [NSString stringWithFormat:@"http://line.naver.jp/R/msg/text/?%@", encodeTemp];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlScheme]];
    
    if(successCB)
    {
        successCB();
    }
    
    return YES;
}

+(BOOL)postMessage2Twitter: (NSString*)message
                       url: (NSString*)url
            viewController: (id)viewController
                 onSuccess: (void(^)())successCB
                  onCancel: (void(^)())cancelCB
{
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    NSLog(@"%f", version);
    
    // エラーチェック
    if([message length] == 0)
    {
        return NO;
    }
    if([url length] == 0)
    {
        return NO;
    }
    
    if(version >= 6.0)
    {
        NSString *serviceType = SLServiceTypeTwitter;
        SLComposeViewController *composeCtl = [SLComposeViewController composeViewControllerForServiceType:serviceType];
        [composeCtl setInitialText: message];
        [composeCtl addURL:[NSURL URLWithString: url]];
        __block SLComposeViewController *blockComposeCtl = composeCtl;
        [composeCtl setCompletionHandler:^(SLComposeViewControllerResult result) 
         {
             [blockComposeCtl dismissViewControllerAnimated:YES completion:nil];
             if (result == SLComposeViewControllerResultDone) 
             {
                 //投稿成功時の処理
                 if(successCB)
                 {
                     successCB();
                 }
             }
             else if(result == SLComposeViewControllerResultCancelled)
             {
                 //投稿キャンセル時の処理
                 if(cancelCB)
                 {
                     cancelCB();
                 }
             }
             else
             {
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"投稿エラー"
                                                                 message:@"メッセージの投稿に失敗しました"
                                                                delegate:self
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles:nil, nil];
                 [alert show];
             }
             
         }];
        
        [viewController presentViewController:composeCtl animated:YES completion:nil];
    }
    else if(version < 6.0 && version >= 5.0)
    {   
        TWTweetComposeViewController *composeCtl =  [[TWTweetComposeViewController alloc] init];
        [composeCtl setInitialText: message];
        [composeCtl addURL:[NSURL URLWithString: url]];
        __block TWTweetComposeViewController *blockComposeCtl = composeCtl;
        [composeCtl setCompletionHandler:^(SLComposeViewControllerResult result) 
         {
             [blockComposeCtl dismissViewControllerAnimated:YES completion:nil];
             if (result == SLComposeViewControllerResultDone) 
             {
                 //投稿成功時の処理
                 if(successCB)
                 {
                     successCB();
                 }
             }
             else if(result == SLComposeViewControllerResultCancelled)
             {
                 //投稿キャンセル時の処理
                 if(cancelCB)
                 {
                     cancelCB();
                 }
             }
             else
             {
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"投稿エラー"
                                                                 message:@"メッセージの投稿に失敗しました"
                                                                delegate:self
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles:nil, nil];
                 [alert show];
             }
             
         }];
        
        [viewController presentViewController:composeCtl animated:YES completion:nil];
    }
    else
    {
        NSString* encodeUrl = [PostMessageSNS urlEncode:url];
        
        NSString* encodeMessage = [PostMessageSNS urlEncode:message];
        
        NSString* urlScheme = [NSString stringWithFormat:@"https://twitter.com/share?text=%@&url=%@", encodeMessage, encodeUrl];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlScheme]];
        
        if(successCB)
        {
            successCB();
        }
    }
    
    return YES;
}


+(BOOL)postMessage2TwitterWithImage: (NSString*)message
                                url: (NSString*)url
                          imagePath: (NSString*)imagePath
                     viewController: (id)viewController
                          onSuccess: (void(^)())successCB
                           onCancel: (void(^)())cancelCB
{
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    NSLog(@"%f", version);
    
    
    // エラーチェック
    if([message length] == 0)
    {
        return NO;
    }
    if([url length] == 0)
    {
        return NO;
    }
    // ファイルマネージャを作成
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([imagePath length] == 0 || ![fileManager fileExistsAtPath:imagePath])
    {
        return NO;
    }
    if(version < 5.0)
    {
        return NO;
    }
    
    if(version >= 6.0)
    {
        UIImage* image = [UIImage imageWithContentsOfFile:imagePath];
        
        NSString *serviceType = SLServiceTypeTwitter;
        SLComposeViewController *composeCtl = [SLComposeViewController composeViewControllerForServiceType:serviceType];
        [composeCtl setInitialText: message];
        [composeCtl addImage: image];
        [composeCtl addURL:[NSURL URLWithString: url]];
        __block SLComposeViewController *blockComposeCtl = composeCtl;
        [composeCtl setCompletionHandler:^(SLComposeViewControllerResult result) 
         {
             [blockComposeCtl dismissViewControllerAnimated:YES completion:nil];
             if (result == SLComposeViewControllerResultDone) 
             {
                 //投稿成功時の処理
                 if(successCB)
                 {
                     successCB();
                 }
             }
             else if(result == SLComposeViewControllerResultCancelled)
             {
                 //投稿キャンセル時の処理
                 if(cancelCB)
                 {
                     cancelCB();
                 }
             }
             else
             {
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"投稿エラー"
                                                                 message:@"メッセージの投稿に失敗しました"
                                                                delegate:self
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles:nil, nil];
                 [alert show];
             }
             
         }];
        
        [viewController presentViewController:composeCtl animated:YES completion:nil];
    }
    else if(version < 6.0 && version >= 5.0)
    {
        UIImage* image = [UIImage imageWithContentsOfFile:imagePath];
        
        TWTweetComposeViewController *composeCtl =  [[TWTweetComposeViewController alloc] init];
        [composeCtl setInitialText: message];
        [composeCtl addImage: image];
        [composeCtl addURL:[NSURL URLWithString: url]];
        __block TWTweetComposeViewController *blockComposeCtl = composeCtl;
        [composeCtl setCompletionHandler:^(SLComposeViewControllerResult result) 
         {
             [blockComposeCtl dismissViewControllerAnimated:YES completion:nil];
             if (result == SLComposeViewControllerResultDone) 
             {
                 //投稿成功時の処理
                 if(successCB)
                 {
                     successCB();
                 }
             }
             else if(result == SLComposeViewControllerResultCancelled)
             {
                 //投稿キャンセル時の処理
                 if(cancelCB)
                 {
                     cancelCB();
                 }
             }
             else
             {
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"投稿エラー"
                                                                 message:@"メッセージの投稿に失敗しました"
                                                                delegate:self
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles:nil, nil];
                 [alert show];
             }
             
         }];
        
        [viewController presentViewController:composeCtl animated:YES completion:nil];
    }
    
    return YES;
}


+(BOOL)postMessage2Facebook: (NSString*)title
                    message: (NSString*)message
                        url: (NSString*)url
                      appId: (NSString*)appId
             viewController: (id)viewController
                  onSuccess: (void(^)())successCB
                   onCancel: (void(^)())cancelCB
{
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    NSLog(@"%f", version);
    
    // エラーチェック
    if([title length] == 0)
    {
        return NO;
    }
    if([message length] == 0)
    {
        return NO;
    }
    if([url length] == 0)
    {
        return NO;
    }
    
    
    if(version >= 6.0)
    {
        NSString *serviceType = SLServiceTypeFacebook;
        SLComposeViewController *composeCtl = [SLComposeViewController composeViewControllerForServiceType:serviceType];
        [composeCtl setTitle: title];
        [composeCtl setInitialText: message];
        [composeCtl addURL:[NSURL URLWithString: url]];
        [composeCtl setCompletionHandler:^(SLComposeViewControllerResult result) 
         {
             if (result == SLComposeViewControllerResultDone) 
             {
                 //投稿成功時の処理
                 if(successCB)
                 {
                     successCB();
                 }
             }
             else if(result == SLComposeViewControllerResultCancelled)
             {
                 //投稿キャンセル時の処理
                 if(cancelCB)
                 {
                     cancelCB();
                 }
             }
             else
             {
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"投稿エラー"
                                                                 message:@"メッセージの投稿に失敗しました"
                                                                delegate:self
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles:nil, nil];
                 [alert show];
             }
             
         }];
        
        [viewController presentViewController:composeCtl animated:YES completion:nil];
    }
    else
    {
        if([appId length] == 0)
        {
            return NO;
        }
        NSString* encodeUrl = [PostMessageSNS urlEncode:url];
        NSString* encodeTitle = [PostMessageSNS urlEncode:title];
        NSString* encodeMessage = [PostMessageSNS urlEncode:message];
        
        NSString* urlScheme = [NSString stringWithFormat:@"https://www.facebook.com/dialog/feed?app_id=%@&display=popup&caption=%@&link=%@&redirect_uri=https://www.facebook.com&description=%@", appId, encodeTitle, encodeUrl, encodeMessage];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlScheme]];
        if(successCB)
        {
            successCB();
        }
    }
    
    return YES;
}


+(BOOL)postMessage2FacebookWithImage: (NSString *)title
                             message: (NSString *)message
                                 url: (NSString *)url
                           imagePath: (NSString *)imagePath
                      viewController: (id)viewController
                           onSuccess: (void (^)())successCB
                            onCancel: (void (^)())cancelCB
{
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    NSLog(@"%f", version);
    
    // エラーチェック
    if([title length] == 0)
    {
        return NO;
    }
    if([message length] == 0)
    {
        return NO;
    }
    if([url length] == 0)
    {
        return NO;
    }
    // ファイルマネージャを作成
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([imagePath length] == 0 || ![fileManager fileExistsAtPath:imagePath])
    {
        return NO;
    }
    if(version < 6.0)
    {
        return NO;
    }
    
    NSString *serviceType = SLServiceTypeFacebook;
    SLComposeViewController *composeCtl = [SLComposeViewController composeViewControllerForServiceType:serviceType];
    
    
    UIImage* image = [UIImage imageWithContentsOfFile:imagePath];
    [composeCtl setTitle: title];
    [composeCtl setInitialText: message];
    [composeCtl addImage: image];
    [composeCtl addURL:[NSURL URLWithString: url]];
    [composeCtl setCompletionHandler:^(SLComposeViewControllerResult result) 
     {
         if (result == SLComposeViewControllerResultDone) 
         {
             //投稿成功時の処理
             if(successCB)
             {
                 successCB();
             }
         }
         else if(result == SLComposeViewControllerResultCancelled)
         {
             //投稿キャンセル時の処理
             if(cancelCB)
             {
                 cancelCB();
             }
         }
         else
         {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"投稿エラー"
                                                             message:@"メッセージの投稿に失敗しました"
                                                            delegate:self
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil, nil];
             [alert show];
         }
         
     }];
    
    [viewController presentViewController:composeCtl animated:YES completion:nil];
    
    return YES;
}

+(BOOL)postMessage2FacebookWithImageURL:(NSString *)title 
                                message:(NSString *)message
                                    url:(NSString *)url
                                  appId: (NSString*)appId
                               imageURL:(NSString *)imageURL
                              onSuccess:(void (^)())successCB
                               onCancel:(void (^)())cancelCB
{
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    NSLog(@"%f", version);
    
    // エラーチェック
    if([title length] == 0)
    {
        return NO;
    }
    if([message length] == 0)
    {
        return NO;
    }
    if([url length] == 0)
    {
        return NO;
    }
    if([appId length] == 0)
    {
        return NO;
    }
    if([imageURL length] == 0)
    {
        return NO;
    }
    
    NSString* encodeUrl = [PostMessageSNS urlEncode:url];
    NSString* encodeTitle = [PostMessageSNS urlEncode:title];
    NSString* encodeMessage = [PostMessageSNS urlEncode:message];
    NSString* encodeImageURL = [PostMessageSNS urlEncode:imageURL]; 
    
    NSString* urlScheme = [NSString stringWithFormat:@"https://www.facebook.com/dialog/feed?app_id=%@&display=popup&caption=%@&link=%@&picture=%@&redirect_uri=https://www.facebook.com&description=%@", appId, encodeTitle, encodeUrl, encodeImageURL, encodeMessage];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlScheme]];
    
    if(successCB)
    {
        successCB();
    }
    
    return YES;
}

+(BOOL)postMessage2Mail: (NSString*)title
                message: (NSString*)message
                    url: (NSString*)url
              onSuccess:(void(^)())successCB
{
    // エラーチェック
    if([title length] == 0)
    {
        return NO;
    }
    if([message length] == 0)
    {
        return NO;
    }
    if([url length] == 0)
    {
        return NO;
    }
    
    NSString* temp = [NSString stringWithFormat:@"%@\n%@", message, url];
    
    NSString* encodeTemp = [PostMessageSNS urlEncode:temp];
    
    NSString* encodeTitle = [PostMessageSNS urlEncode:title];
    
    NSString* urlScheme = [NSString stringWithFormat:@"mailto:?subject=%@&body=%@", encodeTitle,encodeTemp];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlScheme]];
    
    if(successCB)
    {
        successCB();
    }
    
    return YES;
}

+ (BOOL)postMessage2InnerMail: (UIViewController*)viewControllerToPresent
                        title: (NSString*)title
                      message: (NSString*)message
                          url: (NSString*)url
                    onSuccess: (void(^)())successCB
                     onCancel: (void(^)())cancelCB
{
    // エラーチェック
    if([title length] == 0)
    {
        return NO;
    }
    if([message length] == 0)
    {
        return NO;
    }
    if([url length] == 0)
    {
        return NO;
    }
    
    // メールアカウントが設定されていてメール送信可能な状態か確認
    if(![MFMailComposeViewController canSendMail]) 
    {
        return NO;
    }
    
    NSString *messageBody = [NSString stringWithFormat:@"%@\n%@", message, url];
    
    
    [PostMessageSNS createInstance];
    sharedInstance.mPostMessageSNSSuccessCB = successCB;
    sharedInstance.mPostMessageSNSCancelCB = cancelCB;
    
    MFMailComposeViewController *mailView = [[MFMailComposeViewController alloc] init];
    [mailView setSubject:title];
    [mailView setMessageBody:messageBody isHTML:NO];
    [mailView setMailComposeDelegate:(id)sharedInstance];
    
    // 表示
    [viewControllerToPresent presentViewController:mailView
                                          animated:YES
                                        completion:nil];
    
    return YES;
}

+ (BOOL)postMessage2InnerMailWithImage:(UIViewController *)viewControllerToPresent
                                 title:(NSString *)title
                               message:(NSString *)message
                             imagePath:(NSString *)imagePath
                                   url:(NSString *)url
                             onSuccess:(void (^)())successCB
                              onCancel:(void (^)())cancelCB
{
    // エラーチェック
    if([title length] == 0)
    {
        return NO;
    }
    if([message length] == 0)
    {
        return NO;
    }
    if([url length] == 0)
    {
        return NO;
    }
    
    // ファイルマネージャを作成
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([imagePath length] == 0 || ![fileManager fileExistsAtPath:imagePath])
    {
        return NO;
    }
    // メールアカウントが設定されていてメール送信可能な状態か確認
    if(![MFMailComposeViewController canSendMail]) {
        return NO;
    }
    
    NSString *messageBody = [NSString stringWithFormat:@"%@\n%@", message, url];
    
    
    [PostMessageSNS createInstance];
    sharedInstance.mPostMessageSNSSuccessCB = successCB;
    sharedInstance.mPostMessageSNSCancelCB = cancelCB;
    
    
    UIImage* image = [UIImage imageWithContentsOfFile:imagePath];
    
    MFMailComposeViewController *mailView = [[MFMailComposeViewController alloc] init];
    [mailView setSubject:title];
    [mailView setMessageBody:messageBody isHTML:NO];
    NSData *data  = [[NSData alloc] initWithData:UIImagePNGRepresentation(image)];
    [mailView addAttachmentData:data  mimeType:@"image/png" fileName:@"temp"];
    [mailView setMailComposeDelegate:(id)sharedInstance];
    
    // 表示
    [viewControllerToPresent presentViewController:mailView
                                          animated:YES
                                        completion:nil];
    
    return YES;
}


+ (BOOL)postMessage2ActionSheet: (NSString*)title
                        message: (NSString*)message
                            url: (NSString*)url
                          appId: (NSString*)facebookAppId
                 viewController: (id)viewController
                      onSuccess: (void(^)())successCB
                       onCancel: (void(^)())cancelCB
{
    // エラーチェック
    if(viewController == nil)
    {
        return NO;
    }
    if([title length] == 0)
    {
        return NO;
    }
    if([message length] == 0)
    {
        return NO;
    }
    if([url length] == 0)
    {
        return NO;
    }
    
    [PostMessageSNS createInstance];
    
    sharedInstance.mPostMessageSNSViewController = viewController;
    sharedInstance.mPostMessageSNSTitle = [NSString stringWithFormat:@"%@", title];
    sharedInstance.mPostMessageSNSMessage = [NSString stringWithFormat:@"%@", message];
    sharedInstance.mPostMessageSNSURL = [NSString stringWithFormat:@"%@", url];
    sharedInstance.mPostMessageSNSFacebookAppId = [NSString stringWithFormat:@"%@", facebookAppId];
    
    sharedInstance.mPostMessageSNSSuccessCB = successCB;
    sharedInstance.mPostMessageSNSCancelCB = cancelCB;
    
    // アクションシートの作成
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"シェア"
                                  delegate:sharedInstance
                                  cancelButtonTitle:@"キャンセル"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"LINE", @"Facebook", @"Twitter", @"Mail", nil];
    
    UIViewController* viewController2 = (UIViewController*)viewController;
    // アクションシートの表示
    [actionSheet showInView:viewController2.view];
    
    return YES;
}

#define mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    float version;
    switch (buttonIndex) 
    {
        case 0:
            NSLog(@"LINE");
            sharedInstance.mActionSheetStatus = ACTN_SHT_PUSHED_LINE;
            [PostMessageSNS postMessage2LINE:sharedInstance.mPostMessageSNSMessage
                                         url:sharedInstance.mPostMessageSNSURL
                                   onSuccess:sharedInstance.mPostMessageSNSSuccessCB];
            break;
            
        case 1:
            NSLog(@"Facebook");
            version = [[[UIDevice currentDevice] systemVersion] floatValue];
            if(version >= 6.0)
            {
                sharedInstance.mActionSheetStatus = ACTN_SHT_PUSHED_FACEBOOK_ANDOVER_IOS6;
            }
            else
            {
                sharedInstance.mActionSheetStatus = ACTN_SHT_PUSHED_FACEBOOK_UNDER_IOS6;
            }
            [PostMessageSNS postMessage2Facebook:sharedInstance.mPostMessageSNSTitle
                                         message:sharedInstance.mPostMessageSNSMessage
                                             url:sharedInstance.mPostMessageSNSURL
                                           appId:sharedInstance.mPostMessageSNSFacebookAppId
                                  viewController:sharedInstance.mPostMessageSNSViewController
                                       onSuccess:sharedInstance.mPostMessageSNSSuccessCB
                                        onCancel:sharedInstance.mPostMessageSNSCancelCB];
            
            break;
            
        case 2:
            NSLog(@"Twitter");
            version = [[[UIDevice currentDevice] systemVersion] floatValue];
            if(version >= 6.0)
            {
                sharedInstance.mActionSheetStatus = ACTN_SHT_PUSHED_TWITTER_ANDOVER_IOS6;
            }
            else
            {
                sharedInstance.mActionSheetStatus = ACTN_SHT_PUSHED_TWITTER_UNDER_IOS6;
            }
            [PostMessageSNS postMessage2Twitter:sharedInstance.mPostMessageSNSMessage
                                            url:sharedInstance.mPostMessageSNSURL
                                 viewController:sharedInstance.mPostMessageSNSViewController
                                      onSuccess:sharedInstance.mPostMessageSNSSuccessCB
                                       onCancel:sharedInstance.mPostMessageSNSCancelCB];
            break;
            
        case 3:
            NSLog(@"InnerMail");
            sharedInstance.mActionSheetStatus = ACTN_SHT_PUSHED_INNER_MAIL;
            [PostMessageSNS postMessage2InnerMail:sharedInstance.mPostMessageSNSViewController
                                            title:sharedInstance.mPostMessageSNSTitle
                                          message:sharedInstance.mPostMessageSNSMessage
                                              url:sharedInstance.mPostMessageSNSURL
                                        onSuccess:sharedInstance.mPostMessageSNSSuccessCB
                                         onCancel:sharedInstance.mPostMessageSNSCancelCB];
            break;
        default:
            break;
    }
}

#pragma mark - MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error 
{
    [controller dismissViewControllerAnimated:YES completion:nil];
    
    CallbackHandler callback = nil;
    switch (result) 
    {
        case MFMailComposeResultSent:
            callback = sharedInstance.mPostMessageSNSSuccessCB;
            break;
        case MFMailComposeResultCancelled:
        case MFMailComposeResultSaved:
        case MFMailComposeResultFailed:
        default:
            callback = sharedInstance.mPostMessageSNSCancelCB;
            break;
    }
    
    if (callback)
    {
        callback();
    }
}

#pragma mark - Utility
+ (NSString *)urlEncode:(NSString *)string 
{
    NSString *encodeString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                                   (CFStringRef)string,
                                                                                                   NULL,
                                                                                                   (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                                   kCFStringEncodingUTF8));
    return encodeString;
}

@end