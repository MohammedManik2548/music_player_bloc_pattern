import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:music/bloc/album_bloc/album_bloc.dart';
import 'package:music/bloc/home_bloc/home_event.dart';
import 'package:music/view/common_widget/app_bar.dart';
import 'package:music/view/common_widget/loading_files.dart';
import 'package:music/view/home/components/home_top_box.dart';
import 'package:music/view/home/components/recently_played_list.dart';
import 'package:music/view/home/components/songs.dart';
import '../../bloc/home_bloc/home_bloc.dart';
import '../../bloc/home_bloc/home_state.dart';
import 'components/home_bottom_player.dart';
import 'components/home_foler_list.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;
  bool _isLoaded = false;
  int num_of_attemp_load = 0;
  ///Testing


  final adUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/6300978111'
      : 'ca-app-pub-3940256099942544/2934735716';
  final iAdUnit = 'ca-app-pub-3940256099942544/1033173712';

  @override
  void initState() {
    loadAd();
    // inLoadAd();
    // showInst();
    // BlocProvider.of<AdBloc>(context).state.ad??'';
    super.initState();
    context.read<HomeBloc>()
      ..add(GetFavSongEvent())
      ..add(GetSongEvent());
  }

  void loadAd() {
    _bannerAd = BannerAd(
      adUnitId: adUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          debugPrint('$ad loaded.');
          setState(() {
            _isLoaded = true;
            print('check_value: $_isLoaded');
          });
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
    )..load();
  }
  void inLoadAd() {
    InterstitialAd.load(
        adUnitId: iAdUnit,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          // Called when an ad is successfully received.
          onAdLoaded: (ad) {
            debugPrint('$ad loaded.');
            // Keep a reference to the ad so you can show it later.
            _interstitialAd = ad;
            num_of_attemp_load=0;
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('InterstitialAd failed to load: $error');
            _interstitialAd = null;
            num_of_attemp_load+0;
            if(num_of_attemp_load<=2){
              inLoadAd();
            }
          },
        ));
  }
  void showInst(){
    if(_interstitialAd == null){
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad){
        print('ad adOnShowFullScreen');
      },
      onAdDismissedFullScreenContent: (InterstitialAd ad){
        ad.dispose();
        print('add Dispose');
    },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError adError){
        print('add Failed $ad');
        ad.dispose();
        inLoadAd();
      },
    );
    _interstitialAd!.show();

    _interstitialAd = null;
  }

  @override
  Widget build(BuildContext context) {
    var s = context.read<AlbumBloc>().state;
    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 30,
                ),
                const CustomAppBar(),
                const SizedBox(height: 40),
                const HomeIntroBox(),
                const RecentlyPlayedList(),
                Expanded(
                  child: BlocBuilder<HomeBloc, HomeState>(
                    buildWhen: (previous, current) =>
                        current.songListStatus != previous.songListStatus,
                    builder: (context, loadingState) {
                      if (loadingState.songListStatus == Status.complete) {
                        if (loadingState.songList.isEmpty) {
                          return HomeFolderList(
                            state: s,
                          );
                        } else {
                          return  SongsList();
                        }
                      }
                      return const Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Text(
                                'Album',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Spacer(),
                              InkWell(
                                // onTap: () => Utils.go(context: context, screen: AllMusicAlbum()),

                                child: Text(
                                  'See all',
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          ),
                          Expanded(child: FilesLoading()),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
            const HomeBottomPlayer(),
          ],
        ),
      ),
    ),
      bottomSheet: _bannerAd != null?Container(
        alignment: Alignment.center,
        height: 60,
        //  width: _bannerAd!.size.width.toDouble(),
        color: Colors.black12,
        child: Center(child: AdWidget(ad: _bannerAd!)),
      ):Container(),
    );
  }
}
