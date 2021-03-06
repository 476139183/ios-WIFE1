//
//  LayoutYXMViewController.h
//  PlayerEdit
//
//  Created by yixingman on 14-6-4.
//  Copyright (c) 2014年 yixingman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTMasterViewController.h"
#import "MyPlayListViewController.h"
#import "MyProjectListViewController.h"
#import "JHTickerView.h"
#import "AsyncSocket.h"
#import "ASINetworkQueue.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "BaseButton.h"
#import "TableViewWithBlock.h"
#import "SelectionCell.h"
#import "FreeGifMaker.h"
#import "RMSwipeTableViewCelliOS7UIDemoTableViewCell.h"
#import "MusicPickerTableViewController.h"
#import "MRProgressOverlayView.h"
#import "YXM_FTPManager.h"


@interface LayoutYXMViewController : UIViewController<UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIPopoverControllerDelegate,SelectPhotoDelegate,UITextFieldDelegate,PlayListSelectDelegate,MyProjectListSelectDelegate,AsyncSocketDelegate,UIAlertViewDelegate,MyMusicListSelectDelegate,UploadResultDelegate>
{
    
    
    // 当前相册的路径
    
    NSString  *myphothpath;
    
    BOOL viewdown;//判断屏幕是否在下面
    
    //总素材列表,也就是带使用的元器件的列表
    CTMasterViewController *myMasterCtrl;
    //区域内播放素材列表
    MyPlayListViewController *myPlayListCtrl;
    //项目列表
    MyProjectListViewController *myProjectCtrl;
    
    //当前选择区域的索引
    NSInteger _currentSelectIndex;
    //已经添加到项目的素材列表中被选择的索引
    NSInteger _currentSelectRow;
    //项目素材字典,按照区域编号去索引区域内的素材列表
    NSMutableDictionary *_projectMaterialDictionary;

    
    //项目数组
    NSMutableArray *_projectArray;

    //播放的索引
    NSInteger _myPlayIndex;
    
    //定时器回收器
    NSMutableArray *timerKillerArray;
    
    //当前是否处于播放状态
    BOOL isPlay;
    
    //当前调整颜色的对象编号
    NSInteger _currentChangeColorViewTag;
    
    //当前选中的项目的索引
    NSIndexPath *_currentPlayProjIndex;
    
    //当前播放项目的文件名字
    NSString *_currentPlayProjectFilename;
    //当前播放项目名字
    NSString *_currentPlayProjectName;
    
    //soket连接
    AsyncSocket *_sendPlayerSocket;
    //是否连接中
    BOOL isConnect;
    
    //当前数据区域的索引
    NSInteger _currentDataAreaIndex;
    //当前数据仓库
    NSMutableArray *_currentDataArray;
    //发送配置文件的总次数
    int totalPage;
    
    //发送给服务端的xml配置文件
    NSString *xmlfilePath;
    //文件的大小
    NSInteger fileSize;
    
    //当前发送为配置文件
    BOOL isSendConfig;
    //当前发送为数据文件
    BOOL isSendContent;
    //全部发送完成
    BOOL isAllSend;
    //发送中
    BOOL isSendState;
    //是否完成了数据的上传
    BOOL isComplete;
    
    //发布进度
    UIProgressView *myProgressView;
    
    
    //上传百分比
    UILabel *progressLabel;
    
    //默认图片的数组
    NSMutableArray *defaultImageArray;
    
    //分解图片资源为数据包,读取出错记录
    NSMutableArray *analyzeImageDataErrorPathArray;
    
    //重新连接网络
    BOOL isReconnect;
    
    //当前是否为多屏方案
    BOOL isMultiScreen;
    
    //视频播放区域
    MPMoviePlayerController *movewController;
    
    //图片循环是否是第一次加载
    BOOL isFirstRun;
    
    //是否处于编辑状态
    BOOL isEditProject;
    
    //是否已经加载了
    BOOL isAlreadyLoad;
    
    //素材加载中
    BOOL isLoading;
    
    //需要控制是否显示的控制视图集合
    NSMutableArray *myEditerCtrlViewArray;
    
    //需要高亮的控制按钮集合
    NSMutableArray *myCtrlButtonArray;
    
    //需要控制是否显示的控制视图集合
    NSMutableArray *mySceneViewArray;
    
    //需要高亮的控制按钮集合
    NSMutableArray *mySceneButtonArray;
    
    //字体的数组
    NSArray *fontSizeArray;
    
    /*设置大小*/
    BOOL sizeIsOpend;//判断下拉tableView是否打开
    UIImageView *sizeImageView;
    UITextField *sizeTextField;
    BaseButton *sizeButton;
    TableViewWithBlock *sizeTableBlock;
    UILabel *sizeLabel;
    NSArray *sizeArray;
    
    /*设置速度*/
    BOOL speedIsOpend;//判断下拉tableView是否打开
    UITextField *speedTextField;
    BaseButton *speedButton;
    TableViewWithBlock *speedTableBlock;
    UILabel *speedLabel;
    NSArray *speedArray;
    
    /*设置字体*/
    BOOL fontIsOpend;//判断下拉tableView是否打开
    UITextField *fontTextField;
    BaseButton *fontButton;
    TableViewWithBlock *fontTableBlock;
    UILabel *fontLabel;
    NSArray *fontArray;
    
    /*设置动画方向*/
    BOOL directionIsOpend;//判断下拉tableView是否打开
    UITextField *directionTextField;
    BaseButton *directionButton;
    TableViewWithBlock *directionTableBlock;
    UILabel *directionLabel;
    NSArray *directionArray;

    /*设置动画方向*/
    BOOL alphaIsOpend;//判断下拉tableView是否打开
    UITextField *alphaTextField;
    BaseButton *alphaButton;
    TableViewWithBlock *alphaTableBlock;
    UILabel *alphaLabel;
    NSArray *alphaArray;
    NSInteger ialpha;
    
    
    //动画自增长序号
    NSInteger animationIndex;
    
    //当前编辑的场景是前景还是后景
    NSString *_currentScenes;
    //前景运动的方向
    NSString *imageScrollDirection;
    //运动方向的数字
    NSInteger iDriection;
    
    //更多设置按钮传递过来的参数
    NSDictionary *myMoreDict;
    //更多按钮的索引
    NSIndexPath *myMoreIndexPath;
    //带左滑动显示更多按钮的cell
    RMSwipeTableViewCelliOS7UIDemoTableViewCell *myMoreCell;
    
    NSTimer *myPublishCompleteTimer;
    //存储用户选择的项目对象
    NSMutableArray *mySelectedProjectArray;
    //当前播放的项目对象
    ProjectListObject *currentPlayProObject;
    //是否是连续播放
    BOOL isContinusPlay;
    
    //是否点击了旋转
    BOOL isRotation;
    //旋转的角度
    int fangle;
    
    //打印时间的起始时间
    NSDate *tmpStartData;
    
    //音乐拾取器
    MusicPickerTableViewController *myMusicPicker;
    //音乐的名称
    UILabel *musicNameLabel;
    //音乐的播放时间
    UILabel *musicPlaytimeLabel;
    //音乐的路径
    NSString *_musicFilePath;
    //音乐的名称
    NSString *_musicName;
    //音乐的音量
    NSString *_musicVolume;
    //音乐的时间
    NSString *_musicDuration;
    //所有画面的总时间
    float myPhotoTotalDuration;
    //音乐播放的总时间
    float myMusicTotalPlayTime;
    
    //设置一个清理定时器的定时器，用于项目播放完毕的时候停止画面
    NSTimer *stopPhotoTimer;
    
    //临时存储项目名称
    NSString *myProjectTextString;
    
    //当前项目所在路径
    NSString *_currentProjectPathRoot;

    //浮动的进度条
    MRProgressOverlayView *myMRProgressView;

    //当前项目所需要发送到服务端的文件列表
    NSMutableArray *_waitForUploadFilesArray;

    //ftp管理对象
    YXM_FTPManager *_ftpMgr;

    //当前文件发送的索引
    NSInteger _fileSendIndex;

    //上传的文件的长度
    long long _sendFileCountSize;

    //上传的文件的总长度
    long long _uploadFileTotalSize;

    //视频播放器
    AVPlayer *_myVideoPlayer;
    AVPlayerLayer *_myVideoPlayerLayer;


    //视频播放的父视图的x和y
    NSInteger iParentX;
    NSInteger iParentY;
    NSInteger iParentCenterX;
    NSInteger iParentCenterY;

    NSString *mianipscrenn;

    
    //平板  保存图片
    
    NSString *nametime;
    NSString *stringpath;
    
      ALAsset *photoasset;
    
}
@property (nonatomic, assign) NSInteger red1;
@property (nonatomic, assign) NSInteger green1;
@property (nonatomic, assign) NSInteger blue1;
@property (nonatomic, assign) NSInteger alpha1;
@property (nonatomic, assign) NSInteger red2;
@property (nonatomic, assign) NSInteger green2;
@property (nonatomic, assign) NSInteger blue2;
@property (nonatomic, assign) NSInteger alpha2;
@property (nonatomic, assign) NSInteger height1;
@property (nonatomic, assign) NSInteger width1;
@property (nonatomic, assign) NSInteger height2;
@property (nonatomic, assign) NSInteger width2;

//注册账号
@property (nonatomic,strong)  NSString  *registeredUserNameString;

//注册密码
@property (nonatomic,strong)  NSString  *registeredPassWordString;

//注册再次密码
@property (nonatomic,strong)  NSString  *registeredNextPassWordString;

//验证码
@property (nonatomic,strong)  NSString  *messageTextString;

//登陆账号
@property (nonatomic,strong)  NSString  *loginUserNameString;

//登陆密码
@property (nonatomic,strong)  NSString  *loginPassWordString;

@property (nonatomic,strong) NSString *loginMessageString;

-(void)resetBrightness;
-(void)ftpuser1;


/**
 *  返回按钮，需要在返回的时候清理定时器资源
 *
 *  @param sender
 */
-(void)closeEditerButtonClick:(UIButton*)sender;

/**
 *  调节音量
 */
@property (retain, nonatomic) ASValueTrackingSlider *myVolumeTrackingSlider;


//创建视图,在什么位置创建,创建的视图的标记
-(void)createViewFactory:(CGRect)viewFrame viewTag:(NSInteger)tag;



/**
 *  @brief  获得指定目录下，指定后缀名的文件列表
 *
 *  @param  type    文件后缀名
 *  @param  dirPath 指定目录
 *
 *  @return 文件名列表
 */
+(NSArray *)getFilenamelistOfType:(NSString *)type fromDirPath:(NSString *)dirPath AndIsGroupDir:(BOOL)isGroupDir;

/**
 *  创建需要传送给服务端的分组文件
 */
-(void)createGroupXMLFileWithDictionary:(NSDictionary*)myDict andSavePath:(NSString *)savePath andEdit:(BOOL)isEditXML;


/**
 *  获取或者创建分组xml文件所在的路径
 *
 *  @return 分组xml文件所在的路径
 */
-(NSString*)documentGroupXMLDir;

/**
 *  调节音量的滑块的事件
 *
 *  @param mySlider 滑块对象
 */
-(void)changeVolumeEvent:(ASValueTrackingSlider *)mySlider;


/**
 *  播放间隔时间设置到cell
 */
-(void)setTimeToCell;

/**
 *@brief 验证场景或图层的编号
 */
-(void)validateCurrentScene;

/**
 *@brief 默认项目存放的路径
 */
+(NSString *)defaultProjectRootPath;

/**
 *@brief 项目存放文件夹的路径
 */
-(NSString *)customeProjectDirPathWith:(NSString *)dirName;

/**
 *@brief 移动素材到项目目录下
 */
-(void)moveMaterialToProjectDirWithFileName:(NSString *)sMaterialFileName AndProjectDirPath:(NSString *)sProjectDirPath;


/**
 * 保存播放项目
 *
 */
-(BOOL)saveProjectWithProjectName:(NSString *)psProjectName andProjectXMLFilePath:(NSString *)psProjectXMLFilePath;
-(void)qxzp:(NSMutableArray*)arr;
-(void)UploadBrightness;
-(void)backg;
-(void)ftpuser;
-(void)showOneEditerCtrlViewWithTag:(NSInteger)viewTag;
-(void)highlightButtonWithTag:(NSInteger)buttonTag;

-(void)tongBu_buttonOnClick:(NSString *)mianip andarr:(NSMutableArray *)arr;
//获取指定文件的大小的方法
+(long long)fileSizeAtPath:(NSString*)filePath;
@end
