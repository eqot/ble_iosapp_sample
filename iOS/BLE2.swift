import Foundation
import CoreBluetooth

@objc(BLE2)
class BLE2: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
  var centralManager: CBCentralManager!
  var peripheral: CBPeripheral!

  @objc func addEvent(name: String, location: String) -> Void {
    println("BLE2 \(name) \(location)")
  }

  @objc func startScanning() -> Void {
    self.centralManager = CBCentralManager(delegate: self, queue: nil)
    println("Start scanning")
  }

  func centralManagerDidUpdateState(central: CBCentralManager!) {
    println("state: \(central.state.rawValue)")

    switch (central.state) {
      case CBCentralManagerState.PoweredOn:
        self.centralManager.scanForPeripheralsWithServices(nil, options: nil)
        break;

      default:
        break;
    }
  }

  func centralManager(central: CBCentralManager!,
    didDiscoverPeripheral peripheral: CBPeripheral!,
    advertisementData: [NSObject: AnyObject]!,
    RSSI: NSNumber!)
  {
    println("peripheral: \(peripheral)")

    self.peripheral = peripheral
  }

  @objc func stopScanning() -> Void {
    self.centralManager.stopScan()
  }

  @objc func connect(name: NSString) -> Void {
    println("Connecting to \(name)")

    self.centralManager.connectPeripheral(self.peripheral, options: nil)
  }

  func centralManager(central: CBCentralManager!,
    didConnectPeripheral peripheral: CBPeripheral!)
  {
    println("Connected")

    peripheral.delegate = self
    peripheral.discoverServices(nil)
  }

  func centralManager(central: CBCentralManager!,
    didFailToConnectPeripheral peripheral: CBPeripheral!,
    error: NSError!)
  {
    println("Failed to connect")
  }

  func peripheral(peripheral: CBPeripheral,
    didDiscoverServices error: NSError!)
  {
    let services: NSArray = peripheral.services
    println("Found \(services.count) services: \(services)")

    for obj in services {
      if let service = obj as? CBService {
        peripheral.discoverCharacteristics(nil, forService: service)
      }
    }
  }

  func peripheral(peripheral: CBPeripheral!,
    didDiscoverCharacteristicsForService service: CBService!,
    error: NSError!)
  {
    let characteristics: NSArray = service.characteristics
    println("Found \(characteristics.count) characteristics: \(characteristics)")

    for obj in characteristics {
      if let characteristic = obj as? CBCharacteristic {
        if characteristic.properties == CBCharacteristicProperties.Read {
          peripheral.readValueForCharacteristic(characteristic)
        }
      }
    }
  }

  func peripheral(peripheral: CBPeripheral!,
    didUpdateValueForCharacteristic characteristic: CBCharacteristic!,
    error: NSError!)
  {
    println("service uuid: \(characteristic.service.UUID), characteristic uuid: \(characteristic.UUID), value: \(characteristic.value)")
  }
}
