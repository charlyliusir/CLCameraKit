//
//  SocketServer.m
//  WiFiDemo
//
//  Created by apple on 16/6/3.
//  Copyright © 2016年 刘朝龙. All rights reserved.
//

#import "SocketServer.h"
#import "GCDAsyncSocket.h"

@interface SocketServer () <GCDAsyncSocketDelegate>
@property (nonatomic, strong)GCDAsyncSocket *asyncSocket;


@end

@implementation SocketServer


- (instancetype)init
{
    if (self = [super init]) {
        
        self.asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
        
    }
    return self;
}

- (void)dealloc
{
    _asyncSocket.delegate = nil;
    _asyncSocket = nil;
}

- (void)connectWithHost:(NSString *)hostName port:(int)port
{
    NSError *error = nil;
    [_asyncSocket connectToHost:hostName onPort:port error:&error];
    if (error) {
        if (_delegate && [_delegate respondsToSelector:@selector(didDisconnectWithError:)]) {
            [_delegate didDisconnectWithError:error];
        }
    }
}

- (void)disconnect
{
    [_asyncSocket disconnect];
}

- (BOOL)isConnected
{
    return [_asyncSocket isConnected];
}

- (void)readDataWithTimeout:(NSTimeInterval)timeout tag:(long)tag
{
    [_asyncSocket readDataWithTimeout:timeout tag:tag];
}

- (void)writeData:(NSData *)data timeout:(NSTimeInterval)timeout tag:(long)tag
{
    [_asyncSocket writeData:data withTimeout:timeout tag:tag];
}

#pragma mark -
#pragma mark GCDAsyncSocketDelegate method

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(nullable NSError *)err
{
    if (_delegate && [_delegate respondsToSelector:@selector(didDisconnectWithError:)]) {
        [_delegate didDisconnectWithError:nil];
    }
}

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    if (_delegate && [_delegate respondsToSelector:@selector(didConnectToHost:port:)]) {
        [_delegate didConnectToHost:host port:port];
    }
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    if (_delegate && [_delegate respondsToSelector:@selector(didReceiveData:tag:)]) {
        [_delegate didReceiveData:data tag:tag];
    }
    [sock readDataWithTimeout:-1 tag:tag];
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    [sock readDataWithTimeout:-1 tag:tag];
}

@end
