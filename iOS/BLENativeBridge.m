#import <Foundation/Foundation.h>
#import "RCTBridgeModule.h"

@interface RCT_EXTERN_MODULE(BLENative, NSObject)

RCT_EXTERN_METHOD(startScanning:(NSString *)name callback:(RCTResponseSenderBlock)callback)
RCT_EXTERN_METHOD(stopScanning)
RCT_EXTERN_METHOD(connect:(NSString *)name callback:(RCTResponseSenderBlock)callback)
RCT_EXTERN_METHOD(discoverServices:(RCTResponseSenderBlock)callback)
RCT_EXTERN_METHOD(discoverCharacteristics:(NSString *)uuid callback:(RCTResponseSenderBlock)callback)
RCT_EXTERN_METHOD(read:(NSString *)uuid callback:(RCTResponseSenderBlock)callback)
RCT_EXTERN_METHOD(write:(NSString *)uuid value:(NSInteger)value callback:(RCTResponseSenderBlock)callback)

@end
