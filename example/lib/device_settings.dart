import 'package:flutter/material.dart';

class DeviceSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "d2 UHF Test",
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: CurrentSettings(),
    );
  }
}

class CurrentSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              child: Text(''),
            ),
            Container(),
          ],
        ),
      ),
    );
  }
}
