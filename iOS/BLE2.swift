import Foundation
import CoreBluetooth

@objc(BLE2)
class BLE2: NSObject, CBCentralManagerDelegate {
  var centralManager: CBCentralManager!

  @objc func addEvent(name: String, location: String) -> Void {
    println("BLE2 \(name) \(location)")
  }

  @objc func startScanning() -> Void {
    self.centralManager = CBCentralManager(delegate: self, queue: nil)
    println("Start scanning")
  }

  func centralManagerDidUpdateState(central: CBCentralManager) {
    println("state: \(central.state.rawValue)")
  }
}
