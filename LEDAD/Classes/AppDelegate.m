//
//  AppDelegate.m
//  LEDAD
//
//  yixingman on 11-10-22.
//  ledmedia All rights reserved.
//

#import "AppDelegate.h"
#import "SplitVCDemoViewController.h"
#import "LoginViewController.h"
#import "Config.h"
#import "LayoutYXMViewController.h"
#import "MyTool.h"
#import "NSString+MD5.h"
#import "SoftVersionViewController.h"
#import "CX_ProgramViewController.h"


//判断当前系统语言的方法
#define CURR_LANG                        ([[NSLocale preferredLanguages] objectAtIndex:0])


@implementation AppDelegate

@synthesize window;
@synthesize viewController;



#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //yxm 在应用启动时，设置这个方法作为自己的自定义异常回调：
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);

    //云屏市场中的配置参数
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:@"YES" forKey:@"ADD"];
    [ud setObject:@"YES" forKey:@"ADD_TrainingView"];
    [ud setObject:@"image" forKey:@"PingtiOrImage"];

    //检查新版本
    [SoftVersionViewController updateAppVersion:NO];
    
    window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    //判断语言初始化
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSArray * allLanguages = [defaults objectForKey:@"AppleLanguages"];
    NSString * preferredLang = [allLanguages objectAtIndex:0];
    languageString = [[NSString alloc] init];
    languageString = preferredLang;
//    NSUserDefaults *language1 =   [NSUserDefaults standardUserDefaults];
//    languageString =[language1 objectForKey:LOCAL_LANGUAGE];

    NSLog(@"%@",CURR_LANG);
    //语言初始化设置 第一次如果我们设置的字段为空则根据系统的语言相对应赋值 这样通系统的本地国际化相同 但由于我们自定义了这样的字段我们可以一键切换语言
    if ([languageString  length]==0||[languageString isEqualToString:@""]||languageString ==nil) {
        if ([CURR_LANG isEqual:@"zh-Hans"]) {
            languageString = @"zh-Hans";
        }else if ([CURR_LANG isEqual:@"zh-Hant"]){
            languageString = @"zh-Hant";
        }else if ([CURR_LANG isEqual:@"en"]){
            languageString = @"en";
        }else if ([CURR_LANG isEqual:@"it"]){
            languageString = @"it";
        }

    }

    if (DEVICE_IS_IPAD) {
        window.rootViewController=viewController;
//        DYT_HomepageViewController *homepageVC = [[DYT_HomepageViewController alloc] init];
//        [window setRootViewController:homepageVC];
    }else{
        DYT_HomepageViewController *homepageVC = [[DYT_HomepageViewController alloc] init];
//        CX_ProgramViewController *homepageVC = [[CX_ProgramViewController alloc] init];
//        HomepageViewController *homepageVC = [[HomepageViewController alloc]init];
        [window setRootViewController:homepageVC];
    }


    [UIDevice currentDevice].batteryMonitoringEnabled = YES;
    double deviceLevel = [UIDevice currentDevice].batteryLevel;
    DLog(@"电量 = %lf",deviceLevel);
    if (deviceLevel<0.10f) {
        NSLog(@"设备电池电量低！");
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:[Config DPLocalizedString:@"adedit_xcoludsprompt"] message:[Config DPLocalizedString:@"adedit_batterylow"] delegate:self cancelButtonTitle:[Config DPLocalizedString:@"adedit_Done"] otherButtonTitles:nil, nil];

        [alertView show];
        [alertView release];

    }
//    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:@"YES" forKey:@"ADD"];
    [ud setObject:@"YES" forKey:@"ADD_TrainingView"];
    [ud setObject:@"image" forKey:@"PingtiOrImage"];
//    [self useFTPSendFile];
    [self.window makeKeyAndVisible];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}

/**
 *自定义一个方法, 用于处理异常
 */
void uncaughtExceptionHandler(NSException *exception){
    NSArray *arr = [exception callStackSymbols];
    NSString *reason = [exception reason];
    NSString *name = [exception name];
    
    NSString *exceptionReport = [[NSString alloc]initWithFormat:@"=============异常崩溃报告=============\nname:\n%@\nreason:\n%@\ncallStackSymbols:\n%@",name,reason,[arr componentsJoinedByString:@"\n"]];
    
    NSString *path = [[MyTool applicationDocumentsDirectory] stringByAppendingPathComponent:@"ExceptionReport.txt"];
    [exceptionReport writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    DLog(@"%@",exceptionReport);
    RELEASE_SAFELY(exceptionReport)
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    @try {
        NSFileManager *myFileManager = [NSFileManager defaultManager];
        //扫描inbox目录获得其他应用分享的音乐
        NSString *musicNameInInbox = nil;
        NSString *inboxDirectory= [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Inbox/"];
        NSArray *inboxSubfileArray = [myFileManager contentsOfDirectoryAtPath:inboxDirectory error:nil];
        for (NSString *musicNameString in inboxSubfileArray) {
            musicNameInInbox = musicNameString;
        }
        
        //转移音乐到自定义的music目录下
        NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/ProjectMusic/"];
        if (![myFileManager fileExistsAtPath:documentsDirectory]) {
            [myFileManager createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES attributes:nil error:nil];
        }
        NSString *myFilePath = [documentsDirectory
                                stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",musicNameInInbox]];
        if ([myFileManager fileExistsAtPath:myFilePath]) {
            [myFileManager removeItemAtPath:myFilePath error:nil];
        }
        NSData *myData = [NSData dataWithContentsOfURL:url];
        BOOL writeFileResult = [myData writeToFile:myFilePath atomically:YES];
        if (writeFileResult) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:[Config DPLocalizedString:@"adedit_xcoludsprompt"] message:[NSString stringWithFormat:@"%@[%@]%@",[Config DPLocalizedString:@"adedit_musicpromptbefore"],musicNameInInbox,[Config DPLocalizedString:@"adedit_musicpromptlast"]] delegate:self cancelButtonTitle:[Config DPLocalizedString:@"adedit_Done"] otherButtonTitles:nil, nil];
            [alertView show];
            [alertView release];
            for (NSString *musicNameString2 in inboxSubfileArray) {
                NSError *myError = nil;
                BOOL delFileResult = [myFileManager removeItemAtPath:[NSString stringWithFormat:@"%@/%@",inboxDirectory,musicNameString2] error:&myError];
                if (!delFileResult) {
                    DLog(@"delpath = %@",[NSString stringWithFormat:@"%@/%@",inboxDirectory,musicNameString2]);
                }
                if (myError) {
                    DLog(@"myError = %@",myError);
                }
            }
        }
    }
    @catch (NSException *exception) {
        DLog(@"%@",exception);
    }
    @finally {
        
    }
    return YES;
}

- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}



/**
 *  使用ftp来发送文件
 */
-(void)useFTPSendFile{
    if (!_myFtpMgr) {
        NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Upgrade"];
        NSString *filePath = [[NSString alloc]initWithFormat:@"%@/%@",documentsDirectory,@"a.mp4"];
        _uploadFileTotalSize = [LayoutYXMViewController fileSizeAtPath:filePath];
        //连接ftp服务器
        _myFtpMgr = [[YXM_FTPManager alloc]init];
        _myFtpMgr.delegate = self;
        NSString *sUploadUrl = [[NSString alloc]initWithFormat:@"ftp://www.ledmediasz.com:10021"];
        NSLog(@"%@",sUploadUrl);
        [_myFtpMgr startUploadFileWithAccount:@"ledmedia" andPassword:@"Q123456az" andUrl:sUploadUrl andFilePath:filePath];

    }
}

/**
 *  ftp上传文件的结果
 *
 *  @param sInfo 结果信息字符串
 */
-(void)uploadResultInfo:(NSString *)sInfo{
    NSLog(@"sInfo = %@",sInfo);
}

/**
 *  ftp上传文件写入的数据长度
 *
 *  @param writeDataLength 数据长度
 */
-(void)uploadWriteData:(NSInteger)writeDataLength{
    _sendFileCountSize += writeDataLength;
    float progressValue = _sendFileCountSize*1.0f / _uploadFileTotalSize*1.0f;
    NSLog(@"progressValue = %@",[NSString stringWithFormat:@"%0.0lf％",progressValue*100]);
}

@end
