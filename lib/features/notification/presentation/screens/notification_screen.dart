import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:intl/intl.dart';
import 'package:myapp/core/theme/app_theme.dart';
import 'package:myapp/core/services/firestore_service.dart';
import 'package:myapp/features/debt/presentation/screens/debt_screen.dart';
import 'package:myapp/features/savings/presentation/screens/savings_screen.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        title:
            Text('Notifikasi', style: Theme.of(context).textTheme.titleLarge),
        leading: IconButton(
          icon:
              Icon(Icons.arrow_back, color: Theme.of(context).iconTheme.color),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirestoreService().getNotificationsStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: FinoteTextStyles.bodyMedium.copyWith(color: Colors.red),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final notifications = snapshot.data?.docs ?? [];

          if (notifications.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_off_outlined,
                      size: 80, color: Colors.grey[700]),
                  const SizedBox(height: 16),
                  Text(
                    'Belum ada notifikasi',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final doc = notifications[index];
              final data = doc.data() as Map<String, dynamic>;
              final isRead = data['isRead'] ?? false;
              final timestamp = data['createdAt'] as Timestamp?;
              final date = timestamp?.toDate() ?? DateTime.now();
              final type = data['type'];

              return Dismissible(
                key: Key(doc.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  color: Colors.red,
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (direction) {
                  FirestoreService().deleteNotification(doc.id);
                },
                child: GestureDetector(
                  onTap: () {
                    // Delete notification automatically when clicked
                    FirestoreService().deleteNotification(doc.id);

                    // Navigation Logic
                    if (type == 'debt') {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DebtScreen(
                                    onNavigate: (index) =>
                                        Navigator.pop(context),
                                  )));
                    } else if (type == 'saving') {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SavingsScreen(
                                    onNavigate: (index) =>
                                        Navigator.pop(context),
                                  )));
                    } else {
                      // Show detail dialog for info or others
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: const Color(0xFF2F2F2F),
                          title: Text(data['title'] ?? 'Info',
                              style: FinoteTextStyles.titleMedium),
                          content: Text(data['body'] ?? '',
                              style: FinoteTextStyles.bodyMedium),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isRead
                          ? Theme.of(context).cardColor
                          : Theme.of(context)
                              .cardColor
                              .withOpacity(0.8), // Distinct for unread
                      borderRadius: BorderRadius.circular(16),
                      border: isRead
                          ? null
                          : Border.all(color: FinoteColors.primary, width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildNotificationIcon(data['type']),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    data['title'] ?? 'Notifikasi',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                            fontWeight: isRead
                                                ? FontWeight.normal
                                                : FontWeight.bold,
                                            fontSize: 16),
                                  ),
                                  Text(
                                    _formatTime(date),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                            color: Colors.grey, fontSize: 12),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                data['body'] ?? '',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildNotificationIcon(String? type) {
    IconData icon;
    Color color;

    switch (type) {
      case 'debt':
        icon = Icons.warning_amber_rounded;
        color = Colors.orange;
        break;
      case 'saving':
        icon = Icons.check_circle_outline;
        color = Colors.green;
        break;
      case 'info':
      default:
        icon = Icons.info_outline;
        color = FinoteColors.primary;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 24),
    );
  }

  String _formatTime(DateTime date) {
    return DateFormat('dd MMM, HH:mm').format(date);
  }
}

// Added getter for userId in FirestoreService snippet above to make this work
// Wait, I need to expose userId getter in FirestoreService properly
