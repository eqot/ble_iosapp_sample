#import "BLE.h"

#import <CoreBluetooth/CoreBluetooth.h>

#import "RCTBridge.h"
#import "RCTEventDispatcher.h"
#import "RCTLog.h"

@interface BLE () <CBCentralManagerDelegate>
@property (nonatomic, strong) CBCentralManager *centralManager;
@property (nonatomic, strong) CBPeripheral *peripheral;
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
  self.peripheral = peripheral;

  [self.bridge.eventDispatcher sendDeviceEventWithName:@"discoverPeripheral"
    body:@{
      @"name": peripheral.name
    }];
}

RCT_EXPORT_METHOD(stopScaning)
{
  [self.centralManager stopScan];
}

RCT_EXPORT_METHOD(connect:(NSInteger)index)
{
  RCTLogInfo(@"index: %d", index);

  [self.centralManager connectPeripheral:self.peripheral options:nil];
}

- (void) centralManager:(CBCentralManager *)central
   didConnectPeripheral:(CBPeripheral *)peripheral
{
  RCTLogInfo(@"Connected");
}

- (void) centralManager:(CBCentralManager *)central
  didFailToConnectPeripheral:(CBPeripheral *) peripheral
  error:(NSError *)error
{
  RCTLogInfo(@"Failed");
}

@end
