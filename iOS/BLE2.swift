import Foundation

@objc(BLE2)
class BLE2: NSObject {

  @objc func addEvent(name: String, location: String) -> Void {
    println("BLE2 \(name) \(location)")
  }

}
