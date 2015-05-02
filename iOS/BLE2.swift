import Foundation
import CoreBluetooth

@objc(BLE2)
class BLE2: NSObject, CBCentralManagerDelegate {
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
  }
}
