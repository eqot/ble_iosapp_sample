#import <Foundation/Foundation.h>
#import "RCTBridgeModule.h"

@interface RCT_EXTERN_MODULE(BLE2, NSObject)

RCT_EXTERN_METHOD(addEvent:(NSString *)name location:(NSString *)location)
RCT_EXTERN_METHOD(startScanning:(RCTResponseSenderBlock)callback)
RCT_EXTERN_METHOD(stopScanning)
RCT_EXTERN_METHOD(connect:(NSString *)name)

@end
