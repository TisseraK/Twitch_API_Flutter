import 'dart:convert';
import 'dart:io';
import 'package:StreamDash/constant.dart';
import 'package:StreamDash/main.dart';
import 'package:StreamDash/streampad.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:StreamDash/dashboard.dart';
//import 'package:admob_flutter/admob_flutter.dart';

import 'adHelper.dart';

class SecondPage extends StatefulWidget {
  const SecondPage({Key? key}) : super(key: key);

  @override
  State<SecondPage> createState() => SecondPageState();
}

List<String> ids = ['bZlBn4oPYfc'];

class SecondPageState extends State<SecondPage> {
  //AdmobBannerSize bannerSize;
  //AdmobInterstitial interstitialAd;
  //AdmobReward rewardAd;
  BannerAd? _bannerAd;
  @override
  void initState() {
    super.initState();
    BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          ad.dispose();
        },
      ),
    ).load();
  }

  void dispose() {
    // TODO: Dispose a BannerAd object
    _bannerAd?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Home',
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
          child: ListView(
            children: [
              Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(padding: EdgeInsets.all(25)),
                    Text(
                      'Bienvenue ' + bz['data'][0]['display_name'].toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height * 0.03,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    Padding(padding: EdgeInsets.all(25)),
                    Container(
                        padding: EdgeInsets.all(15),
                        margin: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.width * 0.2,
                            vertical:
                                MediaQuery.of(context).size.height * 0.01),
                        height: MediaQuery.of(context).size.height * 0.15,
                        width: MediaQuery.of(context).size.width * 0.8,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade900,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: Colors.white, width: 2)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              'Follower : ',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.height * 0.03,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              follower['total'].toString(),
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.height * 0.03,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        )),
                    Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.width * 0.2,
                            vertical:
                                MediaQuery.of(context).size.height * 0.01),
                        height: MediaQuery.of(context).size.height * 0.15,
                        width: MediaQuery.of(context).size.width * 0.8,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade900,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: Colors.white, width: 2)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Subscriber : ',
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.height * 0.03,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              sub['total'].toString(),
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.height * 0.03,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        )),
                    Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.width * 0.2,
                            vertical:
                                MediaQuery.of(context).size.height * 0.01),
                        height: MediaQuery.of(context).size.height * 0.15,
                        width: MediaQuery.of(context).size.width * 0.8,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade900,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: Colors.white, width: 2)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Points : ',
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.height * 0.03,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              pointsClient.toString(),
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.height * 0.03,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        )),
                    Padding(padding: EdgeInsets.all(5)),
                    if (_bannerAd != null)
                      AnimatedContainer(
                        width: _bannerAd != null
                            ? _bannerAd!.size.width.toDouble()
                            : double.infinity,
                        height: _bannerAd != null
                            ? _bannerAd!.size.height.toDouble()
                            : 0,
                        duration: Duration(seconds: 2),
                        child: AdWidget(ad: _bannerAd!),
                      ),
                    Padding(padding: EdgeInsets.all(5)),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Text(
                        'Découvre nos outils disponible !',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize:
                                MediaQuery.of(context).size.height * 0.03),
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(15)),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Text(
                        'Un outil te permettant de gérer entierement ton stream !',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize:
                                MediaQuery.of(context).size.height * 0.025),
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(15)),
                    GestureDetector(
                      onTap: () async {
                        stream = await http.get(Uri.parse(
                            //'https://api.twitch.tv/helix/streams?user_id=${bz['data'][0]['id']}'),
                            'https://api.twitch.tv/helix/streams'), headers: {
                          'Authorization': 'Bearer $bearerID',
                          'Client-Id': '$clientID',
                        });

                        stream = await json.decode(stream.body);

                        Navigator.pushNamed(context, '/dashboard');
                      },
                      child: Container(
                          padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
                          margin: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.width * 0.2,
                          ),
                          decoration: BoxDecoration(
                              color: Colors.purple,
                              borderRadius: BorderRadius.circular(30)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Dashboard',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          )),
                    ),
                    Padding(padding: EdgeInsets.all(15)),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Text(
                        'Un outil minimaliste pour gérer ton stream !',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize:
                                MediaQuery.of(context).size.height * 0.025),
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(15)),
                    GestureDetector(
                      onTap: () async {
                        id = bz['data'][0]['id'].toString();
                        stream = await http.get(Uri.parse(
                            //'https://api.twitch.tv/helix/streams?user_id=${bz['data'][0]['id']}'),
                            'https://api.twitch.tv/helix/streams'), headers: {
                          'Authorization': 'Bearer $bearerID',
                          'Client-Id': '$clientID',
                        });

                        stream = await json.decode(stream.body);

                        Navigator.pushNamed(context, '/streampad');
                      },
                      child: Container(
                          margin: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.2,
                              vertical:
                                  MediaQuery.of(context).size.height * 0.01),
                          padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
                          decoration: BoxDecoration(
                              color: Colors.purple,
                              borderRadius: BorderRadius.circular(30)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Stream Pad',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          )),
                    ),
                    Padding(padding: EdgeInsets.all(15)),
                    /*Platform.isAndroid
                        ? Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: Text(
                              'Gagne des points avec la communauté et boost ton stream !',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: MediaQuery.of(context).size.height *
                                      0.025),
                            ),
                          )
                        : SizedBox(),
                    Platform.isAndroid
                        ? Padding(padding: EdgeInsets.all(15))
                        : SizedBox(),
                    Platform.isAndroid
                        ? GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/room');
                            },
                            child: Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal:
                                        MediaQuery.of(context).size.width * 0.2,
                                    vertical:
                                        MediaQuery.of(context).size.height *
                                            0.01),
                                padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
                                decoration: BoxDecoration(
                                    color: Colors.purple,
                                    borderRadius: BorderRadius.circular(30)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Twitch Rooms',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                )),
                          )
                        : SizedBox(),
                    Platform.isAndroid
                        ? Padding(padding: EdgeInsets.all(15))
                        : SizedBox(),*/
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Text(
                        'Augmente ton nombre de vus YouTube avec la communauté !',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize:
                                MediaQuery.of(context).size.height * 0.025),
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(15)),
                    GestureDetector(
                      onTap: () async {
                        QuerySnapshot<Map<String, dynamic>> vidsID =
                            await FirebaseFirestore.instance
                                .collection('youtubeBoost')
                                .where("Date", isGreaterThan: DateTime.now())
                                .get();
                        print(vidsID.docs[1]['id']);
                        for (var i = 0; i < vidsID.docs.length; i++) {
                          ids.add(vidsID.docs[i]['id']);
                        }
                        Navigator.pushNamed(context, '/YoutubeBoost');
                      },
                      child: Container(
                          margin: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.2,
                              vertical:
                                  MediaQuery.of(context).size.height * 0.01),
                          padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
                          decoration: BoxDecoration(
                              color: Colors.purple,
                              borderRadius: BorderRadius.circular(30)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Youtube Viewer',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          )),
                    ),
                    Padding(padding: EdgeInsets.all(15)),
                    /*Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Text(
                        'Deviens VIP et gagne encore plus de points !',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize:
                                MediaQuery.of(context).size.height * 0.025),
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(15)),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/room');
                      },
                      child: Container(
                          margin: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.2,
                              vertical:
                                  MediaQuery.of(context).size.height * 0.01),
                          padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
                          decoration: BoxDecoration(
                              color: Colors.purple,
                              borderRadius: BorderRadius.circular(30)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'VIP',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          )),
                    ),*/
                  ])
            ],
          )),
    );
  }
}
