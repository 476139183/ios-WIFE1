//
//  YXM_VideoEditerViewController.m
//  LEDAD
//
//  Created by yixingman on 14-10-14.
//  Copyright (c) 2014年 yxm. All rights reserved.
//
#define  ViewHeight [[UIScreen mainScreen] bounds].size.height
#define  ViewWidth [[UIScreen mainScreen] bounds].size.width

#define SECOND_WIDTH 30.0f
#define TAG_MYTIMESCALE 60
#define TAG_CAMREA_VIEW 200000
#define TAG_SCALE_CHANGE_SLIDER 3000000
#define TAG_VIEWFINDER_LABEL 4000000
//  CMTimeMake和CMTimeMakeWithSeconds 详解
/*CMTimeMake(a,b)    a当前第几帧, b每秒钟多少帧.当前播放时间a/b

 CMTimeMakeWithSeconds(a,b)    a当前时间,b每秒钟多少帧.

 CMTimeMake

 CMTime CMTimeMake (
 int64_t value,
 int32_t timescale
 );
 CMTimeMake顧名思義就是用來建立CMTime用的,
 但是千萬別誤會他是拿來用在一般時間用的,
 CMTime可是專門用來表示影片時間用的類別,
 他的用法為: CMTimeMake(time, timeScale)

 time指的就是時間(不是秒),
 而時間要換算成秒就要看第二個參數timeScale了.
 timeScale指的是1秒需要由幾個frame構成(可以視為fps),
 因此真正要表達的時間就會是 time / timeScale 才會是秒.

 簡單的舉個例子

 CMTimeMake(60, 30);
 CMTimeMake(30, 15);
 在這兩個例子中所表達在影片中的時間都皆為2秒鐘,
 但是影隔播放速率則不同, 相差了有兩倍.*/
#define TAG_UP_MASK_VIEW 80001
#define TAG_DOWN_MASK_VIEW 80002
#define TAG_LEFT_MASK_VIEW 80003
#define TAG_RIGHT_MASK_VIEW 80004
#define TAG_SCRUBBER_CONTAINER 80005
#define TAG_LINE_VIEW 80006

#import "YXM_VideoEditerViewController.h"
#import "AppDelegate.h"
#import "Config.h"
#import "MaterialObject.h"
#import "MyTool.h"
#import "NSString+MD5.h"
#import "YXM_VideoFrameActionObject.h"
#import "MyProjectListViewController.h"
#import "GDataXMLNode.h"
#import "Config.h"
#import "LayoutYXMViewController.h"
#import "LEDAD_TAG.h"




@interface YXM_VideoEditerViewController ()<UINavigationControllerDelegate>
@property (strong, nonatomic) NSArray *evaluateViews;
@end

@implementation YXM_VideoEditerViewController

@synthesize myAsset = _myAsset;
@synthesize viewfinderWidth = _viewfinderWidth;
@synthesize viewfinderHeight = _viewfinderHeight;




#pragma mark - Record View Delegate

-(void)recordDrawFrameWith:(UIView *)view andSecond:(float)videoTime{
    NSInteger iVideoTime = videoTime;
    if (videoTime<1) {
        iVideoTime = 0;
    }
    iSecond3 = iVideoTime;
    if (iSecond3!=iSecond4) {
        iSecond3 = iSecond4;
        UIView *cameraView = [self.view viewWithTag:TAG_CAMREA_VIEW];
        NSInteger tx = cameraView.frame.origin.x;
        NSInteger ty = cameraView.frame.origin.y;
        NSInteger tw = cameraView.frame.size.width;
        NSInteger th = cameraView.frame.size.height;
        YXM_VideoFrameActionObject *fObj = [[YXM_VideoFrameActionObject alloc]init];

        NSString *scrubberOffset = [self decimalwithFormat:@"0.000" floatV:iVideoTime];
        [fObj setFrameTimeline:scrubberOffset];
        [fObj setX:tx];
        [fObj setY:ty];
    //    if (globalWHScale>0) {
    //        tw = tw * globalWHScale;
    //    }
        [fObj setW:tw];
        [fObj setH:th];
        [fObj setSh:[self videoShowScale].hs];
        [fObj setSw:[self videoShowScale].ws];
        [_dictFramesSubRectInfo removeObjectForKey:scrubberOffset];
        [_dictFramesSubRectInfo setObject:fObj forKey:scrubberOffset];
        [fObj release];
    }
}




- (void)viewDidUnload
{
    [self setJsVideoScrubber:nil];
    [super viewDidUnload];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //显示导航栏
    [self.navigationController.navigationBar setHidden:NO];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //暂停播放器
    [_myVideoPlayer pause];
    RELEASE_SAFELY(_myVideoPlayer);
    RELEASE_SAFELY(_myImageGenerator);
    //取消屏幕常亮
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    //隐藏导航栏
    [self.navigationController.navigationBar setHidden:YES];
}


- (void)viewDidLoad {

    [super viewDidLoad];
     _videoShowScale = 1;
    fVideoTime = 0.0f;

    self.view.backgroundColor = [UIColor darkGrayColor];

    _myImageGenerator = nil;
    //初始化数据和容器
    _dictFramesSubRectInfo = [[NSMutableDictionary alloc]init];

    //帧显示器
    [self insertFramesMonitor];

    //保存并且发布
    [self insertSaveAndPublishButton];
    [self initVideoScrubberAndExtractFrames:_myAsset];
}



-(void)insertFramesMonitor{
    //帧画面显示器
    CGRect rectContainerView = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    if (OS_VERSION_FLOAT<8.0) {
        rectContainerView = CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width);
    }
    _frameContainerScrollView = [[UIScrollView alloc]initWithFrame:rectContainerView];
    [self.view addSubview:_frameContainerScrollView];
    [_frameContainerScrollView release];
    _frameImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _frameContainerScrollView.frame.size.width, _frameContainerScrollView.frame.size.height)];
    [_frameImageView setUserInteractionEnabled:YES];
    [_frameContainerScrollView addSubview:_frameImageView];
    [_frameImageView release];

}

-(void)insertSaveAndPublishButton{
    //添加视频到帧处理器的按钮
    UIButton *addButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 80, 60, 30)];
    [addButton setTitle:[Config DPLocalizedString:@"adedit_SaveAndPublishButton"] forState:UIControlStateNormal];
    [addButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [addButton setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    if ([self respondsToSelector:@selector(saveFrameRectAction:)]) {
        [addButton addTarget:self action:@selector(saveFrameRectAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    [addButton setBackgroundColor:[UIColor colorWithRed:0.935 green:0.934 blue:0.933 alpha:1.000]];
    addButton.layer.borderColor = [UIColor greenColor].CGColor;
    addButton.layer.borderWidth = 1;
    [addButton setTitleShadowColor:[UIColor greenColor] forState:UIControlStateHighlighted];
    UIBarButtonItem *addVideoButtonItem = [[UIBarButtonItem alloc]initWithCustomView:addButton];
    [addButton release];
    //清理已编辑信息按钮
    UILabel *viewfinderSizeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 80, 200, 30)];
    viewfinderSizeLabel.layer.borderColor = [UIColor greenColor].CGColor;
    viewfinderSizeLabel.layer.borderWidth = 1;
    [viewfinderSizeLabel setTag:TAG_VIEWFINDER_LABEL];
    [viewfinderSizeLabel setFont:[UIFont boldSystemFontOfSize:12]];
    UIBarButtonItem *viewfinderSizeItem = [[UIBarButtonItem alloc]initWithCustomView:viewfinderSizeLabel];

    NSMutableArray *arrButtonItems = [[NSMutableArray alloc]initWithArray:self.navigationItem.rightBarButtonItems];
    [arrButtonItems addObject:addVideoButtonItem];
    [arrButtonItems addObject:viewfinderSizeItem];
    [addVideoButtonItem release];
    [viewfinderSizeItem release];
    [self.navigationItem setRightBarButtonItems:arrButtonItems animated:YES];
    [arrButtonItems release];
}

-(void)clearButtonEvent:(UIButton *)sender{
}

-(void)saveRectInfoToXMLWithFramesDict:(NSDictionary *)dict{
    if (globalDictFramesInfo) {
        [globalDictFramesInfo removeAllObjects];
        globalDictFramesInfo = nil;
    }
    globalDictFramesInfo = [[NSMutableDictionary alloc]initWithDictionary:_dictFramesSubRectInfo];
    globalDuration = _originDuration;
    if (globalsVideoPath) {
        globalsVideoPath = nil;
    }
    globalsVideoPath = [[NSString alloc]initWithString:_sVideoPathString];
    DLog(@"视频截取信息已生成,%@,count = %d",globalDictFramesInfo,[globalDictFramesInfo count]);
    [self.navigationController popViewControllerAnimated:true];
}

-(void)saveFrameRectAction:(UIButton*)sender{
    
    
    if ([_myVideoPlayer status] == AVPlayerStatusReadyToPlay) {
        DLog(@"视频正在播放");
        return;
    }
    DLog(@"点击了下一步");
    NSURL *sourceMovieURL = [NSURL fileURLWithPath:_sVideoPathString];
    AVAsset *movieAsset	= [AVURLAsset URLAssetWithURL:sourceMovieURL options:nil];
    AVPlayerItem *playerItem = [[AVPlayerItem alloc]initWithAsset:movieAsset];
    _myVideoPlayer = [[AVPlayer alloc]initWithPlayerItem:playerItem];
    _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_myVideoPlayer];
    _playerLayer.frame = CGRectMake(0, 0, _frameImageView.frame.size.width, _frameImageView.frame.size.height);
    _playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    [_frameImageView.layer addSublayer:_playerLayer];
    [_myVideoPlayer play];


    //视频源文件的对角线尺寸
    float originDiagonal = [MyTool diagonalCalculateWithA:_originViedoWidth andB:_originViedoHeight];
    //视频显示区域的对角线尺寸
    float showAreaDiagonal = [MyTool diagonalCalculateWithA:_frameImageView.frame.size.width andB:_frameImageView.frame.size.height];
    //原视频的宽高比
    float originScale = _originViedoWidth/_originViedoHeight;
    if (originDiagonal>showAreaDiagonal) {
        float showAreaWidth = [MyTool widthCalculateWithDiagonal:showAreaDiagonal andhwScale:originScale];
        float showAreaHeight = [MyTool heightCalculateWithDiagonal:showAreaDiagonal andhwScale:originScale];
        _playerLayer.frame = CGRectMake(0, 0, showAreaWidth, showAreaHeight);
    }else{
        _playerLayer.frame = CGRectMake(0, 0, _frameImageView.frame.size.width, _frameImageView.frame.size.height);
    }


    [self createCamrea:NO];
    UIView *camreaView = [self.view viewWithTag:TAG_CAMREA_VIEW];
//    NSString *timeKey = @"0.000";
//    YXM_VideoFrameActionObject *fObj = [_dictFramesSubRectInfo objectForKey:timeKey];
//    DLog(@"%@",fObj);
//    if (fObj) {
//        [camreaView setFrame:CGRectMake(fObj.x, fObj.y, fObj.w, fObj.h)];
//    }
    [_myVideoPlayer addPeriodicTimeObserverForInterval:CMTimeMake(30, TAG_MYTIMESCALE) queue:NULL usingBlock:^(CMTime time) {
        float duration = CMTimeGetSeconds(time);
        NSString *timeKey = [self decimalwithFormat:@"0.000" floatV:duration];
//        NSString *timeKey = @"0.000";
        YXM_VideoFrameActionObject *fObj = [_dictFramesSubRectInfo objectForKey:timeKey];
        if (fObj) {
            [camreaView setFrame:CGRectMake(fObj.x, fObj.y, fObj.w, fObj.h)];
        }
        timeKey = nil;
    }];

    [self saveRectInfoToXMLWithFramesDict:_dictFramesSubRectInfo];
}


-(void)createMaskViewWithShowRect:(CGRect)showRect andParentView:(UIView *)parentView{
    [self clearMaskView];
    CGRect rectPrarentView = parentView.frame;
    UIView *upMaskView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, rectPrarentView.size.width, showRect.origin.y)];
    [upMaskView setBackgroundColor:[UIColor blackColor]];
    [upMaskView setTag:TAG_UP_MASK_VIEW];
    UIView *leftMaskView = [[UIView alloc]initWithFrame:CGRectMake(0, showRect.origin.y, showRect.origin.x, showRect.size.height)];
    [leftMaskView setBackgroundColor:[UIColor blackColor]];
    [leftMaskView setTag:TAG_LEFT_MASK_VIEW];
    UIView *downMaskView = [[UIView alloc]initWithFrame:CGRectMake(0, showRect.origin.y + showRect.size.height, rectPrarentView.size.width, rectPrarentView.size.height - (showRect.origin.y + showRect.size.height))];
    [downMaskView setBackgroundColor:[UIColor blackColor]];
    [downMaskView setTag:TAG_DOWN_MASK_VIEW];
    UIView *rightMaskView = [[UIView alloc]initWithFrame:CGRectMake(showRect.origin.x + showRect.size.width, showRect.origin.y, parentView.frame.size.width - (showRect.origin.x + showRect.size.width), showRect.size.height)];
    [rightMaskView setBackgroundColor:[UIColor blackColor]];
    [rightMaskView setTag:TAG_RIGHT_MASK_VIEW];

    [parentView addSubview:upMaskView];
    [upMaskView release];
    [parentView addSubview:leftMaskView];
    [leftMaskView release];
    [parentView addSubview:downMaskView];
    [downMaskView release];
    [parentView addSubview:rightMaskView];
    [rightMaskView release];
}

-(void)clearMaskView{
    UIView *u = [self.view viewWithTag:TAG_UP_MASK_VIEW];
    [u removeFromSuperview];
    UIView *d = [self.view viewWithTag:TAG_DOWN_MASK_VIEW];
    [d removeFromSuperview];
    UIView *l = [self.view viewWithTag:TAG_LEFT_MASK_VIEW];
    [l removeFromSuperview];
    UIView *r = [self.view viewWithTag:TAG_RIGHT_MASK_VIEW];
    [r removeFromSuperview];
}

-(void)showImageAndRecordDrawWithTime:(float)videoTime{
    fVideoTime = videoTime;
    [self analysisWithSecond:videoTime];
    [self recordDrawFrameWith:nil andSecond:videoTime];
}

/**
 *  更新帧筛选时间轴上的时间
 *
 *  @param scrubber 帧选择器
 */
- (void) updateOffsetLabel:(JSVideoScrubber *) scrubber
{
    DLog(@"视频帧拾取器加载完毕2");
    if (_isHiddenHUD) {
        return;
    }
    _isHiddenHUD = YES;
    [KVNProgress dismiss];

    [self createCamrea:YES];

    [self showImageAndRecordDrawWithTime:1];


}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


-(void)analysisWithSecond:(float)videoTime{
    NSInteger iVideoTime = videoTime;
    if (videoTime<1) {
        iVideoTime = 0;
    }
    iSecond1 = iVideoTime;
    if (iSecond1!=iSecond2) {
        iSecond2 = iSecond1;
        [_myImageGenerator generateCGImagesAsynchronouslyForTimes:[NSArray arrayWithObject:[NSValue valueWithCMTime:CMTimeMakeWithSeconds(iVideoTime, 30)]] completionHandler:
         ^(CMTime requestedTime, CGImageRef image, CMTime actualTime, AVAssetImageGeneratorResult result, NSError *error)
         {

             NSLog(@"actual got image at time:%f", CMTimeGetSeconds(actualTime));
             if (image)
             {
                 [CATransaction begin];
                 [CATransaction setDisableActions:YES];
                 UIImage *myImage = [UIImage imageWithCGImage:image];
                 [_frameContainerScrollView setContentSize:myImage.size];
                 [_frameImageView setFrame:CGRectMake(0, 0, myImage.size.width*_videoShowScale, myImage.size.height*_videoShowScale)];
                 [_frameImageView setImage:myImage];

                 [CATransaction commit];
             }
         }];
    }

    //同步的方法
}

-(void)extractImageWithAVAsset:(NSString *)sVideoPath AndCMTime:(CMTime )myCMTime{
    if (_myImageGenerator) {

        CGImageRef myImageRef = [_myImageGenerator copyCGImageAtTime:myCMTime actualTime:NULL error:nil];

        if (!myImageRef) {
            DLog(@"返回数据为空");
            return;
        }
        UIImage *imageFrame = [UIImage imageWithCGImage:myImageRef];
        if (!imageFrame) {
            DLog(@"返回图像数据为空2");
            return;
        }

        DLog(@"myCMTime.value = %lld",myCMTime.value);
        if (myCMTime.value<30) {
            NSInteger iImageFrameHeight = imageFrame.size.height;
            NSInteger iImageFrameWidth = imageFrame.size.width;
            _originViedoWidth = iImageFrameWidth;
            _originViedoHeight = iImageFrameHeight;

            //视频源文件的对角线尺寸
            float originDiagonal = [MyTool diagonalCalculateWithA:_originViedoWidth andB:_originViedoHeight];
            //视频显示区域的对角线尺寸
            float showAreaDiagonal = [MyTool diagonalCalculateWithA:_frameImageView.frame.size.width andB:_frameImageView.frame.size.height];
            //原视频的宽高比
            float originScale = _originViedoWidth/_originViedoHeight;
            if (originDiagonal > showAreaDiagonal) {
                float showAreaWidth = [MyTool widthCalculateWithDiagonal:showAreaDiagonal andhwScale:originScale];
                float showAreaHeight = [MyTool heightCalculateWithDiagonal:showAreaDiagonal andhwScale:originScale];

                if (showAreaWidth<_frameImageView.frame.size.height) {
                    showAreaDiagonal = [MyTool diagonalCalculateWithA:showAreaWidth andB:_frameImageView.frame.size.height];
                    originScale = _originViedoHeight/_originViedoWidth;
                    showAreaWidth = [MyTool widthCalculateWithDiagonal:showAreaDiagonal andhwScale:originScale];
                    showAreaHeight = [MyTool heightCalculateWithDiagonal:showAreaDiagonal andhwScale:originScale];

                    _frameImageView.frame = CGRectMake(0,0, showAreaWidth, showAreaHeight);
                }else{
                    _frameImageView.frame = CGRectMake(0, 0, showAreaWidth, showAreaHeight);
                }
            }else{
                _frameImageView.frame = CGRectMake(0, 0, _originViedoWidth, _originViedoHeight);
            }

        }

        [_frameImageView setImage:imageFrame];
        CGImageRelease(myImageRef);
    }

}


- (void)extractFramesWithVideoPath:(NSString *)sVideoPath
{
    AVAsset *asset = [AVAsset assetWithURL:[NSURL fileURLWithPath:sVideoPath]];
    AVVideoComposition *composition = [AVVideoComposition videoCompositionWithPropertiesOfAsset:asset];
    _originDuration = CMTimeGetSeconds(asset.duration);
    _frameDuration = CMTimeGetSeconds(composition.frameDuration);
    _originViedoFPS = composition.frameDuration.timescale;//获取每秒视频帧数
    DLog(@"composition = %lf",composition.renderSize.width);
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    DLog(@"内存警告YXM_VideoEditerViewController");
}


//格式话小数 四舍五入类型
- (NSString *) decimalwithFormat:(NSString *)format  floatV:(float)floatV
{
    NSNumberFormatter *numberFormatter = [[[NSNumberFormatter alloc] init] autorelease];
    [numberFormatter setPositiveFormat:format];
    return  [numberFormatter stringFromNumber:[NSNumber numberWithFloat:floatV]];
}



/**
 *  后台复制文件到沙盒，并且在复制完成后调用加载帧选择器的方法
 *
 *  @param myasset     视频对象
 *  @param sRandomName 视频新的名称
 */
-(void)backgroundCopyFile:(ALAsset *)myasset andRandomName:(NSString *)sRandomName{
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(concurrentQueue, ^{
        __block NSString *bSVideoPathString = nil;
        dispatch_sync(concurrentQueue, ^{
            bSVideoPathString = [self handleWrittenFileWithSourceAsset:myasset AndMatrialName:sRandomName];
        });

        dispatch_sync(dispatch_get_main_queue(), ^{
            // 直到复制完成，再调用主线程，更新UI
            if (bSVideoPathString != nil){
                _sVideoPathString = nil;
                _sVideoPathString = [[NSString alloc]initWithString:bSVideoPathString];
                AVAsset* asset = nil;
                NSURL* url = [NSURL fileURLWithPath:bSVideoPathString];
                asset = [AVAsset assetWithURL:url];
                if (asset==nil) {
                    return;
                }
                //获得视频的秒,并且按照每秒占三十个像素的宽度去设置拾取器
                [self insertScrubberWithVideoDuration:CMTimeGetSeconds(asset.duration)];

                [self extractFramesWithVideoPath:bSVideoPathString];

                __block YXM_VideoEditerViewController *ref = self;
                NSArray *keys = [NSArray arrayWithObjects:@"tracks", @"duration", nil];
                [asset loadValuesAsynchronouslyForKeys:keys completionHandler:^(void) {


                    [ref.jsVideoScrubber setupControlWithAVAsset:asset];
                    [self initAVAssetImageGenerator:asset];

                    DLog(@"视频帧拾取器加载完毕");
                }];
            } else {
                NSLog(@"Image isn't downloaded. Nothing to display.");
            }
        });
    });
}

-(void)initAVAssetImageGenerator:(AVAsset *)asset{
    _myImageGenerator = [[AVAssetImageGenerator alloc]initWithAsset:asset];
    _myImageGenerator.requestedTimeToleranceBefore = kCMTimeZero;
    _myImageGenerator.requestedTimeToleranceAfter = kCMTimeZero;
    _myImageGenerator.appliesPreferredTrackTransform = YES;
    [_myImageGenerator generateCGImagesAsynchronouslyForTimes:[NSArray arrayWithObject:[NSValue valueWithCMTime:CMTimeMakeWithSeconds(1, 60)]] completionHandler:
     ^(CMTime requestedTime, CGImageRef image, CMTime actualTime, AVAssetImageGeneratorResult result, NSError *error)
     {

         NSLog(@"actual got image at time:%f", CMTimeGetSeconds(actualTime));
         if (image)
         {
             [CATransaction begin];
             [CATransaction setDisableActions:YES];
             UIImage *myImage = [UIImage imageWithCGImage:image];
             [_frameContainerScrollView setContentSize:myImage.size];
             [_frameImageView setFrame:CGRectMake(0, 0, myImage.size.width, myImage.size.height)];
             [_frameImageView setImage:myImage];
             [self updateOffsetLabel:nil];
             [CATransaction commit];
         }
     }];
}

/**
 *  获得视频的秒,并且按照每秒占三十个像素的宽度去设置拾取器
 *
 *  @param videoSeconds 视频的秒
 */
-(void)insertScrubberWithVideoDuration:(float)videoSeconds{
    //拾取器的高度
    NSInteger iScrubberHeight = 50;
    //标尺时间指示器的高度
    NSInteger iHSCbuttonHeight = 30;
    //标尺时间指示器的宽度
    NSInteger iHSCbuttonWeight = 80;
    //标尺控件的高度
    NSInteger iScaleplateHeight = 30;

    //拾取器的宽度
    int videoScrubberWidth = videoSeconds * SECOND_WIDTH;
    DLog(@"videoScrubberWidth = %d",videoScrubberWidth);
    CGRect rectScrubberContainer = CGRectMake(0, self.view.frame.size.height - (iScrubberHeight+iHSCbuttonHeight+iScaleplateHeight), videoScrubberWidth + iHSCbuttonWeight, (iScrubberHeight+iHSCbuttonHeight+iScaleplateHeight));
    UIView *scrubberContainerView = [[UIView alloc]initWithFrame:rectScrubberContainer];
    [scrubberContainerView setTag:TAG_SCRUBBER_CONTAINER];
    [scrubberContainerView setBackgroundColor:[UIColor blackColor]];
    //创建视频画面拾取器
    CGRect rectJS = CGRectMake( iHSCbuttonWeight/2.0 , iScaleplateHeight, videoScrubberWidth , iScrubberHeight );
    self.jsVideoScrubber = [[JSVideoScrubber alloc]initWithFrame:rectJS];
    [scrubberContainerView addSubview:self.jsVideoScrubber];
    [self.jsVideoScrubber release];

    //创建标尺控件
    CGRect rectScaleplate = CGRectMake( rectJS.origin.x , 0 , rectJS.size.width , 30 );
    [self insertScaleplate:videoSeconds andFrame:rectScaleplate andSuperView:scrubberContainerView];
    [self.view addSubview:scrubberContainerView];
    [scrubberContainerView release];

    //创建左右移动拾取器的控件
    HSCButton *rightButton = [[HSCButton alloc]initWithFrame:CGRectMake(0, (iScrubberHeight+iHSCbuttonHeight), iHSCbuttonWeight, iHSCbuttonHeight)];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"pointerButton"] forState:UIControlStateNormal];
    rightButton.dragEnable = YES;
    rightButton.delegate = self;
    [scrubberContainerView addSubview:rightButton];
    [rightButton release];

    //时间线
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(rectJS.origin.x, 0, 2, (iScrubberHeight+iHSCbuttonHeight)+4)];
    [lineView setBackgroundColor:[UIColor colorWithRed:0.098 green:0.576 blue:0.820 alpha:1.000]];
    [lineView setTag:TAG_LINE_VIEW];
    [scrubberContainerView addSubview:lineView];

    //控制拾取器是否显示
    UIButton *ctrlScrubberButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [ctrlScrubberButton setFrame:CGRectMake(0, self.view.frame.size.height-(30+iScrubberHeight+iHSCbuttonHeight), iHSCbuttonWeight/2, 30+iScrubberHeight)];
    [ctrlScrubberButton setBackgroundColor:[UIColor colorWithRed:0.366 green:1.000 blue:0.404 alpha:1.000]];
    [ctrlScrubberButton setTitle:[Config DPLocalizedString:@"adedit_hide"] forState:UIControlStateNormal];
    [ctrlScrubberButton.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
    [ctrlScrubberButton.titleLabel setTextColor:[UIColor brownColor]];
    [ctrlScrubberButton addTarget:self action:@selector(hiddenScrubberButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:ctrlScrubberButton];
}

/**
 *  插入标尺
 */
-(void)insertScaleplate:(float)videoSeconds andFrame:(CGRect)frame andSuperView:(UIView *)superView{
    //标尺背景
    UIView *scaleplateBackgroundView = [[UIView alloc]initWithFrame:frame];
    [scaleplateBackgroundView setBackgroundColor:[UIColor blackColor]];
    for (int i=0; i<videoSeconds; i++) {
        if (i%5==0) {
            int min = i / 60;
            int seconds = i % 60;
            NSInteger iTimeLabelX = i*30 + 2;
            if (i+1>videoSeconds) {
                iTimeLabelX = iTimeLabelX - 31;
            }
            UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(iTimeLabelX, 0, 30, 10)];
            [timeLabel setFont:[UIFont systemFontOfSize:10]];
            [timeLabel setBackgroundColor:[UIColor clearColor]];
            [timeLabel setTextColor:[UIColor whiteColor]];
            if (seconds%5!=0) {
                seconds -= 1;
            }
            timeLabel.text = [NSString stringWithFormat:@"%02d:%02d", min, seconds];
            UIView *oneView = [[UIView alloc]initWithFrame:CGRectMake(i*30, 0, 1.5, 30)];
            [oneView setBackgroundColor:[UIColor whiteColor]];
            [scaleplateBackgroundView addSubview:oneView];
            [scaleplateBackgroundView addSubview:timeLabel];
        }else{
            UIView *oneView = [[UIView alloc]initWithFrame:CGRectMake(i*30, 10, 1, 20)];
            [oneView setBackgroundColor:[UIColor whiteColor]];
            [scaleplateBackgroundView addSubview:oneView];
        }
    }

    //往左的手势
    UISwipeGestureRecognizer *mySwipeLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(mySwipeLeftScrubber:)];
    [mySwipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [scaleplateBackgroundView addGestureRecognizer:mySwipeLeft];

    //往右的手势
    UISwipeGestureRecognizer *mySwipeRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(mySwipeRightScrubber:)];
    [mySwipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [scaleplateBackgroundView addGestureRecognizer:mySwipeRight];

    [superView addSubview:scaleplateBackgroundView];
    [scaleplateBackgroundView release];
}

-(void)mySwipeLeftScrubber:(UISwipeGestureRecognizer *)gesture{
    UIView *scaleplateBackgroundView = [self.view viewWithTag:TAG_SCRUBBER_CONTAINER];
    [UIView animateWithDuration:0.3 animations:^{
        [scaleplateBackgroundView setFrame:CGRectMake(scaleplateBackgroundView.frame.origin.x - 400, scaleplateBackgroundView.frame.origin.y, scaleplateBackgroundView.frame.size.width, scaleplateBackgroundView.frame.size.height)];
    } completion:^(BOOL finished) {
//        [self moveEnd];
    }];
}

-(void)mySwipeRightScrubber:(UISwipeGestureRecognizer *)gesture{
    UIView *scaleplateBackgroundView = [self.view viewWithTag:TAG_SCRUBBER_CONTAINER];
    [UIView animateWithDuration:0.3 animations:^{
        [scaleplateBackgroundView setFrame:CGRectMake(scaleplateBackgroundView.frame.origin.x + 400, scaleplateBackgroundView.frame.origin.y, scaleplateBackgroundView.frame.size.width, scaleplateBackgroundView.frame.size.height)];
    } completion:^(BOOL finished) {
//        [self moveEnd];
    }];
}

/**
 *  滑动中移动帧选择器相应偏移量
 *
 *  @param offsetx 偏移量
 */
-(void)xValueChange:(float)offsetx andSender:(id)sender{
//    UIView *scaleplateBackgroundView = [self.view viewWithTag:TAG_SCRUBBER_CONTAINER];
    HSCButton *myHSCButton = (HSCButton*)sender;

    UIView *myLineView = [self.view viewWithTag:TAG_LINE_VIEW];
    [myLineView setFrame:CGRectMake(myHSCButton.frame.origin.x + myHSCButton.frame.size.width/2.0, myLineView.frame.origin.y, myLineView.frame.size.width, myLineView.frame.size.height)];
    NSInteger iLineX = myLineView.frame.origin.x;
    float fLineX = iLineX*1.0f - myHSCButton.frame.size.width/2.0f;
    float fSecond = fLineX/30.0f;
    if (fSecond>0) {
        DLog(@"myLineView.frame.origin.x = %lf",myLineView.frame.origin.x);

        DLog(@"fSecond = %lf",fSecond);

        [self showImageAndRecordDrawWithTime:fSecond];
    }
}

/**
 *  滑块按钮的停止的回调，如果超出范围则取最小和最大值
 */
-(void)moveEnd:(id)sender{

    HSCButton *myHSCButton = (HSCButton*)sender;
    UIView *myLineView = [self.view viewWithTag:TAG_LINE_VIEW];

    DLog(@"%lf",myHSCButton.frame.origin.x);
    if (myHSCButton.frame.origin.x < 0) {
        [myHSCButton setFrame:CGRectMake(0, myHSCButton.frame.origin.y, myHSCButton.frame.size.width, myHSCButton.frame.size.height)];
        [myLineView setFrame:CGRectMake(myHSCButton.frame.size.width/2, myLineView.frame.origin.y, myLineView.frame.size.width, myLineView.frame.size.height)];
    }else{
        [myLineView setFrame:CGRectMake(myHSCButton.frame.origin.x + myHSCButton.frame.size.width/2.0, myLineView.frame.origin.y, myLineView.frame.size.width, myLineView.frame.size.height)];
    }
}

/**
 *  计算真实视频的画面与屏幕上显示的画面的比例
 *
 *  @return 浮点型比例值
 */
-(struct VideoScale)videoShowScale{
    struct VideoScale vs;
    vs.ws = _originViedoWidth / _frameImageView.frame.size.width;
    vs.hs = _originViedoHeight / _frameImageView.frame.size.height;
    return vs;
}
/**
 *  初始化预览画面刷
 *
 *  @param asset 对应的视频Asset对象
 */
-(void)initVideoScrubberAndExtractFrames:(ALAsset *)myasset{
    if (myasset==nil) {
        return;
    }
    [globalDictFramesInfo removeAllObjects];
    globalDuration = 0;
    globalsVideoPath = nil;


    //设置屏幕常亮
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];

    //内部生成的名称
    int randomNumber = (arc4random() % 100000) + 1;
    NSString *sRandom = [[NSString alloc]initWithFormat:@"%d,%@",randomNumber,[MyTool getCurrentDateString]];
    DLog(@"开始加载视频");
    [self setupBaseKVNProgressUI];
    [KVNProgress showWithStatus:[Config DPLocalizedString:@"MJRefreshFooterRefreshing"]];
    [self backgroundCopyFile:myasset andRandomName:sRandom];
}



/**
 *  将相册内的资源写入到沙盒中
 *
 *  @param videoAsset 传入系统的资源对象
 *  @return 素材在沙盒中的路径
 */
-(NSString *)handleWrittenFileWithSourceAsset:(ALAsset*)sourceAsset AndMatrialName:(NSString *)sRandom
{
    DLog(@"%@",sRandom);
    NSString *pathString = nil;
    ALAssetRepresentation *rep = [sourceAsset defaultRepresentation];
    //素材存储的文件夹的路径
    NSString *documentsDirectory = [MaterialObject createMatrialRootPath];
    //素材的原始路径
    NSString *originalPath = [[NSString alloc]initWithFormat:@"%@",[sourceAsset valueForProperty:ALAssetPropertyAssetURL]];

    NSArray *pathSeparatedArray = [originalPath componentsSeparatedByString:@"&ext="];
    NSString *sExtString = nil;
    if ([pathSeparatedArray count]==2) {
        sExtString = [pathSeparatedArray objectAtIndex:1];
    }



    @try {
        if ([[sourceAsset valueForProperty:ALAssetPropertyType] isEqualToString:@"ALAssetTypeVideo"]) {
            if (sExtString==nil) {
                sExtString = @"mov";
            }
            NSString *myFilePath = [NSString stringWithFormat:@"%@/%@.%@",documentsDirectory,[sRandom md5Encrypt],sExtString];

            pathString = [[NSString alloc]initWithString:myFilePath];

            NSUInteger size = [rep size];
            const int bufferSize = 65636;

            FILE *f = fopen([myFilePath cStringUsingEncoding:1], "wb+");
            if (f==NULL) {
                return nil;
            }
            Byte *buffer =(Byte*)malloc(bufferSize);
            int read =0, offset = 0;
            NSError *error;
            if (size != 0) {
                do {
                    read = [rep getBytes:buffer
                              fromOffset:offset
                                  length:bufferSize
                                   error:&error];
                    fwrite(buffer, sizeof(char), read, f);
                    offset += read;
                } while (read != 0);
            }
            fclose(f);
        }

        if ([[sourceAsset valueForProperty:ALAssetPropertyType] isEqualToString:@"ALAssetTypePhoto"]) {
            //保存图片
            UIImage *resolutionImage = [UIImage imageWithCGImage:[rep fullResolutionImage]];

            NSData *imageDataObj = UIImagePNGRepresentation(resolutionImage);
            NSString *myFilePath = [documentsDirectory
                                    stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",[sRandom md5Encrypt]]];
            pathString = [[NSString alloc]initWithString:myFilePath];
            [imageDataObj writeToFile:myFilePath atomically:YES];
        }
    }
    @catch (NSException *exception) {
        DLog(@"存储视频异常 = %@",exception);
    }
    @finally {
        
    }
    return pathString;
}

#pragma mark -
#pragma mark 视频画面播放区域截取器

-(void)createCamrea:(BOOL)isMove{
    DLog(@"创建截屏区域");
    UIView *tempView = [self.view viewWithTag:TAG_CAMREA_VIEW];
    if (tempView) {
        [tempView removeFromSuperview];
    }

    UIView *myView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _viewfinderWidth, _viewfinderHeight)];
    UILabel *viewfinderSizeLabel = (UILabel*)[self.navigationController.view viewWithTag:TAG_VIEWFINDER_LABEL];
    [viewfinderSizeLabel setText:[[NSString alloc] initWithFormat:@"[0,0],[%0.0lf,%0.0lf]",_viewfinderWidth, _viewfinderHeight]];
    [myView setTag:TAG_CAMREA_VIEW];

    [_frameImageView addSubview:myView];
    [myView release];

    myView.layer.borderWidth = 1.0f;
    myView.layer.borderColor = [[UIColor redColor] CGColor];

    if (isMove) {
        //显示区域对象数组
        NSArray *views = @[myView];
        [self setEvaluateViews:views];


        //单击手势
        UITapGestureRecognizer *myTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapRecognizer:)];
        myTapGestureRecognizer.numberOfTouchesRequired = 1; //手指数
        myTapGestureRecognizer.numberOfTapsRequired = 1; //tap次数
        [myView addGestureRecognizer:myTapGestureRecognizer];
        [myTapGestureRecognizer release];
        //拖动手势
        UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanRecognizer:)];
        [myView addGestureRecognizer:panRecognizer];
        [panRecognizer release];
    }



    [self createSlider];
}


/**
 *  移动手势
 *
 *  @param sender
 */
- (void)handlePanRecognizer:(id)sender
{

    UIPanGestureRecognizer *recongizer = (UIPanGestureRecognizer *)sender;

    if ([recongizer state] == UIGestureRecognizerStateBegan)
    {
        DLog(@"UIGestureRecognizerStateBegan");
    }

    NSArray *views = [self evaluateViews];
    //    __block UILabel *label = [self completionLabel];


    static void (^overlappingBlock)(UIView *overlappingView);
    overlappingBlock = ^(UIView *overlappingView) {

        [views enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {

            UIView *aView = (UIView *)obj;

            // Style an overlapping view
            if (aView == overlappingView)
            {
                aView.layer.borderWidth = 2.0f;
                aView.layer.borderColor = [UIColor yellowColor].CGColor;
            }
            // Remove styling on non-overlapping views
            else
            {
                aView.layer.borderWidth = 2.0f;

            }


        }];
    };

    // Block to execute when gesture ends.
    static void (^completionBlock)(UIView *overlappingView);
    completionBlock = ^(UIView *overlappingView) {

        if (overlappingView)
        {

        }

        // Remove styling from all views
        [views enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            UIView *aView = (UIView *)obj;
            aView.layer.borderWidth = 1.0f;
            aView.layer.borderColor = [UIColor redColor].CGColor;
            UILabel *viewfinderSizeLabel = (UILabel*)[self.navigationController.view viewWithTag:TAG_VIEWFINDER_LABEL];

            [viewfinderSizeLabel setText:[[NSString alloc] initWithFormat:@"坐标[%0.0lf,%0.0lf]宽高[%0.0lf,%0.0lf]",aView.frame.origin.x,aView.frame.origin.y,_viewfinderWidth, _viewfinderHeight]];
        }];
        DLog(@"移动2");

        [self showImageAndRecordDrawWithTime:fVideoTime];
    };

    [recongizer dragViewWithinView:_frameImageView
           evaluateViewsForOverlap:views
   containedByOverlappingViewBlock:overlappingBlock
                        completion:completionBlock];
}


-(void)handleTapRecognizer:(id*)sender{
    @try {
        //如果是播放态则取消手势下的动作执行
        UITapGestureRecognizer *recongizer = (UITapGestureRecognizer *)sender;
        if (recongizer.numberOfTapsRequired == 1) {
            //单指单击
            //        DLog(@"单指单击");
            DLog(@"当前选择区域的view.tag = %d",(int)recongizer.view.tag);


            //选中一块屏幕
            [self selectOneScreenAreaWith:(int)recongizer.view.tag];

        }
    }
    @catch (NSException *exception) {
        DLog(@"%@",exception);
    }
    @finally {
        
    }
}


/**
 *  按照索引去选中一块屏幕，并且将屏幕的边框线设置为红色
 *
 *  @param selectIndex 屏幕的索引1001、1002、1003、1004
 */
-(void)selectOneScreenAreaWith:(NSInteger)selectIndex{
    UIView *currentSelectView = [[self evaluateViews] firstObject];
    currentSelectView.layer.borderColor = [[UIColor yellowColor] CGColor];
    [UIView animateWithDuration:0.3 animations:^{
        currentSelectView.layer.borderColor = [[UIColor redColor] CGColor];
    } completion:^(BOOL finished) {

    }];

}

#pragma mark -
#pragma mark KVNProgress

- (void)setupBaseKVNProgressUI
{
    // See the documentation of all appearance propoerties
    [KVNProgress appearance].statusColor = [UIColor darkGrayColor];
    [KVNProgress appearance].statusFont = [UIFont systemFontOfSize:17.0f];
    [KVNProgress appearance].circleStrokeForegroundColor = [UIColor darkGrayColor];
    [KVNProgress appearance].circleStrokeBackgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.3f];
    [KVNProgress appearance].circleFillBackgroundColor = [UIColor clearColor];
    [KVNProgress appearance].backgroundFillColor = [UIColor colorWithWhite:0.9f alpha:0.9f];
    [KVNProgress appearance].backgroundTintColor = [UIColor whiteColor];
    [KVNProgress appearance].successColor = [UIColor darkGrayColor];
    [KVNProgress appearance].errorColor = [UIColor darkGrayColor];
    [KVNProgress appearance].circleSize = 75.0f;
    [KVNProgress appearance].lineWidth = 2.0f;
}


#pragma mark -
#pragma mark 缩放的比例控制器
-(void)createSlider{
    UISlider *tempView = (UISlider*)[self.view viewWithTag:TAG_SCALE_CHANGE_SLIDER];
    if (tempView) {
        [tempView removeFromSuperview];
    }
    UISlider *myScaleSlider = [[UISlider alloc]initWithFrame:CGRectMake(self.view.frame.size.width-240, self.view.frame.size.height/2-50, 200, 20)];
    [myScaleSlider setTag:TAG_SCALE_CHANGE_SLIDER];
    myScaleSlider.transform = CGAffineTransformMakeRotation(-M_PI/2);
    [myScaleSlider addTarget:self action:@selector(scaleSliderValueChange:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:myScaleSlider];
}
-(void)scaleSliderValueChange:(UISlider *)mySlider{
    DLog(@"mySlider.value = %lf",mySlider.value);
    _videoShowScale = 1-mySlider.value;
    CGSize imageSize = _frameContainerScrollView.contentSize;
    [_frameImageView setFrame:CGRectMake(0, 0, imageSize.width*_videoShowScale, imageSize.height*_videoShowScale)];
    if (_myVideoPlayer) {
        if ([_myVideoPlayer status] == AVPlayerStatusReadyToPlay) {
            DLog(@"改变视频画面");
            [_playerLayer setFrame:CGRectMake(0, 0, imageSize.width*_videoShowScale, imageSize.height*_videoShowScale)];
        }
    }

}


#pragma mark - 
#pragma mark -显示或隐藏帧拾取器
-(void)hiddenScrubberButtonEvent:(UIButton *)sender{
    UIView *scrubberView = [self.view viewWithTag:TAG_SCRUBBER_CONTAINER];
    if (scrubberView.frame.origin.y>self.view.frame.size.height) {
        //显示
        [UIView animateWithDuration:0.6 animations:^{
            [scrubberView setFrame:CGRectMake(scrubberView.frame.origin.x, scrubberView.frame.origin.y - scrubberView.frame.size.height -10 , scrubberView.frame.size.width,  scrubberView.frame.size.height)];
        } completion:^(BOOL finished){
            [sender setTitle:[Config DPLocalizedString:@"adedit_hide"] forState:UIControlStateNormal];
        }];
    }else  {
        //隐藏
        [UIView animateWithDuration:0.6 animations:^{
            [scrubberView setFrame:CGRectMake(scrubberView.frame.origin.x, scrubberView.frame.origin.y + scrubberView.frame.size.height +10 , scrubberView.frame.size.width,  scrubberView.frame.size.height)];
        } completion:^(BOOL finished) {
            [sender setTitle:[Config DPLocalizedString:@"adedit_show"] forState:UIControlStateNormal];
        }];
    }
}
@end
