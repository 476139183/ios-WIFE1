//
//  DYT_rightbaseview.m
//  LEDAD
//
//  Created by laidiya on 15/7/20.
//  Copyright (c) 2015年 yxm. All rights reserved.
//

#import "DYT_rightbaseview.h"
#import "MyButton.h"
#import "LayoutYXMViewController.h"
#import "Config.h"
#import "DYT_AsyModel.h"
//#import "CX_iPhoneWifiViewController.h"
//#import "DYT_HomepageViewController.h"
@implementation DYT_rightbaseview
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 8;

        self.backgroundColor = [UIColor clearColor];
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        image.image = [UIImage imageNamed:@"rightk"];
        [self addSubview:image];

        [self initview];
    }
    return self;

}
-(void)initview
{
    NSInteger hei = self.frame.size.width/3;

    
// NSArray *titlerightarray = [[NSArray alloc]initWithObjects:@"硬件检测",@"云屏背景", @"重启云屏",@"激活云屏",@"修改名称",@"测试红绿蓝白",nil];
    
    NSArray *titlenamearray = [[NSArray alloc]initWithObjects:@"多联屏控制", @"激活云屏",@"查看云屏方案",@"设置背景图片",@"调节红绿蓝白",@"设置new",nil];
    
    
    for (int i=0; i<titlenamearray.count; i++) {
        
        MyButton *rightbutton = [[MyButton alloc]initWithFrame:CGRectMake(hei*(i%3), 10+60*(i/3), 50, 44)];
        
        [rightbutton setTitle:titlenamearray[i] forState:UIControlStateNormal];
        
        [rightbutton setBackgroundImage:[UIImage imageNamed:titlenamearray[i]] forState:UIControlStateNormal];
        [rightbutton addTarget:self action:@selector(rightbutton:) forControlEvents:UIControlEventTouchUpInside];
        rightbutton.center = CGPointMake(rightbutton.frame.origin.x+hei/2, rightbutton.center.y);

        
//        [rightbutton setBackgroundImage:[UIImage imageNamed:@"tkbtn"] forState:UIControlStateNormal];
        rightbutton.tag = 2000+i;
        [self addSubview:rightbutton];
    }

    
}
-(void)rightbutton:(UIButton *)sender
{
    
    
    //   多连屏控制  或者 查看云屏方案
        if (sender.tag==2000 || sender.tag == 2002) {
            NSString *documentsDirectory= [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/"];
            NSArray *filenameArray = [LayoutYXMViewController getFilenamelistOfType:@"xml"
                                                                        fromDirPath:documentsDirectory AndIsGroupDir:YES];
            DLog(@"%@",filenameArray);
            if (filenameArray.count == 0) {
                UIAlertView *alerview = [[UIAlertView alloc]initWithTitle:[Config DPLocalizedString:@"User_Prompt"] message:[Config DPLocalizedString:@"adedit_zc16"] delegate:nil cancelButtonTitle:[Config DPLocalizedString: @"NSStringYes"] otherButtonTitles: nil];
                [alerview show];
                return;
            }
        }

    // 激活云屏
    
    //设置背景图片
    
        if (sender.tag==2003) {
    
    
            UIAlertView *aletview = [[UIAlertView alloc]initWithTitle:[Config DPLocalizedString:@"adedit_ledbak"] message:[Config DPLocalizedString:@"adedit_ledkl"] delegate:self cancelButtonTitle:[Config DPLocalizedString:@"adedit_Done"] otherButtonTitles: nil];
            aletview.tag = 3003;
            aletview.alertViewStyle = UIAlertViewStylePlainTextInput;
            [aletview show];
            return;
        }

    // 调节红绿蓝白
    
    //设置
    
    
    
    _rightblock(sender.tag);
    
////硬件检测
//    if (sender.tag==2000) {
////        if (selectIpArr.count>1) {
////            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"不得多于一个屏" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
////            [alert show];
////            return;
////        }
//
//        [_delegate returerightview:sender.tag];
//        return;
//    }
//    
//    
//    //激活云屏
//    if(sender.tag == 2003){
//
//        [_delegate returerightview:sender.tag];
//        return;
//
//    }
//    
//    
//    //    设置选屏的
//    if (selectIpArr.count==0) {
//        [self showalertview:[Config DPLocalizedString:@"adedit_shoose"]];
//        back = NO;
//        return;
//    }
//    
//
//    
////    云屏背景
//
//    if (sender.tag==2001) {
//        
//        
//        UIAlertView *aletview = [[UIAlertView alloc]initWithTitle:[Config DPLocalizedString:@"adedit_ledbak"] message:[Config DPLocalizedString:@"adedit_ledkl"] delegate:self cancelButtonTitle:[Config DPLocalizedString:@"adedit_Done"] otherButtonTitles: nil];
//        aletview.tag = 7002;
//        aletview.alertViewStyle = UIAlertViewStylePlainTextInput;
//        [aletview show];
//        return;
//    }
//    
//    
//    
//    
//    
////    重启云屏
//    if (sender.tag==2002) {
//        //重启动
//        UIAlertView *myAlertView = [[UIAlertView alloc]initWithTitle:[Config DPLocalizedString:@"adedit_xcoludsprompt"] message:[Config DPLocalizedString:@"adedit_chongqi"] delegate:self cancelButtonTitle:[Config DPLocalizedString:@"adedit_promptyes"] otherButtonTitles:[Config DPLocalizedString:@"adedit_promptno"], nil];
//        [myAlertView setTag:TAG_ALTERVIEW_TAG_REST_SCREEN_AS_BUTTON];
//        myAlertView.delegate = self;
//        [myAlertView show];
//        
//
//        
//        
//    }
////    修改终端名称
//    if (sender.tag==2004) {
//        UIAlertView *myalert = [[UIAlertView alloc]initWithTitle:[Config DPLocalizedString:@"User_Prompt"] message:[Config DPLocalizedString:@"adedit_ledname"] delegate:self cancelButtonTitle:[Config DPLocalizedString:@"NSStringYes"] otherButtonTitles:[Config DPLocalizedString:@"NSStringNO"], nil];
//        myalert.tag = 7003;
//        myalert.alertViewStyle = UIAlertViewStylePlainTextInput;
//
//        [myalert show];
//        return;
//    }
//    
//    
//    
//    
//    [_delegate returerightview:sender.tag];
    
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    //    重启云屏
//    if (alertView.tag==TAG_ALTERVIEW_TAG_REST_SCREEN_AS_BUTTON) {
//        if (buttonIndex==0) {
//           
//            for (int i=0; i<selectIpArr.count; i++) {
//                
//                DYT_AsyModel *myasy = [[DYT_AsyModel alloc]init];
//                
//                [myasy RestartScreen:selectIpArr[i]];
//            }
//            
//        
//    }
//    }
//
//    修改云屏背景
    
    
    if (alertView.tag == 3003) {
        DLog(@"bu==%ld",(long)buttonIndex);
        if (buttonIndex==0) {
            
            UITextField *mytextfild = [alertView textFieldAtIndex:0];
            if([mytextfild.text isEqual:@"zdec"]){
                
                back=YES;
                _rightblock(2003);

                
//                [_delegate returerightview:2001];
                
                
                
                
//                myMasterCtrl = [[CTMasterViewController alloc]init];
//                myMasterCtrl.view.backgroundColor = [UIColor cyanColor];
//                myMasterCtrl.delegate = self;
//                myMasterCtrl.tableView.hidden = YES;
//                [self.view addSubview:myMasterCtrl.view];
//                
//                //        [self ftpuser]
//                [myMasterCtrl setSAssetType:ASSET_TYPE_PHOTO];
//                [myMasterCtrl setIAssetMaxSelect:1];
//                [myMasterCtrl pickAssets:nil];
//                [myMasterCtrl setIslist:NO];
            }else{
                
                
                
            }
            
            
        }
    }
//
    

    
    
////    修改终端名称
//    
//    if (alertView.tag == 3003) {
//        
//        DLog(@"bu==%ld",buttonIndex);
//        if (buttonIndex==0) {
//        
//            
//            
//
//            
//            UITextField *mytextfild = [alertView textFieldAtIndex:0];
//            
//            if (mytextfild.text.length!=0&&![mytextfild.text isEqualToString:@""]) {
//                
//                 [self writeFile:@"vlc.txt" Data:mytextfild.text];
//                
//                [self ftpuser1];
//                
//              
//                
//            }else
//            {
//            
//                
//                
//            }
//            
//        
//        }
//        
//        
//    
//    }
//
//    
}
//
//写文件
-(void)writeFile:(NSString*)filename Data:(NSString*)data

{
    //获得应用程序沙盒的Documents目录，官方推荐数据文件保存在此
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* doc_path = [path objectAtIndex:0];
    
    DLog(@"Documents Directory:%@",doc_path);
    
    //创建文件管理器对象
    
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString* _filename = [doc_path stringByAppendingPathComponent:filename];
    //NSString* new_folder = [doc_path stringByAppendingPathComponent:@"test"];
    //创建目录
    //[fm createDirectoryAtPath:new_folder withIntermediateDirectories:YES attributes:nil error:nil];
    [fm createFileAtPath:_filename contents:[data dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
    NSArray *files = [fm subpathsAtPath: doc_path];
    DLog(@"修改终端%@",files);
    
}

-(void)ftpuser1{
    
    isgaiming = YES;
    
    //    if (!_ftpMgr) {
    //连接ftp服务器
    _ftpMgr = [[YXM_FTPManager alloc]init];
    _ftpMgr.delegate = self;
    //    }
    NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString* sZipPath =[NSString stringWithFormat:@"%@/vlc.txt",DocumentsPath];
    NSString *sUploadUrl = [[NSString alloc]initWithFormat:@"ftp://%@:21/config",ipAddressString];
    [_ftpMgr startUploadFileWithAccount:@"ftpuser" andPassword:@"ftpuser" andUrl:sUploadUrl andFilePath:sZipPath];
    NSFileManager * fm = [NSFileManager defaultManager];
    NSDictionary * dict = [fm attributesOfItemAtPath:sZipPath error:nil];
    //方法一:
    NSLog(@"size = %lld",[dict fileSize]);
    
}


/**
 *  反映上传进度的回调，每次写入流的数据长度
 *
 *  @param writeDataLength 数据长度
 */
-(void)uploadWriteData:(NSInteger)writeDataLength{
    _sendFileCountSize += writeDataLength;
    
}


/**
 *  ftp上传文件的反馈结果
 *
 *  @param sInfo 反馈结果字符串
 */
-(void)uploadResultInfo:(NSString *)sInfo{
    DLog(@"sInfo = %@",sInfo);
    
    if ([sInfo isEqualToString:@"uploadComplete"]) {
                if (isgaiming) {
                    DYT_AsyModel *myasy = [[DYT_AsyModel alloc]init];
                    
                    [myasy changeTerminalname];
            return;
            //            [self commandCompleteWithType:0x19 andContent:nil andContentLength:0];
        }
        
        
            }else{
        UIAlertView *myAlertView = [[UIAlertView alloc]initWithTitle:[Config DPLocalizedString:@"adedit_xcoludsprompt"] message:[Config DPLocalizedString:@"adedit_netconnecterror"] delegate:self cancelButtonTitle:[Config DPLocalizedString:@"adedit_promptyes"] otherButtonTitles:nil, nil];
        [myAlertView show];
    }
}

-(void)showalertview:(NSString *)messge
{
    UIAlertView *alerview = [[UIAlertView alloc]initWithTitle:[Config DPLocalizedString:@"User_Prompt"] message:messge delegate:nil cancelButtonTitle:[Config DPLocalizedString:@"adedit_Done"] otherButtonTitles: nil];
    [alerview show];
    
    
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
