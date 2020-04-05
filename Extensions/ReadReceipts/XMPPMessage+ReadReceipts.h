//
//  XMPPMessage+ReadReceipts.h
//  XMPPFramework
//
//  Created by Yevhen Pyvovarov on 4/5/20.
//  Copyright © 2020 XMPPFramework. All rights reserved.
//

#ifndef XMPPMessage_ReadReceipts_h
#define XMPPMessage_ReadReceipts_h

#import <Foundation/Foundation.h>
#import "XMPPMessage.h"

NS_ASSUME_NONNULL_BEGIN
@interface XMPPMessage (ReadReceipts)

@property (nonatomic, readonly) BOOL hasReadReceiptRequest;
@property (nonatomic, readonly) BOOL hasReadReceiptResponse;
@property (nonatomic, readonly, nullable) NSString *readReceiptResponseID;
@property (nonatomic, readonly, nullable) XMPPMessage *generateReadReceiptResponse;

// Global read receipt for all messages
+ (XMPPMessage *)generateReadReceiptForJid:(NSString *)jid;

- (void)addReadReceiptRequest;

@end
NS_ASSUME_NONNULL_END

#endif /* XMPPMessage_ReadReceipts_h */
