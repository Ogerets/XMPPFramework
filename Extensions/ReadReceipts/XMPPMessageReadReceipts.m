//
//  XMPPMessageReadReceipts.m
//  XMPPFramework
//
//  Created by Yevhen Pyvovarov on 4/5/20.
//  Copyright © 2020 XMPPFramework. All rights reserved.
//

#import "XMPPMessageReadReceipts.h"
#import "XMPPMessage+ReadReceipts.h"
#import "XMPPFramework.h"

#if ! __has_feature(objc_arc)
#warning This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#define XMLNS_URN_XMPP_READ_RECEIPTS @"urn:xmpp:read_receipts"

@implementation XMPPMessageReadReceipts

@synthesize autoSendMessageReadRequests;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Init/Dealloc
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (id)initWithDispatchQueue:(dispatch_queue_t)queue
{
    if((self = [super initWithDispatchQueue:queue]))
    {
        autoSendMessageReadRequests = NO;
    }
    
    return self;
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark XMPPModule
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)activate:(XMPPStream *)aXmppStream
{
    if ([super activate:aXmppStream])
    {
#ifdef _XMPP_CAPABILITIES_H
        [xmppStream autoAddDelegate:self delegateQueue:moduleQueue toModulesOfClass:[XMPPCapabilities class]];
#endif
        return YES;
    }
    
    return NO;
}

- (void)deactivate
{
#ifdef _XMPP_CAPABILITIES_H
    [xmppStream removeAutoDelegate:self delegateQueue:moduleQueue fromModulesOfClass:[XMPPCapabilities class]];
#endif
    
    [super deactivate];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Properties
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)autoSendMessageReadRequests
{
    __block BOOL result = NO;
    
    dispatch_block_t block = ^{
        result = self.autoSendMessageReadRequests;
    };
    
    if (dispatch_get_specific(moduleQueueTag))
        block();
    else
        dispatch_sync(moduleQueue, block);
    
    return result;
}

- (void)setAutoSendMessageReadRequests:(BOOL)flag
{
    dispatch_block_t block = ^{
        self.autoSendMessageReadRequests = flag;
    };
    
    if (dispatch_get_specific(moduleQueueTag))
        block();
    else
        dispatch_async(moduleQueue, block);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark XMPPStream Delegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
    if ([message hasReadReceiptResponse])
    {
        [multicastDelegate xmppMessageReadReceipts:self didReceiveReadReceiptResponseMessage:message];
    }
}
- (XMPPMessage *)xmppStream:(XMPPStream *)sender willSendMessage:(XMPPMessage *)message
{
    if(self.autoSendMessageReadRequests
       && [message to]
       && ![message isErrorMessage] && ![[[message attributeForName:@"type"] stringValue] isEqualToString:@"groupchat"]
       && [[message elementID] length]
       && ![message hasReadReceiptRequest] && ![message hasReadReceiptResponse])
    {
        [message addReadReceiptRequest];
    }
    
    return message;
}

@end

