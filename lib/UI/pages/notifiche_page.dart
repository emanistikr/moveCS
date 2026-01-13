import 'package:flutter/material.dart';
import '../../controller/notification_controller.dart';
import '../../controller/app_localization.dart';
import '../../config/widget_decoration/widget_styles.dart';
import '../../models/notification_model.dart'; // Assicurati che il percorso sia corretto

class NotifichePage extends StatelessWidget {
  final VoidCallback? onBack;

  const NotifichePage({super.key, this.onBack});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        children: [
          _buildAppBar(context),
          Expanded(
            child: ValueListenableBuilder<List<NotificationModel>>(
              valueListenable: NotificationController.notificationsNotifier,
              builder: (context, notifications, child) {
                if (notifications.isEmpty) {
                  return Center(
                    child: Text(
                      AppLocalizations.of(
                            context,
                          )?.translate("noNotification") ??
                          "There are no new notifications",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  itemCount: notifications.length,
                  separatorBuilder: (context, index) => Divider(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withAlpha(150),
                  ),
                  itemBuilder: (context, index) {
                    final notification = notifications[index];

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.primaryContainer,
                        child: Icon(
                          Icons.notifications,
                          color: Theme.of(
                            context,
                          ).colorScheme.onPrimaryContainer,
                        ),
                      ),
                      title: Text(
                        notification.title,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      subtitle: Text(
                        notification.body,
                        maxLines: 10,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelMedium!
                            .copyWith(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                            ),
                      ),
                      trailing: Text(
                        notification.formattedTime,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Container _buildAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 60),
      height: 110,
      decoration: WidgetStyles.cardDecoration(context),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              onBack;
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: Theme.of(context).colorScheme.primary,
              size: 22,
            ),
          ),
          Expanded(
            child: Text(
              AppLocalizations.of(context)?.translate("notificationTitle") ??
                  "Your Notifications",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          InkWell(
            onTap: () async {
              await NotificationController().clearAll();
            },
            child: Icon(
              Icons.delete_sweep,
              color: Theme.of(context).colorScheme.primary,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }
}
