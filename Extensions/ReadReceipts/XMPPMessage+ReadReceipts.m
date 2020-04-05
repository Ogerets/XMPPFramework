//
//  XMPPMessage+ReadReceipts.m
//  XMPPFramework
//
//  Created by Yevhen Pyvovarov on 4/5/20.
//  Copyright © 2020 XMPPFramework. All rights reserved.
//

#import "XMPPMessage+ReadReceipts.h"
#import "NSXMLElement+XMPP.h"
#import "XMPPMessage+XEP0045.h"

@implementation XMPPMessage (ReadReceipts)

- (BOOL)hasReadReceiptRequest
{
    NSXMLElement *receiptRequest = [self elementForName:@"request" xmlns:@"urn:xmpp:read_receipts"];
    
    return (receiptRequest != nil);
}

- (BOOL)hasReadReceiptResponse
{
    NSXMLElement *receiptResponse = [self elementForName:@"read" xmlns:@"urn:xmpp:read_receipts"];
    
    return (receiptResponse != nil);
}

- (NSString *)readReceiptResponseID
{
    NSXMLElement *receiptResponse = [self elementForName:@"read" xmlns:@"urn:xmpp:read_receipts"];
    
    return [receiptResponse attributeStringValueForName:@"id"];
}

- (XMPPMessage *)generateReadReceiptResponse
{
    // Example:
    //
    // <message to="juliet">
    //   <read xmlns="urn:xmpp:read_receipts" id="ABC-123"/>
    // </message>
    
    NSXMLElement *read = [NSXMLElement elementWithName:@"read" xmlns:@"urn:xmpp:read_receipts"];
    
    NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
    
    NSString *type = [self type];
    
    if (type) {
        [message addAttributeWithName:@"type" stringValue:type];
    }
    
    NSString *to = [self fromStr];
    
    if([self isGroupChatMessage]) {
        to = [[self from] bare];
        [message addAttributeWithName:@"type" stringValue:@"groupchat"];
    }
    
    if (to)
    {
        [message addAttributeWithName:@"to" stringValue:to];
    }
    
    NSString *msgid = [self elementID];
    if (msgid)
    {
        [read addAttributeWithName:@"id" stringValue:msgid];
    }
    
    [message addChild:read];
    
    return [[self class] messageFromElement:message];
}


- (void)addReadReceiptRequest
{
    NSXMLElement *receiptRequest = [NSXMLElement elementWithName:@"request" xmlns:@"urn:xmpp:read_receipts"];
    [self addChild:receiptRequest];
}

@end
