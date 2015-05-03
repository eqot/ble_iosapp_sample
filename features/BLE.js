'use strict';

var BLENative = require('NativeModules').BLENative;

class BLE {
  startScanning(): Promise {
    console.log('0');
    return new Promise((resolve, reject) => {
      BLENative.startScanning(function() {
        resolve();
      });
    });
  }

  scanPeripherals(): Promise {
    console.log('1');
    return new Promise((resolve, reject) => {
      BLENative.scanPeripherals(function(name, id) {
        resolve(name);
      });
    });
  }
}

module.exports = BLE;
