import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:d2uhf/d2uhf.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "d2 UHF Test",
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentPower = 1;
  double _currentSliderValue = 0;
  String _setPower = "";
  String _currentTag = "Нет данных";
  bool _isSuccess = false;
  @override
  void initState() {
    super.initState();

    _onInit();
    _getPower();
  }

  Future<bool> _onInit() async {
    bool success = false;
    try {
      success = (await D2uhf.onInit)!;
    } on PlatformException {
      success = false;
    }
    return _isSuccess = success;
  }

  Future<void> _getPower() async {
    int? power;
    try {
      power = await D2uhf.getPower;
    } on PlatformException {
      power = 0;
    }
    if (!mounted) return;

    setState(() {
      _currentPower = power!;
      _currentSliderValue = _currentPower.toDouble();
    });
  }

  Future<bool> _writePower(int newPower) async {
    bool isSuccess = false;
    try {
      isSuccess = (await D2uhf.writePower(newPower))!;
    } on PlatformException {
      isSuccess = false;
    }
    return isSuccess;
  }

  Future<String> _getTag() async {
    String tag = "";
    try {
      tag = await D2uhf.readTag;
    } on PlatformException {
      tag = 'Нет данных';
    }
    return tag;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Тестирование")),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              child: Text(
                'Текущая мощность: $_currentPower\n',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
            ),
            Container(
              child: Slider(
                value: _currentSliderValue,
                min: 0,
                max: 33,
                //divisions: 30,
                label: _currentSliderValue.round().toString(),
                onChanged: (double value) {
                  setState(() {
                    _currentSliderValue = value;
                    _setPower = (_currentSliderValue.round()).toString();
                  });
                },
              ),
            ),
            Container(
              child: ElevatedButton(
                child: Text(
                  'Установить мощность $_setPower',
                  style: TextStyle(fontSize: 22),
                ),
                onPressed: () {
                  _writePower(_currentSliderValue.round()).then((value) {
                    setState(() {
                      if (!value) {
                        return;
                      } else {
                        _currentPower = _currentSliderValue.round();
                      }
                    });
                  });
                },
              ),
            ),
            const Divider(
              height: 20,
              thickness: 5,
              indent: 20,
              endIndent: 20,
            ),
            Container(
              padding: const EdgeInsets.only(left: 20),
              child: Align(
                alignment: AlignmentDirectional.centerStart,
              ),
            ),
            Expanded(
              child: Container(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    " Метка:\n\n $_currentTag",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 100,
              child: ElevatedButton(
                child: Text(
                  'Считать метку',
                  style: TextStyle(fontSize: 22),
                ),
                onPressed: () {
                  _getTag().then((value) {
                    setState(() {
                      _currentTag = value;
                    });
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
