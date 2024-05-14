import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'ad_event.dart';
import 'ad_state.dart';

class AdBloc extends Bloc<AdEvent, AdState> {
  AdBloc() : super(AdState());

  @override
  Stream<AdState> mapEventToState(AdEvent event) async* {
    if (event is LoadAd) {
      yield state.copyWith(status: AdStatus.loading);

      try {
        final ad = BannerAd(
          size: AdSize.banner,
          adUnitId: 'ca-app-pub-3940256099942544/6300978111',
          request: AdRequest(),
          listener: BannerAdListener(
            // Called when an ad is successfully received.
            onAdLoaded: (ad) {
              debugPrint('$ad loaded.');
              // setState(() {
              //   _isLoaded = true;
              // });
            },
            // Called when an ad request failed.
            onAdFailedToLoad: (ad, err) {
              debugPrint('BannerAd failed to load: $err');
              // Dispose the ad here to free resources.
              ad.dispose();
            },
            // Called when an ad opens an overlay that covers the screen.
            onAdOpened: (Ad ad) {},
            // Called when an ad removes an overlay that covers the screen.
            onAdClosed: (Ad ad) {},
            // Called when an impression occurs on the ad.
            onAdImpression: (Ad ad) {

            },
          ),
        );

        await ad.load();

        yield state.copyWith(status: AdStatus.loaded, ad: ad);
      } catch (e) {
        yield state.copyWith(status: AdStatus.error, errorMessage: e.toString());
      }
    }
  }

  @override
  Future<void> close() {
    state.ad?.dispose();
    return super.close();
  }
}