import 'dart:io';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-4220221705377808/8895675793';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-4220221705377808/8829099328';
    } else {
      throw new UnsupportedError('Unsupported platform');
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/1033173712";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/4411468910";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-4220221705377808/6600271597";
    } else if (Platform.isIOS) {
      return "ca-app-pub-4220221705377808/5942900002";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
}
