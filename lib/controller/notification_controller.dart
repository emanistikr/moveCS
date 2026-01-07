import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_controller.dart';
import '../main.dart';
import '../models/notification_model.dart';

class NotificationController {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  static final ValueNotifier<int> tabIndexNotifier = ValueNotifier(0);

  static final ValueNotifier<List<NotificationModel>> notificationsNotifier =
      ValueNotifier([]);

  Future<void> init() async {
    await _firebaseMessaging.requestPermission();
    await loadSavedNotifications();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _addNotificationToList(message);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _addNotificationToList(message);
      _navigateToNotificationPage();
    });
    RemoteMessage? initialMessage = await _firebaseMessaging
        .getInitialMessage();
    if (initialMessage != null) {
      _addNotificationToList(initialMessage);
      // aspetta che carica l'app prima di iniziare la navigazione
      Future.delayed(Duration(seconds: 4), () {
        _navigateToNotificationPage();
      });
    }
  }

  void _addNotificationToList(RemoteMessage message) {
    NotificationModel newNotification = NotificationModel.fromRemoteMessage(
      message,
    );
    List<NotificationModel> currentList = List.from(
      notificationsNotifier.value,
    );
    currentList.insert(0, newNotification);
    notificationsNotifier.value = currentList;

    _saveNotificationsToDisk(currentList);
  }

  Future<void> _saveNotificationsToDisk(
    List<NotificationModel> notifications,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> encodedList = notifications
        .map((n) => jsonEncode(n.toMap()))
        .toList();
    await prefs.setStringList('saved_notifications', encodedList);
  }

  Future<void> loadSavedNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? saved = prefs.getStringList('saved_notifications');

    if (saved != null) {
      notificationsNotifier.value = saved
          .map((s) => NotificationModel.fromMap(jsonDecode(s)))
          .toList();
    }
  }

  void _navigateToNotificationPage() async {
    if (AuthController().currentUser != null) {
      navigatorKey.currentState?.popUntil((route) => route.isFirst);
      tabIndexNotifier.value = 2;
    }
  }

  // cancella le notifiche
  Future<void> clearAll() async {
    notificationsNotifier.value = [];

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('saved_notifications');
  }
}
