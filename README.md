PostMessageSNS-iOS  
==================

iOS 用の LINE / Twitter / Facebook / Mail への投稿用ライブラリです。  

iOS 5.0 から利用できますが、iOS 5.0 をサポートする場合、
Social.framework を optional で取り込んで下さい。

=================================================================================
バージョン  
=================================================================================
1.3  

=================================================================================
変更履歴  
=================================================================================
version 1.3  
- 画像投稿機能追加

version 1.2  
- アプリ内メール送信機能を追加(ActionSheetの"メール"がアプリ内メールに変更)  
- MessageUI.framework の追加が必須になりました。  

version 1.1.1  
- コールバックを受け取れるように修正  

version 1.1  
- ActionSheet 機能を追加  

version 1.0  
- 初回リリース  

=================================================================================
ビルド方法  
=================================================================================
Static iOS Framework を Xcode にインストールする必要があります。  

以下を実行してインストールします。  
$ git clone git://github.com/kstenerud/iOS-Universal-Framework.git  
$ cd ./iOS-Universal-Framework/Real\ Framework/  
$ ./install.sh  

=================================================================================
インポート方法  
=================================================================================

iOS 版  

- Social.framework を optional でインポートして下さい。(iOS 6 未満のため)  
- MessageUI.framework を required でインポートして下さい。  
- PostMessageSNS.framework を required で取り込めば使用可能になります。  

=================================================================================
API 一覧 - iOS 版  
=================================================================================

// LINE に投稿するための API  
+(BOOL)postMessage2LINE: (NSString*)message  
                    url: (NSString*)url  
              onSuccess: (void(^)())successCB;  

	message
		(必須) 投稿する本文の内容
	url
		(必須) 投稿する URL
	successCB
		(オプション) ブラウザを開いた後に呼ばれるコールバックです。nil を指定することもできます。
	return 
		引数が無い場合は NO が返却されます。	


// Twitter に投稿するための API  
+(BOOL)postMessage2Twitter: (NSString*)message  
                       url: (NSString*)url  
            viewController: (id)viewController  
                 onSuccess: (void(^)())successCB  
                  onCancel: (void(^)())cancelCB;  

	message
		(必須) 投稿する本文の内容
	url
		(必須) 投稿する URL
	viewController
		(必須) 投稿 UI を表示させる viewController のインスタンス	
	successCB
		(オプション) iOS5 以降の場合、投稿後に呼ばれるコールバックです。iOS5 未満の場合は、ブラウザを開いた後に呼ばれます。nil を指定することもできます。
	cancelCB
		(オプション) iOS5 以降の場合、投稿画面をキャンセルした後に呼ばれるコールバックです。iOS5 未満の場合は呼ばれません。nil を指定することもできます。
	return 
		引数が無い場合は NO が返却されます。	


// Facebook に投稿するための API  
+(BOOL)postMessage2Facebook: (NSString*)title  
                    message: (NSString*)message  
                        url: (NSString*)url  
                      appId: (NSString*)appId  
             viewController: (id)viewController  
                  onSuccess: (void(^)())successCB  
                   onCancel: (void(^)())cancelCB;  

	title
		(必須) 投稿するタイトル
	message
		(必須) 投稿する本文の内容
	url
		(必須) 投稿する URL
	appId  
		(必須) Facebook の appId
	viewController
		(必須) 投稿 UI を表示させる viewController のインスタンス
	successCB
		(オプション) iOS6 以降の場合、投稿後に呼ばれるコールバックです。iOS6 未満の場合は、ブラウザを開いた後に呼ばれます。nil を指定することもできます。
	cancelCB
		(オプション) iOS6 以降の場合、投稿画面をキャンセルした後にに呼ばれるコールバックです。iOS6 未満の場合は呼ばれません。nil を指定することもできます。
	return 
		引数が無い場合は NO が返却されます。	


// Mail に投稿するための API  
+(BOOL)postMessage2Mail: (NSString*)title  
                message: (NSString*)message  
                    url: (NSString*)url;  

	title
		(必須) 投稿するタイトル
	message
		(必須) 投稿する本文の内容
	url
		(必須) 投稿する URL
	successCB
		(オプション) メールアプリを開いた後に呼ばれるコールバックです。nil を指定することもできます。
	return 
		引数が無い場合は NO が返却されます。	


// アプリ内で Mail に投稿するための API  
+(BOOL)postMessage2InnerMail: (UIViewController*)viewControllerToPresent  
                       title: (NSString*)title  
                     message: (NSString*)message  
                         url: (NSString*)url  
                   onSuccess: (void(^)())successCB  
                    onCancel: (void(^)())cancelCB;  

	viewControllerToPresent
		(必須) Mail 画面を表示させる view controller
	title
		(必須) 投稿するタイトル
	message
		(必須) 投稿する本文の内容
	url
		(必須) 投稿する URL
	successCB
		(オプション) メールを送信した後に呼ばれるコールバックです。nil を指定することもできます。
	cancelCB
		(オプション) メールの送信をキャンセルした後に呼ばれるコールバックです。nil を指定することもできます。
	return 
		引数が無い場合、メールが設定されていない場合は NO が返却されます。	


// 投稿用の UIActionSheet を出すための API  
+(BOOL)postMessage2ActionSheet: (NSString*)title  
                        message: (NSString*)message  
                            url: (NSString*)url  
                          appId: (NSString*)facebookAppId  
                 viewController: (id)viewController  
                      onSuccess: (void(^)())successCB  
                       onCancel: (void(^)())cancelCB;  

	title
		(必須) 投稿するタイトル
	message
		(必須) 投稿する本文の内容
	url
		(必須) 投稿する URL
	facebookAppId  
		(必須) Facebook の appId
	viewController
		(必須) 投稿 UI を表示させる viewController のインスタンス
	successCB
		(オプション) iOS6 以降かつ Facebook/Twitte の場合、投稿後に呼ばれるコールバックです。他の場合は、ブラウザを開いた後に呼ばれます。nil を指定することもできます。
	cancelCB
		(オプション) iOS6 以降かつ Facebook/Twitte の場合、投稿画面をキャンセルした後にに呼ばれるコールバックです。他の場合は呼ばれません。nil を指定することもできます。
	return 
		必須の引数が無い場合は NO が返却されます。

// 直前の postMessage2ActionSheet でどれが押されたかを ACTIONSHEET_PUSHED_STATUS で返す API  
+(ACTIONSHEET_PUSHED_STATUS)getPushedButtonActionSheet  

	引数
        なし
	return 
		ACTIONSHEET_PUSHED_STATUS (enum) で返します。
		ACTN_SHT_PUSHED_NOT_PUSHED = 0,
		ACTN_SHT_PUSHED_LINE, // LINE ボタンが押された
		ACTN_SHT_PUSHED_TWITTER_ANDOVER_IOS6, // TWITTER ボタンが押された、かつ iOS 6 以上
		ACTN_SHT_PUSHED_FACEBOOK_ANDOVER_IOS6, // Facebook ボタンが押された、かつ iOS 6 以上
		ACTN_SHT_PUSHED_TWITTER_UNDER_IOS6, // TWITTER ボタンが押された、かつ iOS 6 未満
		ACTN_SHT_PUSHED_FACEBOOK_UNDER_IOS6, // Facebook ボタンが押された、かつ iOS 6 未満
		ACTN_SHT_PUSHED_MAIL, // Mail ボタンが押された



// Twitter に画像付きで投稿するための API (iOS 5 以上対応)  
+(BOOL)postMessage2TwitterWithImage: (NSString*)message  
                                url: (NSString*)url  
                          imagePath: (NSString*)imagePath  
                     viewController: (id)viewController  
                          onSuccess: (void(^)())successCB  
                           onCancel: (void(^)())cancelCB  

	message
		(必須) 投稿する本文の内容
	url
		(必須) 投稿する URL
	viewController
		(必須) 投稿 UI を表示させる viewController のインスタンス	
	imagePath
		(必須) 投稿する画像のファイルパス
	successCB
		(オプション) iOS5 以降の場合、投稿後に呼ばれるコールバックです。iOS5 未満の場合は、ブラウザを開いた後に呼ばれます。nil を指定することもできます。
	cancelCB
		(オプション) iOS5 以降の場合、投稿画面をキャンセルした後にに呼ばれるコールバックです。iOS5 未満の場合は呼ばれません。nil を指定することもできます。
	return 
		引数が無い場合は NO が返却されます。	
        
        
// Facebook に画像付きで投稿するための API (iOS 6 以上対応)  
+(BOOL)postMessage2FacebookWithImage: (NSString*)title  
                             message: (NSString*)message  
                                 url: (NSString*)url  
                           imagePath: (NSString*)imagePath  
                      viewController: (id)viewController  
                           onSuccess: (void(^)())successCB  
                            onCancel: (void(^)())cancelCB  

	title
		(必須) 投稿するタイトル
	message
		(必須) 投稿する本文の内容
	url
		(必須) 投稿する URL
	imagePath
		(必須) 投稿する画像のファイルパス
	viewController
		(必須) 投稿 UI を表示させる viewController のインスタンス
	successCB
		(オプション) iOS6 以降の場合、投稿後に呼ばれるコールバックです。iOS6 未満の場合は、ブラウザを開いた後に呼ばれます。nil を指定することもできます。
	cancelCB
		(オプション) iOS6 以降の場合、投稿画面をキャンセルした後にに呼ばれるコールバックです。iOS6 未満の場合は呼ばれません。nil を指定することもできます。
	return 
		引数が無い場合は NO が返却されます。	
        
                            
// Facebook に画像 URL を含めて投稿するための API (Safari 経由)  
+(BOOL)postMessage2FacebookWithImageURL: (NSString*)title  
                                message: (NSString*)message  
                                    url: (NSString*)url  
                                  appId: (NSString*)appId  
                               imageURL: (NSString*)imageURL  
                              onSuccess: (void(^)())successCB  
                               onCancel: (void(^)())cancelCB

	title
		(必須) 投稿するタイトル
	message
		(必須) 投稿する本文の内容
	url
		(必須) 投稿する URL    
    	imageURL
        	(必須) 投稿する画像のURL
	appId  
		(必須) Facebook の appId
	successCB
		(オプション) iOS6 以降の場合、投稿後に呼ばれるコールバックです。iOS6 未満の場合は、ブラウザを開いた後に呼ばれます。nil を指定することもできます。
	cancelCB
		(オプション) iOS6 以降の場合、投稿画面をキャンセルした後にに呼ばれるコールバックです。iOS6 未満の場合は呼ばれません。nil を指定することもできます。
	return 
		引数が無い場合は NO が返却されます。	  
        
        
                                                  
// アプリ内で Mail に画像付きで投稿するための API  
+(BOOL)postMessage2InnerMailWithImage:(UIViewController *)viewControllerToPresent  
                                 title:(NSString *)title  
                               message:(NSString *)message  
                             imagePath:(NSString *)imagePath  
                                   url:(NSString *)url  
                             onSuccess:(void (^)())successCB  
                              onCancel:(void (^)())cancelCB  

	viewControllerToPresent
		(必須) Mail 画面を表示させる view controller
	title
		(必須) 投稿するタイトル
	message
		(必須) 投稿する本文の内容
	url
		(必須) 投稿する URL
    	imagePath
        	(必須) 投稿する画像のファイルパス
	successCB
		(オプション) メールを送信した後に呼ばれるコールバックです。nil を指定することもできます。
	cancelCB
		(オプション) メールの送信をキャンセルした後に呼ばれるコールバックです。nil を指定することもできます。
	return 
		引数が無い場合、メールが設定されていない場合は NO が返却されます。	

