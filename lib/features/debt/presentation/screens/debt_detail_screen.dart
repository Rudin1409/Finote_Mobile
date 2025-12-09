import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:myapp/core/services/firestore_service.dart';
import 'package:myapp/widgets/pay_debt_form.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/services.dart';

class DebtDetailScreen extends StatelessWidget {
  final String debtId;
  final String title;

  const DebtDetailScreen({
    super.key,
    required this.debtId,
    required this.title,
  });

  // Dummy data for the payment URL - In a real app, this might come from the debt data or config
  final String paymentUrl = 'https://link.shopeepay.co.id/2/23423423';

  void _showPayDebtModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PayDebtForm(
        paymentUrl: paymentUrl,
        debtId: debtId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF37C8C3);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        title: Text(title, style: Theme.of(context).textTheme.titleLarge),
        leading: IconButton(
          icon:
              Icon(Icons.arrow_back, color: Theme.of(context).iconTheme.color),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirestoreService().getDebtStream(debtId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Data not found'));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          final paidAmount = (data['paidAmount'] as num).toDouble();
          final totalAmount = (data['amount'] as num).toDouble();
          final percentage = (paidAmount / totalAmount).clamp(0.0, 1.0);
          final remainingAmount = totalAmount - paidAmount;
          final paymentEntries =
              (data['paymentEntries'] as List<dynamic>?) ?? [];

          // Sort entries by date descending
          paymentEntries.sort((a, b) {
            final dateA = (a['date'] as Timestamp).toDate();
            final dateB = (b['date'] as Timestamp).toDate();
            return dateB.compareTo(dateA);
          });

          final currencyFormatter = NumberFormat.currency(
              locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

          final dueDate = data['dueDate'] != null
              ? (data['dueDate'] as Timestamp).toDate()
              : null;
          final formattedDueDate =
              dueDate != null ? DateFormat('d MMM yyyy').format(dueDate) : '-';

          // Calculate days remaining
          String daysRemainingText = '';
          if (dueDate != null) {
            final difference = dueDate.difference(DateTime.now()).inDays;
            if (difference > 0) {
              daysRemainingText = '$difference HARI LAGI';
            } else if (difference == 0) {
              daysRemainingText = 'HARI INI';
            } else {
              daysRemainingText = 'TERLEWAT ${difference.abs()} HARI';
            }
          }

          final installmentAmount =
              (data['installmentAmount'] as num?)?.toDouble() ?? 0.0;
          final durationInMonths = data['durationInMonths'] as int? ?? 0;
          final remainingInstallments = installmentAmount > 0
              ? (remainingAmount / installmentAmount).ceil()
              : 0;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                CircularPercentIndicator(
                  radius: 100.0,
                  lineWidth: 15.0,
                  percent: percentage,
                  center: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Terbayar',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      FittedBox(
                        child: Text(
                          currencyFormatter.format(paidAmount),
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Sisa: ${currencyFormatter.format(remainingAmount)}',
                        style:
                            const TextStyle(color: primaryColor, fontSize: 14),
                      ),
                    ],
                  ),
                  progressColor: primaryColor,
                  backgroundColor:
                      Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey[800]!
                          : Colors.grey[300]!,
                  circularStrokeCap: CircularStrokeCap.round,
                ),
                const SizedBox(height: 30),
                if (remainingAmount > 0)
                  ElevatedButton(
                    onPressed: () => _showPayDebtModal(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text(
                      'BAYAR CICILAN',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                else
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text(
                        'LUNAS',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                const SizedBox(height: 30),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'DETAIL',
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        if (installmentAmount > 0)
                          Text(
                            'CICILAN: ${currencyFormatter.format(installmentAmount)} / BULAN\nDURASI: $durationInMonths BULAN\nPERKIRAAN SISA: ${remainingInstallments}X CICILAN',
                            style: TextStyle(
                                color: primaryColor, fontSize: 14, height: 1.5),
                          )
                        else
                          Text(
                            'TOTAL HUTANG: ${currencyFormatter.format(totalAmount)}',
                            style: TextStyle(
                                color: primaryColor, fontSize: 14, height: 1.5),
                          ),
                        const SizedBox(height: 16),
                        Text(
                          'JATUH TEMPO: $formattedDueDate $daysRemainingText',
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'RIWAYAT PEMBAYARAN',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: paymentEntries.isEmpty
                              ? const Center(
                                  child: Text('Belum ada pembayaran',
                                      style: TextStyle(color: Colors.grey)))
                              : ListView.builder(
                                  itemCount: paymentEntries.length,
                                  itemBuilder: (context, index) {
                                    final entry = paymentEntries[index]
                                        as Map<String, dynamic>;
                                    return _buildPaymentHistoryItem(
                                        context, entry, currencyFormatter);
                                  },
                                ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPaymentHistoryItem(BuildContext context,
      Map<String, dynamic> entry, NumberFormat formatter) {
    final amount = (entry['amount'] as num).toDouble();
    final date = (entry['date'] as Timestamp).toDate();
    final formattedDate = DateFormat('d MMM, yyyy').format(date);
    final source = entry['source'] as String? ?? 'Unknown';

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Color(0xFF3b3b3b),
            child: FaIcon(FontAwesomeIcons.landmark,
                color: Colors.white, size: 20),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Pembayaran ($source)',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontSize: 16)),
              const SizedBox(height: 4),
              Text(formattedDate,
                  style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
          const Spacer(),
          Text('+${formatter.format(amount)}',
              style: const TextStyle(
                  color: Color(0xFF37C8C3),
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
