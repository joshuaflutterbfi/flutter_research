import 'package:flutter/material.dart';

class CrashLyticsScreen extends StatefulWidget {
  @override
  _CrashLyticsScreenState createState() => _CrashLyticsScreenState();
}

class _CrashLyticsScreenState extends State<CrashLyticsScreen> {
  bool isCrashed = false;

  void crashLah() {
    setState(() {
      isCrashed = true;
    });
    throw Exception("This is a crash!");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: ElevatedButton(
              child: Text('Test Crash'),
              onPressed: () {
                crashLah();
              },
            ),
          ),
          SizedBox(height: 16),
          isCrashed
              ? Text(
                  'Opps! Crashed',
                )
              : Container()
        ],
      ),
    );
  }
}
