import 'dart:io';

import 'package:StreamDash/api/function.dart';
import 'package:StreamDash/constant.dart';
import 'package:StreamDash/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:countdown_progress_indicator/countdown_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'accueil.dart';
import 'dart:async';

import 'dart:ui' as ui;
import 'package:flutter/material.dart';

import 'adHelper.dart';

late Timer _timer;
int _start = 6000;
late String videoURL;
int fff = 0;
late String videoID;
late int numberCredit;
late String error;

class Launcher extends StatefulWidget {
  const Launcher({Key? key}) : super(key: key);

  @override
  State<Launcher> createState() => LauncherState();
}

class LauncherState extends State<Launcher> {
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

  final _controller = YoutubePlayerController(
    params: YoutubePlayerParams(
      mute: false,
      showControls: false,
      showFullscreenButton: false,
      loop: true,
    ),
  )..loadVideoById(
      videoId: ids.first,
    );

  @override
  void dispose() {
    _bannerAd?.dispose();
    _timer.cancel();
    super.dispose();
  }

  CountDownController ccontroller = CountDownController();
  @override
  Widget build(BuildContext context) {
    print(ids);

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/home');
                },
                icon: Icon(Icons.home))
          ],
          centerTitle: true,
          title: Center(
            child: Text('Youtube Boost'),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Center(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.3,
                width: MediaQuery.of(context).size.width * 0.9,
                child: YoutubePlayer(
                  controller: _controller,
                ),
              ),
            ),
            if (_bannerAd != null)
              AnimatedContainer(
                width: _bannerAd != null
                    ? _bannerAd!.size.width.toDouble()
                    : double.infinity,
                height:
                    _bannerAd != null ? _bannerAd!.size.height.toDouble() : 0,
                duration: Duration(seconds: 2),
                child: AdWidget(ad: _bannerAd!),
              ),
            SizedBox(
              height: 200,
              width: 200,
              child: CountDownProgressIndicator(
                  controller: ccontroller,
                  valueColor: Colors.red,
                  backgroundColor: Colors.blue,
                  initialPosition: 0,
                  duration: 60,
                  text: 'SEC',
                  onComplete: () async {
                    updatePoint(100);
                    pointsClient += 100;
                    ids.removeAt(0);
                    if (ids.isEmpty) {
                      QuerySnapshot<Map<String, dynamic>> vidsID =
                          await FirebaseFirestore.instance
                              .collection('youtubeBoost')
                              .where("Date", isGreaterThan: DateTime.now())
                              .get();
                      print(vidsID.docs[1]['id']);
                      for (var i = 0; i < vidsID.docs.length; i++) {
                        ids.add(vidsID.docs[i]['id']);
                      }
                    }
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Vous avez gagner 100 Points !'),
                    ));
                    Navigator.pushNamed(context, '/YoutubeBoost');
                  }),
            ),
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => _buildPopupDialog(context),
                );
              },
              child: Container(
                height: MediaQuery.of(context).size.height * 0.075,
                width: MediaQuery.of(context).size.width * 0.8,
                margin: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height * 0.1),
                decoration: BoxDecoration(
                    color: Colors.purple,
                    borderRadius: BorderRadius.circular(30)),
                child: Center(
                  child: Text(
                    'Ajouter une vidéo',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            )
          ],
        ));
  }

  Widget _buildPopupDialog(BuildContext context) {
    return AlertDialog(
      title: const Text('Add YouTube Vidéo'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.width * 0.025),
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.025),
            height: MediaQuery.of(context).size.height * 0.065,
            width: MediaQuery.of(context).size.width * 0.7,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.grey.shade900, width: 2)),
            child: TextFormField(
              style: TextStyle(color: Colors.black),
              validator: null,
              decoration: InputDecoration(
                border: InputBorder.none,
                icon: Icon(
                  Icons.youtube_searched_for_sharp,
                  color: Colors.black,
                ),
                hintText: 'Vidéo ID',
                hintStyle: TextStyle(color: Colors.black),
              ),
              onChanged: (val) {
                setState(() => videoID = val);
              },
            ),
          ),
          Text(
            '1 jour = 1000 Points',
            textAlign: TextAlign.center,
          ),
          Container(
            margin: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.width * 0.025),
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.025),
            height: MediaQuery.of(context).size.height * 0.065,
            width: MediaQuery.of(context).size.width * 0.7,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.grey.shade900, width: 2)),
            child: TextFormField(
              keyboardType: TextInputType.number,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                border: InputBorder.none,
                icon: Icon(
                  Icons.monetization_on,
                  color: Colors.black,
                ),
                hintText: 'Nombre de jours',
                hintStyle: TextStyle(color: Colors.black),
              ),
              onChanged: (val) {
                setState(() => numberCredit = int.parse(val).round());
              },
            ),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
        TextButton(
          onPressed: () async {
            var bdd = await FirebaseFirestore.instance
                .collection('users')
                .doc(id)
                .get();
            if (videoID.length > 11) {
              videoID = videoID.substring(17, 28);
            }
            int iiii = bdd['point'];
            var date = new DateTime.now();
            print(iiii);
            print(videoID.length);
            if (iiii < numberCredit * 100 || videoID.length != 11) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Erreur de crédit ou lien incorrect'),
              ));
              Navigator.pop(context);
            } else {
              print('OK');
              await FirebaseFirestore.instance
                  .collection('youtubeBoost')
                  .doc(videoID)
                  .set({
                'Date': DateTime(
                  date.year,
                  date.month,
                  date.day + numberCredit,
                ),
                'id': videoID,
              });
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(id)
                  .update({
                'point': iiii - (numberCredit * 1000),
              });
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Vidéo ajouté'),
              ));
              Navigator.pop(context);
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
