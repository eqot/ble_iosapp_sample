'use strict';

var BLENative = require('NativeModules').BLENative;

class BLE {
  startScanning(): Promise {
    return new Promise((resolve, reject) => {
      BLENative.startScanning(function() {
        resolve();
      });
    });
  }

  scanPeripherals(): Promise {
    return new Promise((resolve, reject) => {
      BLENative.scanPeripherals(function(name, id) {
        resolve(name);
      });
    });
  }

  connect(name: string): Promise {
    return new Promise((resolve, reject) => {
      BLENative.connect(name, function() {
        resolve();
      })
    });
  }

  discoverServices(): Promise {
    return new Promise((resolve, reject) => {
      BLENative.discoverServices(function() {
        resolve();
      })
    });
  }
}

module.exports = BLE;
