'use strict';

var React = require('react-native');

var {
  StyleSheet,
  SwitchIOS,
  Text,
  View,
  DeviceEventEmitter,
} = React;

var BLE = require('NativeModules').BLE;

var GenericTab = React.createClass({
  statics: {
    title: 'Generic Tab',
    systemIcon: 'recents',
  },

  getInitialState() {
    return {
      led: true,
      text: 'off',
    };
  },

  componentDidMount: function() {
    DeviceEventEmitter.addListener('discoverPeripheral', (name, identifier) => {
      this.setState({text: name});
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
          <Text>LED {this.state.text}</Text>
          <SwitchIOS
            onValueChange={(value) => {
              this.setLed(value);
              this.setState({led: value});
            }}
            value={this.state.led} />
        </View>
      </View>
    )
  }
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
});

module.exports = GenericTab;
