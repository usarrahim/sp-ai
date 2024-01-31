import 'package:flutter/material.dart';
import 'package:sp_ai/splashPages/login_page.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  stt.SpeechToText speechToText = stt.SpeechToText();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialize();
  }

  initialize() async {
    bool available = await speechToText.initialize(
      onStatus: (status) {},
      onError: (errorNotification) {},
    );

    if (available) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ));
    } else {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            width: MediaQuery.sizeOf(context).width,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("İzin alma işlemi başarısız oldu."),
                  ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SplashScreen(),
                            ));
                      },
                      icon: Icon(Icons.restart_alt),
                      label: Text("Tekrar Dene")),
                  Text("Uygulama izinlerine göz atın.")
                ],
              ),
            ),
          );
        },
      );
    }
    // some time later...
    speechToText.stop();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        decoration: BoxDecoration(color: Color(0xFFF2FAFF)),
        child: Center(
          child: Container(
            height: MediaQuery.sizeOf(context).height * 0.4,
            child: Column(
              children: [
                Container(
                  child: Image.asset(
                    "assets/items/playstore.png",
                    width: 90,
                    height: 120,
                  ),
                ),
                Text(
                  "Uygulamaya devam etmek icin \nerisim izinleri gerekmektedir.",
                  style: TextStyle(
                    backgroundColor: Colors.transparent,
                    fontStyle: FontStyle.normal,
                    fontSize: 18,
                    color: Color(0xFF002623),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
