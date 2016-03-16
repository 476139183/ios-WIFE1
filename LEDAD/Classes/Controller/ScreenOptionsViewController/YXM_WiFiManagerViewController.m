//
//  YXM_WiFiManagerViewController.m
//  LEDAD
//
//  Created by yixingman on 14/12/30.
//  Copyright (c) 2014年 yxm. All rights reserved.
//

#import "YXM_WiFiManagerViewController.h"
#import "Config.h"
#import "DataColumns.h"

#import <corefoundation/corefoundation.h>

#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <unistd.h>


#import <systemconfiguration/captivenetwork.h>



#import "getgateway.h"
#import <arpa/inet.h>
#import <netdb.h>
#import <netinet/in.h>
#import <netinet6/in6.h>
#import <ifaddrs.h>
#import <SystemConfiguration/SCNetworkReachability.h>
#include <sys/socket.h>


#define TAG_WIFI @"1834888"
#define TAG_OPEN_SETTING 10090

@interface YXM_WiFiManagerViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation YXM_WiFiManagerViewController
{
    UILabel *wifiipLabel;
    BOOL isIP;
    NSString *keyString;
    NSString *luyouList;//扫描
    UITextField *fid;//luyouIP
    //路由界面
    UIView *ipview;//修改IP
    UIView *cqview;//重启
    UIView *czview;//重置
    UIView *ipsetview;//ip设置
    UIView *qjview;//桥接
    //泳池地址
    UITextField *fid1;//开始
    UITextField *fid2;//借宿
    UILabel *lab5;
    UILabel *lab6;

    NSMutableArray *arrlist;
    UITextField *wifipwd;


    NSString *lyname;
    NSString *lypwd;
    NSString *lyid;

    NSString *khlist;
    NSMutableArray *khdhcplist;
    NSMutableArray *maclist;

    UITableView *mytable;
    NSString *luip;
    NSInteger cx_count;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    liststring = [NSMutableString stringWithFormat:@""];
    
    self.view.backgroundColor = [UIColor blackColor];
    self.view.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.8];
    //    isIP=NO;
    ////    [self.view setBackgroundColor:[UIColor whiteColor]];

    //    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    //    keyString = [ud objectForKey:@"luyouqiIP"];
    //    if (keyString.length == 0) {
    //        keyString=@"192.168.0.1";
    //    }

    UIButton *closeButton = [[UIButton alloc]initWithFrame:CGRectMake(5, 2, 40, 40)];
    [closeButton addTarget:self action:@selector(removeSelfView:) forControlEvents:UIControlEventTouchUpInside];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"backToMainButton"] forState:UIControlStateNormal];
    if (DEVICE_IS_IPAD) {
        [self.view addSubview:closeButton];
    }

    [closeButton release];
    //    http://192.168.0.1/lan.asp


    //    NSString *rootLoginString = [NSString stringWithFormat:@"http://%@/lan_dhcp_clients.asp",@"(null)"];
    //        DLog(@"%@",rootLoginString);
    //    NSURL *url = [NSURL URLWithString:rootLoginString];
    //    ASIHTTPRequest *getRootInfo = [[ASIHTTPRequest alloc]initWithURL:url];
    //
    //    [getRootInfo setCompletionBlock:^{
    //        DLog(@"%@",[getRootInfo responseString]);
    //        khlist = [getRootInfo responseString];
    //        [self hqdhcp];
    //        //        NSString *responseString1 = [getRootInfo1 responseString];
    //        //        [self settingWifiInfo:[self infoAnaylis:responseString1]];
    //
    //        //        [self stopProgress:self.view];
    //    }];
    //    [getRootInfo startAsynchronous];


    NSString *rootLoginString = [NSString stringWithFormat:@"http://%@/lan.asp",NULL];
    DLog(@"lan%@",rootLoginString);
    
    NSURL *url = [NSURL URLWithString:rootLoginString];
    
    
    ASIHTTPRequest *getRootInfo = [[ASIHTTPRequest alloc]initWithURL:url];

    [getRootInfo setCompletionBlock:^{
        DLog(@"IP＝＝＝＝＝＝＝＝%@",[getRootInfo responseString]);
        //获取ip
        luip = [getRootInfo responseString];
        [self hqip];
    }];
    
    [getRootInfo startAsynchronous];

    
    NSString *rootLoginString1 = [NSString stringWithFormat:@"http://%@/goform/WDSScan",NULL];
    DLog(@"WDSScan=====%@",rootLoginString1);
    NSURL *url1 = [NSURL URLWithString:rootLoginString1];
    ASIHTTPRequest *getRootInfo1 = [[ASIHTTPRequest alloc]initWithURL:url1];

    [getRootInfo1 setCompletionBlock:^{
        
        DLog(@"mac＝＝%@",[getRootInfo1 responseString]);
        //  获取mac
        luyouList = [getRootInfo1 responseString];
        [self hqmac];

    }];
    [getRootInfo1 startAsynchronous];


    //
    //
    //    if (!DEVICE_IS_IPAD) {
    //        DataColumns *tData = [[DataColumns alloc]init];
    //        [tData setColumn_id:TAG_WIFI];
    //        [tData setColumn_name:[Config DPLocalizedString:@"adedit_wifimanager"]];
    //        if (!secondMenuArray) {
    //            secondMenuArray = [[NSMutableArray alloc]init];
    //        }
    //        [secondMenuArray addObject:tData];
    //        //首次点击栏目的id
    //
    //        currentColumId = [(DataColumns *)[secondMenuArray objectAtIndex:0] column_id];
    //
    //        [self inserSegmentView];
    //    }
    //
    //
    //    promptLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 10, 500, 100)];
    //    if (!DEVICE_IS_IPAD) {
    //        [promptLabel setFrame:CGRectMake(0, 20, SCREEN_CGSIZE_2WIDTH, 100)];
    //    }
    //    [promptLabel setNumberOfLines:4];
    //    [promptLabel setText:@"修改WiFi密码或名称后需要到设置中忽略掉之前的wifi进行重连！点击此处刷新！"];
    //    [promptLabel setTextAlignment:NSTextAlignmentCenter];
    //    [promptLabel setUserInteractionEnabled:YES];
    //    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(refreshLoadInfo)];
    //    [promptLabel addGestureRecognizer:tap];
    //    [promptLabel setLineBreakMode:NSLineBreakByWordWrapping];
    //
    //    [self.view addSubview:promptLabel];
    //
    //
    //
    //
    //    UIImageView *backegroudView = [[UIImageView alloc]initWithFrame:CGRectMake(200, 200, 300, 900)];
    //    if (!DEVICE_IS_IPAD) {
    //        [backegroudView setFrame:CGRectMake(0, promptLabel.frame.size.height + promptLabel.frame.origin.y + 10, SCREEN_CGSIZE_2WIDTH, 200)];
    //    }
    //    [backegroudView setImage:[UIImage imageNamed:@"day_frame"]];
    //    [backegroudView setUserInteractionEnabled:YES];
    //    [self.view addSubview:backegroudView];
    //
    //    UILabel *wifiNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 80, 44)];
    //    [wifiNameLabel setText:@"WiFi名称"];
    //    [wifiNameLabel setBackgroundColor:[UIColor clearColor]];
    //    [backegroudView addSubview:wifiNameLabel];
    //
    //    wifiNameTextField = [[BaseTextField alloc]initWithFrame:CGRectMake(wifiNameLabel.frame.size.width + wifiNameLabel.frame.origin.x + 10, wifiNameLabel.frame.origin.y, 200, 44)];
    //    wifiNameTextField.delegate = self;
    //    wifiNameTextField.borderStyle = UITextBorderStyleLine;
    //    [wifiNameTextField setClearButtonMode:UITextFieldViewModeAlways];
    //    [backegroudView addSubview:wifiNameTextField];
    //
    //
    //    UILabel *wifiPassLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, wifiNameLabel.frame.size.height + wifiNameLabel.frame.origin.y + 20, 80, 44)];
    //    [wifiPassLabel setText:@"WiFi密码"];
    //    [wifiPassLabel setBackgroundColor:[UIColor clearColor]];
    //    [backegroudView addSubview:wifiPassLabel];
    //
    //    wifiPasswordField = [[BaseTextField alloc]initWithFrame:CGRectMake(wifiPassLabel.frame.size.width + wifiPassLabel.frame.origin.x + 10, wifiPassLabel.frame.origin.y, 200, 44)];
    //    wifiPasswordField.delegate = self;
    //    wifiPasswordField.borderStyle = UITextBorderStyleLine;
    //    [wifiPasswordField setClearButtonMode:UITextFieldViewModeAlways];
    //    [backegroudView addSubview:wifiPasswordField];
    //
    //
    //    confirmButton = [[BFPaperButton alloc] initWithFrame:CGRectMake(wifiPassLabel.frame.origin.x, wifiPassLabel.frame.size.height + wifiPassLabel.frame.origin.y + 20, wifiPassLabel.frame.size.width + wifiPasswordField.frame.size.width + 20, 44)];
    //    [confirmButton setTitle:[Config DPLocalizedString:@"adedit_wifipasswordsubmitbutton"] forState:UIControlStateNormal];
    //    [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    [confirmButton addTarget:self action:@selector(submitButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    //    [backegroudView addSubview:confirmButton];
    //
    //
    //    wifiipLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, confirmButton.frame.size.height + confirmButton.frame.origin.y + 100, 80, 44)];
    //    [wifiipLabel setText:@"路由网关"];
    //    [wifiipLabel setBackgroundColor:[UIColor clearColor]];
    //    [backegroudView addSubview:wifiipLabel];
    //
    //    wifiIptextField = [[BaseTextField alloc]initWithFrame:CGRectMake(wifiipLabel.frame.size.width + wifiipLabel.frame.origin.x + 10, wifiipLabel.frame.origin.y, 200, 44)];
    //    wifiIptextField.delegate = self;
    //    wifiIptextField.borderStyle = UITextBorderStyleLine;
    //    [wifiIptextField setClearButtonMode:UITextFieldViewModeAlways];
    //    [backegroudView addSubview:wifiIptextField];
    //
    //
    //
    //    confirmButton1 = [[UIButton alloc] initWithFrame:CGRectMake(wifiipLabel.frame.origin.x, wifiipLabel.frame.size.height + wifiipLabel.frame.origin.y + 20, wifiipLabel.frame.size.width + wifiIptextField.frame.size.width + 20, 44)];
    //    [confirmButton1 setTitle:[Config DPLocalizedString:@"adedit_wifiIPsubmitbutton"] forState:UIControlStateNormal];
    //    [confirmButton1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    [confirmButton1 addTarget:self action:@selector(IPclick:) forControlEvents:UIControlEventTouchUpInside];
    //    confirmButton1.backgroundColor = [UIColor blackColor];
    //    [backegroudView addSubview:confirmButton1];
    //    [wifiIptextField setText:keyString];
    //    [self loadRooterInfo];
    //
    //    [self yongchi];

    [self wifiload];
}


//获取路由器IP
-(void)hqip{
    
    NSArray *arr = [luip componentsSeparatedByString:@"var LANIP="];
    DLog(@"%@",arr);
    NSArray *arr1 = [arr[1] componentsSeparatedByString:@"\""];
    DLog(@"%@",arr1);
    keyString = arr1[1];
    fid.text = keyString;
    NSArray *iparr = [keyString componentsSeparatedByString:@"."];
    NSString *ipstr = [NSString stringWithFormat:@"%@.%@.%@.",iparr[0],iparr[1],iparr[2]];
    lab6.text = ipstr;
    lab5.text = ipstr;
}

//获取客户端列表信息
-(void)hqdhcp{
    khdhcplist = [[NSMutableArray alloc]init];
    maclist = [[NSMutableArray alloc]init];
    NSArray *arr = [khlist componentsSeparatedByString:@"("];
    DLog(@"%@",arr);
    NSArray *arr1 = [arr[1] componentsSeparatedByString:@")"];
    DLog(@"%@",arr1);
    NSArray *arr2 = [arr1[0] componentsSeparatedByString:@"'"];
    DLog(@"%@",arr2);
    for (int i = 0; i < arr2.count; i ++) {
        if (i % 2 != 0) {
            NSArray * arr3 = [arr2[i] componentsSeparatedByString:@";"];
            DLog(@"%@",arr3);
            if ([arr3[0] componentsSeparatedByString:@"ledmedia"].count > 1) {
                [khdhcplist addObject:arr3];
            }
        }
    }
    DLog(@"%@",khdhcplist);
    NSArray *arr4 = [khlist componentsSeparatedByString:@"StaticList = new Array"];
    NSArray *arr5 = [arr4[1] componentsSeparatedByString:@"("];
    DLog(@"%@",arr5);
    NSArray *arr6 = [arr5[1] componentsSeparatedByString:@")"];
    DLog(@"%@",arr6);
    NSArray *arr7 = [arr6[0] componentsSeparatedByString:@"'"];
    DLog(@"%@",arr7);
    for (int i = 0; i< arr7.count; i++) {
        if (i % 2 != 0) {
            NSArray *arr8 = [arr7[i] componentsSeparatedByString:@";"];
            DLog(@"%@",arr8);
            [maclist addObject:arr8];
        }
    }
    DLog(@"%@",maclist);
}


-(void)hqmac{
    NSArray *arr = [[NSArray alloc]init];
    arr =[luyouList componentsSeparatedByString:@"\r"];
    arrlist = [[NSMutableArray alloc]init];
    for (int i =0; i<arr.count; i++) {
        NSArray *arr1 = [arr[i] componentsSeparatedByString:@"\t"];
        [arrlist addObject:arr1];
        DLog(@"%@",arr1);
    }
    DLog(@"%@",arrlist);
    [mytable reloadData];

}

//路由器管理界面
-(void)wifiload{
    NSInteger groupwidth = self.view.frame.size.width/4;
    NSInteger groupheigh = self.view.frame.size.height/9;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(groupwidth, groupheigh, groupwidth*2, groupheigh*7)];
    view.backgroundColor = [UIColor whiteColor];
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height/12)];
    NSInteger btnwidth = view.frame.size.width/5;
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, btnwidth, view1.frame.size.height)];
    [btn.layer setBorderWidth:1];
    [btn setTitle:[Config DPLocalizedString:@"adedit_wifi"] forState:0];
    [btn setTitleColor:[UIColor cyanColor] forState:0];
    btn.tag = 9401;
    [btn addTarget:self action:@selector(onclick:) forControlEvents:UIControlEventTouchUpInside];
    [view1 addSubview:btn];
    UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(btnwidth, 0, btnwidth, view1.frame.size.height)];
    [btn1.layer setBorderWidth:1];
    [btn1 setTitle:[Config DPLocalizedString:@"adedit_wifi1"] forState:0];
    [btn1 setTitleColor:[UIColor cyanColor] forState:0];
    btn1.tag = 9402;
    [btn1 addTarget:self action:@selector(onclick:) forControlEvents:UIControlEventTouchUpInside];
    [view1 addSubview:btn1];
    UIButton *btn2 = [[UIButton alloc]initWithFrame:CGRectMake(btnwidth*2, 0, btnwidth, view1.frame.size.height)];
    [btn2.layer setBorderWidth:1];
    [btn2 setTitle:[Config DPLocalizedString:@"adedit_wifi2"] forState:0];
    [btn2 setTitleColor:[UIColor cyanColor] forState:0];
    btn2.tag = 9403;
    [btn2 addTarget:self action:@selector(onclick:) forControlEvents:UIControlEventTouchUpInside];
    [view1 addSubview:btn2];
    UIButton *btn3 = [[UIButton alloc]initWithFrame:CGRectMake(btnwidth*3, 0, btnwidth, view1.frame.size.height)];
    [btn3.layer setBorderWidth:1];
    [btn3 setTitle:[Config DPLocalizedString:@"adedit_wifi3"] forState:0];
    [btn3 setTitleColor:[UIColor cyanColor] forState:0];
    btn3.tag = 9404;
    [btn3 addTarget:self action:@selector(onclick:) forControlEvents:UIControlEventTouchUpInside];
    [view1 addSubview:btn3];
    UIButton *btn4 = [[UIButton alloc]initWithFrame:CGRectMake(btnwidth*4, 0, btnwidth, view1.frame.size.height)];
    [btn4.layer setBorderWidth:1];
    [btn4 setTitle:[Config DPLocalizedString:@"adedit_wifi4"] forState:0];
    [btn4 setTitleColor:[UIColor cyanColor] forState:0];
    btn4.tag = 9405;
    [btn4 addTarget:self action:@selector(onclick:) forControlEvents:UIControlEventTouchUpInside];
    [view1 addSubview:btn4];
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0, btn4.frame.size.height, view1.frame.size.width, view.frame.size.height - view1.frame.size.height)];
    view2.tag = 20150705;
    [view addSubview:view2];
    [view addSubview:view1];
    [self.view addSubview:view];
    
    [self IPload];
    [self cqload];
    [self czview];
    [self ipsetload];
    [self qjviewload];

    ipview.hidden = NO;
    ipsetview.hidden = YES;
    qjview.hidden = YES;
    cqview.hidden = YES;
    czview.hidden = YES;
}
//修改网管ip界面
-(void)IPload{
    UIView *view2 = [self.view viewWithTag:20150705];
    ipview = [[UIView alloc]initWithFrame:CGRectMake(0,0, view2.frame.size.width, view2.frame.size.height)];
    NSInteger ipwidth = ipview.frame.size.width/2;
    NSInteger ipheight = ipview.frame.size.height/2;
    UILabel *iplabel = [[UILabel alloc]initWithFrame:CGRectMake(ipwidth-135, ipheight-100, 90, 44)];
    iplabel.text = [Config DPLocalizedString:@"adedit_wifi5"];
    iplabel.textAlignment = NSTextAlignmentCenter;
    [ipview addSubview:iplabel];
    fid = [[UITextField alloc]initWithFrame:CGRectMake(iplabel.frame.origin.x + iplabel.frame.size.width, iplabel.frame.origin.y, 180, 44)];
    fid.borderStyle = UITextBorderStyleBezel;
    UIButton *ipbtn = [[UIButton alloc]initWithFrame:CGRectMake(iplabel.frame.origin.x, iplabel.frame.origin.y + iplabel.frame.size.height + 10, iplabel.frame.size.width + fid.frame.size.width, 44)];
    [ipbtn setTitle:[Config DPLocalizedString:@"adedit_Done"] forState:0];
    [ipbtn setTitleColor:[UIColor blackColor] forState:0];
    ipbtn.backgroundColor = [UIColor redColor];
    [ipbtn addTarget:self action:@selector(IPclick:) forControlEvents:UIControlEventTouchUpInside];
    [ipview addSubview:ipbtn];
    [ipview addSubview:fid];
    [view2 addSubview:ipview];
}
//重启
-(void)cqload{
    UIView *view2 = [self.view viewWithTag:20150705];
    cqview = [[UIView alloc]initWithFrame:CGRectMake(0,0, view2.frame.size.width, view2.frame.size.height)];
    NSInteger cqwidth = cqview.frame.size.width/2;
    NSInteger cqheight = cqview.frame.size.height/2;
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(cqwidth-135, cqheight-100, 270, 44)];
    [btn setTitle:[Config DPLocalizedString:@"adedit_wifi3"] forState:0];
    [btn setTitleColor:[UIColor blackColor] forState:0];
    btn.backgroundColor = [UIColor redColor];
    [cqview addSubview:btn];
    [btn addTarget:self action:@selector(rest) forControlEvents:UIControlEventTouchUpInside];
    [view2 addSubview:cqview];
}
//重置
-(void)czview{
    UIView *view2 = [self.view viewWithTag:20150705];
    czview = [[UIView alloc]initWithFrame:CGRectMake(0,0, view2.frame.size.width, view2.frame.size.height)];
    NSInteger cqwidth = czview.frame.size.width/2;
    NSInteger cqheight = czview.frame.size.height/2;
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(cqwidth-135, cqheight-100, 270, 44)];
    [btn setTitle:[Config DPLocalizedString: @"adedit_wifi4"] forState:0];
    [btn setTitleColor:[UIColor blackColor] forState:0];
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(hf) forControlEvents:UIControlEventTouchUpInside];
    [czview addSubview:btn];
    [view2 addSubview:czview];
}
//ip设置
-(void)ipsetload{
    UIView *view2 = [self.view viewWithTag:20150705];
    ipsetview = [[UIView alloc]initWithFrame:CGRectMake(view2.frame.origin.x, view2.frame.origin.y, view2.frame.size.width, view2.frame.size.height)];
    NSInteger cqwidth = czview.frame.size.width/2;
    NSInteger cqheight = czview.frame.size.height/2;
    UILabel *lab3 = [[UILabel alloc]initWithFrame:CGRectMake(cqwidth-180 , cqheight-160 , 130, 44)];
    lab3.text = [Config DPLocalizedString:@"adedit_wifi14"];
    UILabel *lab4 = [[UILabel alloc]initWithFrame:CGRectMake(lab3.frame.origin.x , lab3.frame.origin.y + 50 , 130, 44)];
    lab4.text = [Config DPLocalizedString:@"adedit_wifi13"];
    lab5 = [[UILabel alloc]initWithFrame:CGRectMake(lab3.frame.origin.x + lab3.frame.size.width , lab3.frame.origin.y , 100, 44)];

    lab6 = [[UILabel alloc]initWithFrame:CGRectMake(lab4.frame.origin.x + lab4.frame.size.width  , lab4.frame.origin.y , 100, 44)];

    fid1 = [[UITextField alloc]initWithFrame:CGRectMake(lab5.frame.origin.x + lab5.frame.size.width, lab5.frame.origin.y, 100, 44)];
    fid1.text = @"100";
    fid1.borderStyle = UITextBorderStyleBezel;
    fid2 = [[UITextField alloc]initWithFrame:CGRectMake(fid1.frame.origin.x, lab6.frame.origin.y, 100, 44)];
    fid2.text = @"150";
    fid2.borderStyle = UITextBorderStyleBezel;
    UILabel *lab7 = [[UILabel alloc]initWithFrame:CGRectMake(lab3.frame.origin.x, lab4.frame.origin.y + lab4.frame.size.height + 10, 100, 44)];
    lab7.text = @"过期时间";
    UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(lab6.frame.origin.x, lab7.frame.origin.y + lab7.frame.size.height, 100, 44)];
    [btn1 setTitle:[Config DPLocalizedString:@"adedit_Done"] forState:0];
    [btn1 setTitleColor:[UIColor redColor] forState:0];
    btn1.backgroundColor = [UIColor cyanColor];
    [btn1 addTarget:self action:@selector(dhpc) forControlEvents:UIControlEventTouchUpInside];
    [ipsetview addSubview:btn1];
//    [ipsetview addSubview:lab7];
    [ipsetview addSubview:fid1];
    [ipsetview addSubview:fid2];
    [ipsetview addSubview:lab6];
    [ipsetview addSubview:lab5];
    [ipsetview addSubview:lab4];
    [ipsetview addSubview:lab3];
    [view2 addSubview:ipsetview];
}

-(void)dhpc{
    [self dhpc:[NSString stringWithFormat:@"%@%@",lab5.text,fid1.text] IP2:[NSString stringWithFormat:@"%@%@",lab6.text,fid2.text]];
}

//桥接
-(void)qjviewload{
    UIView *view2 = [self.view viewWithTag:20150705];
    qjview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, view2.frame.size.width, view2.frame.size.height)];
    DLog(@"%@",luyouList);

    mytable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, qjview.frame.size.width, qjview.frame.size.height - 100)];
    mytable.delegate = self;
    mytable.dataSource = self;
    [qjview addSubview:mytable];
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(view2.frame.size.width/5, mytable.frame.size.height + 10, view2.frame.size.width/5, 44)];
    lab.text = [Config DPLocalizedString:@"adedit_wifi12"];
    wifipwd = [[UITextField alloc]initWithFrame:CGRectMake(lab.frame.origin.x + lab.frame.size.width , lab.frame.origin.y, view2.frame.size.width/5*2, 44)];
    wifipwd.borderStyle = UITextBorderStyleBezel;
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(view2.frame.size.width/5*2, lab.frame.origin.y + lab.frame.size.height, view2.frame.size.width/5, 44)];
    btn.layer.borderWidth = 1;
    [btn setTitle:[Config DPLocalizedString:@"adedit_Done"] forState:0];
    [btn setTitleColor:[UIColor blackColor] forState:0];
    btn.backgroundColor = [UIColor cyanColor];
    [btn addTarget:self action:@selector(WANsub) forControlEvents:UIControlEventTouchUpInside];
    [qjview addSubview:lab];
    [qjview addSubview:btn];
    [qjview addSubview:wifipwd];
    [view2 addSubview:qjview];
    qjview.hidden = YES;
}

-(void)WANsub{
    [self WANsub:lyname lyid:lyid wifipwd:wifipwd.text];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrlist.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellWithIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellWithIdentifier];
    }
    DLog(@"%@",arrlist);
    cell.textLabel.text = arrlist[indexPath.row][0];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    lyname = arrlist[indexPath.row][0];
    lyid = arrlist[indexPath.row][2];
}

//路由器界面切换
-(void)onclick:(UIButton*)sender{
    if (sender.tag == 9401) {
        ipview.hidden = NO;
        ipsetview.hidden = YES;
        qjview.hidden = YES;
        cqview.hidden = YES;
        czview.hidden = YES;
    }
    if (sender.tag == 9402) {
        ipview.hidden = YES;
        ipsetview.hidden = NO;
        qjview.hidden = YES;
        cqview.hidden = YES;
        czview.hidden = YES;
    }
    if (sender.tag == 9403) {
        ipview.hidden = YES;
        ipsetview.hidden = YES;
        qjview.hidden = NO;
        cqview.hidden = YES;
        czview.hidden = YES;

    }
    if (sender.tag == 9404) {
        ipview.hidden = YES;
        ipsetview.hidden = YES;
        qjview.hidden = YES;
        cqview.hidden = NO;
        czview.hidden = YES;
    }
    if (sender.tag == 9405) {
        ipview.hidden = YES;
        ipsetview.hidden = YES;
        qjview.hidden = YES;
        cqview.hidden = YES;
        czview.hidden = NO;

    }
}

//修改 dhxp 100  150
-(void)dhpc:(NSString *)IP1 IP2:(NSString *)IP2{
    //    NSString *IP1 = [NSString stringWithFormat:@"%@%@",lab5.text,fid1.text];
    //    NSString *IP2 = [NSString stringWithFormat:@"%@%@",lab6.text,fid2.text];
    //    NSString *dhcpString = [NSString stringWithFormat:@"http://%@//goform/DhcpSetSer?GO=lan_dhcps.asp&dhcpEn=1&dips=200&dipe=210&DHLT=7200",keyString];
    
    NSString *dhcpString = [NSString stringWithFormat:@"http://%@//goform/DhcpSetSer?GO=lan_dhcps.asp&dhcpEn=1",[self routerIp]];
    NSURL *dhcpURL = [NSURL URLWithString:dhcpString];
    DLog(@"dhpc");
    ASIFormDataRequest *dncp = [[ASIFormDataRequest alloc]initWithURL:dhcpURL];
    //    [dncp addPostValue:@"lan_dhcps.asp" forKey:@"GO"];
    //    [dncp addPostValue:@"1" forKey:@"DHEN"];
    [dncp addPostValue:IP1 forKey:@"dips"];
    [dncp addPostValue:IP2 forKey:@"dipe"];
    [dncp addPostValue:@"3600" forKey:@"DHLT"];
    [dncp startAsynchronous];
    
    [dncp setFailedBlock:^{
       
        DLog(@"绑定失败了＝＝＝＝");
        
//        [self dhpc:@""];

        
        
    }];
    
    
}

-(void)dhpcnum:(NSString *)ipnum;
{

    //    NSString *IP1 = [NSString stringWithFormat:@"%@%@",lab5.text,fid1.text];
    //    NSString *IP2 = [NSString stringWithFormat:@"%@%@",lab6.text,fid2.text];
    //    NSString *dhcpString = [NSString stringWithFormat:@"http://%@//goform/DhcpSetSer?GO=lan_dhcps.asp&dhcpEn=1&dips=200&dipe=210&DHLT=7200",keyString];
    
    NSString *strongip = [self getipstring];
    NSArray *myarray = [strongip componentsSeparatedByString:@"."];
    if (![myarray[0] isEqualToString:@"192"]) {
        [self showAlertView:@"请检查wifi"];
        strongip = [self routerIp];
    }

    NSString *ipname = [self routerIp];
    
    
//    NSArray *array = [ipname componentsSeparatedByString:@"."];
//    while ([array[0] isEqualToString:@"192.168.0.1"]) {
//    
//        ipname = [self routerIp];
//    }
//    
    
    
    
    NSString *dhcpString = [NSString stringWithFormat:@"http://%@//goform/DhcpSetSer?GO=lan_dhcps.asp&dhcpEn=1",ipnum];
    NSURL *dhcpURL = [NSURL URLWithString:dhcpString];
    DLog(@"打开dhcp");
    ASIFormDataRequest *dncp = [[ASIFormDataRequest alloc]initWithURL:dhcpURL];
    //    [dncp addPostValue:@"lan_dhcps.asp" forKey:@"GO"];
    //    [dncp addPostValue:@"1" forKey:@"DHEN"];
    [dncp addPostValue:@"192.168.0.100" forKey:@"dips"];
    [dncp addPostValue:@"192.168.0.150" forKey:@"dipe"];
    [dncp addPostValue:@"3600" forKey:@"DHLT"];
    [dncp startAsynchronous];
    
    [dncp setFailedBlock:^{
        
        DLog(@"打开dhcp失败＝＝＝＝");
        
//        sleep(3);
        
//        [self dhpcnum:ipnum];
//        [self dhpc:@"192.168.0.100" IP2:@"192.168.0.150"];
        _Opengdhcp();
        
        
    }];
    
    
    [dncp setCompletionBlock:^{
        DLog(@"打开dhcp 成功");
        _Opengdhcp();
    }];
    
    
}

NSMutableString *liststring;

-(void)dhcpipbangding:(NSMutableArray *)iparray andtag:(NSInteger )tag
{
//    ipAddressString
    
    NSString *stringip = [self getipstring];
    
    NSArray *array1 = [stringip componentsSeparatedByString:@"."];
    if (![array1[0] isEqualToString:@"192"]) {
        [self showAlertView:@"请检查wifi!"];
        stringip = [self routerIp];
    }
    
    
    
    NSMutableString *str  = [[NSMutableString alloc]init];
    
    NSString *str1 = @"";
    
    NSInteger k = tag-1;
    
    
//    if (tag==1) {
    
        //主屏
//        str = [NSString stringWithFormat:@"%@1",str];
    // 获取list 的东西
    
        NSString *str2 = [NSString stringWithFormat:@";%@;%@;1;3600",[NSString stringWithFormat:@"192.168.0.%ld",(long)198+10*k],iparray[0][2]];
    

    
    // 屏的信息plist；
//    str1 = [NSString stringWithFormat:@"%@&list%ld=%@",liststring,(long)k+1,str2];

//    if (liststring.length==0) {
    
//        liststring = [[NSMutableString alloc]init];
        str1 = [NSString stringWithFormat:@"list%ld=%@",1,str2];

//    }
    
    
//    liststring = [[NSMutableString alloc]initWithString:str1];
    
//    }
    
    //屏的数量
    NSArray *array = [str1 componentsSeparatedByString:@"list"];
    
    for (int i=0; i<array.count-1; i++) {
        [str appendString:@"1"];
    }
    
    
    
    DLog(@"mac地址绑定====%@",str1);
    
//    NSString *dhcpString = [NSString stringWithFormat:@"http://%@/goform/DhcpListClient?GO=lan_dhcp_clients.asp%@&IpMacEN=%@&LISTLEN=%ld",@"192.168.0.1",str1,str,(long)array.count];
    
    NSString *dhcpString = [NSString stringWithFormat:@"http://192.168.0.1/goform/DhcpListClient?GO=lan_dhcp_clients.asp&%@&IpMacEN=%@&LISTLEN=%ld",str1,str,(long)array.count-1];
    
    
    DLog(@"网络请求===%@",dhcpString);
    
    
    NSURL *dhcpURL = [NSURL URLWithString:dhcpString];
    
    
    
    
    
    ASIFormDataRequest *dhcplist = [[ASIFormDataRequest alloc]initWithURL:dhcpURL];
    
    [dhcplist setFailedBlock:^{
        _bangding();
        DLog(@"绑定失败=======%@",dhcpString);
        
    }];
[dhcplist setCompletionBlock:^{
   
    _bangding();
    
}];
    [dhcplist startAsynchronous];
    
   

}


//DHCP客户端列表
-(void)dhcpList:(NSMutableArray *)macarr {
    
    NSString *str = @"";
    NSString *str1 = @"";
    for (int i = 0; i<macarr.count; i++) {
        
        str = [NSString stringWithFormat:@"%@1",str];
        
        NSString *str2 = [NSString stringWithFormat:@";%@;%@;1;3600",[NSString stringWithFormat:@"192.168.0.%ld",(long)198+10*i],macarr[i][2]];
        
        str1 = [NSString stringWithFormat:@"%@&list%ld=%@",str1,(long)i+1,str2];
        
    }
    
    DLog(@"mac地址绑定====%@",str1);
    NSString *dhcpString = [NSString stringWithFormat:@"http://%@/goform/DhcpListClient?GO=lan_dhcp_clients.asp%@&IpMacEN=%@&LISTLEN=%ld",@"192.168.0.1",str1,str,(long)macarr.count];
    DLog(@"%@",dhcpString);
    NSURL *dhcpURL = [NSURL URLWithString:dhcpString];
    ASIFormDataRequest *dhcplist = [[ASIFormDataRequest alloc]initWithURL:dhcpURL];
    [dhcplist startAsynchronous];
}

-(void)IPclick:(UIButton*)sender{
    isIP=YES;
    [self editIP:[NSString stringWithFormat:@"%@",fid.text]];
    NSString *alertMsg = [Config DPLocalizedString:@"NSStringModifySuccess"];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[Config DPLocalizedString:@"adedit_wifi5"] message:alertMsg delegate:self cancelButtonTitle:[Config DPLocalizedString:@"NSStringYes"] otherButtonTitles:nil, nil];
    alert.delegate = self;
    [alert setTag:TAG_OPEN_SETTING];
    [alert show];
    [alert release];
}

-(void)alert:(NSString*)str alertMsg:(NSString *)msg{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:str message:msg delegate:self cancelButtonTitle:[Config DPLocalizedString:@"adedit_Done"] otherButtonTitles:nil, nil];
    alert.delegate = self;
    [alert show];
    [alert release];
}

#pragma mark - showAlertView
-(void)showAlertView:(NSString*)showString
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[Config DPLocalizedString:@"Login_ts3"] message:showString delegate:nil  cancelButtonTitle:nil otherButtonTitles:nil];
    [alert show];
    [self performSelector:@selector(dimissAlert:) withObject:alert afterDelay:15.0];



}//温馨提示



- (void)dimissAlert:(UIAlertView *)alert
{
    if(alert)
    {

        [alert dismissWithClickedButtonIndex:[alert cancelButtonIndex] animated:YES];

    }
}//温馨提示


-(void)refreshLoadInfo{
    
    NSString *rootLoginString = [NSString stringWithFormat:@"http://%@",keyString];
    NSURL *url = [NSURL URLWithString:rootLoginString];
    ASIHTTPRequest *getRootInfo = [[ASIHTTPRequest alloc]initWithURL:url];
    [getRootInfo setCompletionBlock:^{
        DLog(@"%@",[getRootInfo responseString]);
        NSString *responseString = [getRootInfo responseString];
        [self settingWifiInfo:[self infoAnaylis:responseString]];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"重新加载成功！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }];
    [getRootInfo setFailedBlock:^{
        DLog(@"%@",[getRootInfo responseString]);
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请检查设置-无线局域网,确定已经连接到LED屏的wifi之后再试！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }];
    [getRootInfo startAsynchronous];
}

-(void)loadRooterInfo{
    //    [self startProgress];

    NSString *rootLoginString = [NSString stringWithFormat:@"http://%@",[self routerIp]];
    DLog(@"%@",rootLoginString);
    NSURL *url = [NSURL URLWithString:rootLoginString];
    ASIHTTPRequest *getRootInfo = [[ASIHTTPRequest alloc]initWithURL:url];

    [getRootInfo setCompletionBlock:^{
        DLog(@"%@",[getRootInfo responseString]);

        //        [self stopProgress:self.view];
    }];
    //    [getRootInfo setFailedBlock:^{
    //        NSUserDefaults *wifiDefaults = [NSUserDefaults standardUserDefaults];
    //        if ([wifiDefaults objectForKey:@"name"]) {
    //            [wifiNameTextField setText:[wifiDefaults objectForKey:@"name"]];
    //        }
    //        if ([wifiDefaults objectForKey:@"pwd"]) {
    //            [wifiPasswordField setText:[wifiDefaults objectForKey:@"pwd"]];
    //        }
    //        DLog(@"%@",[getRootInfo responseString]);
    //        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请检查设置-无线局域网,确定已经连接到LED屏的wifi之后再试！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    //        [alert show];
    //
    //        [alert release];
    //    }];
    [getRootInfo startAsynchronous];

}

-(void)settingWifiInfo:(NSDictionary *)infoDict{
    [wifiNameTextField setText:[infoDict objectForKey:@"name"]];
    [wifiPasswordField setText:[infoDict objectForKey:@"pwd"]];
    //    NSUserDefaults *wifiDefaults = [NSUserDefaults standardUserDefaults];
    //    [wifiDefaults setObject:[infoDict objectForKey:@"name"] forKey:@"name"];
    //    [wifiDefaults setObject:[infoDict objectForKey:@"pwd"] forKey:@"pwd"];
}

-(NSDictionary *)infoAnaylis:(NSString *)responseString{
    /*---------------在串中搜索子串----------------*/
    DLog(@"%@",responseString);

    NSString *string1 = @"def_wirelesspassword";
    NSRange range = [responseString rangeOfString:string1];
    NSInteger location = range.location;


    //-substringFromIndex: 以指定位置开始（包括指定位置的字符），并包括之后的全部字符
    NSString *string2 = [responseString substringFromIndex:location];


    NSString *string3 = @"\";";
    NSRange range3 = [string2 rangeOfString:string3];
    NSInteger location3 = range3.location;


    NSString *string4 = [string2 substringWithRange:NSMakeRange(0, location3)];
    DLog(@"string4 = %@",string4);

    NSArray *string4Array = [string4 componentsSeparatedByString:@"\""];
    DLog(@"string4Array = %@",string4Array);
    NSString *password = [string4Array objectAtIndex:1];
    NSString *wifiname = [string4Array lastObject];
    NSDictionary *wifiinfoDict = [[NSDictionary alloc]initWithObjectsAndKeys:password,@"pwd",wifiname,@"name",nil];
    return wifiinfoDict;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma
 mark - Navigation

 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)removeSelfView:(UIButton *)sender{
    [self.view removeFromSuperview];
}


-(void)editIP:(NSString *)ip{
    
    NSString *strongip = [self getipstring];
    NSArray *myarray = [strongip componentsSeparatedByString:@"."];
    if (![myarray[0] isEqualToString:@"192"]) {
        [self showAlertView:@"请检查wifi"];
        strongip = [self routerIp];
    }
    

    DLog(@"修改ip===========================%@",ip);
    NSString *pwdString = [NSString stringWithFormat:@"http://%@/goform/AdvSetLanip",[self routerIp]];
    
    NSURL *pwdURL = [NSURL URLWithString:pwdString];
    DLog(@"修改ipurl＝＝＝＝＝＝＝＝%@",pwdURL);
    ASIFormDataRequest *editIP = [[ASIFormDataRequest alloc]initWithURL:pwdURL];
    [editIP addPostValue:@"lan.asp" forKey:@"GO"];
    [editIP addPostValue:ip forKey:@"LANIP"];
    [editIP addPostValue:@"255.255.255.0" forKey:@"LANMASK"];
    [editIP startAsynchronous];
    //正在修改 请等待15秒
    NSString *string = [Config DPLocalizedString:@"adedit_wifi10"];
    
    [editIP setCompletionBlock:^{
        DLog(@"修改成功!");
        _edingip();
        
    }];
    [editIP setFailedBlock:^{
        DLog(@"修改ip失败");
        _edingip();
    }];
    
    [self showAlertView:string];
}
-(void)editPassword{
    
    
    NSString *strongip = [self getipstring];
    NSArray *myarray = [strongip componentsSeparatedByString:@"."];
    if (![myarray[0] isEqualToString:@"192"]) {
        [self showAlertView:@"请检查wifi"];
        strongip = [self routerIp];
    }
    

    
//    NSString *pwdString = [NSString stringWithFormat:@"http://%@/goform/wirelessSetSecurity",keyString];
    
    NSString *pwdString = [NSString stringWithFormat:@"http://%@/goform/wirelessSetSecurity",[self routerIp]];

    
    
    NSURL *pwdURL = [NSURL URLWithString:pwdString];
    DLog(@"修改密码====%@",pwdString);
    ASIFormDataRequest *editPwd = [[ASIFormDataRequest alloc]initWithURL:pwdURL];
    [editPwd addPostValue:@"disabled" forKey:@"wifiEn"];
    [editPwd addPostValue:@"pbc" forKey:@"wpsmethod"];
    [editPwd addPostValue:@"wireless_security.asp" forKey:@"GO"];
    [editPwd addPostValue:@"psk" forKey:@"security_mode"];
    [editPwd addPostValue:@"aes" forKey:@"cipher"];
    [editPwd addPostValue:@"12345678" forKey:@"passphrase"];
    [editPwd addPostValue:@"disabled" forKey:@"wpsenable"];
    [editPwd setCompletionBlock:^{
        _changepassword();
        DLog(@"主屏修改密码成功 = %@",[editPwd responseString]);
        
    }];
    [editPwd setFailedBlock:^{
        
        DLog(@"主屏修改密码失败 = %@",[editPwd responseString]);
        
        [self performSelector:@selector(editPassword) withObject:nil afterDelay:5];
        return ;
        
//        _changepassword();
    }];
    [editPwd startAsynchronous];
}




//WAN口介質
-(void)WANsub:(NSString *)name lyid:(NSString *)Id wifipwd:(NSString *)pwd andnum:(NSInteger)num
{
    
    
    lyname = name;
    lyid = Id;
    lypwd = pwd;
    DLog(@"桥接  参数一%@;参数2%@;参数3%@",name,Id,pwd);
    
//    NSString *dhcpString = [NSString stringWithFormat:@"http://%@/goform/wirelessMode?wds_list=1&extra_mode=apclient&ssid=%@&channel=%@&wds_1=&wds_2=&security=psk+psk2&wep_default_key=1&wep_key_1=ASCII&WEP1Select=1&wep_key_2=ASCII&WEP2Select=1&wep_key_3=ASCII&WEP3Select=1&wep_key_4=ASCII&WEP4Select=1&cipher=aes&passphrase=%@&keyRenewalInterval=3600",NULL,name,Id,pwd];
    
//    NSString *ipstring = [self routerIp];
    
    
    
  NSString  *ipstring11111 = [NSString stringWithFormat:@"192.168.0.%d",num];
//    NSArray *array = [ipstring componentsSeparatedByString:@"."];
    
//    while (![array[0] isEqualToString:@"192"]) {
//        sleep(3);
//        ipstring = [self routerIp];
//        array = [ipstring componentsSeparatedByString:@"."];
//    }
    
    NSString *strongip = [self getipstring];
    NSArray *myarray = [strongip componentsSeparatedByString:@"."];
    if (![myarray[0] isEqualToString:@"192"]) {
        [self showAlertView:@"请检查wifi"];
        strongip = [self routerIp];
    }
    

    
//    if (ipstring.length==0) {
//        UIAlertView *aletr= [[UIAlertView alloc]initWithTitle:@"意思" message:@"ip没有获取" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//        [aletr show];
//        return;
//    }
    
    
    NSString *dhcpString = [NSString stringWithFormat:@"http://%@/goform/wirelessMode?wds_list=1&extra_mode=apclient&ssid=%@&channel=%@&wds_1=&wds_2=&security=psk+psk2&wep_default_key=1&wep_key_1=ASCII&WEP1Select=1&wep_key_2=ASCII&WEP2Select=1&wep_key_3=ASCII&WEP3Select=1&wep_key_4=ASCII&WEP4Select=1&cipher=aes&passphrase=%@&keyRenewalInterval=3600",ipstring11111,name,Id,pwd];

    
    DLog(@"桥接url＝＝＝＝＝＝＝＝%@",dhcpString);
//    DLog(@"桥接");
//    cx_count = 0;

    NSURL *dhcpURL = [NSURL URLWithString:dhcpString];
    ASIFormDataRequest *dhcplist = [[ASIFormDataRequest alloc]initWithURL:dhcpURL];
    
    [dhcplist setCompletionBlock:^{
        _xiugaidhcp();
        DLog(@"桥接成功");
    }];
    
    [dhcplist setFailedBlock:^{
        NSLog(@"桥接失败 ");
        _xiugaidhcp();

//        [self WANsub:name lyid:Id wifipwd:pwd andnum:num];
        
    }];
    
//    [dhcplist setFailedBlock:^{
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"对不起，请检查云屏连接" delegate:self cancelButtonTitle:nil otherButtonTitles:@"已连接",@"暂不连接", nil];
//        alert.delegate = self;
//        alert.tag = 1000;
//        [alert show];
//        [alert release];
//    }];

    [dhcplist startAsynchronous];
}
//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//
//}


-(void)submitButtonClicked:(NSString *)ssid{

    //    NSString *ssid;
    //    if (isIP) {
    //        ssid=@"Tenda_5522B0";
    //    }else{
    //        ssid = wifiNameTextField.text;
    //    }
    //
    //
    //    if (([ssid length]<4)||([ssid length]>24)) {
    //        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"非法操作" message:@"WiFi名称长度应该为4到24个字符之间" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    //        [alert show];
    //        [alert release];
    //        return;
    //    }
    //    NSString *basewifi = @"http://192.168.0.1/goform/wirelessBasic?ssid=tenda_52222";
    //    NSURL *baseURL = [NSURL URLWithString:basewifi];
    //    ASIFormDataRequest *editSsid = [[ASIFormDataRequest alloc]initWithURL:baseURL];
    ////    [editSsid addPostValue:@"" forKey:@"rebootTag"];
    //    [editSsid addPostValue:@"wireless_basic.asp" forKey:@"GO"];
    //    [editSsid addPostValue:@"1" forKey:@"bssid_num"];
    ////    [editSsid addPostValue:ssid forKey:@"ssid"];
    //    [editSsid addPostValue:@"" forKey:@"mssid_1"];
    //    [editSsid addPostValue:@"0" forKey:@"WirelessT"];
    //    [editSsid addPostValue:@"0" forKey:@"wirelessmode"];
    //    [editSsid addPostValue:@"0" forKey:@"broadcastssid"];
    //    [editSsid addPostValue:@"0" forKey:@"sz11bChannel"];
    //    [editSsid addPostValue:@"0" forKey:@"ap_isolate"];
    //    [editSsid addPostValue:@"1" forKey:@"n_bandwidth"];
    //    [editSsid addPostValue:@"0" forKey:@"n_extcha"];
    //    [editSsid addPostValue:@"on" forKey:@"wmm_capable"];
    //    [editSsid addPostValue:@"off" forKey:@"apsd_capable"];
    //    [editSsid addPostValue:@"1" forKey:@"enablewireless"];
    //
    //    DLog(@"ssid = %@",ssid);
    //
    //
    //
    //    [editSsid setCompletionBlock:^{
    //        DLog(@"editSsid = %@",[editSsid responseString]);
    //    }];
    //    [editSsid setFailedBlock:^{
    //        DLog(@"editSsid2 = %@",[editSsid responseString]);
    //    }];
    //    [editSsid startAsynchronous];
    //    NSString *dhcpString = [NSString stringWithFormat:@"http://%@/goform/wirelessBasic?GO=wireless_basic.asp&bssid_num=1&enablewirelessEx=1&enablewireless=1&ssid=MERCURY_1111&mssid_1=&WirelessT=1&wirelessmode=9&broadcastssid=0&ap_isolate=0&sz11bChannel=8&n_bandwidth=1&n_extcha=0&wmm_capable=on&apsd_capable=off&wds_1=6C-59-40-57-43-24&ssid_1=MERCURY_4324&schannel_1=8&wds_2=&ssid_2=&schannel_2=&wds_3=&ssid_3=&schannel_3=&wds_4=&ssid_4=&schannel_4=&wds_list=6C-59-40-57-43-24",keyString];
    
    NSString *strongip = [self getipstring];
    NSArray *myarray = [strongip componentsSeparatedByString:@"."];
    if (![myarray[0] isEqualToString:@"192"]) {
        [self showAlertView:@"请检查wifi"];
        strongip = [self routerIp];
    }
    
    
    
    NSString *dhcpString = [NSString stringWithFormat:@"http://%@/goform/wirelessBasic?GO=wireless_basic.asp&en_wl=1&enablewireless=1&ssid=%@&mssid_1=&wirelessmode=9&broadcastssid=0&ap_isolate=0&channel=1&n_bandwidth=1&n_extcha=1&wmm_capable=on&apsd_capable=off&wl_power=HK",[self routerIp],ssid];
    
    DLog(@"信道请求url======%@",dhcpString);
    
    DLog(@"信道");
    NSURL *dhcpURL = [NSURL URLWithString:dhcpString];
    ASIFormDataRequest *dhcplist = [[ASIFormDataRequest alloc]initWithURL:dhcpURL];
    [dhcplist startAsynchronous];

    [dhcplist setFailedBlock:^{
       
        DLog(@"修改信道失败");
        _xiugaidhcp();
        
    }];
    
    [dhcplist setCompletionBlock:^{
        _xiugaidhcp();
        
    }];
    //    [self editPassword];
}

//重启路由器
-(void)rest{
    
    NSString *chongqi = [NSString stringWithFormat:@"http://%@/goform/SysToolReboot",[self routerIp]];
    DLog(@"重起");
    NSURL *cqURL = [NSURL URLWithString:chongqi];
    ASIFormDataRequest *cqList = [[ASIFormDataRequest alloc]initWithURL:cqURL];
    [cqList addPostValue:@"SYS_CONF" forKey:@"CMD"];
    [cqList addPostValue:@"system_reboot.asp" forKey:@"GO"];
    [cqList addPostValue:@"0" forKey:@"CCMD"];
    [cqList startAsynchronous];
    [self alert:[Config DPLocalizedString:@"adedit_wifi8"] alertMsg:[Config DPLocalizedString:@"adedit_wifi9"]];
}


//恢復出廠設置
-(void)hf{
    
    
    
    for (int i = 6; i>0; i--) {
        
        NSString *hf = [NSString stringWithFormat:@"http://192.168.0.%d/goform/SysToolRestoreSet",i];
        DLog(@"重置");
        NSURL *hfURL = [NSURL URLWithString:hf];
        
        ASIFormDataRequest *hfList = [[ASIFormDataRequest alloc]initWithURL:hfURL];
        
        [hfList addPostValue:@"SYS_CONF" forKey:@"CMD"];
        [hfList addPostValue:@"system_reboot.asp" forKey:@"GO"];
        [hfList addPostValue:@"0" forKey:@"CCMD"];
        
        [hfList startAsynchronous];
        
        [hfList setFailedBlock:^{
            
            //请求失败的时候调用
            
            DLog(@"请求失败");
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:            [NSString stringWithFormat:@"第%d个路由器重置失败!",i] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            return;
            
        }];

        
    }
    
    [self alert:[Config DPLocalizedString:@"adedit_wifi6"] alertMsg:[Config DPLocalizedString:@"adedit_wifi7"]];
    
}


/**
 *@brief 开始进度条
 */
-(void)startProgress{
    KKProgressTimer *myProgress = [[KKProgressTimer alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    [myProgress setCenter:CGPointMake(SCREEN_CGSIZE_WIDTH/2, SCREEN_CGSIZE_HEIGHT/2)];
    myProgress.delegate = self;
    [myProgress setTag:TAG_PROGRESS + 1];

    [self.view addSubview:myProgress];
    __block CGFloat i3 = 0;
    [myProgress startWithBlock:^CGFloat {
        return ((i3++ >= 50) ? (i3 = 0) : i3) / 50;
    }];
}

/**
 *@brief 停止进度条
 */
-(void)stopProgress:(UIView *)containtView{
    KKProgressTimer *oldProgress = (KKProgressTimer *)[containtView viewWithTag:TAG_PROGRESS + 1];
    [oldProgress stop];
    if (oldProgress) {
        [oldProgress removeFromSuperview];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == TAG_OPEN_SETTING) {
        DLog(@"打开设置");
        [self.view removeFromSuperview];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=WiFi"]];
    }
    if (alertView.tag == 1000) {
        if (buttonIndex == 0) {
            cx_count ++;
            if (cx_count == 1) {
                [self WANsub:lyname lyid:lyid wifipwd:lypwd];

            }
        }
    }
}


//栏目标题segmentControl
- (void)inserSegmentView
{
    admoduleHeight = 0;
    if ([secondMenuArray count]>0) {
        admoduleHeight=50;
        YGPtitleArray = [[NSMutableArray alloc] init];
        for (int i=0; i<[secondMenuArray count]; i++) {
            [YGPtitleArray addObject:[(DataColumns*)[secondMenuArray objectAtIndex:i] column_name]];
        }
        if (_ygp) {
            [_ygp removeFromSuperview];
        }
        if (DEVICE_IS_IPAD) {
            _ygp = [[YGPSegmentedController alloc] initContentTitleContaintFrame:YGPtitleArray CGRect:CGRectMake(70, 0, SCREEN_CGSIZE_HEIGHT - 70/* *2 */,admoduleHeight) ContaintFrame:CGRectMake(71, 1, SCREEN_CGSIZE_HEIGHT - 72,admoduleHeight)];
        }else {
            _ygp = [[YGPSegmentedController alloc] initContentTitleContaintFrame:YGPtitleArray CGRect:CGRectMake(0, 0, SCREEN_CGSIZE_WIDTH,admoduleHeight) ContaintFrame:CGRectMake(0, 0, SCREEN_CGSIZE_WIDTH,admoduleHeight)];
        }
        [_ygp setDelegate:self];
        [_ygp setUserInteractionEnabled:YES];
        [self.view setUserInteractionEnabled:YES];
        [self.view addSubview:_ygp];
    }
    DLog(@"admoduleHeight = %d\nYGPtitleArray = %@",admoduleHeight, YGPtitleArray);
}



+ (NSString *)localIPAddress
{
    NSString *localIP = nil;
    struct ifaddrs *addrs;
    
    if (getifaddrs(&addrs)==0) {
        const struct ifaddrs *cursor = addrs;
        while (cursor != NULL) {
            if (cursor->ifa_addr->sa_family == AF_INET && (cursor->ifa_flags & IFF_LOOPBACK) == 0)
            {
                NSString *name = [NSString stringWithUTF8String:cursor->ifa_name];
                if ([name isEqualToString:@"en0"]) // Wi-Fi adapter
                {
                    localIP = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)cursor->ifa_addr)->sin_addr)];
                    break;
                }
            }
            cursor = cursor->ifa_next;
        }
        freeifaddrs(addrs);
    }
    return localIP;
}



- (NSString *)getBSSID
{
    NSDictionary *dic = [self getWIFIDic];
    if (dic == nil) {
        return nil;
    }
    return dic[@"BSSID"];
}




- (NSDictionary *)getWIFIDic
{
    CFArrayRef myArray = CNCopySupportedInterfaces();
    if (myArray != nil) {
        CFDictionaryRef myDict = CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(myArray, 0));
        if (myDict != nil) {
            NSDictionary *dic = (NSDictionary*)CFBridgingRelease(myDict);
            return dic;
        }
    }
    return nil;
}




- (NSString *)routerIp
{
    
    
    int i = 0;
    
    
    NSString *string = [self getipstring];
    
    NSArray *array = [string componentsSeparatedByString:@"."];
    if (![array[0] isEqualToString:@"192"]) {
        [self showAlertView:@"请选择wifi"];
    }
    
    
    while ((![array[0] isEqualToString:@"192"])&&i<50) {
        sleep(3);
        string = [self getipstring];
        
        array = [string componentsSeparatedByString:@"."];
        i++;
        
    }
    
    return string;
    

    
    
    
}

-(NSString *)getipstring
{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0)
    {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        //*/
        while(temp_addr != NULL)
        /*/
         int i=255;
         while((i--)>0)
         //*/
        {
            if(temp_addr->ifa_addr->sa_family == AF_INET)
            {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"])
                {
                    // Get NSString from C String //ifa_addr
                    //ifa->ifa_dstaddr is the broadcast address, which explains the "255's"
                    //                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_dstaddr)->sin_addr)];
                    
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                    
                    //routerIP----192.168.1.255 广播地址
                    NSLog(@"broadcast address--%@",[NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_dstaddr)->sin_addr)]);
                    //--192.168.1.106 本机地址
                    NSLog(@"local device ip--%@",[NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)]);
                    //--255.255.255.0 子网掩码地址
                    NSLog(@"netmask--%@",[NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_netmask)->sin_addr)]);
                    //--en0 端口地址
                    NSLog(@"interface--%@",[NSString stringWithUTF8String:temp_addr->ifa_name]);
                    
                }
                
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    // Free memory
    freeifaddrs(interfaces);
    
    
    
    in_addr_t i =inet_addr([address cStringUsingEncoding:NSUTF8StringEncoding]);
    in_addr_t* x =&i;
    
    
    unsigned char *s=getdefaultgateway(x);
    NSString *ip=[NSString stringWithFormat:@"%d.%d.%d.%d",s[0],s[1],s[2],s[3]];
    free(s);
    
    
    DLog(@"ip=====%@",ip);
    return ip;

    
    
}



@end
