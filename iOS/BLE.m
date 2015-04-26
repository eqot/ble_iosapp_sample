#import "BLE.h"

#import <CoreBluetooth/CoreBluetooth.h>

#import "RCTBridge.h"
#import "RCTEventDispatcher.h"
#import "RCTLog.h"

@interface BLE () <CBCentralManagerDelegate>

@property (nonatomic, strong) CBCentralManager *centralManager;

@end

@implementation BLE

RCT_EXPORT_MODULE()

@synthesize bridge = _bridge;

RCT_EXPORT_METHOD(startScaning)
{
  self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];

  RCTLogInfo(@"Pretending to create a");
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
  RCTLogInfo(@"state:%ld", (long)central.state);

  switch (central.state) {
    case CBCentralManagerStatePoweredOn:
      [self.centralManager scanForPeripheralsWithServices:nil options:nil];
      break;

    default:
      break;
  }
}

- (void) centralManager:(CBCentralManager *)central
  didDiscoverPeripheral:(CBPeripheral *)peripheral
      advertisementData:(NSDictionary *)advertisementData
                   RSSI:(NSNumber *)RSSI
{
  RCTLogInfo(@"peripheral:%@", peripheral);

  [self.bridge.eventDispatcher sendDeviceEventWithName:@"discoverPeripheral"
    body:@{
      @"name": peripheral.name
    }];
}

RCT_EXPORT_METHOD(stopScaning)
{
  [self.centralManager stopScan];
}

@end
