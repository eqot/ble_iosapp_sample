'use strict';

var BLENative = require('NativeModules').BLENative;

class BLE {
  startScanning(): Promise {
    return new Promise((resolve, reject) => {
      BLENative.startScanning(function(name, id) {
        resolve(name);
      });
    });
  }

  stopScanning() {
    BLENative.stopScanning();
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
      BLENative.discoverServices(function(services) {
        resolve(services);
      })
    });
  }

  discoverCharacteristics(uuid: string): Promise {
    return new Promise((resolve, reject) => {
      BLENative.discoverCharacteristics(uuid, function(characteristics) {
        resolve(characteristics);
      })
    });
  }

  read(uuid: string): Promise {
    return new Promise((resolve, reject) => {
      BLENative.read(uuid, function(value) {
        resolve(value);
      })
    });
  }

  write(uuid: string, value: integer): Promise {
    return new Promise((resolve, reject) => {
      BLENative.write(uuid, value, function() {
        resolve();
      })
    });
  }
}

module.exports = BLE;
