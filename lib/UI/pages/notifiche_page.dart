import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../controller/notification_controller.dart';
import '../../controller/app_localization.dart';

class NotifichePage extends StatelessWidget {

  final VoidCallback? onBack;

  const NotifichePage({super.key , this.onBack});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)?.translate("notificationTitle") ?? "Your Notifications"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: () => NotificationController.notificationsNotifier.value = [],
          )
        ],
      ),
      body: ValueListenableBuilder<List<RemoteMessage>>(
        valueListenable: NotificationController.notificationsNotifier,
        builder: (context, notifications, child) {
          if (notifications.isEmpty) {
            return Center(
              child: Text(AppLocalizations.of(context)?.translate("noNotification") ?? "There are no new notifications"),
            );
          }

          return ListView.separated(
            itemCount: notifications.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final notification = notifications[index].notification;
              final data = notifications[index].data;

              return ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.notifications),
                ),
                title: Text(notification?.title ?? 'No Title'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(notification?.body ?? 'No content'),
                    if (data.isNotEmpty)
                      Text(
                        "Extra data: $data",
                        style: const TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                  ],
                ),
                trailing: Text(
                  "${DateTime.now().hour}:${DateTime.now().minute}", // Esempio orario
                  style: const TextStyle(fontSize: 12),
                ),
              );
            },
          );
        },
      ),
    );
  }
}