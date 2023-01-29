
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:provider/provider.dart';

import 'ble/services/bluetooth.dart';
import 'ble/services/shared_pref.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _value;
  bool _connected = false;
  bool _connecting = false;

  _autoConnect(BuildContext context) async {
    print('_autoConnect');
    final SharedPref sharedPref = Provider.of<SharedPrefService>(context,listen: false);
    String address = await sharedPref.getAddress();
    if(address=='nothing'){
      return;
    }
    else{
      setState(() {
        _value = address;
      });
      _connect(context);
    }

  }

  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(Duration.zero,(){
      _autoConnect(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Bluetooth bluetooth = Provider.of<BluetoothService>(context);
    final SharedPref sharedPref = Provider.of<SharedPrefService>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: Icon(Icons.bluetooth),
        title: Text("Bluetooth Control"),
      ),
      body: RefreshIndicator(
        // ignore: missing_return
        onRefresh: () async {
          await sharedPref.getTurnOffFan();
          setState(() {});
        },
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              color: Colors.white),
          child: ListView(
            children: <Widget>[
              FutureBuilder<List<BluetoothDevice>>(
                future: bluetooth.getDevices(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: <Widget>[
                            DropdownButtonFormField(
                              items: snapshot.data
                                  .map((e) => DropdownMenuItem(
                                child: Text(e.name),
                                value: e.address,
                              ))
                                  .toList(),
                              onChanged: _connected ? null:(value) {
                                setState(() {
                                  _value = value;
                                  print(_value);
                                });
                              },
                              value: _value,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                              disabledHint: Text("Disconnect to change device"),
                            ),
                            ElevatedButton(
                              child:
                              Text(_connected ? "Disconnect" : "Connect"),
                              onPressed: _connecting ? null :(){
                                _connected ? _disconnect(context): _connect(context);
                              },
                            )
                          ],
                        ),
                      );
                    }
                    return Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text("Turn on bluetooth"),
                    );
                  }
                  return CircularProgressIndicator();
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: Icon(Icons.lightbulb_outline),
                  title: FutureBuilder<bool>(
                    future: sharedPref.getStatus('light'),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasData) {
                          return snapshot.data
                              ? Text('Status : On ')
                              : Text('Status : Off ');
                        }
                        return Text('Off ');
                      }
                      return Text('unknown');
                    },
                  ),
                  subtitle: FutureBuilder<String>(
                    future: sharedPref.getTurnOnLight(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasData) {
                          return Text("Last turned on: ${snapshot.data}");
                        }
                        return Text('unknown');
                      }
                      return Text('unknown');
                    },
                  ),
                  trailing: FutureBuilder<String>(
                    future: sharedPref.getTurnOffLight(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasData) {
                          return Text("Last turned off: ${snapshot.data}");
                        }
                        return Text('unknown');
                      }
                      return Text('unknown');
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: Icon(Icons.ac_unit),
                  title: FutureBuilder<bool>(
                    future: sharedPref.getStatus('fan'),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasData) {
                          return snapshot.data
                              ? Text('Status : On ')
                              : Text('Status : Off ');
                        }
                        return Text('Off ');
                      }
                      return Text('unknown ');
                    },
                  ),
                  subtitle: FutureBuilder<String>(
                    future: sharedPref.getTurnOnFan(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasData) {
                          return Text("Last turned on: ${snapshot.data}");
                        }
                        return Text('unknown');
                      }
                      return Text('unknown');
                    },
                  ),
                  trailing: FutureBuilder<String>(
                    future: sharedPref.getTurnOffFan(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasData) {
                          return Text("Last turned off: ${snapshot.data}");
                        }
                        return Text('unknown');
                      }
                      return Text('unknown');
                    },
                  ),
                ),
              ),
              Material(
                elevation: 0,
                child: ButtonBar(
                  alignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text("Enable Motion Sensor"),
                    FutureBuilder<bool>(
                      future: sharedPref.getStatus('light'),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasData) {
                            return snapshot.data
                                ? ElevatedButton(
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.flash_off),
                                  Text("OFF"),
                                ],
                              ),
                              onPressed: !_connected
                                  ? null
                                  : () {
                                bluetooth.write("em");
                                sharedPref.setStatus(
                                    'light', false);
                                sharedPref.setTurnOffLight();
                                setState(() {});
                              },
                            )
                                : ElevatedButton(
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.flash_on),
                                  Text("On"),
                                ],
                              ),
                              onPressed: !_connected
                                  ? null
                                  : () {
                                bluetooth.write("dm");
                                sharedPref.setStatus('light', true);
                                sharedPref.setTurnOnLight();
                                setState(() {});
                              },
                            );
                          }
                          return Text('Off ');
                        }
                        return Text('unknown');
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _connect(BuildContext context) async {
    final Bluetooth bluetooth =
    Provider.of<BluetoothService>(context, listen: false);
    final SharedPref sharedPref =
    Provider.of<SharedPrefService>(context, listen: false);
    bool status = await bluetooth.connectTo(_value);
    print('status:');
    print(status);
    await sharedPref.setAddress(_value);
    if (status) {
      sharedPref.getStatus('light').then((value) {
        value ? bluetooth.write('L') : bluetooth.write('7');
      });
      sharedPref.getStatus('fan').then((value) {
        value ? bluetooth.write('F') : bluetooth.write('3');
      });
    }
    setState(() {
      _connected = status;
      _connecting = false;
    });
  }

  _disconnect(BuildContext context) async {
    final Bluetooth bluetooth =
    Provider.of<BluetoothService>(context, listen: false);
    bluetooth.disconnect();
    setState(() {
      _connected = false;
    });

  }
}
