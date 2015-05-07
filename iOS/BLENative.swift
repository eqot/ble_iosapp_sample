import Foundation
import CoreBluetooth

@objc(BLENative)
class BLENative: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
  var centralManager: CBCentralManager!
  var peripherals: Array<CBPeripheral>!
  var peripheral: CBPeripheral!
  var characteristics: NSArray!

  var callbackOnPeripheralsDiscovered: ((NSArray) -> Void)!
  var callbackOnPeripheralConnected: ((NSArray) -> Void)!
  var callbackOnServicesDiscovered: ((NSArray) -> Void)!
  var callbackOnCharacteristicsDiscovered: ((NSArray) -> Void)!
  var callbackOnValueRead: ((NSArray) -> Void)!

  @objc func startScanning(callback: (NSArray) -> Void) -> Void {
    self.callbackOnPeripheralsDiscovered = callback

    self.peripherals = []
    self.centralManager = CBCentralManager(delegate: self, queue: nil)
  }

  func centralManagerDidUpdateState(central: CBCentralManager!) {
    switch (central.state) {
      case CBCentralManagerState.PoweredOn:
        self.scanPeripherals()
        break;

      default:
        break;
    }
  }

  @objc func stopScanning() -> Void {
    self.centralManager.stopScan()
  }

  func scanPeripherals() {
    self.centralManager.scanForPeripheralsWithServices(nil, options: nil)
  }

  func centralManager(central: CBCentralManager!,
    didDiscoverPeripheral peripheral: CBPeripheral!,
    advertisementData: [NSObject: AnyObject]!,
    RSSI: NSNumber!)
  {
    if (findPeripheral(peripheral.name) == -1) {
      self.peripherals.append(peripheral)
    }
    println("\(self.peripherals)")

    self.callbackOnPeripheralsDiscovered([peripheral.name, peripheral.identifier.UUIDString])
  }

  func findPeripheral(name: NSString) -> NSInteger {
    for (index, peripheral) in enumerate(self.peripherals) {
      if peripheral.name == name {
        return index
      }
    }

    return -1
  }

  @objc func connect(name: NSString, callback: (NSArray) -> Void) -> Void {
    println("Connecting to \(name)")

    self.callbackOnPeripheralConnected = callback

    let index = findPeripheral(name)
    if (index == -1) {
      return
    }
    self.peripheral = self.peripherals[index]

    self.centralManager.connectPeripheral(self.peripheral, options: nil)
  }

  func centralManager(central: CBCentralManager!,
    didConnectPeripheral peripheral: CBPeripheral!)
  {
    println("Connected")

    self.callbackOnPeripheralConnected([])
  }

  func centralManager(central: CBCentralManager!,
    didFailToConnectPeripheral peripheral: CBPeripheral!,
    error: NSError!)
  {
    println("Failed to connect")
  }

  @objc func discoverServices(callback: (NSArray) -> Void) -> Void {
    self.callbackOnServicesDiscovered = callback

    self.characteristics = []
    self.peripheral.delegate = self
    self.peripheral.discoverServices(nil)
  }

  func peripheral(peripheral: CBPeripheral,
    didDiscoverServices error: NSError!)
  {
    let services: NSArray = peripheral.services
    println("Found \(services.count) services: \(services)")

    var uuids: Array<String> = []
    for obj in services {
      if let service = obj as? CBService {
        uuids.append(service.UUID.UUIDString)
      }
    }

    self.callbackOnServicesDiscovered([uuids])
  }

  @objc func discoverCharacteristics(uuid: NSString, callback: (NSArray) -> Void) -> Void {
    self.callbackOnCharacteristicsDiscovered = callback

    var index = findService(uuid)
    if (index == -1) {
      return
    }

    self.peripheral.discoverCharacteristics(nil, forService: self.peripheral.services[index] as! CBService)
  }

  func findService(uuid: NSString) -> NSInteger {
    for (index, obj) in enumerate(peripheral.services) {
      if let service = obj as? CBService {
        if (service.UUID.UUIDString == uuid) {
          return index
        }
      }
    }

    return -1
  }

  func peripheral(peripheral: CBPeripheral!,
    didDiscoverCharacteristicsForService service: CBService!,
    error: NSError!)
  {
    let characteristics: NSArray = service.characteristics
    println("Found \(characteristics.count) characteristics: \(characteristics)")

    self.characteristics = service.characteristics

    var uuids: Array<String> = []
    for obj in characteristics {
      if let characteristic = obj as? CBCharacteristic {
        uuids.append(characteristic.UUID.UUIDString)
      }
    }

    self.callbackOnCharacteristicsDiscovered([uuids])

  }

  @objc func read(uuid: NSString, callback: (NSArray) -> Void) -> Void {
    self.callbackOnValueRead = callback

    let index = findCharacteristic(uuid)
    if (index == -1) {
      return
    }

    self.peripheral.readValueForCharacteristic(self.characteristics[index] as! CBCharacteristic)
  }

  func findCharacteristic(uuid: NSString) -> NSInteger {
    for (index, obj) in enumerate(self.characteristics) {
      if let characteristic = obj as? CBCharacteristic {
        if (characteristic.UUID.UUIDString == uuid) {
          return index
        }
      }
    }

    return -1
  }

  func peripheral(peripheral: CBPeripheral!,
    didUpdateValueForCharacteristic characteristic: CBCharacteristic!,
    error: NSError!)
  {
    println("service uuid: \(characteristic.service.UUID), characteristic uuid: \(characteristic.UUID), value: \(characteristic.value)")

    if (characteristic.value != nil) {
      var value: CUnsignedChar = 0
      characteristic.value.getBytes(&value, length: 1)
      self.callbackOnValueRead([NSInteger(value)])
    } else {
      self.callbackOnValueRead([-1])
    }
  }
}
