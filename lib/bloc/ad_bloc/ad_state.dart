import 'package:equatable/equatable.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

enum AdStatus { initial, loading, loaded, error }

class AdState extends Equatable {
  final AdStatus status;
  final BannerAd? ad;
  final String? errorMessage;

  const AdState({
    this.status = AdStatus.initial,
    this.ad,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [status, ad, errorMessage];

  AdState copyWith({
    AdStatus? status,
    BannerAd? ad,
    String? errorMessage,
  }) {
    return AdState(
      status: status ?? this.status,
      ad: ad ?? this.ad,
      errorMessage: errorMessage,
    );
  }
}