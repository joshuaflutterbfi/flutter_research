import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_research/feature/local_auth/function/local_auth.dart';
import 'package:flutter_research/feature/local_auth/widget/card_category_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_auth/local_auth.dart';
import 'dart:io' as platform;

class LocalAuthScreen extends StatefulWidget {
  @override
  _LocalAuthScreenState createState() => _LocalAuthScreenState();
}

class _LocalAuthScreenState extends State<LocalAuthScreen> {
  final LocalAuthentication localAuth = LocalAuthentication();

  String resultText = "Tekan FAB untuk melakukan autentikasi";
  Color resultColor = Colors.black;

  void _startBioMetricAuth(String message) async {
    try {
      bool didAuthenticate =
          await localAuth.authenticate(localizedReason: message);
      if (didAuthenticate) {
        setState(() {
          resultColor = Colors.green;
          resultText = "Autentikasi berhasil.";
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => newScreen()));
        });
      } else {
        setState(() {
          resultColor = Colors.red;
          resultText = "Autentikasi gagal.";
        });
      }
    } on PlatformException catch (e) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('Your Biometrics Not Configure'),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [Text('Configure Dulu dongs')],
                ),
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: Padding(
          padding: EdgeInsets.only(left: 8, top: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 24.0,
                ),
              ),
              SizedBox(
                width: 16,
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * .36,
            decoration: BoxDecoration(
                color: Colors.deepPurple[800],
                image: DecorationImage(
                  alignment: Alignment.topRight,
                  image: AssetImage('assets/imgs/Vector1.png'),
                )),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.only(left: 8, top: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('HELLO,',
                      style: GoogleFonts.lato(
                          textStyle:
                              TextStyle(color: Colors.white, fontSize: 50))),
                  SizedBox(
                    height: 4,
                  ),
                  Text('Welcome to Page Local Auth Demo',
                      style: GoogleFonts.lato(
                          textStyle:
                              TextStyle(fontSize: 36, color: Colors.white))),
                  SizedBox(
                    height: 24,
                  ),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: .85,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20,
                      children: [
                        CardCategoryWidget(
                          onTap: () async {
                            final isAvailable =
                                await LocalAuthMethod.hasBiometrics();
                            final biometrics =
                                await LocalAuthMethod.getBiometrics();

                            final hasFingerprint =
                                biometrics.contains(BiometricType.fingerprint);
                            final hasFaceID =
                                biometrics.contains(BiometricType.face);

                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      title: Text('Available'),
                                      content: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          buildText('Biometrics', isAvailable),
                                          buildText(
                                              'Fingerprint', hasFingerprint),
                                          buildText('Face ID', hasFaceID),
                                        ],
                                      ),
                                    ));
                          },
                          title: 'Check Biometric',
                          assetImage: 'assets/imgs/check.png',
                        ),
                        CardCategoryWidget(
                          onTap: () async {
                            List<BiometricType> availBiometrics =
                                await localAuth.getAvailableBiometrics();
                            if (platform.Platform.isAndroid) {
                              if (availBiometrics
                                  .contains(BiometricType.fingerprint)) {
                                print('Face id');
                                _startBioMetricAuth('Use Finger Print');
                              } else {
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          title: Text('Warning!',
                                              style: GoogleFonts.lato(
                                                  textStyle: TextStyle(
                                                      color: Colors.red))),
                                          content: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text('Not Available')
                                              ]),
                                        ));
                              }
                            } else if (platform.Platform.isIOS) {
                              if (availBiometrics
                                  .contains(BiometricType.fingerprint)) {
                                print('Face id');
                                _startBioMetricAuth('Use Finger Print');
                              }
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: Text('Warning!',
                                            style: GoogleFonts.lato(
                                                textStyle: TextStyle(
                                                    color: Colors.red))),
                                        content: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [Text('Not Available')]),
                                      ));
                            }
                          },
                          title: 'Fingerprint Demo',
                          assetImage: 'assets/imgs/fingerprint.png',
                        ),
                        CardCategoryWidget(
                          onTap: () async {
                            List<BiometricType> availBiometrics =
                                await localAuth.getAvailableBiometrics();
                            if (platform.Platform.isIOS) {
                              if (availBiometrics
                                  .contains(BiometricType.face)) {
                                print('Face id');
                                _startBioMetricAuth('Use Face ID');
                              } else {
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          title: Text('Warning!',
                                              style: GoogleFonts.lato(
                                                  textStyle: TextStyle(
                                                      color: Colors.red))),
                                          content: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text('Not Available')
                                              ]),
                                        ));
                              }
                            } else if (platform.Platform.isAndroid) {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: Text('Warning!',
                                            style: GoogleFonts.lato(
                                                textStyle: TextStyle(
                                                    color: Colors.red))),
                                        content: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [Text('Not Available')]),
                                      ));
                            }
                          },
                          title: 'Check Face ID',
                          assetImage: 'assets/imgs/faceid.png',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget checkAvailbale(BuildContext context) => buttonCheck(
      text: 'Check Local Auth',
      icon: Icons.event_available,
      onPressed: () async {
        final isAvailable = await LocalAuthMethod.hasBiometrics();
        final biometrics = await LocalAuthMethod.getBiometrics();

        final hasFingerprint = biometrics.contains(BiometricType.fingerprint);
        final hasFaceID = biometrics.contains(BiometricType.face);

        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('Available'),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      buildText('Biometrics', isAvailable),
                      buildText('Fingerprint', hasFingerprint),
                      buildText('Face ID', hasFaceID),
                    ],
                  ),
                ));
      });

  Widget newScreen() {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Screen'),
        centerTitle: true,
      ),
      body: Center(
        child: Text('HOMEPAGE!'),
      ),
    );
  }

  Widget buildText(String text, bool checked) => Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            checked
                ? Icon(Icons.check, color: Colors.green, size: 24)
                : Icon(Icons.close, color: Colors.red, size: 24),
            const SizedBox(width: 12),
            Text(text, style: TextStyle(fontSize: 24)),
          ],
        ),
      );

  Widget buttonCheck({
    @required String text,
    @required IconData icon,
    @required VoidCallback onPressed,
  }) =>
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            minimumSize: Size.fromHeight(50),
          ),
          icon: Icon(icon, size: 24),
          label: Text(
            text,
            style: TextStyle(fontSize: 12, color: Colors.black),
          ),
          onPressed: onPressed,
        ),
      );
}
