import 'package:StreamDash/constant.dart';
import 'package:StreamDash/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

void updatePoint(int points) async {
  var getUser =
      await FirebaseFirestore.instance.collection('users').doc(id).get();
  await FirebaseFirestore.instance
      .collection("users")
      .doc(id)
      .update({"point": getUser['point'] + points});
}

void getPoint() async {
  var getUser =
      await FirebaseFirestore.instance.collection('users').doc(id).get();
  pointsClient = getUser['points'];
}

void createRoom(int points) async {
  var getUser =
      await FirebaseFirestore.instance.collection('users').doc(id).get();
  if ((getUser['point'] - points) > 0) {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .update({"point": getUser['point'] - points});
    var getRoom =
        await FirebaseFirestore.instance.collection("room").doc('1').get();
    await FirebaseFirestore.instance
        .collection("room")
        .doc('1')
        .set({"Nom": ""});
  } else {}
}

Future<bool> getUserSignUp() async {
  print('ehehhehe');
  try {
    var getUser = await FirebaseFirestore.instance
        .collection('users')
        .doc(bz['data'][0]['id'])
        .get();
    pointsClient = getUser['point'];
  } catch (e) {
    print(bz['data'][0]['id'].toString());
    await FirebaseFirestore.instance
        .collection('users')
        .doc("${bz['data'][0]['id']}")
        .set({
      "display_name": bz['data'][0]['display_name'],
      "id": bz['data'][0]['id'],
      "img": bz['data'][0]['profile_image_url'],
      "point": 0,
    });
  }

  return true;
}
