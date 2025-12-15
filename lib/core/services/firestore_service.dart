import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  String? get _userId => FirebaseAuth.instance.currentUser?.uid;
  String? get userId => _userId;

  // Get user specific collection stream
  Stream<QuerySnapshot> getTransactionsStream() {
    if (_userId == null) return const Stream.empty();
    return _db
        .collection('users')
        .doc(_userId)
        .collection('transactions')
        .orderBy('date', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getSavingsStream() {
    if (_userId == null) return const Stream.empty();
    return _db
        .collection('users')
        .doc(_userId)
        .collection('savings')
        .snapshots();
  }

  Stream<QuerySnapshot> getDebtsStream() {
    if (_userId == null) return const Stream.empty();
    return _db.collection('users').doc(_userId).collection('debts').snapshots();
  }

  // Add Transaction
  Future<void> addTransaction({
    required String type, // 'income' or 'expense'
    required double amount,
    required String category,
    required DateTime date,
    required String description, // Changed from 'note' to 'description'
    required String source, // Added 'source'
  }) async {
    if (_userId == null) return;
    await _db.collection('users').doc(_userId).collection('transactions').add({
      'type': type,
      'amount': amount,
      'category': category,
      'description': description, // Changed from 'note'
      'date': Timestamp.fromDate(date),
      'source': source, // Added 'source'
      'createdAt': FieldValue
          .serverTimestamp(), // Keep for internal use if needed, though not in schema explicitly
    });
  }

  // Add Saving Goal
  Future<void> addSaving({
    required String name, // Changed from 'title' to 'name'
    required String goalType, // Added 'goalType': 'target' or 'regular'
    required double targetAmount,
    required double currentAmount,
    DateTime? targetDate, // Added optional targetDate
  }) async {
    if (_userId == null) return;
    await _db.collection('users').doc(_userId).collection('savings').add({
      'name': name, // Changed from 'title'
      'goalType': goalType, // Added
      'targetAmount': targetAmount,
      'currentAmount': currentAmount,
      'targetDate':
          targetDate != null ? Timestamp.fromDate(targetDate) : null, // Added
      'createdAt': FieldValue.serverTimestamp(),
      'entries': [], // Initialize empty array
    });
  }

  // Add Debt
  Future<void> addDebt({
    required String name, // Changed from 'title' to 'name'
    required String creditor, // Added 'creditor'
    required double amount,
    required String debtType, // Added 'debtType': 'lump_sum' or 'installment'
    DateTime? dueDate,
    double? installmentAmount,
    int? durationInMonths,
    int? paymentDayOfMonth,
    DateTime? startDate,
  }) async {
    if (_userId == null) return;
    await _db.collection('users').doc(_userId).collection('debts').add({
      'name': name, // Changed from 'title'
      'creditor': creditor, // Added
      'amount': amount,
      'paidAmount': 0.0,
      'isPaid': false, // Added
      'debtType': debtType, // Added
      'dueDate': dueDate != null ? Timestamp.fromDate(dueDate) : null,
      'installmentAmount': installmentAmount,
      'durationInMonths': durationInMonths,
      'paymentDayOfMonth': paymentDayOfMonth,
      'startDate': startDate != null ? Timestamp.fromDate(startDate) : null,
      'createdAt': FieldValue.serverTimestamp(),
      'paymentEntries': [], // Initialize empty array
    });
  }

  // Add Saving Entry (Add Funds)
  Future<void> addSavingEntry({
    required String savingId,
    required double amount,
    required DateTime date,
  }) async {
    if (_userId == null) return;

    final savingRef = _db
        .collection('users')
        .doc(_userId)
        .collection('savings')
        .doc(savingId);

    await _db.runTransaction((transaction) async {
      final snapshot = await transaction.get(savingRef);
      if (!snapshot.exists) {
        throw Exception("Saving goal does not exist!");
      }

      final currentAmount =
          (snapshot.data()?['currentAmount'] as num?)?.toDouble() ?? 0.0;
      final newAmount = currentAmount + amount;

      transaction.update(savingRef, {
        'currentAmount': newAmount,
        'entries': FieldValue.arrayUnion([
          {
            'amount': amount,
            'date': Timestamp.fromDate(date),
          }
        ]),
      });
    });
  }

  // Add Debt Payment Entry
  Future<void> addDebtEntry({
    required String debtId,
    required double amount,
    required DateTime date,
    required String source,
  }) async {
    if (_userId == null) return;

    final debtRef =
        _db.collection('users').doc(_userId).collection('debts').doc(debtId);

    await _db.runTransaction((transaction) async {
      final snapshot = await transaction.get(debtRef);
      if (!snapshot.exists) {
        throw Exception("Debt does not exist!");
      }

      final paidAmount =
          (snapshot.data()?['paidAmount'] as num?)?.toDouble() ?? 0.0;
      final totalAmount =
          (snapshot.data()?['amount'] as num?)?.toDouble() ?? 0.0;
      final newPaidAmount = paidAmount + amount;
      final isPaid = newPaidAmount >= totalAmount;

      transaction.update(debtRef, {
        'paidAmount': newPaidAmount,
        'isPaid': isPaid,
        'paymentEntries': FieldValue.arrayUnion([
          {
            'amount': amount,
            'date': Timestamp.fromDate(date),
            'source': source,
          }
        ]),
      });
    });
  }

  // Get Single Saving Stream
  Stream<DocumentSnapshot> getSavingStream(String savingId) {
    if (_userId == null) return const Stream.empty();
    return _db
        .collection('users')
        .doc(_userId)
        .collection('savings')
        .doc(savingId)
        .snapshots();
  }

  // Get Single Debt Stream
  Stream<DocumentSnapshot> getDebtStream(String debtId) {
    if (_userId == null) return const Stream.empty();
    return _db
        .collection('users')
        .doc(_userId)
        .collection('debts')
        .doc(debtId)
        .snapshots();
  }

  // Transfer Funds
  Future<void> transferFunds({
    required double amount,
    required String fromSource,
    required String toSource,
    required DateTime date,
    required String description,
  }) async {
    if (_userId == null) return;

    final batch = _db.batch();
    final transactionsRef =
        _db.collection('users').doc(_userId).collection('transactions');

    // Expense from source
    final expenseDoc = transactionsRef.doc();
    batch.set(expenseDoc, {
      'type': 'expense',
      'amount': amount,
      'category': 'transfer',
      'source': fromSource,
      'description': description,
      'date': Timestamp.fromDate(date),
      'createdAt': FieldValue.serverTimestamp(),
    });

    // Income to source
    final incomeDoc = transactionsRef.doc();
    batch.set(incomeDoc, {
      'type': 'income',
      'amount': amount,
      'category': 'transfer',
      'source': toSource,
      'description': description,
      'date': Timestamp.fromDate(date),
      'createdAt': FieldValue.serverTimestamp(),
    });

    await batch.commit();
  }

  // Update Transaction
  Future<void> updateTransaction({
    required String transactionId,
    required Map<String, dynamic> data,
  }) async {
    if (_userId == null) return;
    await _db
        .collection('users')
        .doc(_userId)
        .collection('transactions')
        .doc(transactionId)
        .update(data);
  }

  // Delete Transaction
  Future<void> deleteTransaction(String transactionId) async {
    if (_userId == null) return;
    await _db
        .collection('users')
        .doc(_userId)
        .collection('transactions')
        .doc(transactionId)
        .delete();
  }

  // --- Notifications ---

  Stream<QuerySnapshot> getNotificationsStream() {
    if (_userId == null) return const Stream.empty();
    return _db
        .collection('users')
        .doc(_userId)
        .collection('notifications')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<void> addNotification({
    required String userId,
    required String title,
    required String body,
    required String type, // 'debt', 'saving', 'info'
  }) async {
    // Simple deduplication check for daily reports/info to avoid spam
    // (Optional: Implement robust checking if needed)

    await _db.collection('users').doc(userId).collection('notifications').add({
      'title': title,
      'body': body,
      'type': type,
      'isRead': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> markNotificationAsRead(String notificationId) async {
    if (_userId == null) return;
    await _db
        .collection('users')
        .doc(_userId)
        .collection('notifications')
        .doc(notificationId)
        .update({'isRead': true});
  }

  Future<void> deleteNotification(String notificationId) async {
    if (_userId == null) return;
    await _db
        .collection('users')
        .doc(_userId)
        .collection('notifications')
        .doc(notificationId)
        .delete();
  }

  // --- Savings CRUD ---

  /// Delete a saving goal
  Future<void> deleteSaving(String savingId) async {
    if (_userId == null) return;
    await _db
        .collection('users')
        .doc(_userId)
        .collection('savings')
        .doc(savingId)
        .delete();
  }

  /// Update a saving goal
  Future<void> updateSaving(String savingId, Map<String, dynamic> data) async {
    if (_userId == null) return;
    await _db
        .collection('users')
        .doc(_userId)
        .collection('savings')
        .doc(savingId)
        .update(data);
  }

  // --- Debts CRUD ---

  /// Delete a debt
  Future<void> deleteDebt(String debtId) async {
    if (_userId == null) return;
    await _db
        .collection('users')
        .doc(_userId)
        .collection('debts')
        .doc(debtId)
        .delete();
  }

  /// Update a debt
  Future<void> updateDebt(String debtId, Map<String, dynamic> data) async {
    if (_userId == null) return;
    await _db
        .collection('users')
        .doc(_userId)
        .collection('debts')
        .doc(debtId)
        .update(data);
  }
}
