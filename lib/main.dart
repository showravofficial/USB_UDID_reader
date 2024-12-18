import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: UdidScreen(),
    );
  }
}

class UdidScreen extends StatefulWidget {
  @override
  _UdidScreenState createState() => _UdidScreenState();
}

class _UdidScreenState extends State<UdidScreen> {
  static const platform = MethodChannel('com.example.usb_udid_reader/usb');
  String _udid = "Unknown UDID";
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _getUdid(); // Initial check
    _startUdidCheck();
  }

  // Function to start checking for UDID every 5 seconds
  void _startUdidCheck() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _getUdid(); // Continuously check for UDID
    });
  }

  // Stop the periodic timer when the widget is disposed
  @override
  void dispose() {
    _timer.cancel();  // Cancel the timer to avoid memory leaks
    super.dispose();
  }

  // Function to get UDID from platform channel
  Future<void> _getUdid() async {
    try {
      final String udid = await platform.invokeMethod('getUdid');
      setState(() {
        _udid = udid;
      });
    } on PlatformException catch (e) {
      setState(() {
        _udid = "Failed to get UDID: '${e.message}'.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("USB UDID Reader"),
      ),
      body: Center(
        child: Text('UDID: $_udid'),
      ),
    );
  }
}
