'use strict';

var React = require('react-native');
var BLE = require('./BLE');

var {
  StyleSheet,
  SwitchIOS,
  Text,
  ListView,
  TouchableHighlight,
  View,
  DeviceEventEmitter,
} = React;

var BLENative = require('NativeModules').BLENative;

var GenericTab = React.createClass({
  statics: {
    title: 'Generic Tab',
    systemIcon: 'recents',
  },

  peripherals: [],

  ds: new ListView.DataSource({rowHasChanged: (r1, r2) => r1 !== r2}),

  getInitialState() {
    return {
      led: true,
      timer: null,
      dataSource: this.ds.cloneWithRows(this.peripherals),
    };
  },

  componentDidMount: function() {
    DeviceEventEmitter.addListener('discoverPeripheral', (peripheral) => {
      this.peripherals.push(peripheral);
      this.setState({dataSource: this.ds.cloneWithRows(this.peripherals)});
    });

    this.ble = new BLE();
    // this.startScanning();
    this.startScanningAndConnecting('ble_app_sample2');
  },

  setLed: function(value) {
    if (value) {
      // this.startScanning();
      this.startScanningAndConnecting('ble_app_sample2');
    } else {
      this.stopScanning();
      this.stopBlinking();
    }
  },

  startScanningAndConnecting: function(name: string) {
    this.ble.startScanning(name)
      .then(this.ble.connect)
      .then(this.ble.discoverServices)
      .then((services) => {
        console.log(services);
        this.ble.discoverCharacteristics(services[0])
          .then((characteristics) => {
            console.log(characteristics);
            this.stopScanning();

            this.startBlinking(characteristics[1]);
          });
      });
  },

  startScanning: function() {
    this.ble.startScanning()
      .then((name) => {
        this.peripherals.push(name);
        this.setState({dataSource: this.ds.cloneWithRows(this.peripherals)});
      });
  },

  stopScanning: function() {
    this.ble.stopScanning();
  },

  onPressRow: function(rowID: number) {
    this.stopScanning();
    this.ble.connect(this.peripherals[rowID])
      .then(this.ble.discoverServices)
      .then((services) => {
        console.log(services);
        this.ble.discoverCharacteristics(services[0])
          .then((characteristics) => {
            console.log(characteristics);

            this.startBlinking(characteristics[1]);

            // this.ble.read(characteristics[1])
            //   .then((value) => {
            //     console.log(value);
            //   });
          });
      });
  },

  startBlinking: function(uuid: string) {
    var value = 0;

    this.timer = setInterval(() => {
      this.ble.write(uuid, value);
      value ^= 255;
    }, 1000);
  },

  stopBlinking: function() {
    if (this.timer) {
      clearInterval(this.timer);
    }

    this.timer = null;
  },

  render: function() {
    return (
      <View style={styles.tabContent}>
        <View style={styles.row}>
          <Text>LED</Text>
          <SwitchIOS
            onValueChange={(value) => {
              this.setLed(value);
              this.setState({led: value});
            }}
            value={this.state.led} />
        </View>
        <ListView style={styles.list}
          dataSource={this.state.dataSource}
          renderRow={this.renderRow}
        />
      </View>
    )
  },

  renderRow: function(rowData: string, sectionID: number, rowID: number) {
    return (
      <TouchableHighlight onPress={() => this.onPressRow(rowID)}>
        <View>
          <View style={styles.listrow}>
            <Text style={styles.text}>
              {rowData}
            </Text>
          </View>
          <View style={styles.separator} />
        </View>
      </TouchableHighlight>
    );
  },
});

var styles = StyleSheet.create({
  tabContent: {
    paddingTop: 20,
    flex: 1,
    justifyContent: 'flex-start',
  },
  row: {
    flexDirection: 'row',
    flex: 1,
    paddingHorizontal: 14,
    justifyContent: 'space-between',
  },
  list: {
    flex: 1,
  },
  listrow: {
    flexDirection: 'row',
    justifyContent: 'center',
    padding: 10,
    backgroundColor: '#f6f6f6',
  },
  text: {
    flex: 1,
    paddingHorizontal: 14,
  },
  separator: {
    height: 1,
    backgroundColor: '#cccccc',
  }
});

module.exports = GenericTab;
