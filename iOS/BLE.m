#import "BLE.h"

#import <CoreBluetooth/CoreBluetooth.h>

#import "RCTBridge.h"
#import "RCTEventDispatcher.h"
#import "RCTLog.h"

@interface BLE () <CBCentralManagerDelegate, CBPeripheralDelegate>
@property (nonatomic, strong) CBCentralManager *centralManager;
@property (nonatomic, strong) CBPeripheral *peripheral;
@end

@implementation BLE

RCT_EXPORT_MODULE()

@synthesize bridge = _bridge;

RCT_EXPORT_METHOD(startScaning)
{
  self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];

  RCTLogInfo(@"Start scanning.");
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
  RCTLogInfo(@"state:%ld", (long)central.state);

  switch (central.state) {
    case CBCentralManagerStatePoweredOn:
      [self.centralManager stopScan];
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

  if (peripheral.name == nil) {
    return;
  }

  [self.bridge.eventDispatcher sendDeviceEventWithName:@"discoverPeripheral"
    body:@{
      @"name": peripheral.name,
      @"identifier": peripheral.identifier.UUIDString
    }];
}

RCT_EXPORT_METHOD(stopScaning)
{
  [self.centralManager stopScan];
}

RCT_EXPORT_METHOD(connect:(NSString *)name)
{
  RCTLogInfo(@"Connecting to %@", name);

  [self.centralManager connectPeripheral:self.peripheral options:nil];
}

- (void) centralManager:(CBCentralManager *)central
   didConnectPeripheral:(CBPeripheral *)peripheral
{
  RCTLogInfo(@"Connected");

  peripheral.delegate = self;
  [peripheral discoverServices:nil];
}

- (void) centralManager:(CBCentralManager *)central
  didFailToConnectPeripheral:(CBPeripheral *) peripheral
  error:(NSError *)error
{
  RCTLogInfo(@"Failed");
}

- (void)   peripheral:(CBPeripheral *)peripheral
  didDiscoverServices:(NSError *)error
{
  NSArray *services = peripheral.services;
  RCTLogInfo(@"%lu services: %@", (unsigned long)services.count, services);

  for (CBService *service in services) {
    [peripheral discoverCharacteristics:nil forService:service];
  }
}

- (void)                    peripheral:(CBPeripheral *)peripheral
  didDiscoverCharacteristicsForService:(CBService *)service
                                 error:(NSError *)error
{
  NSArray *characteristics = service.characteristics;
  RCTLogInfo(@"%lu characteristics: %@", (unsigned long)characteristics.count, characteristics);

  for (CBCharacteristic *characteristic in characteristics) {
    if (characteristic.properties == CBCharacteristicPropertyRead) {
      [peripheral readValueForCharacteristic:characteristic];
    }
  }
}

- (void)               peripheral:(CBPeripheral *)peripheral
  didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic
                            error:(NSError *)error
{
  RCTLogInfo(@"Read. serivce uuid:%@, characteristic uuid:%@, value:%@",
    characteristic.service.UUID, characteristic.UUID, characteristic.value);
}

@end
