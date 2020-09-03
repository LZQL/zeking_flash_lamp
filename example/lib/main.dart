import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:zeking_flash_lamp/zeking_flash_lamp.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _hasFlash = false;
  bool _isOn = false;
  double _intensity = 1.0;

  @override
  initState() {
    super.initState();
    initPlatformState();
  }

  initPlatformState() async {
    bool hasFlash = await ZekingFlashLamp.hasLamp;
    print("Device has flash ? $hasFlash");
    setState(() {
      _hasFlash = hasFlash;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(primarySwatch: Colors.pink),
      home: new Scaffold(
        appBar: new AppBar(title: new Text('zeking_flash_lamp_example')),
        body: new Center(
          child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Text('Device has flash: $_hasFlash\n Flash is on: $_isOn'),
                new Slider(
                    value: _intensity,
                    onChanged: _isOn ? _intensityChanged : null),
                new RaisedButton(
                    onPressed: () async =>
                        await ZekingFlashLamp.flash(new Duration(seconds: 2)),
                    child: new Text("Flash for 2 seconds"))
              ]),
        ),
        floatingActionButton: new FloatingActionButton(
            child: new Icon(_isOn ? Icons.flash_off : Icons.flash_on),
            onPressed: _turnFlash),
      ),
    );
  }

  Future _turnFlash() async {
    _isOn
        ? ZekingFlashLamp.turnOff()
        : ZekingFlashLamp.turnOn(intensity: _intensity);
    var f = await ZekingFlashLamp.hasLamp;
    setState(() {
      _hasFlash = f;
      _isOn = !_isOn;
    });
  }

  _intensityChanged(double intensity) {
    ZekingFlashLamp.turnOn(intensity: intensity);
    setState(() {
      _intensity = intensity;
    });
  }
}
