'use strict';

var React = require('react-native');

var {
  StyleSheet,
  SwitchIOS,
  Text,
  View,
} = React;

var BLE = require('NativeModules').BLE;

var GenericTab = React.createClass({
  statics: {
    title: 'Generic Tab',
    systemIcon: 'recents',
  },

  getInitialState() {
    return {
      led: false,
      text: 'off',
    };
  },

  setLed: function(value) {
    if (value) {
      this.state.text = 'on';

      BLE.startScaning((error, foo) => {
        if (error) {
          console.log(error);
        } else {
          this.setState({text: foo});
        }
      });
    } else {
      this.state.text = 'off';

      BLE.stopScaning();
    }
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
    // alignSelf: 'center',
  },
  row: {
    flexDirection: 'row',
    flex: 1,
    paddingHorizontal: 14,
    justifyContent: 'space-between',
  },
});

module.exports = GenericTab;
