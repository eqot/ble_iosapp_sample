/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 */
'use strict';

var React = require('react-native');
var {
  AppRegistry,
  StyleSheet,
  TabBarIOS,
} = React;

var GenericTab = require('./features/generic');
var CounterTab = require('./features/counter');

var tabs = [
  {
    component: GenericTab,
    render: function() {
      return (
        <GenericTab />
      )
    }
  }, {
    component: CounterTab,
    render: function() {
      return (
        <CounterTab />
      )
    }
  },
];

var ble_iosapp_sample = React.createClass({
  getInitialState: function() {
    return {
      selectedTab: tabs[0].component.title
    };
  },

  render: function() {
    return (
      <TabBarIOS style={styles.container}>
        {tabs.map(function(tab, i) {
          return (
            <TabBarIOS.Item
              title={tab.component.title}
              systemIcon={tab.component.systemIcon}
              selected={this.state.selectedTab === tab.component.title}
              onPress={() => {
                this.setState({
                  selectedTab: tab.component.title,
                });
              }}
              >
              {tab.render()}
            </TabBarIOS.Item>
          );
        }, this)}
      </TabBarIOS>
    );
  }
});

var styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
  },
});

AppRegistry.registerComponent('ble_iosapp_sample', () => ble_iosapp_sample);
