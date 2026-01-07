import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:intl/intl.dart';

class NotificationModel {
  final String title;
  final String body;
  final DateTime timestamp;
  final Map<String, dynamic>? data;

  NotificationModel({
    required this.title,
    required this.body,
    required this.timestamp,
    this.data,
  });

  factory NotificationModel.fromRemoteMessage(RemoteMessage message) {
    return NotificationModel(
      title: message.notification?.title ?? "Nessun Titolo",
      body: message.notification?.body ?? "Nessun Contenuto",
      // Usa l'orario di invio, se null usa l'orario attuale (ricezione)
      timestamp: message.sentTime ?? DateTime.now(),
      data: message.data,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'body': body,
      'timestamp': timestamp.toIso8601String(),
      'data': data,
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      title: map['title'],
      body: map['body'],
      timestamp: DateTime.parse(map['timestamp']),
      data: map['data'],
    );
  }

  String get formattedTime {
    return DateFormat('HH:mm').format(timestamp);
  }

  String get formattedDate {
    return DateFormat('dd/MM/yyyy').format(timestamp);
  }
}
