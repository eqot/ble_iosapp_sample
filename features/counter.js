'use strict';

var React = require('react-native');

var {
  StyleSheet,
  Text,
  View,
} = React;

var CounterTab = React.createClass({
  statics: {
    title: 'Counter Tab',
    systemIcon: 'downloads',
  },

  render: function() {
    return (
      <View style={styles.tabContent}>
        <Text>Counter Tab</Text>
      </View>
    )
  }
});

var styles = StyleSheet.create({
  tabContent: {
    paddingTop: 20,
    flex: 1,
    justifyContent: 'flex-start',
    alignItems: 'center',
  },
});

module.exports = CounterTab;
