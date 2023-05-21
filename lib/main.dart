import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cw_food_quality_tracking_system_version2/LoginScreen.dart';
import 'package:flutter_cw_food_quality_tracking_system_version2/homepage.dart';
import 'package:flutter_cw_food_quality_tracking_system_version2/service.dart';
import 'package:grock/grock_exports.dart';

void main() async {
  FirebaseMessaging.onBackgroundMessage(
      FirebaseNotificationService.backgroundMessage);
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    navigatorKey: Grock.navigationKey,
    scaffoldMessengerKey: Grock.scaffoldMessengerKey,
    home: LoginScreen(),
  ));
}
