import 'dart:convert';
import 'dart:io';

import 'package:StreamDash/accueil.dart';
import 'package:StreamDash/constant.dart';
import 'package:StreamDash/streampad.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:http/http.dart' as http;
import 'package:StreamDash/dashboard.dart';
//import 'package:admob_flutter/admob_flutter.dart';

var bdd;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize without device test ids.
  await Firebase.initializeApp();
  //await Admob.requestTrackingAuthorization();

  //Admob.initialize();
  if (Platform.isAndroid) {
    await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);

    var swAvailable = await AndroidWebViewFeature.isFeatureSupported(
        AndroidWebViewFeature.SERVICE_WORKER_BASIC_USAGE);
    var swInterceptAvailable = await AndroidWebViewFeature.isFeatureSupported(
        AndroidWebViewFeature.SERVICE_WORKER_SHOULD_INTERCEPT_REQUEST);

    if (swAvailable && swInterceptAvailable) {
      AndroidServiceWorkerController serviceWorkerController =
          AndroidServiceWorkerController.instance();

      await serviceWorkerController
          .setServiceWorkerClient(AndroidServiceWorkerClient(
        shouldInterceptRequest: (request) async {
          print(request);
          return null;
        },
      ));
    }
  }
  runApp(MyApp());
}

late String id;
var stream;
int i = 0;
var ez;
var bz;
var follower;
var sub;
var test;

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Twitch Panel with Twitch API',
        theme: ThemeData(
          primarySwatch: Colors.purple,
        ),
        routes: {
          '/': (context) => MyHomePage(),
          '/home': (context) => SecondPage(),
          '/dashboard': (context) => Dashboard(),
          '/twitch': (context) => Twitch(),
          '/streampad': (context) => StreamPad(),
        },
        initialRoute: '/');
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                'Welcome to StreamDash',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.purple,
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.height * 0.04),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.25,
                width: MediaQuery.of(context).size.height * 0.25,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(175),
                  border: Border.all(color: Colors.purple, width: 1),
                  image: DecorationImage(
                    image: AssetImage("lib/launcher.png"),
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/twitch');
                },
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.075,
                  width: MediaQuery.of(context).size.width * 0.90,
                  decoration: BoxDecoration(
                      color: Colors.purple,
                      borderRadius: BorderRadius.circular(30)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'Login with Twitch',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize:
                                MediaQuery.of(context).size.height * 0.025),
                      )
                    ],
                  ),
                ),
              ),
              TextButton(
                  onPressed: () async {
                    bz = await http.get(
                        Uri.parse('https://api.twitch.tv/helix/users'),
                        headers: {
                          'Authorization': 'Bearer $bearerID',
                          'Client-Id': '$clientID'
                        });
                    bz = json.decode(bz.body);
                    id = bz['data'][0]['id'].toString();
                    ez = await http.get(Uri.parse(
                        //   'https://api.twitch.tv/helix/streams?user_id=${bz['data'][0]['id']}'),
                        'https://api.twitch.tv/helix/streams'), headers: {
                      'Authorization': 'Bearer $bearerID',
                      'Client-Id': '$clientID',
                    });

                    ez = json.decode(ez.body);

                    follower = await http.get(Uri.parse(
                            //'https://api.twitch.tv/helix/streams?user_id=${bz['data'][0]['id']}'),
                            'https://api.twitch.tv/helix/users/follows?to_id=${bz['data'][0]['id']}'),
                        headers: {
                          'Authorization': 'Bearer $bearerID',
                          'Client-Id': '$clientID',
                        });

                    follower = json.decode(follower.body);
                    sub = await http.get(Uri.parse(
                            //'https://api.twitch.tv/helix/streams?user_id=${bz['data'][0]['id']}'),
                            'https://api.twitch.tv/helix/subscriptions?broadcaster_id=${bz['data'][0]['id']}&first=1'),
                        headers: {
                          'Authorization': 'Bearer $bearerID',
                          'Client-Id': '$clientID',
                        });

                    sub = json.decode(sub.body);
                    test = await http.get(
                        Uri.parse(
                            'https://api.twitch.tv/helix/eventsub/subscriptions'),
                        headers: {
                          'Authorization': 'Bearer $bearerID',
                          'Client-Id': '$clientID',
                        });
                    test = json.decode(test.body);
                    print(test.toString());

                    Navigator.pushNamed(context, '/home');
                  },
                  child: Text('Test it now'))
            ],
          )),
    );
  }
}

class Twitch extends StatefulWidget {
  const Twitch({Key? key}) : super(key: key);

  @override
  State<Twitch> createState() => TwitchState();
}

class TwitchState extends State<Twitch> {
  //AdmobBannerSize bannerSize;
  // AdmobInterstitial interstitialAd;
  // AdmobReward rewardAd;

  @override
  final GlobalKey webViewKey = GlobalKey();

  late InAppWebViewController webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
          useShouldOverrideUrlLoading: true,
          mediaPlaybackRequiresUserGesture: false),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  late PullToRefreshController pullToRefreshController;
  late ContextMenu contextMenu;
  String url = "";
  double progress = 0;
  final urlController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // You should execute `Admob.requestTrackingAuthorization()` here before showing any ad.
    //bannerSize = AdmobBannerSize.BANNER;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      // Center is a layout widget. It takes a single child and positions it
      // in the middle of the parent.
      child: InAppWebView(
        initialUrlRequest: URLRequest(
          url: Uri.parse(
              ('https://id.twitch.tv/oauth2/authorize?response_type=token&client_id=$clientID&redirect_uri=https://tisserak.fr&scope=channel%3Amanage%3Apolls+channel%3Aread%3Apolls+channel%3Aread%3Asubscriptions+channel%3Aedit%3Acommercial+clips%3Aedit+channel%3Amanage%3Abroadcast')),
        ),
        androidOnPermissionRequest: (controller, origin, resources) async {
          return PermissionRequestResponse(
              resources: resources,
              action: PermissionRequestResponseAction.GRANT);
        },
        onLoadStart: (controller, url) {
          print(url.toString());
          setState(() async {
            String urll = url.toString();
            print('URL!!!! : ' + '$urll');
            //Get the user token for use it in different get requete
            if (urll.startsWith('https://tisserak.fr')) {
              bearerID = urll.substring(34, 64);
              print(bearerID);
              bz = await http.get(
                  Uri.parse('https://api.twitch.tv/helix/users'),
                  headers: {
                    'Authorization': 'Bearer $bearerID',
                    'Client-Id': '$clientID'
                  });
              bz = json.decode(bz.body);
              print(bz.toString());
              id = bz['data'][0]['id'].toString();
              ez = await http.get(Uri.parse(
                  //   'https://api.twitch.tv/helix/streams?user_id=${bz['data'][0]['id']}'),
                  'https://api.twitch.tv/helix/streams'), headers: {
                'Authorization': 'Bearer $bearerID',
                'Client-Id': '$clientID',
              });

              ez = json.decode(ez.body);
              print(ez.toString());
              follower = await http.get(Uri.parse(
                      //'https://api.twitch.tv/helix/streams?user_id=${bz['data'][0]['id']}'),
                      'https://api.twitch.tv/helix/users/follows?to_id=${bz['data'][0]['id']}'),
                  headers: {
                    'Authorization': 'Bearer $bearerID',
                    'Client-Id': '$clientID',
                  });

              follower = json.decode(follower.body);
              print(follower.toString());
              sub = await http.get(Uri.parse(
                      //'https://api.twitch.tv/helix/streams?user_id=${bz['data'][0]['id']}'),
                      'https://api.twitch.tv/helix/subscriptions?broadcaster_id=${bz['data'][0]['id']}&first=1'),
                  headers: {
                    'Authorization': 'Bearer $bearerID',
                    'Client-Id': '$clientID',
                  });

              sub = json.decode(sub.body);
              print(sub.toString());
              test = await http.get(
                  Uri.parse(
                      'https://api.twitch.tv/helix/eventsub/subscriptions'),
                  headers: {
                    'Authorization': 'Bearer $bearerID',
                    'Client-Id': '$clientID',
                  });
              test = json.decode(test.body);
              print(test.toString());
              print(test.toString());

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SecondPage()),
              );
            }
          });
        },
      ),
    ));
  }
}

//SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);

