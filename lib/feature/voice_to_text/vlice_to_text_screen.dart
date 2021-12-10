import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:url_launcher/url_launcher.dart';

class VoiceToTextScreen extends StatefulWidget {
  @override
  _VoiceToTextScreenState createState() => _VoiceToTextScreenState();
}

class _VoiceToTextScreenState extends State<VoiceToTextScreen> {
  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';
  List<String> _language = ['ID', 'EN'];
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  /// This has to happen only once per app
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  /// Each time to start a speech recognition session
  void _startListening() async {
    await _speechToText.listen(
        onResult: _onSpeechResult,
        localeId: _language[_index],
        pauseFor: Duration(seconds: 3));
    setState(() {});
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
    });

    if (result.finalResult) {
      if (_lastWords.toLowerCase().contains('back')) {
        Navigator.pop(context);
      } else if (_lastWords.toLowerCase().contains('kembali')) {
        Navigator.pop(context);
      } else if (_lastWords.toLowerCase().contains('google')) {
        _launchURL('https://google.co.id');
      }
    }
  }

  Future<void> _launchURL(String type) async {
    if (await canLaunch(type)) {
      await launch(type);
    } else {
      throw 'Could not launch $type';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1c1c1e),
      appBar: AppBar(
        backgroundColor: Color(0xFF1c1c1e),
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios_outlined,
            color: Colors.white,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              setState(() {
                if (_index == 0) {
                  _index++;
                } else {
                  _index--;
                }
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Row(
                children: [
                  Icon(
                    Icons.language_outlined,
                    color: Colors.white,
                  ),
                  SizedBox(width: 4),
                  Text(
                    _language[_index],
                    style: TextStyle(fontSize: 20.0, color: Colors.white),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(16),
              child: Text(
                'Speech-Recognize',
                style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
            _index == 0
                ? Container(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      'Apa yang bisa saya bantu?',
                      style: TextStyle(fontSize: 16.0, color: Colors.grey),
                    ),
                  )
                : Container(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      'What can i help you with?',
                      style: TextStyle(fontSize: 16.0, color: Colors.grey),
                    ),
                  ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: MediaQuery.of(context).size.height * 0.30),
                child: _index == 0
                    ? Text(
                        _speechToText.isListening
                            ? '$_lastWords'
                            : _speechEnabled
                                ? 'Ketuk mikrofon untuk mulai mendengarkan...'
                                : 'Tidak tersedia',
                        style: TextStyle(color: Colors.white),
                      )
                    : Text(
                        _speechToText.isListening
                            ? '$_lastWords'
                            : _speechEnabled
                                ? 'Tap the microphone to start listening...'
                                : 'Speech not available',
                        style: TextStyle(color: Colors.white),
                      ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed:
            _speechToText.isNotListening ? _startListening : _stopListening,
        tooltip: 'Listen',
        child: Icon(_speechToText.isNotListening ? Icons.mic_off : Icons.mic),
      ),
    );
  }
}
