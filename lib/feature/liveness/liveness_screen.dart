import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guardian_liveness/guardian_liveness.dart';

class LivenessScreen extends StatefulWidget {
  @override
  _LivenessScreenState createState() => _LivenessScreenState();
}

class _LivenessScreenState extends State<LivenessScreen> {
  @override
  void initState() {
    super.initState();
    setState(() {
      _initialData = true;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      GuardianLiveness.isDeviceSupportLiveness().then(
        (isSupported) async {
          try {
            await GuardianLiveness.initLiveness();
            setState(() {
              _canDetectLiveness = isSupported;
            });
          } catch (e) {
            _showError(
              e,
            );
          }
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios_outlined,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(
          24.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text(
                  'Liveness Checking',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 32),
                Text(
                  'Start Liveness Detection to checking Liveness',
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            !_initialData
                ? Column(
                    children: [
                      _isLive
                          ? Icon(
                              Icons.check_circle_outline_rounded,
                              color: Colors.green,
                              size: 80,
                            )
                          : Icon(
                              Icons.block_rounded,
                              color: Colors.red,
                              size: 80,
                            ),
                      SizedBox(height: 8),
                      Text(
                        _isLive
                            ? 'Liveness is Detected'
                            : 'Liveness is not Detected',
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  )
                : Container(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Center(
                //   child: Padding(
                //     padding: const EdgeInsets.all(
                //       16.0,
                //     ),
                //     child: Container(
                //       alignment: Alignment.center,
                //       constraints: BoxConstraints.loose(
                //         Size.square(
                //           _bitmap != null ? 300.0 : 0.0,
                //         ),
                //       ),
                //       child: Builder(
                //         builder: (_) {
                //           if (_bitmap == null) {
                //             return Container();
                //           }
                //           return Image.memory(
                //             _bitmap,
                //             fit: BoxFit.cover,
                //           );
                //         },
                //       ),
                //     ),
                //   ),
                // ),

                Container(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.red,
                        ),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ))),
                    child: Text('Start Liveness Detection',
                        style: GoogleFonts.poppins(
                            fontSize: 14, fontWeight: FontWeight.bold)),
                    onPressed:
                        _canDetectLiveness ? _startLivenessDetection : null,
                  ),
                ),

                _canDetectLiveness
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.all(
                          16.0,
                        ),
                        child: Text(
                          "Your device doesn't support Liveness Detection",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  bool _canDetectLiveness = false, _isLive = false, _initialData = true;
  Uint8List _bitmap;

  void _startLivenessDetection() {
    GuardianLiveness.detectLiveness().then(
      (result) {
        print(
          "Base64 Result: ${result.base64String}",
        );
        setState(() {
          _bitmap = result.bitmap;
          _isLive = true;
          _initialData = false;
        });
      },
    ).catchError(
      (e) {
        setState(() {
          _isLive = false;
          _initialData = false;
        });
      },
    );
  }

  void _showError(var e) {
    if (e is LivenessException) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            e.code,
          ),
          content: Text(
            e.message,
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                "Close",
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            LivenessException.ERROR_UNDEFINED,
          ),
          content: Text(
            e.toString(),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                "Close",
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    }
  }
}
