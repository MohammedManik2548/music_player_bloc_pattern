import 'dart:io';
import 'dart:math';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:music/res/app_colors.dart';
import 'package:music/res/app_images.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
class Utils{
  static go({required BuildContext context,required dynamic screen,bool replace=false}){
    replace ?
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => screen,))
        : Navigator.push(context, MaterialPageRoute(builder: (context) => screen,));
  }
  static String getRandomImage(){
    return AppImages.imageList[Random().nextInt(13)]!;
  }
  // static Future<bool> requestPermission() async {
  //   final DeviceInfoPlugin info = DeviceInfoPlugin(); // import 'package:device_info_plus/device_info_plus.dart';
  //
  //
  //   bool havePermission = false;
  //
  //   if(Platform.isAndroid){
  //     final AndroidDeviceInfo androidInfo = await info.androidInfo;
  //     if (androidInfo.version.sdkInt >= 33) {
  //       final request = await [
  //         Permission.storage,
  //         Permission.audio,
  //         //..... as needed
  //       ].request(); //import 'package:permission_handler/permission_handler.dart';
  //
  //       havePermission = request.values.every((status) => status == PermissionStatus.granted);
  //     } else {
  //       final status = await Permission.storage.request();
  //       havePermission = status.isGranted;
  //     }
  //
  //     if (!havePermission) {
  //       // if no permission then open app-setting
  //       await openAppSettings();
  //     }
  //
  //     return havePermission;
  //   }else if(Platform.isIOS){
  //     final status = await Permission.storage.request();
  //     if(status.isGranted){
  //       havePermission=status.isGranted;
  //     }
  //   }
  //
  //   return havePermission;
  //
  // }
  static Future<bool> requestPermission()async{
    var status = await Permission.storage.status;
    if(status.isGranted){
      return true;
    }
    else if (status.isDenied) {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.storage,
        Permission.audio,
      ].request();
      var temp = await Permission.storage.status;
      if(temp.isGranted){
        return true;
      }else {
        return true;
      }
    }
    return true;
  }

  static String getGreetingMessage() {
    DateTime now = DateTime.now();
    int hour = now.hour;
    if (hour >= 5 && hour < 12) {
      return 'Good morning';
    } else if (hour >= 12 && hour < 18) {
      return 'Good afternoon';
    } else {
      return 'Good evening';
    }
  }
  static showBottomSheet({required BuildContext context,
  required Widget widget,
    bool isDismissible=false
  }){
    showModalBottomSheet(
      backgroundColor: backgroundColor,
      isDismissible: isDismissible,
      enableDrag: false,
      isScrollControlled: true,
      context: context, builder: (context) {
      return widget;
    },);
  }

}