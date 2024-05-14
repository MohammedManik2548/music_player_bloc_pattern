import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdHelper {
  static BannerAd? bannerAd;
  static InterstitialAd? interstitialAd;
  static void initInterstitialAd(){
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
            },
          );

          interstitialAd = ad;

        },
        onAdFailedToLoad: (err) {
          print('Failed to load an interstitial ad: ${err.message}');
        },
      ),
    );
  }

  static void initBannerAd(){
    bannerAd?.dispose();
    // myBanner.load();
    BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          bannerAd = ad as BannerAd;
        },
        onAdFailedToLoad: (ad, err) {
          //print('Failed to load a banner ad: ${err.message}');
          ad.dispose();
        },
      ),
    ).load();
  }

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-1739797254488033/9737923092';///Live
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      // return "ca-app-pub-1739797254488033/5938316871";///Live
      return "ca-app-pub-3940256099942544/1033173712";///Testing
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/4411468910";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }
  static String get nativeAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/2247696110';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/3986624511';
    }
    throw UnsupportedError("Unsupported platform");
  }

  static Widget customBannerAds({required double h, required double w}) {
    return Container(
      alignment: Alignment.center,
      height: h,
      width: w,
      child: AdHelper.bannerAd==null?const SizedBox():AdWidget(

          ad: AdHelper.bannerAd!),
    );
  }

  static void customInterstitial(Duration duration) async{
    await Future.delayed(duration).then((value) {
      final interstitialAd = AdHelper.interstitialAd;
      if(interstitialAd!=null){
        interstitialAd.show();
      }
    });
  }
}