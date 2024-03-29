import 'dart:async';
import 'dart:io';

//import 'package:admob_flutter/admob_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:StreamDash/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';

import 'adHelper.dart';
import 'main.dart';
import 'dart:convert';

RewardedAd? _rewardedAd;
int nfollower = follower['total'];
int nsub = sub['total'];
int timerC = 0;
String namee = bz['data'][0]['login'].toString();

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => DashboardState();
}

WebViewController controller = WebViewController()
  ..setJavaScriptMode(JavaScriptMode.unrestricted)
  ..setBackgroundColor(const Color(0x00000000))
  ..setNavigationDelegate(
    NavigationDelegate(
      onProgress: (int progress) {
        // Update loading bar.
      },
      onPageStarted: (String url) {},
      onPageFinished: (String url) {},
      onWebResourceError: (WebResourceError error) {},
    ),
  )
  ..loadRequest(Uri.parse(
      'https://nightdev.com/hosted/obschat?theme=bttv_dark&channel=${bz['data'][0]['login']}&fade=false&bot_activity=true&prevent_clipping=false'));

class DashboardState extends State<Dashboard> {
  @override
  void initState() {
    RewardedAd.load(
      adUnitId: AdHelper.rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          print('---');
          debugPrint('$ad loaded.');
          // Keep a reference to the ad so you can show it later.
          _rewardedAd = ad;
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (LoadAdError error) {
          print('ERRRROOOO');
          debugPrint('RewardedAd failed to load: $error');
        },
      ),
    );

    nfollower = follower['total'];
    nsub = sub['total'];
    id = bz['data'][0]['id'].toString();
    print(id);
    Timer mytimer = Timer.periodic(Duration(seconds: 5), (timer) async {
      stream = await http
          .get(Uri.parse('https://api.twitch.tv/helix/streams?user_id=$id'),
              //'https://api.twitch.tv/helix/streams'),
              headers: {
            'Authorization': 'Bearer $bearerID',
            'Client-Id': '$clientID',
          });
      follower = await http.get(Uri.parse(
          //'https://api.twitch.tv/helix/streams?user_id=${bz['data'][0]['id']}'),
          'https://api.twitch.tv/helix/users/follows?to_id=$id'), headers: {
        'Authorization': 'Bearer $bearerID',
        'Client-Id': '$clientID',
      });
      follower = await json.decode(follower.body);
      if (follower['total'] > nfollower) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('NEW FOLLOWERS !'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Text("Name : ${follower['data'][0]['from_name']} ")],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
      }

      sub = await http.get(Uri.parse(
              //'https://api.twitch.tv/helix/streams?user_id=${bz['data'][0]['id']}'),
              'https://api.twitch.tv/helix/subscriptions?broadcaster_id=$id&first=1'),
          headers: {
            'Authorization': 'Bearer $bearerID',
            'Client-Id': '$clientID',
          });

      sub = await json.decode(sub.body);
      if (sub['total'] > nsub) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('NEW SUBSCRIBERs !'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Text("Name : ${sub['data'][0]['user_name']} ")],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Close',
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ),
              ],
            );
          },
        );
      }

      if (timerC == 1) {
        timer.cancel();
      }
      print('3');
      setState(() {
        stream = json.decode(stream.body);
        nfollower = follower['total'];
        nsub = sub['total'];
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(ez['data'][0]['user_login']);
    timerC = 0;

    if (stream['data'].toString() == '[]') {
      print('1');
      return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.home),
              tooltip: 'Back Home',
              onPressed: () {
                timerC = 1;
                Navigator.pushNamed(context, '/home');
              },
            ),
          ],
          automaticallyImplyLeading: false,
          title: Text(
            'Dashboard',
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.height * 0.03,
                color: Colors.white,
                fontWeight: FontWeight.bold),
          ),
        ),
        body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(color: Colors.black),
            child: ListView(children: [
              if (bannerAd != null)
                AnimatedContainer(
                  width: bannerAd != null
                      ? bannerAd!.size.width.toDouble()
                      : double.infinity,
                  height:
                      bannerAd != null ? bannerAd!.size.height.toDouble() : 0,
                  duration: Duration(seconds: 2),
                  child: AdWidget(ad: bannerAd!),
                ),
              Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'Viewer',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize:
                                MediaQuery.of(context).size.height * 0.02),
                      ),
                      Padding(padding: EdgeInsets.all(2.5)),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.purple,
                            borderRadius: BorderRadius.circular(30)),
                        padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        child: Text(
                          "Stream Off",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.015),
                        ),
                      )
                    ],
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                      padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            'Followers',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.02),
                          ),
                          Padding(padding: EdgeInsets.all(2.5)),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.purple,
                                borderRadius: BorderRadius.circular(30)),
                            padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                            child: Text(
                              '${follower['total'].toString()}',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: MediaQuery.of(context).size.height *
                                      0.015),
                            ),
                          )
                        ],
                      )),
                  Padding(padding: EdgeInsets.all(2.5)),
                  Container(
                      padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            'Sub',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.02),
                          ),
                          Padding(padding: EdgeInsets.all(2.5)),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.purple,
                                borderRadius: BorderRadius.circular(30)),
                            padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                            child: Text(
                              '${sub['total'].toString()}',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: MediaQuery.of(context).size.height *
                                      0.015),
                            ),
                          )
                        ],
                      )),
                ],
              ),
              Padding(padding: EdgeInsets.all(10)),
              Padding(padding: EdgeInsets.all(10)),
              Container(
                height: MediaQuery.of(context).size.height * 0.5,
                width: MediaQuery.of(context).size.width,
                child: GridView.count(
                  primary: false,
                  padding: const EdgeInsets.all(10),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  crossAxisCount: 3,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        var marker;
                        marker = await http.post(Uri.parse(
                                //'https://api.twitch.tv/helix/streams?user_id=${bz['data'][0]['id']}'),
                                'https://api.twitch.tv/helix/streams/markers'),
                            headers: {
                              'Authorization': 'Bearer $bearerID',
                              'Client-Id': '$clientID',
                            },
                            body: {
                              'user_id': '${bz['data'][0]['id']}',
                              'derscription': "Stream Marker from StreamDash"
                            });

                        marker = json.decode(marker.body);
                        print(marker.toString());
                        if (marker['error'] != null) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('${marker['message']}'),
                          ));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: const Text('Stream Marker create'),
                          ));
                        }

                        _rewardedAd!.show(
                            onUserEarnedReward:
                                (AdWithoutView ad, RewardItem rewardItem) {});
                      },
                      child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.purple,
                              borderRadius: BorderRadius.circular(30)),
                          child: Center(
                            child: Text(
                              'Create Stream Marker',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: MediaQuery.of(context).size.height *
                                      0.02),
                            ),
                          )),
                    ),
                    GestureDetector(
                      onTap: () async {
                        var marker;
                        marker = await http.post(Uri.parse(
                                //'https://api.twitch.tv/helix/streams?user_id=${bz['data'][0]['id']}'),
                                'https://api.twitch.tv/helix/clips?broadcaster_id?=$id'),
                            headers: {
                              'Authorization': 'Bearer $bearerID',
                              'Client-Id': '$clientID',
                            },
                            body: {
                              'broadcaster_id': id,
                              'length': '90'
                            });

                        marker = json.decode(marker.body);
                        print(marker.toString());
                        if (marker['error'] != null) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('${marker['message']}'),
                          ));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: const Text('Clip Create'),
                          ));
                        }

                        _rewardedAd!.show(
                            onUserEarnedReward:
                                (AdWithoutView ad, RewardItem rewardItem) {});
                      },
                      child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.purple,
                              borderRadius: BorderRadius.circular(30)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                'Create Clip',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            0.02),
                              ),
                            ],
                          )),
                    ),
                    GestureDetector(
                      onTap: () async {
                        var marker;
                        marker = await http.post(Uri.parse(
                                //'https://api.twitch.tv/helix/streams?user_id=${bz['data'][0]['id']}'),
                                'https://api.twitch.tv/helix/channels/commercial'),
                            headers: {
                              'Authorization': 'Bearer $bearerID',
                              'Client-Id': '$clientID',
                            },
                            body: {
                              'broadcaster_id': id,
                              'length': '30'
                            });

                        marker = json.decode(marker.body);
                        print(marker.toString());
                        if (marker['error'] != null) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('${marker['message']}'),
                          ));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: const Text('30 secondes ADS launch'),
                          ));
                        }

                        _rewardedAd!.show(
                            onUserEarnedReward:
                                (AdWithoutView ad, RewardItem rewardItem) {});
                      },
                      child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.purple,
                              borderRadius: BorderRadius.circular(30)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                'Ads 30 secondes',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            0.02),
                              ),
                            ],
                          )),
                    ),
                    GestureDetector(
                      onTap: () async {
                        var marker;
                        marker = await http.post(Uri.parse(
                                //'https://api.twitch.tv/helix/streams?user_id=${bz['data'][0]['id']}'),
                                'https://api.twitch.tv/helix/channels/commercial'),
                            headers: {
                              'Authorization': 'Bearer $bearerID',
                              'Client-Id': '$clientID',
                            },
                            body: {
                              'broadcaster_id': id,
                              'length': '60'
                            });

                        marker = json.decode(marker.body);
                        print(marker.toString());
                        if (marker['error'] != null) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('${marker['message']}'),
                          ));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: const Text('60 secondes ADS launch'),
                          ));
                        }

                        _rewardedAd!.show(
                            onUserEarnedReward:
                                (AdWithoutView ad, RewardItem rewardItem) {});
                      },
                      child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.purple,
                              borderRadius: BorderRadius.circular(30)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                'Ads 60 secondes',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            0.02),
                              ),
                            ],
                          )),
                    ),
                    GestureDetector(
                      onTap: () async {
                        var marker;
                        marker = await http.post(Uri.parse(
                                //'https://api.twitch.tv/helix/streams?user_id=${bz['data'][0]['id']}'),
                                'https://api.twitch.tv/helix/channels/commercial'),
                            headers: {
                              'Authorization': 'Bearer $bearerID',
                              'Client-Id': '$clientID',
                            },
                            body: {
                              'broadcaster_id': id,
                              'length': '90'
                            });

                        marker = json.decode(marker.body);
                        print(marker.toString());
                        if (marker['error'] != null) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('${marker['message']}'),
                          ));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: const Text('90 secondes ADS launch'),
                          ));
                        }

                        _rewardedAd!.show(
                            onUserEarnedReward:
                                (AdWithoutView ad, RewardItem rewardItem) {});
                      },
                      child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.purple,
                              borderRadius: BorderRadius.circular(30)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                'Ads 90 secondes',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            0.02),
                              ),
                            ],
                          )),
                    ),
                  ],
                ),
              )
            ])),
      );
    } else {
      if (MediaQuery.of(context).size.height >
          MediaQuery.of(context).size.width) {
        return Scaffold(
          appBar: AppBar(
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.home),
                tooltip: 'Back Home',
                onPressed: () {},
              ),
            ],
            automaticallyImplyLeading: false,
            title: Text(
              'Dashboard',
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height * 0.03,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
          body: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(color: Colors.black),
              child: ListView(children: [
                if (bannerAd != null)
                  AnimatedContainer(
                    width: bannerAd != null
                        ? bannerAd!.size.width.toDouble()
                        : double.infinity,
                    height:
                        bannerAd != null ? bannerAd!.size.height.toDouble() : 0,
                    duration: Duration(seconds: 2),
                    child: AdWidget(ad: bannerAd!),
                  ),
                /*
                Platform.isAndroid
                    ? Container(
                        height: MediaQuery.of(context).size.height * 0.35,
                        width: MediaQuery.of(context).size.width * 0.95,
                        child: TwitchPlayerIFrame(
                          channel: '$namee',
                          controller: tt,
                          parent: 'twitch.tv',
                          autoplay: true,
                        )
*/
                /*InAppWebView(
                  initialUrlRequest: URLRequest(
                    url: Uri.parse(
                      ('https://nightdev.com/hosted/obschat?theme=bttv_dark&channel=${bz['data'][0]['login']}&fade=false&bot_activity=true&prevent_clipping=false'),
                    ),
                  ),
                  androidOnPermissionRequest:
                      (controller, origin, resources) async {
                    return PermissionRequestResponse(
                        resources: resources,
                        action: PermissionRequestResponseAction.GRANT);
                  },
                ),*/
                /* )
                    : Container(),*/
                Container(
                    padding: EdgeInsets.fromLTRB(64, 16, 64, 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.purple,
                              borderRadius: BorderRadius.circular(30)),
                          padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                          child: Text(
                            stream['data'][0]['viewer_count'].toString(),
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.015),
                          ),
                        )
                      ],
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                        padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              'Followers',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: MediaQuery.of(context).size.height *
                                      0.02),
                            ),
                            Padding(padding: EdgeInsets.all(10)),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.purple,
                                  borderRadius: BorderRadius.circular(30)),
                              padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                              child: Text(
                                '${follower['total'].toString()}',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            0.015),
                              ),
                            )
                          ],
                        )),
                    Container(
                        padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              'Sub',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: MediaQuery.of(context).size.height *
                                      0.02),
                            ),
                            Padding(padding: EdgeInsets.all(10)),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.purple,
                                  borderRadius: BorderRadius.circular(30)),
                              padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                              child: Text(
                                '${sub['total'].toString()}',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            0.015),
                              ),
                            )
                          ],
                        )),
                  ],
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: MediaQuery.of(context).size.width * 0.95,
                  child: Platform.isAndroid
                      ? InAppWebView(
                          initialUrlRequest: URLRequest(
                            url: Uri.parse(
                              ('https://nightdev.com/hosted/obschat?theme=bttv_dark&channel=${bz['data'][0]['login']}&fade=false&bot_activity=true&prevent_clipping=false'),
                            ),
                          ),
                          androidOnPermissionRequest:
                              (controller, origin, resources) async {
                            return PermissionRequestResponse(
                                resources: resources,
                                action: PermissionRequestResponseAction.GRANT);
                          },
                        )
                      : WebViewWidget(
                          controller: controller,
                        ),
                ),
                /*Container(
                  margin: EdgeInsets.symmetric(vertical: 20.0),
                  child: AdmobBanner(
                    adUnitId: getBannerAdUnitId(),
                    adSize: bannerSize,
                    listener:
                        (AdmobAdEvent event, Map<String, dynamic> args) {},
                  ),
                ),*/
                Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  width: MediaQuery.of(context).size.width,
                  child: GridView.count(
                    primary: false,
                    padding: const EdgeInsets.all(10),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    crossAxisCount: 3,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          var marker;
                          marker = await http.post(Uri.parse(
                                  //'https://api.twitch.tv/helix/streams?user_id=${bz['data'][0]['id']}'),
                                  'https://api.twitch.tv/helix/streams/markers'),
                              headers: {
                                'Authorization': 'Bearer $bearerID',
                                'Client-Id': '$clientID',
                              },
                              body: {
                                'user_id': '${bz['data'][0]['id']}',
                                'derscription': "Stream Marker from StreamDash"
                              });

                          marker = json.decode(marker.body);
                          print(marker.toString());
                          if (marker['error'] != null) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('${marker['message']}'),
                            ));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: const Text('Stream Marker create'),
                            ));
                          }

                          _rewardedAd!.show(
                              onUserEarnedReward:
                                  (AdWithoutView ad, RewardItem rewardItem) {});
                        },
                        child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.purple,
                                borderRadius: BorderRadius.circular(30)),
                            child: Center(
                              child: Text(
                                'Create Stream Marker',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            0.02),
                              ),
                            )),
                      ),
                      GestureDetector(
                        onTap: () async {
                          var marker;
                          marker = await http.post(Uri.parse(
                                  //'https://api.twitch.tv/helix/streams?user_id=${bz['data'][0]['id']}'),
                                  'https://api.twitch.tv/helix/clips?broadcaster_id?=$id'),
                              headers: {
                                'Authorization': 'Bearer $bearerID',
                                'Client-Id': '$clientID',
                              },
                              body: {
                                'broadcaster_id': id,
                                'length': '90'
                              });

                          marker = json.decode(marker.body);
                          print(marker.toString());
                          if (marker['error'] != null) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('${marker['message']}'),
                            ));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: const Text('Clip Create'),
                            ));
                          }

                          _rewardedAd!.show(
                              onUserEarnedReward:
                                  (AdWithoutView ad, RewardItem rewardItem) {});
                        },
                        child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.purple,
                                borderRadius: BorderRadius.circular(30)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  'Create Clip',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              0.02),
                                ),
                              ],
                            )),
                      ),
                      GestureDetector(
                        onTap: () async {
                          var marker;
                          marker = await http.post(Uri.parse(
                                  //'https://api.twitch.tv/helix/streams?user_id=${bz['data'][0]['id']}'),
                                  'https://api.twitch.tv/helix/channels/commercial'),
                              headers: {
                                'Authorization': 'Bearer $bearerID',
                                'Client-Id': '$clientID',
                              },
                              body: {
                                'broadcaster_id': id,
                                'length': '30'
                              });

                          marker = json.decode(marker.body);
                          print(marker.toString());
                          if (marker['error'] != null) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('${marker['message']}'),
                            ));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: const Text('30 secondes ADS launch'),
                            ));
                          }

                          _rewardedAd!.show(
                              onUserEarnedReward:
                                  (AdWithoutView ad, RewardItem rewardItem) {});
                        },
                        child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.purple,
                                borderRadius: BorderRadius.circular(30)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  'Ads 30 secondes',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              0.02),
                                ),
                              ],
                            )),
                      ),
                      GestureDetector(
                        onTap: () async {
                          var marker;
                          marker = await http.post(Uri.parse(
                                  //'https://api.twitch.tv/helix/streams?user_id=${bz['data'][0]['id']}'),
                                  'https://api.twitch.tv/helix/channels/commercial'),
                              headers: {
                                'Authorization': 'Bearer $bearerID',
                                'Client-Id': '$clientID',
                              },
                              body: {
                                'broadcaster_id': id,
                                'length': '60'
                              });

                          marker = json.decode(marker.body);
                          print(marker.toString());
                          if (marker['error'] != null) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('${marker['message']}'),
                            ));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: const Text('60 secondes ADS launch'),
                            ));
                          }

                          _rewardedAd!.show(
                              onUserEarnedReward:
                                  (AdWithoutView ad, RewardItem rewardItem) {});
                        },
                        child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.purple,
                                borderRadius: BorderRadius.circular(30)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  'Ads 60 secondes',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              0.02),
                                ),
                              ],
                            )),
                      ),
                      GestureDetector(
                        onTap: () async {
                          var marker;
                          marker = await http.post(Uri.parse(
                                  //'https://api.twitch.tv/helix/streams?user_id=${bz['data'][0]['id']}'),
                                  'https://api.twitch.tv/helix/channels/commercial'),
                              headers: {
                                'Authorization': 'Bearer $bearerID',
                                'Client-Id': '$clientID',
                              },
                              body: {
                                'broadcaster_id': id,
                                'length': '90'
                              });

                          marker = json.decode(marker.body);
                          print(marker.toString());
                          if (marker['error'] != null) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('${marker['message']}'),
                            ));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: const Text('90 secondes ADS launch'),
                            ));
                          }

                          _rewardedAd!.show(
                              onUserEarnedReward:
                                  (AdWithoutView ad, RewardItem rewardItem) {});
                        },
                        child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.purple,
                                borderRadius: BorderRadius.circular(30)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  'Ads 90 secondes',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              0.02),
                                ),
                              ],
                            )),
                      ),
                    ],
                  ),
                )
              ])),
        );
      } else {
        return Scaffold(
          appBar: AppBar(
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.home),
                tooltip: 'Back Home',
                onPressed: () {
                  timerC = 1;
                  Navigator.pushNamed(context, '/home');
                },
              ),
            ],
            automaticallyImplyLeading: false,
            title: Text(
              'Dashboard',
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height * 0.03,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
          body: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(color: Colors.black),
              child: ListView(children: [
                if (bannerAd != null)
                  AnimatedContainer(
                    width: bannerAd != null
                        ? bannerAd!.size.width.toDouble()
                        : double.infinity,
                    height:
                        bannerAd != null ? bannerAd!.size.height.toDouble() : 0,
                    duration: Duration(seconds: 2),
                    child: AdWidget(ad: bannerAd!),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                        padding: EdgeInsets.fromLTRB(64, 16, 64, 16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.purple,
                                  borderRadius: BorderRadius.circular(30)),
                              padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                              child: Text(
                                stream['data'][0]['viewer_count'].toString(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            0.015),
                              ),
                            )
                          ],
                        )),
                    Container(
                        padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              'Followers',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: MediaQuery.of(context).size.height *
                                      0.02),
                            ),
                            Padding(padding: EdgeInsets.all(10)),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.purple,
                                  borderRadius: BorderRadius.circular(30)),
                              padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                              child: Text(
                                '${follower['total'].toString()}',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            0.015),
                              ),
                            )
                          ],
                        )),
                    Container(
                        padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              'Sub',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: MediaQuery.of(context).size.height *
                                      0.02),
                            ),
                            Padding(padding: EdgeInsets.all(10)),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.purple,
                                  borderRadius: BorderRadius.circular(30)),
                              padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                              child: Text(
                                '${sub['total'].toString()}',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            0.015),
                              ),
                            )
                          ],
                        )),
                  ],
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.35,
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Platform.isAndroid
                          ? InAppWebView(
                              initialUrlRequest: URLRequest(
                                url: Uri.parse(
                                  ('https://nightdev.com/hosted/obschat?theme=bttv_dark&channel=${bz['data'][0]['login']}&fade=false&bot_activity=true&prevent_clipping=false'),
                                ),
                              ),
                              androidOnPermissionRequest:
                                  (controller, origin, resources) async {
                                return PermissionRequestResponse(
                                    resources: resources,
                                    action:
                                        PermissionRequestResponseAction.GRANT);
                              },
                            )
                          : WebViewWidget(
                              controller: controller,
                            ),
                    ),
                  ]),
                ),
                /*Container(
                  child: AdmobBanner(
                    adUnitId: getBannerAdUnitId(),
                    adSize: bannerSize,
                    listener:
                        (AdmobAdEvent event, Map<String, dynamic> args) {},
                  ),
                ),*/
                Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  width: MediaQuery.of(context).size.width,
                  child: GridView.count(
                    primary: false,
                    padding: const EdgeInsets.all(10),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    crossAxisCount: 3,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          var marker;
                          marker = await http.post(Uri.parse(
                                  //'https://api.twitch.tv/helix/streams?user_id=${bz['data'][0]['id']}'),
                                  'https://api.twitch.tv/helix/streams/markers'),
                              headers: {
                                'Authorization': 'Bearer $bearerID',
                                'Client-Id': '$clientID',
                              },
                              body: {
                                'user_id': '${bz['data'][0]['id']}',
                                'derscription': "Stream Marker from StreamDash"
                              });

                          marker = json.decode(marker.body);
                          print(marker.toString());
                          if (marker['error'] != null) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('${marker['message']}'),
                            ));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: const Text('Stream Marker create'),
                            ));
                          }

                          _rewardedAd!.show(
                              onUserEarnedReward:
                                  (AdWithoutView ad, RewardItem rewardItem) {});
                        },
                        child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.purple,
                                borderRadius: BorderRadius.circular(30)),
                            child: Center(
                              child: Text(
                                'Create Stream Marker',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            0.02),
                              ),
                            )),
                      ),
                      GestureDetector(
                        onTap: () async {
                          var marker;
                          marker = await http.post(Uri.parse(
                                  //'https://api.twitch.tv/helix/streams?user_id=${bz['data'][0]['id']}'),
                                  'https://api.twitch.tv/helix/clips?broadcaster_id?=$id'),
                              headers: {
                                'Authorization': 'Bearer $bearerID',
                                'Client-Id': '$clientID',
                              },
                              body: {
                                'broadcaster_id': id,
                                'length': '90'
                              });

                          marker = json.decode(marker.body);
                          print(marker.toString());
                          if (marker['error'] != null) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('${marker['message']}'),
                            ));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: const Text('Clip Create'),
                            ));
                          }

                          _rewardedAd!.show(
                              onUserEarnedReward:
                                  (AdWithoutView ad, RewardItem rewardItem) {});
                        },
                        child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.purple,
                                borderRadius: BorderRadius.circular(30)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  'Create Clip',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              0.02),
                                ),
                              ],
                            )),
                      ),
                      GestureDetector(
                        onTap: () async {
                          var marker;
                          marker = await http.post(Uri.parse(
                                  //'https://api.twitch.tv/helix/streams?user_id=${bz['data'][0]['id']}'),
                                  'https://api.twitch.tv/helix/channels/commercial'),
                              headers: {
                                'Authorization': 'Bearer $bearerID',
                                'Client-Id': '$clientID',
                              },
                              body: {
                                'broadcaster_id': id,
                                'length': '30'
                              });

                          marker = json.decode(marker.body);
                          print(marker.toString());
                          if (marker['error'] != null) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('${marker['message']}'),
                            ));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: const Text('30 secondes ADS launch'),
                            ));
                          }

                          _rewardedAd!.show(
                              onUserEarnedReward:
                                  (AdWithoutView ad, RewardItem rewardItem) {});
                        },
                        child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.purple,
                                borderRadius: BorderRadius.circular(30)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  'Ads 30 secondes',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              0.02),
                                ),
                              ],
                            )),
                      ),
                      GestureDetector(
                        onTap: () async {
                          var marker;
                          marker = await http.post(Uri.parse(
                                  //'https://api.twitch.tv/helix/streams?user_id=${bz['data'][0]['id']}'),
                                  'https://api.twitch.tv/helix/channels/commercial'),
                              headers: {
                                'Authorization': 'Bearer $bearerID',
                                'Client-Id': '$clientID',
                              },
                              body: {
                                'broadcaster_id': id,
                                'length': '60'
                              });

                          marker = json.decode(marker.body);
                          print(marker.toString());
                          if (marker['error'] != null) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('${marker['message']}'),
                            ));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: const Text('60 secondes ADS launch'),
                            ));
                          }

                          _rewardedAd!.show(
                              onUserEarnedReward:
                                  (AdWithoutView ad, RewardItem rewardItem) {});
                        },
                        child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.purple,
                                borderRadius: BorderRadius.circular(30)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  'Ads 60 secondes',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              0.02),
                                ),
                              ],
                            )),
                      ),
                      GestureDetector(
                        onTap: () async {
                          var marker;
                          marker = await http.post(Uri.parse(
                                  //'https://api.twitch.tv/helix/streams?user_id=${bz['data'][0]['id']}'),
                                  'https://api.twitch.tv/helix/channels/commercial'),
                              headers: {
                                'Authorization': 'Bearer $bearerID',
                                'Client-Id': '$clientID',
                              },
                              body: {
                                'broadcaster_id': id,
                                'length': '90'
                              });

                          marker = json.decode(marker.body);
                          print(marker.toString());
                          if (marker['error'] != null) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('${marker['message']}'),
                            ));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: const Text('90 secondes ADS launch'),
                            ));
                          }

                          _rewardedAd!.show(
                              onUserEarnedReward:
                                  (AdWithoutView ad, RewardItem rewardItem) {});
                        },
                        child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.purple,
                                borderRadius: BorderRadius.circular(30)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  'Ads 90 secondes',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              0.02),
                                ),
                              ],
                            )),
                      ),
                    ],
                  ),
                )
              ])),
        );
      }
    }
  }
}
