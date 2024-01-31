import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sp_ai/auth/auth_bloc/auth_bloc.dart';
import 'package:sp_ai/auth/register_or_login_screen.dart';
import 'package:sp_ai/firebase_options.dart';
import 'package:sp_ai/splashPages/splash_screen.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:cloud_text_to_speech/cloud_text_to_speech.dart';

// palette url : https://goodpalette.io/19a9c2-e0a941-bec3c4
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => PhoneAuthBloc(),
            child: RegisterOrLoginScreen())
      ],
      child: MaterialApp(
        title: 'Sp Ai',
        home: SplashScreen(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';
  late TtsParamsMicrosoft ttsParamsMicrosoft;
  late dynamic voice;

  @override
  void initState() {
    super.initState();
    inittts();
    _initSpeech();
  }

  inittts() async {
    TtsMicrosoft.init(
        params: InitParamsMicrosoft(
            subscriptionKey: "b159784bf0c84636b6dbb887ab827b0a",
            region: "eastus"),
        withLogs: true);

    // Get voices
    final voicesResponse = await TtsMicrosoft.getVoices();
    final voices = voicesResponse.voices;

    //Print all voices
    print(voices);

    //Pick an English Voice
    voice = voices
        .where((element) => element.locale.code.startsWith("en-"))
        .toList(growable: false)
        .first;
  }

  /// This has to happen only once per app
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  /// Each time to start a speech recognition session
  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void _stopListening() async {
    await _speechToText.stop();
    ttsParamsMicrosoft = TtsParamsMicrosoft(
        voice: voice,
        audioFormat: AudioOutputFormatMicrosoft.audio48Khz192kBitrateMonoMp3,
        text: _lastWords,
        rate: 'slow',
        // optional
        pitch: 'default' // optional
        );
    final ttsResponse = await TtsMicrosoft.convertTts(ttsParamsMicrosoft);
    final audioBytes = ttsResponse.audio.buffer.asByteData();
    AudioPlayer audioPlayer = AudioPlayer();
    audioPlayer.setSourceBytes(ttsResponse.audio);
    final Source? source = audioPlayer.source;
    source != null ? audioPlayer.play(source) : print("Null");
    setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Speech Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(16),
              child: Text(
                'Recognized words:',
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(16),
                child: Text(
                  // If listening is active show the recognized words
                  _speechToText.isListening
                      ? '$_lastWords'
                      // If listening isn't active but could be tell the user
                      // how to start it, otherwise indicate that speech
                      // recognition is not yet ready or not supported on
                      // the target device
                      : _speechEnabled
                          ? '$_lastWords'
                          : 'Speech not available',
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:
            // If not yet listening for speech start, otherwise stop
            _speechToText.isNotListening ? _startListening : _stopListening,
        tooltip: 'Listen',
        child: Icon(_speechToText.isNotListening ? Icons.mic_off : Icons.mic),
      ),
    );
  }
}
