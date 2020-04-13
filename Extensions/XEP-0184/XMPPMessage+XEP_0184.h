#import <Foundation/Foundation.h>
#import "XMPPMessage.h"

NS_ASSUME_NONNULL_BEGIN
@interface XMPPMessage (XEP_0184)

@property (nonatomic, readonly) BOOL hasDeliveryReceiptRequest;
@property (nonatomic, readonly) BOOL hasDeliveryReceiptResponse;
@property (nonatomic, readonly, nullable) NSString *deliveryReceiptResponseID;
@property (nonatomic, readonly, nullable) XMPPMessage *generateDeliveryReceiptResponse;

- (void)addDeliveryReceiptRequest;

@end
NS_ASSUME_NONNULL_END
