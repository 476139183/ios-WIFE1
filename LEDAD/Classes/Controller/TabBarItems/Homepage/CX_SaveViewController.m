//
//  CX_SaveViewController.m
//  LEDAD
//   创建项目
//  Created by chengxu on 15/5/15.
//  Copyright (c) 2015年 yxm. All rights reserved.
//

#import "CX_SaveViewController.h"
#import "GDataXMLNode.h"
#import "XMLDictionary.h"
#import "NSString+MD5.h"
#import "Config.h"
#import "MyProjectListViewController.h"
#import "Common.h"
@interface CX_SaveViewController ()
{
    UITextField *textfield;
    NSInteger fileSize;
    NSString *xmlfilePath;
    NSString *nametime;
    NSString *stringpath;
}
@end

@implementation CX_SaveViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    ALAssetRepresentation* representation = [_asset defaultRepresentation];
    NSString* filename = [representation filename];
    
    DLog(@"filename===%@",filename);
    
    NSArray *b = [filename componentsSeparatedByString:@"."];
    NSString *str = [NSString stringWithFormat:@"%@%@",b[0],[self getNowdateString]];
    nametime = [NSString stringWithFormat:@"%@",[str md5Encrypt]];
//    DLog(@"%@",nametime);
    stringpath = [self documentGroupXMLDir];
    
    [self initview];
//    [self addshoushi];
    // Do any additional setup after loading the view.
}



//加载视图
-(void)initview{
    
    ALAssetRepresentation* representation = [_asset defaultRepresentation];
    NSString* filename = [representation filename];
    NSArray *b = [filename componentsSeparatedByString:@"."];
//    UIView * v1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//    v1.backgroundColor=[UIColor whiteColor];
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(50, 100, 220, 50)];
    
    lable.text=[Config DPLocalizedString:@"write_video"];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.font = [UIFont systemFontOfSize:13];
    textfield = [[UITextField alloc]initWithFrame:CGRectMake(lable.frame.origin.x, lable.frame.origin.y+70, lable.frame.size.width, lable.frame.size.height)];
    textfield.text = b[0];
    textfield.borderStyle = UITextBorderStyleLine;
    
    
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(textfield.frame.origin.x, textfield.frame.origin.y+70, textfield.frame.size.width, textfield.frame.size.height)];
    btn.backgroundColor=[UIColor blackColor];
    
//    保存
    [btn setTitle:[Config DPLocalizedString:@"Save"] forState:0];
    [btn setTitleColor:[UIColor redColor] forState:0];
    [btn addTarget:self action:@selector(abc:) forControlEvents:UIControlEventTouchUpInside];
//    [btn addTarget:self action:@selector(createpro:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:lable];
    [self.view addSubview:textfield];
    [self.view addSubview:btn];
}

-(void)abc:(id)sender{
    NSLog(@"进来了");
    
    
     [textfield resignFirstResponder];
    
    //保存素材
    [self createxml];
    
    
    _buttonOnClick();
    
}

//保存项目
-(void)createpro:(UIButton *)sender
{
    
    


   

    
   
     _buttonOnClick();
   
}



//创建项目xml
-(void)createxml{
    GDataXMLElement *rootElement = [GDataXMLNode elementWithName:@"project"];
    GDataXMLElement *projectName = [GDataXMLNode elementWithName:@"projectName" stringValue:textfield.text];
    [rootElement addChild:projectName];
    GDataXMLElement *textElement = [GDataXMLNode elementWithName:@"text"];
    GDataXMLElement *textContent = [GDataXMLNode elementWithName:@"textContent"];
    [textElement addChild:textContent];
    GDataXMLElement *textRColorElement = [GDataXMLNode elementWithName:@"textRColor" stringValue:[NSString stringWithFormat:@"%d",251]];
    [textElement addChild:textRColorElement];
    GDataXMLElement *textGColorElement = [GDataXMLNode elementWithName:@"textGColor" stringValue:[NSString stringWithFormat:@"%d",251]];
    [textElement addChild:textGColorElement];
    GDataXMLElement *textBColorElement = [GDataXMLNode elementWithName:@"textBColor" stringValue:[NSString stringWithFormat:@"%d",251]];
    [textElement addChild:textBColorElement];
    GDataXMLElement *textBackgroundRColorElement = [GDataXMLNode elementWithName:@"textBackgroundRColor" stringValue:[NSString stringWithFormat:@"%d",2]];
    [textElement addChild:textBackgroundRColorElement];
    GDataXMLElement *textBackgroundGColorElement = [GDataXMLNode elementWithName:@"textBackgroundGColor" stringValue:[NSString stringWithFormat:@"%d",5]];
    [textElement addChild:textBackgroundGColorElement];
    GDataXMLElement *textBackgroundBColorElement = [GDataXMLNode elementWithName:@"textBackgroundBColor" stringValue:[NSString stringWithFormat:@"%d",2]];
    [textElement addChild:textBackgroundBColorElement];
    GDataXMLElement *textBackgroundAlphaElement = [GDataXMLNode elementWithName:@"textBackgroundAlpha" stringValue:@"0.0100"];
    [textElement addChild:textBackgroundAlphaElement];
    //字体大小
    GDataXMLElement *textFontSizeElement = [GDataXMLNode elementWithName:@"textFontSize" stringValue:@"18"];
    [textElement addChild:textFontSizeElement];
    //字体名称
    GDataXMLElement *textFontNameElement = [GDataXMLNode elementWithName:@"textFontName" stringValue:@"Arial"];
    [textElement addChild:textFontNameElement];
    //文字滚动速度
    GDataXMLElement *textRollingSpeedElement = [GDataXMLNode elementWithName:@"textRollingSpeed" stringValue:@"2"];
    [textElement addChild:textRollingSpeedElement];
    //文字区域的原点X
    GDataXMLElement *textRegionXElement = [GDataXMLNode elementWithName:@"textX" stringValue:@"0"];
    [textElement addChild:textRegionXElement];
    //文字区域的原点Y
    GDataXMLElement *textRegionYElement = [GDataXMLNode elementWithName:@"textY" stringValue:@"98"];
    [textElement addChild:textRegionYElement];
    //文字区域的宽度
    GDataXMLElement *textRegionWElement = [GDataXMLNode elementWithName:@"textW" stringValue:@"512"];
    [textElement addChild:textRegionWElement];
    //文字区域的高度
    GDataXMLElement *textRegionHElement = [GDataXMLNode elementWithName:@"textH" stringValue:@"46"];
    [textElement addChild:textRegionHElement];
    [rootElement addChild:textElement];

    GDataXMLElement *masterScreenFrameElement = [GDataXMLNode elementWithName:@"masterScreenFrame"];
    //X
    GDataXMLElement *masterScreenXElement = [GDataXMLElement elementWithName:@"masterScreenX" stringValue:@"0"];
    [masterScreenFrameElement addChild:masterScreenXElement];
    //Y
    GDataXMLElement *masterScreenYElement = [GDataXMLElement elementWithName:@"masterScreenY" stringValue:@"0"];
    [masterScreenFrameElement addChild:masterScreenYElement];
    //W
    GDataXMLElement *masterScreenWElement = [GDataXMLElement elementWithName:@"masterScreenW" stringValue:@"512"];
    [masterScreenFrameElement addChild:masterScreenWElement];
    //H
    GDataXMLElement *masterScreenHElement = [GDataXMLElement elementWithName:@"masterScreenH" stringValue:@"96"];
    [masterScreenFrameElement addChild:masterScreenHElement];
    [rootElement addChild:masterScreenFrameElement];

    GDataXMLElement *materialListElement = [GDataXMLNode elementWithName:@"materialListElement"];
    GDataXMLElement *selectAreaIndexElement = [GDataXMLElement elementWithName:@"key" stringValue:@"1004"];
    [materialListElement addChild:selectAreaIndexElement];
    GDataXMLElement *listItemElement = [GDataXMLElement elementWithName:@"listItemElement"];
    GDataXMLElement *itemIndex = [GDataXMLElement elementWithName:@"itemIndex" stringValue:@"item0"];
    [listItemElement addChild:itemIndex];
    GDataXMLElement *durationElement = [GDataXMLElement elementWithName:@"duration" stringValue:@"50"];
    [listItemElement addChild:durationElement];
    //filename
    ALAssetRepresentation* representation = [_asset defaultRepresentation];
    NSString* filename = [representation filename];
    NSArray *b = [filename componentsSeparatedByString:@"."];

    GDataXMLElement *filenameElement = [GDataXMLElement elementWithName:@"filename" stringValue:[NSString stringWithFormat:@"%@.%@",[b[0] md5Encrypt],b[1]]];
    [listItemElement addChild:filenameElement];
    //filetype
    GDataXMLElement *filetypeElement = [GDataXMLElement elementWithName:@"filetype" stringValue:@"Video"];
    [listItemElement addChild:filetypeElement];
    GDataXMLElement *xElement = [GDataXMLElement elementWithName:@"x" stringValue:@"0"];
    [listItemElement addChild:xElement];
    GDataXMLElement *yElement = [GDataXMLElement elementWithName:@"y" stringValue:@"0"];
    [listItemElement addChild:yElement];
    GDataXMLElement *wElement = [GDataXMLElement elementWithName:@"w" stringValue:@"160"];
    [listItemElement addChild:wElement];
    GDataXMLElement *hElement = [GDataXMLElement elementWithName:@"h" stringValue:@"640"];
    [listItemElement addChild:hElement];
    GDataXMLElement *directionElement = [GDataXMLElement elementWithName:@"direction" stringValue:@"0"];
    [listItemElement addChild:directionElement];
    GDataXMLElement *angleElement = [GDataXMLElement elementWithName:@"angle" stringValue:@"0"];
    [listItemElement addChild:angleElement];
    GDataXMLElement *video_frame_listElement = [GDataXMLNode elementWithName:@"video_frame_list"];
    
    GDataXMLElement *frameElement = [GDataXMLNode elementWithName:@"frame"];
    GDataXMLElement *fiElement = [GDataXMLElement elementWithName:@"i" stringValue:@"1"];
    [frameElement addChild:fiElement];
    GDataXMLElement *fxElement = [GDataXMLElement elementWithName:@"x" stringValue:[NSString stringWithFormat:@"%d",0]];
    [frameElement addChild:fxElement];
    GDataXMLElement *fyElement = [GDataXMLElement elementWithName:@"y" stringValue:[NSString stringWithFormat:@"%d",0]];
    [frameElement addChild:fyElement];
    GDataXMLElement *fwElement = [GDataXMLElement elementWithName:@"w" stringValue:[NSString stringWithFormat:@"%d",160]];
    [frameElement addChild:fwElement];
    GDataXMLElement *fhElement = [GDataXMLElement elementWithName:@"h" stringValue:[NSString stringWithFormat:@"%d",640]];
    [frameElement addChild:fhElement];
    GDataXMLElement *swElement = [GDataXMLElement elementWithName:@"sw" stringValue:@"1"];
    [frameElement addChild:swElement];
    GDataXMLElement *shElement = [GDataXMLElement elementWithName:@"sh" stringValue:@"1"];
    [frameElement addChild:shElement];
    [video_frame_listElement addChild:frameElement];
    [listItemElement addChild:video_frame_listElement];
    [materialListElement addChild:listItemElement];
    [rootElement addChild:materialListElement];
    //使用根节点创建xml文档
    GDataXMLDocument *rootDoc = [[GDataXMLDocument alloc] initWithRootElement:rootElement];
    DLog(@"11111%@",rootDoc);
    //设置使用的xml版本号
    [rootDoc setVersion:@"1.0"];
    //设置xml文档的字符编码
    [rootDoc setCharacterEncoding:@"utf-8"];
    //获取并打印xml字符串
    NSString *XMLDocumentString = [[NSString alloc] initWithData:rootDoc.XMLData encoding:NSUTF8StringEncoding];
    DLog(@"22%@",XMLDocumentString);
    //文件字节大小
    fileSize = [rootDoc.XMLData length];
    DLog(@"%ld",(long)fileSize);

    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    xmlfilePath = [NSString stringWithFormat:@"%@/%@.xml",stringpath,nametime];
    DLog(@"写入路径======%@",xmlfilePath);
    NSError *error = nil;
    BOOL writeFileBool = [XMLDocumentString writeToFile:xmlfilePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
    NSArray *files = [fileManager subpathsAtPath: documentsDirectoryPath];
    NSLog(@"%@",files);
    NSDictionary * dict = [fileManager attributesOfItemAtPath:xmlfilePath error:nil];
    //方法一:
    NSLog(@"22222222size = %lld",[dict fileSize]);
    
    
    
    if (writeFileBool) {
        
        
        [self aa];
        
        //保存到数据里面
        NSUserDefaults *mysqlarray = [NSUserDefaults standardUserDefaults];
        NSArray *_numarray = [mysqlarray objectForKey:@"mysqlprojects"];
        
        NSMutableArray *_yunsi = [[NSMutableArray alloc]initWithArray:_numarray];
        
        if (_yunsi.count==0) {
            
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            [dic setObject:[Config DPLocalizedString:@"adedit_Notgrouped"] forKey:@"name"];
            NSMutableArray *arr = [[NSMutableArray alloc]init];
            
            [dic setObject:arr forKey:@"myproject"];
            
            [_yunsi addObject:dic];
            
        }
        
        NSLog(@"=====%@",_yunsi);
        //
        NSDictionary *dic = _yunsi[0];
        
        NSArray *arr = dic[@"myproject"];
        
        
        NSMutableArray *nextarr = [NSMutableArray arrayWithArray:arr];
        
        
        
        NSLog(@"woyaode======%@",[xmlfilePath lastPathComponent]);
        NSString *onestr = [xmlfilePath lastPathComponent];
        //        新数组
        [nextarr addObject:onestr];
        
        NSMutableDictionary *mydic = [[NSMutableDictionary alloc]init];
        [mydic setObject:[Config DPLocalizedString:@"adedit_Notgrouped"] forKey:@"name"];
        [mydic setObject:nextarr forKey:@"myproject"];
        
        [_yunsi replaceObjectAtIndex:0 withObject:mydic];
        
        [mysqlarray removeObjectForKey:@"mysqlprojects"];
        
        [mysqlarray setObject:_yunsi forKey:@"mysqlprojects"];
        
        NSLog(@"woyaode======%@",_yunsi);
        
        

        
        
        
        
        
        
    }
}
//当前时间字符串
-(NSString *)getNowdateString{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYYMMddhhmmss"];
    return [formatter stringFromDate:[NSDate date]];
}

//添加单击手势
-(void)addshoushi{
    //添加单击手势
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                                    initWithTarget:self
                                                    action:@selector(tapGestureRecognizerNumberOf_one)];

    //设置手势点击次数 1
    [tapGestureRecognizer setNumberOfTapsRequired:1];

    //加载单击手势
    [self.view addGestureRecognizer:tapGestureRecognizer];
}


-(void)tapGestureRecognizerNumberOf_one
{
    if (textfield) {
        [textfield resignFirstResponder];
    }
}


-(void)showRestScreenSuccess{
    MyProjectListViewController *myProjectCtrl = [[MyProjectListViewController alloc]init];
    [myProjectCtrl reloadMyPlaylist];
}
//创建文件路径
-(NSString*)documentGroupXMLDir{
    DLog(@"%@",nametime);
    
    NSFileManager *myFileManager = [NSFileManager defaultManager];
 //   NSString *documentsGroupXMLDir = [[[[[[NSString stringWithFormat:@"%@",[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/ProjectCaches/%@",nametime]]]];

    NSString *documentsGroupXMLDir = [NSString stringWithFormat:@"%@",[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/ProjectCaches/%@",nametime]]];

    BOOL isDir;
    if (![myFileManager fileExistsAtPath:documentsGroupXMLDir isDirectory:&isDir]) {
        [myFileManager createDirectoryAtPath:[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/ProjectCaches/%@",nametime]] withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return documentsGroupXMLDir;
}
//视屏移到指定路径
-(void)aa{
    NSString * nsALAssetPropertyType = [_asset valueForProperty:ALAssetPropertyType];
    DLog(@"===%@",nsALAssetPropertyType);
    ALAssetRepresentation* representation = [_asset defaultRepresentation];
    NSString* filename = [representation filename];
    DLog(@"filename:%@",filename);
    NSArray *pathSeparatedArray = [[NSString stringWithFormat:@"%@",filename] componentsSeparatedByString:@"."];
    NSString *sExtString;
    NSString *myFilePath;
    NSString *pname1;
    if ([pathSeparatedArray count]==2) {
        pname1 = [pathSeparatedArray objectAtIndex:0];
        sExtString=[pathSeparatedArray objectAtIndex:1];
    }
    NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    if(!DEVICE_IS_IPAD){
        if ([nsALAssetPropertyType isEqualToString:@"ALAssetTypeVideo"]) {
            if (sExtString==nil) {
                sExtString = @"mov";
            }
        }else{
            if (sExtString==nil) {
                sExtString = @"PNG";
            }
        }
            myFilePath = [NSString stringWithFormat:@"%@/%@.%@",stringpath,[pname1 md5Encrypt],sExtString];

            NSString * pathString = [[NSString alloc]initWithString:myFilePath];
            DLog(@"移动的路径＝＝＝＝＝%@",pathString);
            NSUInteger size = [representation size];
            const int bufferSize = 65636;
            FILE *f = fopen([myFilePath cStringUsingEncoding:1], "wb+");
            if (f==NULL) {
            }
            Byte *buffer =(Byte*)malloc(bufferSize);
            int read =0, offset = 0;
            NSError *error;
            if (size != 0) {
                do {
                    read = [representation getBytes:buffer
                                         fromOffset:offset
                                             length:bufferSize
                                              error:&error];
                    fwrite(buffer, sizeof(char), read, f);
                    offset += read;
                } while (read != 0);
            }
            fclose(f);
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSDictionary * dict = [fileManager attributesOfItemAtPath:myFilePath error:nil];
            //方法一:
            NSLog(@"size = %lld",[dict fileSize]);
            NSArray *arr=[[NSArray alloc]init];
            arr=[fileManager subpathsOfDirectoryAtPath:DocumentsPath error:nil];
            DLog(@"%@",arr);
        
    }
//    [self showRestScreenSuccess];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
