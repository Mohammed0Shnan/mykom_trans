import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:my_kom/module_home/navigator_routes.dart';
import 'package:my_kom/module_notifications/preferences/notification_preferences/notification_preferences.dart';
import 'package:my_kom/module_profile/service/profile_service.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:rxdart/subjects.dart';

class FireNotificationService {
  final NotificationsPrefsHelper _prefsHelper = NotificationsPrefsHelper();
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final ProfileService _profileService = ProfileService();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static final PublishSubject<String> _onNotificationRecieved =
      PublishSubject();

  static Stream get onNotificationStream => _onNotificationRecieved.stream;

  static late StreamSubscription iosSubscription;
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future<void> init(BuildContext context) async {
   NotificationSettings _settings =  await _fcm.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );


    FirebaseMessaging.instance.subscribeToTopic('advertisements');

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    );
    _flutterLocalNotificationsPlugin.initialize(initializationSettings);
    _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? route) async {
      Navigator.pushNamed(context, NavigatorRoutes.NAVIGATOR_SCREEN);
    });
  }

  void display(RemoteNotification message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final NotificationDetails notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails(
        'my_kom_channel',
        'my_kom_channel channel',
        'this is the channel',
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: IOSNotificationDetails(

      )
      );
      if(Platform.isIOS){

        showSimpleNotification(Text( message.title!)
        ,subtitle: Text(message.body!),
          duration: Duration(seconds: 2),

        );
      }
      else{
        await _flutterLocalNotificationsPlugin.show(
            id, message.title, message.body, notificationDetails,
            payload: message.android!.clickAction);
      }

    } catch (e) {
      print(e);
    }
  }

}
