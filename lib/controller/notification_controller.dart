import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'auth_controller.dart';

class NotificationController{
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  // Lista statica per conservare le notifiche durante la sessione,
  // si usa ValueNotifier per permettere l'aggiornamento della UI quando la lista cambia
  static final ValueNotifier<List<RemoteMessage>> notificationsNotifier = ValueNotifier([]);

  Future<void> init() async{
    await _firebaseMessaging.requestPermission();
    String? token = await _firebaseMessaging.getToken();
    print("Firebase Messaging Token: $token"); // Si potrebbe voler salvare questo token nel database
    // Gestione delle notifiche in background
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    //Gestione nel primo piano
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _addNotificationToList(message);
    });

    //Gestione della pressione delle notifiche in background
    RemoteMessage? initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      if (AuthController().currentUser != null) {
        //TODO
        //Bisogna portare direttamente alla schermata delle notifiche
        // se l'utente è autenticato
      }
    }
  }

  void _addNotificationToList(RemoteMessage message) {
    notificationsNotifier.value = List.from(notificationsNotifier.value)..add(message);
  }

}//notificationController

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Gestisci la notifica in background.
  //Stampiamo anche in console la notifica ricevuta
  print('Title:${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Payload: ${message.data}');
  NotificationController()._addNotificationToList(message);
}