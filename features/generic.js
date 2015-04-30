'use strict';

var React = require('react-native');

var {
  StyleSheet,
  SwitchIOS,
  Text,
  ListView,
  TouchableHighlight,
  View,
  DeviceEventEmitter,
} = React;

var BLE = require('NativeModules').BLE;
var BLE2 = require('NativeModules').BLE2;

var GenericTab = React.createClass({
  statics: {
    title: 'Generic Tab',
    systemIcon: 'recents',
  },

  peripherals: [],

  ds: new ListView.DataSource({rowHasChanged: (r1, r2) => r1 !== r2}),

  getInitialState() {
    BLE2.addEvent('foo', 'bar');

    return {
      led: true,
      dataSource: this.ds.cloneWithRows(this.peripherals),
    };
  },

  componentDidMount: function() {
    DeviceEventEmitter.addListener('discoverPeripheral', (peripheral) => {
      this.peripherals.push(peripheral);
      this.setState({dataSource: this.ds.cloneWithRows(this.peripherals)});
    });

    this.startScaning();
  },

  setLed: function(value) {
    if (value) {
      this.startScaning();
    } else {
      this.state.text = '';

      this.stopScaning();
    }
  },

  startScaning: function() {
    BLE.startScaning();
  },

  stopScaning: function() {
    BLE.stopScaning();
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
              {rowData.name}
            </Text>
          </View>
          <View style={styles.separator} />
        </View>
      </TouchableHighlight>
    );
  },

  onPressRow: function(rowID: number) {
    BLE.connect(this.peripherals[rowID].name);
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
