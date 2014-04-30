PostMessageSNS-iOS
==================

提供 iOS 上 LINE / Twitter / Facebook / Mail 投稿功能。

支持 iOS 5.0 以上。
如果应用支持 iOS 5.0 ，链接 Social.framework 时须选取 optional。

=================================================================================
版本
=================================================================================
1.3

=================================================================================
更新历史  
=================================================================================
version 1.3  
- 增加图像投稿功能

version 1.2  
- 增加应用内发送邮件功能（不使用 ActionSheet 而直接在应用内发送邮件）
- 必须连接 MessageUI.framework

version 1.1.1
- 修改回调接收部分功能

version 1.1
- 增加 ActionSheet 功能

version 1.0
- 初版

=================================================================================
安装需要的插件
=================================================================================
在 Xcode 里安装 Static iOS Framework 插件。

在终端里实行以下命令
$ git clone git://github.com/kstenerud/iOS-Universal-Framework.git  
$ cd ./iOS-Universal-Framework/Real\ Framework/  
$ ./install.sh  

=================================================================================
把软件库加到项目里
=================================================================================

iOS 版  

- 把 Social.framework 加到项目里。选取 optional 以支持 iOS 5 以前的版本。
- 把 MessageUI.framework 加到项目里。选取 required。
- 把 PostMessageSNS.framework 加到项目里。选取 required。

=================================================================================
API 说明 - iOS 版
=================================================================================

// LINE 投稿 API
+(BOOL)postMessage2LINE: (NSString*)message  
                    url: (NSString*)url  
              onSuccess: (void(^)())successCB;  

	message
		(必须) 投稿内容
	url
		(必须) 投稿 URL
	successCB
		(任意) 开启浏览器后的回调函数。可使用 nil。
	return 
		无指定参数时返回 NO。


// Twitter 投稿 API
+(BOOL)postMessage2Twitter: (NSString*)message  
                       url: (NSString*)url  
            viewController: (id)viewController  
                 onSuccess: (void(^)())successCB  
                  onCancel: (void(^)())cancelCB;  

	message
		(必须) 投稿内容
	url
		(必须) 投稿 URL
	viewController
		(必须) 显示投稿 UI 的主 View Controller
	successCB
		(任意) iOS 5 以后版本：投稿后的回调函数；iOS 4 或以前版本：开启浏览器后的回调函数。
        可使用 nil。
	cancelCB
        (任意) iOS 5 以后版本：取消投稿的回调函数；iOS 4 或以前版本：不会使用此回调函数。
        可使用 nil。
	return 
		无指定参数时返回 NO。


// Facebook 投稿 API
+(BOOL)postMessage2Facebook: (NSString*)title  
                    message: (NSString*)message  
                        url: (NSString*)url  
                      appId: (NSString*)appId
             viewController: (id)viewController  
                  onSuccess: (void(^)())successCB  
                   onCancel: (void(^)())cancelCB;  

	title
		(必须) 投稿标题
	message
		(必须) 投稿内容
	url
		(必须) 投稿 URL
    appId  
        (必须) Facebook appId
	viewController
		(必须) 显示投稿 UI 的主 View Controller
	successCB
		(任意) iOS 6 以后版本：投稿后的回调函数；iOS 5 或以前版本：开启浏览器后的回调函数。
        可使用 nil。
	cancelCB
		(任意) iOS 6 以后版本：取消投稿的回调函数；iOS 5 或以前版本：不会使用此回调函数。
        可使用 nil。
	return 
		无指定参数时返回 NO。


// Mail （应用外）投稿 API
+(BOOL)postMessage2Mail: (NSString*)title  
                message: (NSString*)message  
                    url: (NSString*)url;  

	title
		(必须) 投稿标题
	message
		(必须) 投稿内容
	url
		(必须) 投稿 URL
	successCB
		(任意) 邮件应用启动后的回调函数。可使用 nil。
	return 
		无指定参数时返回 NO。


// Mail （应用内）投稿 API
+(BOOL)postMessage2InnerMail: (UIViewController*)viewControllerToPresent  
                       title: (NSString*)title  
                     message: (NSString*)message  
                         url: (NSString*)url  
                   onSuccess: (void(^)())successCB  
                    onCancel: (void(^)())cancelCB;  

	viewControllerToPresent
		(必须) 显示投稿 UI 的主 View Controller
	title
		(必须) 投稿标题
	message
		(必须) 投稿内容
	url
		(必须) 投稿 URL
	successCB
		(任意) 邮件发送后的回调函数。可使用 nil。
	cancelCB
		(任意) 邮件发送取消后的回调函数。可使用 nil。
	return 
		无指定参数或邮箱没设置时返回 NO。


// 显示投稿 UIActionSheet 的 API
+(BOOL)postMessage2ActionSheet: (NSString*)title  
                        message: (NSString*)message  
                            url: (NSString*)url  
                          appId: (NSString*)facebookAppId
                 viewController: (id)viewController  
                      onSuccess: (void(^)())successCB  
                       onCancel: (void(^)())cancelCB;  

	title
		(必须) 投稿标题
	message
		(必须) 投稿内容
	url
		(必须) 投稿 URL
    facebookAppId  
        (必须) Facebook appId
	viewController
		(必须) 显示投稿 UI 的主 View Controller
	successCB
        (任意) iOS 6 以后，选择 Facebook/Twitter 时投稿后回调函数。那以外是开启浏览器后的回调函数。
        可使用 nil。
	cancelCB
        (任意) iOS 6 以后，选择 Facebook/Twitter 时投稿取消后回调函数。那以外不被调用。
        可使用 nil。
	return 
		无指定必须参数时返回 NO。

// 读取 postMessage2ActionSheet 里被选择按钮的 API
+(ACTIONSHEET_PUSHED_STATUS)getPushedButtonActionSheet  

	参数
        没有
	return
		ACTIONSHEET_PUSHED_STATUS (enum)
		ACTN_SHT_PUSHED_NOT_PUSHED = 0,
		ACTN_SHT_PUSHED_LINE, // LINE 被按了
		ACTN_SHT_PUSHED_TWITTER_ANDOVER_IOS6, // TWITTER 被按了，iOS 版本 >= 6
		ACTN_SHT_PUSHED_FACEBOOK_ANDOVER_IOS6, // Facebook 被按了，iOS 版本 >= 6
		ACTN_SHT_PUSHED_TWITTER_UNDER_IOS6, // TWITTER 被按了，iOS 版本 < 6
		ACTN_SHT_PUSHED_FACEBOOK_UNDER_IOS6, // Facebook 被按了，iOS 版本 < 6
		ACTN_SHT_PUSHED_MAIL, // Mail 被按了



// Twitter 图像投稿 API (iOS 5 以上)
+(BOOL)postMessage2TwitterWithImage: (NSString*)message  
                                url: (NSString*)url  
                          imagePath: (NSString*)imagePath  
                     viewController: (id)viewController  
                          onSuccess: (void(^)())successCB  
                           onCancel: (void(^)())cancelCB  

	message
		(必须) 投稿内容
	url
		(必须) 投稿 URL
	viewController
		(必须) 显示投稿 UI 的主 View Controller
    imagePath
        (必须) 投稿图像的档案途径
	successCB
        (任意) iOS 5 以后版本：投稿后的回调函数；iOS 4 或以前版本：开启浏览器后的回调函数。
        可使用 nil。
	cancelCB
        (任意) iOS 5 以后版本：投稿取消后的回调函数；iOS 4 或以前版本不被调用。
        可使用 nil。
	return 
		无指定参数时返回 NO。
        
        
// Facebook 图像投稿 API (iOS 6 以上)
+(BOOL)postMessage2FacebookWithImage: (NSString*)title  
                             message: (NSString*)message  
                                 url: (NSString*)url  
                           imagePath: (NSString*)imagePath  
                      viewController: (id)viewController  
                           onSuccess: (void(^)())successCB  
                            onCancel: (void(^)())cancelCB  

	title
		(必须) 投稿标题
	message
		(必须) 投稿内容
	url
		(必须) 投稿 URL
    imagePath
        (必须) 投稿图像的档案途径
	viewController
		(必须) 显示投稿 UI 的主 View Controller
	successCB
        (任意) iOS 6 以后版本：投稿后的回调函数；iOS 4 或以前版本：开启浏览器后的回调函数。
        可使用 nil。
	cancelCB
        (任意) iOS 6 以后版本：投稿取消后的回调函数；iOS 5 或以前版本不被调用。
        可使用 nil。
	return 
		无指定参数时返回 NO。
        
                            
// Facebook 图像 URL 投稿 API (使用 Safari 浏览器)
+(BOOL)postMessage2FacebookWithImageURL: (NSString*)title  
                                message: (NSString*)message  
                                    url: (NSString*)url  
                                  appId: (NSString*)appId  
                               imageURL: (NSString*)imageURL  
                              onSuccess: (void(^)())successCB  
                               onCancel: (void(^)())cancelCB

	title
		(必须) 投稿标题
	message
		(必须) 投稿内容
	url
		(必须) 投稿 URL
    appId  
        (必须) Facebook appId
    imageURL
        (必须) 投稿图像的 URL
	successCB
        (任意) iOS 6 以后版本：投稿后的回调函数；iOS 4 或以前版本：开启浏览器后的回调函数。
        可使用 nil。
	cancelCB
        (任意) iOS 6 以后版本：投稿取消后的回调函数；iOS 5 或以前版本不被调用。
        可使用 nil。
	return 
		无指定参数时返回 NO。
        
        
                                                  
// Mail （应用内）图像投稿 API
+(BOOL)postMessage2InnerMailWithImage:(UIViewController *)viewControllerToPresent  
                                 title:(NSString *)title  
                               message:(NSString *)message  
                             imagePath:(NSString *)imagePath  
                                   url:(NSString *)url  
                             onSuccess:(void (^)())successCB  
                              onCancel:(void (^)())cancelCB  

	viewControllerToPresent
		(必须) 显示投稿 UI 的主 View Controller
	title
		(必须) 投稿标题
	message
		(必须) 投稿内容
	url
		(必须) 投稿 URL
    imagePath
        (必须) 投稿图像的档案途径
    successCB
        (任意) 邮件发送后的回调函数。可使用 nil。
    cancelCB
        (任意) 邮件发送取消后的回调函数。可使用 nil。
    return 
        无指定参数或邮箱没设置时返回 NO。
	

