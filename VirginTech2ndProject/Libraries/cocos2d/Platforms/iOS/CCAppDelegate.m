/*
 * cocos2d for iPhone: http://www.cocos2d-iphone.org
 *
 * Copyright (c) 2013-2014 Cocos2D Authors
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
 *
 */

#import "../../ccMacros.h"
#ifdef __CC_PLATFORM_IOS

#import "CCAppDelegate.h"
#import "CCTexture.h"
#import "CCFileUtils.h"
#import "CCDirector_Private.h"
#import "CCScheduler.h"

#import "kazmath/kazmath.h"
#import "kazmath/GL/matrix.h"

#import "OALSimpleAudio.h"

#import "InfoLayer.h"
#import "GameManager.h"
#import <GameFeatKit/GFController.h>

NSString* const CCSetupPixelFormat = @"CCSetupPixelFormat";
NSString* const CCSetupScreenMode = @"CCSetupScreenMode";
NSString* const CCSetupScreenOrientation = @"CCSetupScreenOrientation";
NSString* const CCSetupAnimationInterval = @"CCSetupAnimationInterval";
NSString* const CCSetupFixedUpdateInterval = @"CCSetupFixedUpdateInterval";
NSString* const CCSetupShowDebugStats = @"CCSetupShowDebugStats";
NSString* const CCSetupTabletScale2X = @"CCSetupTabletScale2X";

NSString* const CCSetupDepthFormat = @"CCSetupDepthFormat";
NSString* const CCSetupPreserveBackbuffer = @"CCSetupPreserveBackbuffer";
NSString* const CCSetupMultiSampling = @"CCSetupMultiSampling";
NSString* const CCSetupNumberOfSamples = @"CCSetupNumberOfSamples";

NSString* const CCScreenOrientationLandscape = @"CCScreenOrientationLandscape";
NSString* const CCScreenOrientationPortrait = @"CCScreenOrientationPortrait";

NSString* const CCScreenModeFlexible = @"CCScreenModeFlexible";
NSString* const CCScreenModeFixed = @"CCScreenModeFixed";

// Fixed size. As wide as iPhone 5 at 2x and as high as the iPad at 2x.
const CGSize FIXED_SIZE = {568, 384};

@interface CCNavigationController ()
{
    CCAppDelegate* __weak _appDelegate;
    NSString* _screenOrientation;
}
@property (nonatomic, weak) CCAppDelegate* appDelegate;
@property (nonatomic, strong) NSString* screenOrientation;
@end

@implementation CCNavigationController

@synthesize appDelegate = _appDelegate;
@synthesize screenOrientation = _screenOrientation;

// The available orientations should be defined in the Info.plist file.
// And in iOS 6+ only, you can override it in the Root View controller in the "supportedInterfaceOrientations" method.
// Only valid for iOS 6+. NOT VALID for iOS 4 / 5.
-(NSUInteger)supportedInterfaceOrientations
{
    if ([_screenOrientation isEqual:CCScreenOrientationLandscape])
    {
        return UIInterfaceOrientationMaskLandscape;
    }
    else
    {
        return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
    }
}

// Supported orientations. Customize it for your own needs
// Only valid on iOS 4 / 5. NOT VALID for iOS 6.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([_screenOrientation isEqual:CCScreenOrientationLandscape])
    {
        return UIInterfaceOrientationIsLandscape(interfaceOrientation);
    }
    else
    {
        return UIInterfaceOrientationIsPortrait(interfaceOrientation);
    }
}

// Projection delegate is only used if the fixed resolution mode is enabled
-(void)updateProjection
{
	CGSize sizePoint = [CCDirector sharedDirector].viewSize;
	CGSize fixed = [CCDirector sharedDirector].designSize;
	
	// Half of the extra size that will be cut off
	CGPoint offset = ccpMult(ccp(fixed.width - sizePoint.width, fixed.height - sizePoint.height), 0.5);
	
	kmGLMatrixMode(KM_GL_PROJECTION);
	kmGLLoadIdentity();
	
	kmMat4 orthoMatrix;
	kmMat4OrthographicProjection(&orthoMatrix, offset.x, sizePoint.width + offset.x, offset.y, sizePoint.height + offset.y, -1024, 1024 );
	kmGLMultMatrix( &orthoMatrix );
	
	kmGLMatrixMode(KM_GL_MODELVIEW);
	kmGLLoadIdentity();
}

// This is needed for iOS4 and iOS5 in order to ensure
// that the 1st scene has the correct dimensions
// This is not needed on iOS6 and could be added to the application:didFinish...
-(void) directorDidReshapeProjection:(CCDirector*)director
{
	if(director.runningScene == nil) {
		// Add the first scene to the stack. The director will draw it immediately into the framebuffer. (Animation is started automatically when the view is displayed.)
		// and add the scene to the stack. The director will run it when it automatically when the view is displayed.
		[director runWithScene: [_appDelegate startScene]];
	}
}
@end


@implementation CCAppDelegate

@synthesize window=window_, navController=navController_;

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
	return UIInterfaceOrientationMaskAll;
}

- (CCScene*) startScene
{
    NSAssert(NO, @"Override CCAppDelegate and implement the startScene method");
    return NULL;
}

static CGFloat
FindPOTScale(CGFloat size, CGFloat fixedSize)
{
	int scale = 1;
	while(fixedSize*scale < size) scale *= 2;
	
	return scale;
}

- (void) setupCocos2dWithOptions:(NSDictionary*)config
{
	// Create the main window
	window_ = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	
	// CCGLView creation
	// viewWithFrame: size of the OpenGL view. For full screen use [_window bounds]
	//  - Possible values: any CGRect
	// pixelFormat: Format of the render buffer. Use RGBA8 for better color precision (eg: gradients). But it takes more memory and it is slower
	//	- Possible values: kEAGLColorFormatRGBA8, kEAGLColorFormatRGB565
	// depthFormat: Use stencil if you plan to use CCClippingNode. Use Depth if you plan to use 3D effects, like CCCamera or CCNode#vertexZ
	//  - Possible values: 0, GL_DEPTH_COMPONENT24_OES, GL_DEPTH24_STENCIL8_OES
	// sharegroup: OpenGL sharegroup. Useful if you want to share the same OpenGL context between different threads
	//  - Possible values: nil, or any valid EAGLSharegroup group
	// multiSampling: Whether or not to enable multisampling
	//  - Possible values: YES, NO
	// numberOfSamples: Only valid if multisampling is enabled
	//  - Possible values: 0 to glGetIntegerv(GL_MAX_SAMPLES_APPLE)
	CCGLView *glView = [CCGLView
		viewWithFrame:[window_ bounds]
		pixelFormat:config[CCSetupPixelFormat] ?: kEAGLColorFormatRGBA8
        depthFormat:[config[CCSetupDepthFormat] unsignedIntValue]
		preserveBackbuffer:[config[CCSetupPreserveBackbuffer] boolValue]
		sharegroup:nil
		multiSampling:[config[CCSetupMultiSampling] boolValue]
		numberOfSamples:[config[CCSetupNumberOfSamples] unsignedIntValue]
	];
	
	CCDirectorIOS* director = (CCDirectorIOS*) [CCDirector sharedDirector];
	
	director.wantsFullScreenLayout = YES;
	
//#if DEBUG
	// Display FSP and SPF
	[director setDisplayStats:[config[CCSetupShowDebugStats] boolValue]];
//#endif
	
	// set FPS at 60
	NSTimeInterval animationInterval = [(config[CCSetupAnimationInterval] ?: @(1.0/60.0)) doubleValue];
	[director setAnimationInterval:animationInterval];
	
	director.fixedUpdateInterval = [(config[CCSetupFixedUpdateInterval] ?: @(1.0/60.0)) doubleValue];
	
	// attach the openglView to the director
	[director setView:glView];
	
	if([config[CCSetupScreenMode] isEqual:CCScreenModeFixed]){
		CGSize size = [CCDirector sharedDirector].viewSizeInPixels;
		CGSize fixed = FIXED_SIZE;
		
		if([config[CCSetupScreenOrientation] isEqualToString:CCScreenOrientationPortrait]){
			CC_SWAP(fixed.width, fixed.height);
		}
		
		// Find the minimal power-of-two scale that covers both the width and height.
		CGFloat scaleFactor = MIN(FindPOTScale(size.width, fixed.width), FindPOTScale(size.height, fixed.height));
		
		director.contentScaleFactor = scaleFactor;
		director.UIScaleFactor = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? 1.0 : 0.5);
		
		// Let CCFileUtils know that "-ipad" textures should be treated as having a contentScale of 2.0.
		[[CCFileUtils sharedFileUtils] setiPadContentScaleFactor: 2.0];
		
		director.designSize = fixed;
		[director setProjection:CCDirectorProjectionCustom];
	} else {
		// Setup tablet scaling if it was requested.
		if(
			UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad &&
			[config[CCSetupTabletScale2X] boolValue]
		){
			// Set the director to use 2 points per pixel.
			director.contentScaleFactor *= 2.0;
			
			// Set the UI scale factor to show things at "native" size.
			director.UIScaleFactor = 0.5;
			
			// Let CCFileUtils know that "-ipad" textures should be treated as having a contentScale of 2.0.
			[[CCFileUtils sharedFileUtils] setiPadContentScaleFactor:2.0];
		}
		
		[director setProjection:CCDirectorProjection2D];
	}
	
	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change this setting at any time.
	[CCTexture setDefaultAlphaPixelFormat:CCTexturePixelFormat_RGBA8888];
    
    // Initialise OpenAL
    [OALSimpleAudio sharedInstance];
	
	// Create a Navigation Controller with the Director
	navController_ = [[CCNavigationController alloc] initWithRootViewController:director];
	navController_.navigationBarHidden = YES;
	navController_.appDelegate = self;
	navController_.screenOrientation = (config[CCSetupScreenOrientation] ?: CCScreenOrientationLandscape);
    
	// for rotation and other messages
	[director setDelegate:navController_];
	
	// set the Navigation Controller as the root view controller
	[window_ setRootViewController:navController_];
	
	// make main window visible
	[window_ makeKeyAndVisible];
}

// getting a call, pause the game
-(void) applicationWillResignActive:(UIApplication *)application
{
	if( [navController_ visibleViewController] == [CCDirector sharedDirector] )
		[[CCDirector sharedDirector] pause];
}

// call got rejected
-(void) applicationDidBecomeActive:(UIApplication *)application
{
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
	if( [navController_ visibleViewController] == [CCDirector sharedDirector] )
		[[CCDirector sharedDirector] resume];
    
    //ゲームフィートSDK有効化
    [GFController activateGF:@"8161" useCustom:NO useIcon:YES usePopup:NO];
    
    //初回ログインボーナス
    //NSDate* currentDate= [NSDate dateWithTimeIntervalSinceNow:[[NSTimeZone systemTimeZone] secondsFromGMT]];
    NSDate* currentDate=[NSDate date];//GMTで貫く
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] persistentDomainForName:appDomain];
    if([dict valueForKey:@"LoginDate"]==nil){//初回なら
        [GameManager save_login_Date:currentDate];
        
        UIAlertView *alert = [[UIAlertView alloc] init];
        alert.tag=1;
        alert.delegate = self;
        alert.title = NSLocalizedString(@"BonusGet",NULL);
        alert.message = NSLocalizedString(@"FirstBonus",NULL);
        [alert addButtonWithTitle:NSLocalizedString(@"OK",NULL)];
        [alert show];
    }
    
    //デイリー・ボーナス
    NSDate* recentDate=[GameManager load_Login_Date];
    //日付のみに変換
    NSCalendar *calen = [NSCalendar currentCalendar];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDateComponents *comps = [calen components:unitFlags fromDate:currentDate];
    //[comps setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];//GMTで貫く
    currentDate = [calen dateFromComponents:comps];
    
    if([currentDate compare:recentDate]==NSOrderedDescending){//日付が変わってるなら「1」
        [GameManager save_login_Date:currentDate];
        
        UIAlertView *alert = [[UIAlertView alloc] init];
        alert.tag=2;
        alert.delegate = self;
        alert.title = NSLocalizedString(@"BonusGet",NULL);
        alert.message = NSLocalizedString(@"DailyBonus",NULL);
        [alert addButtonWithTitle:NSLocalizedString(@"OK",NULL)];
        [alert show];
    }
    
}

-(void) applicationDidEnterBackground:(UIApplication*)application
{
	if( [navController_ visibleViewController] == [CCDirector sharedDirector] )
		[[CCDirector sharedDirector] stopAnimation];
    
    //ゲームフィートコンバージョン確認タスクの起動
    UIDevice *device = [UIDevice currentDevice];
    BOOL backgroundSupported = NO;
    if ([device respondsToSelector:@selector(isMultitaskingSupported)]) {
        backgroundSupported = device.multitaskingSupported;
    }
    if (backgroundSupported) {
        [GFController backgroundTask];
    }
    
    //========================
    //　ローカル通知設定
    //========================
    // インスタンス生成
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    // 12時間後に通知をする（設定は秒単位）
    notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:(60 * 60 * 12)];
    // タイムゾーンの設定
    notification.timeZone = [NSTimeZone defaultTimeZone];
    // 通知時に表示させるメッセージ内容
    notification.alertBody = NSLocalizedString(@"LocalNotification",NULL);
    // 通知に鳴る音の設定
    notification.soundName = UILocalNotificationDefaultSoundName;
    // 通知の登録
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

-(void) applicationWillEnterForeground:(UIApplication*)application
{
	if( [navController_ visibleViewController] == [CCDirector sharedDirector] )
		[[CCDirector sharedDirector] startAnimation];
    
    //ゲームフィートコンバージョン確認タスクの停止
    [GFController conversionCheckStop];
    
    // アプリに登録されている全ての通知を削除
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

// application will be killed
- (void)applicationWillTerminate:(UIApplication *)application
{
	[[CCDirector sharedDirector] end];
}

// purge memory
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
	[[CCDirector sharedDirector] purgeCachedData];
}

// next delta time will be zero
-(void) applicationSignificantTimeChange:(UIApplication *)application
{
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==1){
        
        //チケット付与
        [GameManager save_Ticket_Count:[GameManager load_Ticket_Count]+10];
        [InfoLayer update_Ticket];
        
    }else if(alertView.tag==2){
        
        //チケット付与
        [GameManager save_Ticket_Count:[GameManager load_Ticket_Count]+ 1];
        [InfoLayer update_Ticket];
        
    }
}


@end

#endif
