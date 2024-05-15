import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:music/bloc/album_bloc/album_event.dart';
import 'package:music/view/all_music/components/folders_list.dart';
import 'package:music/view/all_music/components/song_list.dart';
import 'package:music/view/common_widget/app_bar.dart';
import 'package:music/view/home/components/home_bottom_player.dart';

import '../../bloc/album_bloc/album_bloc.dart';
import '../../bloc/album_bloc/album_state.dart';
import '../../utils/addHelper.dart';

class AllMusicAlbum extends StatefulWidget {
  const AllMusicAlbum({super.key});

  @override
  State<AllMusicAlbum> createState() => _AllMusicAlbumState();
}

class _AllMusicAlbumState extends State<AllMusicAlbum> {

  BannerAd? _bannerAd;
  bool _isLoaded = false;

  ///Testing


  final adUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/6300978111'
      : 'ca-app-pub-3940256099942544/2934735716';

  @override
  void initState() {
    loadAd();
    super.initState();
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



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: ()async{
          if(context.read<AlbumBloc>().currentPage==0){
            return true;
          }else{
            context.read<AlbumBloc>().add(BackArrowTap(context: context));
            return false;
          }
        },
        child: SafeArea(
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: BlocBuilder<AlbumBloc, AlbumState>(
                      buildWhen: (previous, current) => previous.appBarTitle!=current.appBarTitle,
                      builder: (context, state) {
                        return CustomAppBar(
                          title: state.appBarTitle,
                          preIcon: GestureDetector(
                            onTap: (){
                              AdHelper.initInterstitialAd();
                              AdHelper.customInterstitial(const Duration(seconds: 5));
                              context.read<AlbumBloc>().add(BackArrowTap(context: context));
                            },
                            // onTap: () => context.read<AlbumBloc>().add(BackArrowTap(context: context)),
                            child: const Icon(
                              Icons.arrow_back_ios_new_rounded,
                              size: 20,
                            ),
                          ),
                          postIcon: const Icon(Icons.more_horiz_rounded),
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(child: PageView(
                    controller: context
                        .read<AlbumBloc>()
                        .pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: const [
                      FolderList(),
                      SongList(),
                    ],
                  ))
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

//
// class AllMusicAlbum extends StatelessWidget {
//   const AllMusicAlbum({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: WillPopScope(
//         onWillPop: ()async{
//           if(context.read<AlbumBloc>().currentPage==0){
//             return true;
//           }else{
//             context.read<AlbumBloc>().add(BackArrowTap(context: context));
//             return false;
//           }
//         },
//         child: SafeArea(
//           child: Stack(
//             alignment: Alignment.bottomCenter,
//             children: [
//               Column(
//                 children: [
//                   const SizedBox(
//                     height: 30,
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 20),
//                     child: BlocBuilder<AlbumBloc, AlbumState>(
//                       buildWhen: (previous, current) => previous.appBarTitle!=current.appBarTitle,
//                       builder: (context, state) {
//                         return CustomAppBar(
//                           title: state.appBarTitle,
//                           preIcon: GestureDetector(
//                             onTap: (){
//                               AdHelper.initInterstitialAd();
//                               AdHelper.customInterstitial(const Duration(seconds: 5));
//                               context.read<AlbumBloc>().add(BackArrowTap(context: context));
//                             },
//                             // onTap: () => context.read<AlbumBloc>().add(BackArrowTap(context: context)),
//                             child: const Icon(
//                               Icons.arrow_back_ios_new_rounded,
//                               size: 20,
//                             ),
//                           ),
//                           postIcon: const Icon(Icons.more_horiz_rounded),
//                         );
//                       },
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 20,
//                   ),
//                   Expanded(child: PageView(
//                     controller: context
//                         .read<AlbumBloc>()
//                         .pageController,
//                     physics: const NeverScrollableScrollPhysics(),
//                     children: const [
//                       FolderList(),
//                       SongList(),
//                     ],
//                   ))
//                 ],
//               ),
//               const HomeBottomPlayer(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
