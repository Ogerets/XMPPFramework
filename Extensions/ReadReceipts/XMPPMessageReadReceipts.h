//
//  XMPPMessageReadReceipts.h
//  XMPPFramework
//
//  Created by Yevhen Pyvovarov on 4/5/20.
//  Copyright © 2020 XMPPFramework. All rights reserved.
//

#ifndef XMPPMessageReadReceipts_h
#define XMPPMessageReadReceipts_h

#import "XMPPModule.h"

#define _XMPP_MESSAGE_READ_RECEIPTS_H

@class XMPPMessage;

/**
 * XMPPMessageReadReceipts can be configured to automatically send read receipts and requests
**/

NS_ASSUME_NONNULL_BEGIN
@interface XMPPMessageReadReceipts : XMPPModule

/**
 * Automatically add message read requests to outgoing messages
 *
 * - Message MUST NOT be of type 'error' or 'groupchat'
 * - Message MUST have an id
 * - Message MUST NOT have a delivery receipt or request
 * - To must either be a bare JID or a full JID that advertises the urn:xmpp:receipts capability
 *
 * Default NO
**/

@property (assign) BOOL autoSendMessageReadRequests;

@end

/**
 * A protocol defining @c XMPPManagedMessaging module delegate API.
**/
@protocol XMPPMessageReadReceiptsDelegate <NSObject>

@optional

/**
 * Notifies the delegate of a receipt response message received in the stream.
**/
- (void)xmppMessageReadReceipts:(XMPPMessageReadReceipts *)xmppMessageReadReceipts didReceiveReadReceiptResponseMessage:(XMPPMessage *)message;

@end
NS_ASSUME_NONNULL_END


#endif /* XMPPMessageReadReceipts_h */
