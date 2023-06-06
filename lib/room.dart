import 'dart:async';
import 'dart:io';

//import 'package:admob_flutter/admob_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:StreamDash/constant.dart';
import 'package:flutter/material.dart';

import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:http/http.dart' as http;

import 'main.dart';
import 'dart:convert';

int i = 0;

int nfollower = follower['total'];
int nsub = sub['total'];
int timerC = 0;

class Room extends StatefulWidget {
  const Room({Key? key}) : super(key: key);

  @override
  State<Room> createState() => RoomState();
}

class RoomState extends State<Room> {
  ///AdmobBannerSize bannerSize;
  //AdmobInterstitial interstitialAd;
  //AdmobReward rewardAd;
  final BannerAd myBanner = BannerAd(
    adUnitId: Platform.isAndroid
        ? 'ca-app-pub-4220221705377808/8895675793'
        : 'ca-app-pub-4220221705377808/8829099328',
    size: AdSize.banner,
    request: AdRequest(),
    listener: BannerAdListener(),
  );
  final AdSize adSize = AdSize(width: 300, height: 50);
  final BannerAdListener listener = BannerAdListener(
    // Called when an ad is successfully received.
    onAdLoaded: (Ad ad) => print('Ad loaded.'),
    // Called when an ad request failed.
    onAdFailedToLoad: (Ad ad, LoadAdError error) {
      // Dispose the ad here to free resources.
      ad.dispose();
      print('Ad failed to load: $error');
    },
    // Called when an ad opens an overlay that covers the screen.
    onAdOpened: (Ad ad) => print('Ad opened.'),
    // Called when an ad removes an overlay that covers the screen.
    onAdClosed: (Ad ad) => print('Ad closed.'),
    // Called when an impression occurs on the ad.
    onAdImpression: (Ad ad) => print('Ad impression.'),
  );

  @override
  void initState() {
    super.initState();
    //bannerSize = AdmobBannerSize.BANNER;
  }

  @override
  Widget build(BuildContext context) {
    timerC = 0;
    myBanner.load();
    final AdWidget adWidget = AdWidget(ad: myBanner);
    final Container adContainer = Container(
      alignment: Alignment.center,
      child: adWidget,
      width: myBanner.size.width.toDouble(),
      height: myBanner.size.height.toDouble(),
    );

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
          'Rooms',
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
          child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('room').snapshots(),
            builder: (context, snapshot) {
              return ListView.builder(
                  padding: EdgeInsets.zero,
                  physics: ClampingScrollPhysics(),
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (context, index) =>
                      _buildListItem(snapshot.data!.docs[index], context));
            },
          )),
    );
  }

  Widget _buildListItem(DocumentSnapshot document, BuildContext context) {
    return GestureDetector(
        onTap: () {},
        child: Container(
          margin: EdgeInsets.all(20),
          padding: EdgeInsets.all(20),
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.1,
          decoration: BoxDecoration(
              border: Border.all(width: 1),
              color: Colors.grey,
              borderRadius: BorderRadius.circular(30)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                  child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          document['Name'],
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
            ],
          ),
        ));
  }
}

class Room2 extends StatefulWidget {
  const Room2({Key? key}) : super(key: key);

  @override
  State<Room2> createState() => Room2State();
}

//TwitchController tt = TwitchController();

class Room2State extends State<Room2> {
  ///AdmobBannerSize bannerSize;
  //AdmobInterstitial interstitialAd;
  //AdmobReward rewardAd;
  final BannerAd myBanner = BannerAd(
    adUnitId: Platform.isAndroid
        ? 'ca-app-pub-4220221705377808/8895675793'
        : 'ca-app-pub-4220221705377808/8829099328',
    size: AdSize.banner,
    request: AdRequest(),
    listener: BannerAdListener(),
  );
  final AdSize adSize = AdSize(width: 300, height: 50);
  final BannerAdListener listener = BannerAdListener(
    // Called when an ad is successfully received.
    onAdLoaded: (Ad ad) => print('Ad loaded.'),
    // Called when an ad request failed.
    onAdFailedToLoad: (Ad ad, LoadAdError error) {
      // Dispose the ad here to free resources.
      ad.dispose();
      print('Ad failed to load: $error');
    },
    // Called when an ad opens an overlay that covers the screen.
    onAdOpened: (Ad ad) => print('Ad opened.'),
    // Called when an ad removes an overlay that covers the screen.
    onAdClosed: (Ad ad) => print('Ad closed.'),
    // Called when an impression occurs on the ad.
    onAdImpression: (Ad ad) => print('Ad impression.'),
  );

  @override
  void initState() {
    super.initState();
    //bannerSize = AdmobBannerSize.BANNER;
  }

  @override
  Widget build(BuildContext context) {
    timerC = 0;
    myBanner.load();
    final AdWidget adWidget = AdWidget(ad: myBanner);
    final Container adContainer = Container(
      alignment: Alignment.center,
      child: adWidget,
      width: myBanner.size.width.toDouble(),
      height: myBanner.size.height.toDouble(),
    );

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
            'Rooms',
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.height * 0.03,
                color: Colors.white,
                fontWeight: FontWeight.bold),
          ),
        ),
        body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(color: Colors.orange),
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('room')
                  .doc("1")
                  .collection("1")
                  .where("DateTime", isGreaterThan: DateTime.now())
                  .orderBy("DateTime")
                  .limit(1)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<QueryDocumentSnapshot<Map<String, dynamic>>>? items =
                      snapshot.data?.docs;
                  return Column(
                    children: [
                      /*Container(
                          height: MediaQuery.of(context).size.height * 0.35,
                          width: MediaQuery.of(context).size.width * 0.95,
                          child: TwitchPlayerIFrame(
                            channel: items![0]["Name"],
                            controller: tt,
                            parent: 'twitch.tv',
                            autoplay: true,
                          ))*/
                    ],
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            )));
  }
}
