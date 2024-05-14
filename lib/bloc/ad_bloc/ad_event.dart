import 'package:equatable/equatable.dart';

abstract class AdEvent extends Equatable {
  const AdEvent();

  @override
  List<Object> get props => [];
}

class LoadAd extends AdEvent {}