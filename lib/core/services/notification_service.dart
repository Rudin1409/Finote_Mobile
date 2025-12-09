import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    as fln;

import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/core/services/firestore_service.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() {
    return _instance;
  }

  NotificationService._internal();

  final fln.FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      fln.FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz_data.initializeTimeZones();
    try {
      final timeZoneName = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(timeZoneName.toString()));
    } catch (e) {
      // Fallback if detection fails or type mismatch occurs
      tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));
    }

    const fln.AndroidInitializationSettings initializationSettingsAndroid =
        fln.AndroidInitializationSettings('@mipmap/launcher_icon');

    const fln.InitializationSettings initializationSettings =
        fln.InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (fln.NotificationResponse response) async {
        // Handle notification tap
      },
    );
    // Request permissions for Android 13+
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            fln.AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    await scheduleDailyReminder();
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const fln.AndroidNotificationDetails androidNotificationDetails =
        fln.AndroidNotificationDetails(
      'finote_channel',
      'Finote Notifications',
      channelDescription: 'Important notifications for Finote',
      importance: fln.Importance.max,
      priority: fln.Priority.high,
      ticker: 'ticker',
    );

    const fln.NotificationDetails notificationDetails =
        fln.NotificationDetails(android: androidNotificationDetails);

    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  Future<void> scheduleDailyReminder() async {
    // Schedule a daily notification at 20:00 (8 PM)
    await flutterLocalNotificationsPlugin.zonedSchedule(
      888,
      'Pengingat Harian',
      'Sudahkah Anda mencatat pengeluaran hari ini?',
      _nextInstanceOfEightPM(),
      const fln.NotificationDetails(
        android: fln.AndroidNotificationDetails(
          'finote_daily',
          'Daily Reminder',
          channelDescription: 'Daily reminder to record transactions',
          importance: fln.Importance.high,
        ),
      ),
      androidScheduleMode: fln.AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  tz.TZDateTime _nextInstanceOfEightPM() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, 20); // 20:00
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  // --- Logic Integrations ---

  Future<void> checkAll(String userId) async {
    await checkDebtDeadlines(userId);
    await checkSavingsTargets(userId);
    await checkMonthlyReportReady(userId);
    // Ensure daily reminder is scheduled
    await scheduleDailyReminder();
  }

  Future<void> checkDebtDeadlines(String userId) async {
    final debtsSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('debts')
        .where('isPaid', isEqualTo: false)
        .get();

    final now = DateTime.now();
    for (var doc in debtsSnapshot.docs) {
      final data = doc.data();
      if (data['dueDate'] != null) {
        DateTime dueDate = (data['dueDate'] as Timestamp).toDate();
        final difference = dueDate.difference(now).inDays;

        if (difference >= 0 && difference <= 3) {
          // Check if we already notified today for this debt
          // Skipping complex "already notified" logic for MVP, just showing it.
          // In production, we'd check a local pref or database log.

          await showNotification(
            id: doc.id.hashCode,
            title: 'Pengingat Hutang',
            body:
                'Jangan lupa bayar hutang ${data['name']} sebesar Rp ${data['amount']}',
          );

          // Add to Firestore notifications list
          await FirestoreService().addNotification(
            userId: userId,
            title: 'Pengingat Hutang',
            body:
                'Jangan lupa bayar hutang ${data['name']} sebesar Rp ${data['amount']}',
            type: 'debt',
          );
        }
      }
    }
  }

  Future<void> checkSavingsTargets(String userId) async {
    final savingsSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('savings')
        .get();

    for (var doc in savingsSnapshot.docs) {
      final data = doc.data();
      double current = (data['currentAmount'] as num).toDouble();
      double target = (data['targetAmount'] as num).toDouble();

      if (target > 0 && current >= target) {
        // Simple check to avoid spamming: assumes if we are running this, maybe we should notify.
        // Ideally we mark 'notified' in the document.
        if (data['targetReachedNotified'] != true) {
          await showNotification(
            id: doc.id.hashCode,
            title: 'Target Tercapai!',
            body: 'Selamat! Target tabungan ${data['name']} telah tercapai.',
          );

          await FirestoreService().addNotification(
            userId: userId,
            title: 'Target Tercapai!',
            body: 'Selamat! Target tabungan ${data['name']} telah tercapai.',
            type: 'saving',
          );

          // Mark as notified so we don't spam
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .collection('savings')
              .doc(doc.id)
              .update({'targetReachedNotified': true});
        }
      }
    }
  }

  Future<void> checkMonthlyReportReady(String userId) async {
    final now = DateTime.now();
    // Check if today is the 1st of the month
    if (now.day == 1) {
      // Ideally check if we already notified this month
      // For MVP, just show it.
      int id = 999;
      await showNotification(
          id: id,
          title: 'Laporan Bulanan',
          body: 'Laporan keuangan bulan lalu siap dilihat.');

      // Avoid duplicate log entries by checking existence (optional/advanced)
      // Simple fire-and-forget for now
      await FirestoreService().addNotification(
        userId: userId,
        title: 'Laporan Bulanan',
        body: 'Laporan keuangan bulan lalu siap dilihat.',
        type: 'info',
      );
    }
  }
}
