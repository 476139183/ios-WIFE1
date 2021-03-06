//
//  DYT_AsyModel.m
//  LEDAD
//
//  Created by laidiya on 15/7/20.
//  Copyright (c) 2015年 yxm. All rights reserved.
//

#import "DYT_AsyModel.h"
#import "AsyncSocket.h"
@interface DYT_AsyModel () <AsyncSocketDelegate>
{
    
    //soket连接
    AsyncSocket *_sendPlayerSocket;
    
    
    
}
@end


@implementation DYT_AsyModel
-(id)init
{
    self = [super init];
    if (self) {
        _isConnect = NO;
    }

    return self;
}

//启动连接
-(void)startSocket:(NSString *)string
{
    
    
    
    _sendPlayerSocket = [[AsyncSocket alloc] initWithDelegate:self];

    DLog(@"socketip====%@",string);
    
    _isConnect = NO;
    
    if (string) {
        if (!_isConnect) {
            
            _isConnect = [_sendPlayerSocket connectToHost:string onPort:PORT_OF_TRANSCATION_PLAY error:nil];
            
            [_sendPlayerSocket setRunLoopModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
            if (!_isConnect) {
                DLog(@"连接失败");
            }else{
                DLog(@"连接成功socket==%@",string);
            }
        }
    }else{
        _isConnect = NO;
        DLog(@"ipaddress is null");
    }


}


-(void)startSockettow:(NSString *)string
{
    //    if (!_sendPlayerSocket) {
    _sendPlayerSocket = [[AsyncSocket alloc] initWithDelegate:self];
    //    }
    
    
    _isConnect = NO;
    
    if (string) {
        if (!_isConnect) {
            
            _isConnect = [_sendPlayerSocket connectToHost:string onPort:PORT_OF_UPGRADE_SERVICE_IP error:nil];
            
            [_sendPlayerSocket setRunLoopModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
            if (!_isConnect) {
                DLog(@"连接失败");
            }else{
                DLog(@"连接成功");
            }
        }
    }else{
        _isConnect = NO;
        DLog(@"ipaddress is null");
    }
    


    
    
}


//获取屏幕亮度
-(void)getScreenbrightness;
{

    [self startSocket:ipAddressString];
    
    
     [self commandResetServerWithType:0x12 andContent:nil andContentLength:0];
    

}

//修改终端名称
-(void)changeTerminalname;
{

    [self startSocket:ipAddressString];

    [self commandResetServerWithType:0x19 andContent:nil andContentLength:0];

}

//重置云屏
-(void)ResetScreen:(NSString *)string
{
    [self startSocket:string];

    
    //0x20
    [self commandResetServerWithType:0x1C andContent:nil andContentLength:0];

}
//重启云屏
-(void)RestartScreen:(NSString *)string
{

    //    if (!_isConnect) {
    [self startSocket:string];
    //    }
    
    [self commandResetServerWithType:0x20 andContent:nil andContentLength:0];


}
//安全退出
-(void)SafetySignout:(NSString *)string
{
    //    if (!_isConnect) {
    [self startSocket:string];
    //    }
    
    
    [self commandResetServerWithType:0x16 andContent:nil andContentLength:0];
    


}

//多屏同步
-(void)moreScreensynchro:(NSData *)mydata
{
    //    if (!_isConnect) {
    [self startSocket:ipAddressString];
    //    }
    
    [_sendPlayerSocket writeData:mydata withTimeout:-1 tag:1];



}

-(void)quxiaoduolianpingtongbu:(NSString *)string;
{
    [self startSocket:string];
    //    }
    
    
    [self commandResetServerWithType:0x4c andContent:nil andContentLength:0];
    

   
    
    
}


#pragma mark-
//写屏幕亮度
-(void)commandResetServerWithType:(Byte)commandType andContent:(Byte[])contentBytes andContentLength:(NSInteger)contentLength
{
    
    int byteLength = 6;
    Byte outdate[byteLength];
    memset(outdate, 0x00, byteLength);
    outdate[0]=0x7D;
    outdate[1]=commandType;//命令类型
    outdate[2]=0x00; /*命令执行与状态检查2：获取服务器端的数据*/
    outdate[byteLength-3]=(Byte)byteLength;
    outdate[byteLength-2]=(Byte)(byteLength>>8);
    //计算校验码
    int sumByte = 0;
    for (int j=0; j<(byteLength-1); j++) {
        sumByte += outdate[j];
    }
    //校验码计算（包头到校验码前所有字段求和取反+1）
    outdate[(byteLength-1)]=~(sumByte)+1;
    long tag = outdate[1];
    DLog(@"恢复默认列表 = %d",(int)commandType);
    NSData *udpPacketData = [[NSData alloc] initWithBytes:outdate length:byteLength];
    DLog(@"udpPacketData=======%@",udpPacketData);
    [_sendPlayerSocket writeData:udpPacketData withTimeout:-1 tag:tag];
}

-(void)commandCompleteWithType:(Byte)commandType andSendType:(Byte)sendType andContent:(Byte[])contentBytes andContentLength:(NSInteger)contentLength andPageNumber:(NSInteger)pageNumber;
{
    
    
    int byteLength = 7;
    if (sendType == 0x01 ) {
        byteLength = 11 + contentLength;
    }
    DLog(@"byteLength = %d",byteLength);
    Byte outdate[byteLength];
    memset(outdate, 0x00, byteLength);
    outdate[0]=0x7D;
    outdate[1]=commandType;//命令类型
    outdate[2]=0x03; //传输数据到客户端
    outdate[3]=sendType;
    
    if (sendType == 0x01) {
        DLog(@"pageNumber = %d",pageNumber);
        pageNumber = pageNumber + 1;
        outdate[4]=(Byte)pageNumber;
        outdate[5]=(Byte)(pageNumber>>8);
        outdate[6]=(Byte)(pageNumber>>16);
        outdate[7]=(Byte)(pageNumber>>24);
        for (int i=0; i<contentLength; i++) {
            outdate[i+8]=contentBytes[i];
        }
    }
    outdate[byteLength-3]=(Byte)byteLength;
    outdate[byteLength-2]=(Byte)(byteLength>>8);
    int sumByte = 0;
    for (int j=0; j<(byteLength-1); j++) {
        sumByte += outdate[j];
    }
    //校验码计算（包头到校验码前所有字段求和取反+1）
    outdate[(byteLength-1)]=~(sumByte)+1;
    long tag = outdate[1];
    NSData *udpPacketData = [[NSData alloc] initWithBytes:outdate length:byteLength];
    if (pageNumber==TAG_MAX_NUMBER) {
        DLog(@"发送文件数据传输完成命令");
    }
    DLog(@"udpPacketData = %@",udpPacketData);
    [_sendPlayerSocket writeData:udpPacketData withTimeout:-1 tag:tag];
    
    
    
    
}


//云屏升级的重置
-(void)startSocketother:(NSString *)string
{
    //    if (!_sendPlayerSocket) {
    _sendPlayerSocket = [[AsyncSocket alloc] initWithDelegate:self];
    //    }
    
    
    _isConnect = NO;
    
    if (string) {
        if (!_isConnect) {
            
            _isConnect = [_sendPlayerSocket connectToHost:string onPort:PORT_OF_TRANSCATION_SERVICE_IP error:nil];
            
            [_sendPlayerSocket setRunLoopModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
            if (!_isConnect) {
                DLog(@"连接失败");
            }else{
                DLog(@"连接成功");
            }
        }
    }else{
        _isConnect = NO;
        DLog(@"ipaddress is null");
    }
    



}


-(void)Cloudscreenreset:(NSString *)string;
{
    [self startSocketother:string];
    
    [self commandResetServerWithType:0xd1 andContent:nil andContentLength:0];

    

}





#pragma mark - Socket
- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    DLog(@"%s %d", __FUNCTION__, __LINE__);
    [_sendPlayerSocket readDataWithTimeout: -1 tag: 0];
}

- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    DLog(@"%s %d, tag = %ld", __FUNCTION__, __LINE__, tag);
    DLog(@"段雨田写数据完成");
    [_sendPlayerSocket readDataWithTimeout: -1 tag: tag];
}

- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    DLog(@"返回的数据");
    //   Byte *AckByte = (Byte *)[data bytes];
    [_sendPlayerSocket readDataWithTimeout: -1 tag: tag];
    
    if (_mydelegate &&[_mydelegate respondsToSelector:@selector(returemydata:)]) {
        [_mydelegate returemydata:data];
    }
    
    
    
}

- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err
{
    DLog(@"willDisconnectWithError, err = %@", err);
}


- (void)onSocketDidDisconnect:(AsyncSocket *)sock
{
    DLog(@"反馈=%s %d", __FUNCTION__, __LINE__);
    if (isSendState) {
        UIAlertView *myAlertView = [[UIAlertView alloc]initWithTitle:[Config DPLocalizedString:@"adedit_xcoludsprompt"] message:[Config DPLocalizedString:@"adedit_netconnecterror"] delegate:self cancelButtonTitle:[Config DPLocalizedString:@"adedit_promptyes"] otherButtonTitles:nil, nil];
        [myAlertView show];
    }
}


-(void)lianxu:(NSString *)ip;
{
    [self startSocket:ip];
    
    [self commandCompleteWithType:0x2C andSendType:0x04 andContent:nil andContentLength:TAG_MAX_NUMBER andPageNumber:TAG_MAX_NUMBER];
    
    
}


-(void)fasong:(NSString *)ip;
{
    
    [self startSocket:ip];
    
    [self commandCompleteWithType:0x1D andSendType:0x04 andContent:nil andContentLength:TAG_MAX_NUMBER andPageNumber:TAG_MAX_NUMBER];
    
    
    
}
-(void)setscreenBrightness:(Byte)commandType andContent:(Byte[])contentBytes andContentLength:(NSInteger)contentLength and:(NSArray *)array

{
    //    [number addObject:[NSString stringWithFormat:@"%ld",(long)_alpha2]];
//    [number addObject:[NSString stringWithFormat:@"%ld",(long)_red2]];
//    [number addObject:[NSString stringWithFormat:@"%ld",(long)_green2]];
//    [number addObject:[NSString stringWithFormat:@"%ld",(long)_blue2]];

//    [number addObject:[NSString stringWithFormat:@"%ld",(long)_width2]];
//    [number addObject:[NSString stringWithFormat:@"%ld",(long)_height2]];

    
    NSInteger a = [array[4] intValue]%256;
    NSInteger b = [array[4] intValue]/256;
    NSInteger c = [array[5] intValue]%256;
    NSInteger d = [array[5] intValue]/256;
    int byteLength = 13;
    Byte outdate[byteLength];
    memset(outdate, 0x00, byteLength);
    outdate[0] = 0x7D;
    outdate[1] = commandType;//命令类型
    outdate[2] = 0x00; /*命令执行与状态检查2：获取服务器端的数据*/
    outdate[3] = [array[0] intValue];
    outdate[4] = [array[1] intValue];
    outdate[5] = [array[2] intValue];
    outdate[6] = [array[3] intValue];
    outdate[7]=a;
    outdate[8]=b;
    outdate[9]=c;
    outdate[10]=d;
    outdate[11]=9;
    outdate[12]=0xff;
    //    outdate[byteLength-3]=(Byte)byteLength;
    //    outdate[byteLength-2]=(Byte)(byteLength>>11);
    //计算校验码
    
    int sumByte = 0;
    for (int j=0; j<(byteLength-1); j++) {
        sumByte += outdate[j];
    }
    //校验码计算（包头到校验码前所有字段求和取反+1）
    outdate[(byteLength-1)]=~(sumByte)+1;
    long tag = outdate[1];
    DLog(@"恢复默认列表 = %d",(int)commandType);
    NSData *udpPacketData = [[NSData alloc] initWithBytes:outdate length:byteLength];
    DLog(@"udpPacketData=======%@",udpPacketData);
    [_sendPlayerSocket writeData:udpPacketData withTimeout:-1 tag:tag];


    
    
    
    
    
    

}

@end
