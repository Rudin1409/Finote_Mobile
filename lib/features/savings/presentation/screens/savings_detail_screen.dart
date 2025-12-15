import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:myapp/core/services/firestore_service.dart';
import 'package:myapp/features/savings/presentation/screens/add_funds_screen.dart';
import 'package:myapp/widgets/edit_saving_form.dart';
import 'package:percent_indicator/percent_indicator.dart';

class SavingsDetailScreen extends StatefulWidget {
  final String savingId;
  final String title;

  const SavingsDetailScreen({
    super.key,
    required this.savingId,
    required this.title,
  });

  @override
  State<SavingsDetailScreen> createState() => _SavingsDetailScreenState();
}

class _SavingsDetailScreenState extends State<SavingsDetailScreen> {
  final FirestoreService _firestoreService = FirestoreService();

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.warning_amber_rounded,
                color: Colors.orange, size: 28),
            const SizedBox(width: 12),
            Text('Hapus Tabungan?',
                style: Theme.of(context).textTheme.titleLarge),
          ],
        ),
        content: const Text(
          'Data tabungan ini akan dihapus permanen dan tidak dapat dikembalikan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await _deleteSaving();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteSaving() async {
    try {
      await _firestoreService.deleteSaving(widget.savingId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tabungan berhasil dihapus'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context); // Go back to savings list
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menghapus: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showEditForm(Map<String, dynamic> data) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: EditSavingForm(
          savingId: widget.savingId,
          initialData: data,
        ),
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
        leading: IconButton(
          icon:
              Icon(Icons.arrow_back, color: Theme.of(context).iconTheme.color),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title:
            Text(widget.title, style: Theme.of(context).textTheme.titleLarge),
        actions: [
          StreamBuilder<DocumentSnapshot>(
            stream: _firestoreService.getSavingStream(widget.savingId),
            builder: (context, snapshot) {
              if (!snapshot.hasData || !snapshot.data!.exists) {
                return const SizedBox.shrink();
              }
              final data = snapshot.data!.data() as Map<String, dynamic>;
              return IconButton(
                icon: Icon(Icons.edit_outlined,
                    color: Theme.of(context).iconTheme.color),
                onPressed: () => _showEditForm(data),
                tooltip: 'Edit',
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: _showDeleteConfirmationDialog,
            tooltip: 'Hapus',
          ),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: _firestoreService.getSavingStream(widget.savingId),
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
          final currentAmount = (data['currentAmount'] as num).toDouble();
          final targetAmount = (data['targetAmount'] as num).toDouble();
          final percentage = (currentAmount / targetAmount).clamp(0.0, 1.0);
          final entries = (data['entries'] as List<dynamic>?) ?? [];

          // Sort entries by date descending
          entries.sort((a, b) {
            final dateA = (a['date'] as Timestamp).toDate();
            final dateB = (b['date'] as Timestamp).toDate();
            return dateB.compareTo(dateA);
          });

          final currencyFormatter = NumberFormat.currency(
              locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

          final targetDate = data['targetDate'] != null
              ? (data['targetDate'] as Timestamp).toDate()
              : null;
          final formattedTargetDate = targetDate != null
              ? DateFormat('d MMM yyyy').format(targetDate)
              : '-';

          return Column(
            children: [
              _buildHeader(context, primaryColor, currentAmount, percentage,
                  currencyFormatter, formattedTargetDate),
              const SizedBox(height: 20),
              _buildHistorySection(context, entries, currencyFormatter),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(
      BuildContext context,
      Color primaryColor,
      double currentAmount,
      double percentage,
      NumberFormat formatter,
      String targetDate) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Column(
        children: [
          CircularPercentIndicator(
            radius: 100.0,
            lineWidth: 20.0,
            animation: true,
            percent: percentage,
            center: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${(percentage * 100).toStringAsFixed(0)}% tercapai',
                  style: GoogleFonts.poppins(
                      color: Colors.grey[400], fontSize: 16),
                ),
                FittedBox(
                  child: Text(
                    formatter.format(currentAmount),
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),
            circularStrokeCap: CircularStrokeCap.round,
            progressColor: primaryColor,
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey[800]!
                : Colors.grey[300]!,
          ),
          const SizedBox(height: 20),
          Text(
            'Target: $targetDate',
            style: GoogleFonts.poppins(color: Colors.grey, fontSize: 16),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddFundsScreen(
                          savingGoalName: widget.title,
                          savingId: widget.savingId,
                        )),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              minimumSize: const Size(double.infinity, 55),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18)),
            ),
            child: Text(
              'TAMBAH DANA',
              style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistorySection(
      BuildContext context, List<dynamic> entries, NumberFormat formatter) {
    return Expanded(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(25.0),
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(40),
              topRight: Radius.circular(40),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 5,
                blurRadius: 15,
                offset: const Offset(0, -5),
              )
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'RIWAYAT TABUNGAN',
              style: GoogleFonts.poppins(
                color: Colors.grey[400],
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: entries.isEmpty
                  ? Center(
                      child: Text('Belum ada riwayat',
                          style: GoogleFonts.poppins(color: Colors.grey)))
                  : ListView.separated(
                      itemCount: entries.length,
                      separatorBuilder: (context, index) =>
                          const Divider(color: Colors.transparent, height: 15),
                      itemBuilder: (context, index) {
                        final entry = entries[index] as Map<String, dynamic>;
                        return _buildHistoryItem(context, entry, formatter);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryItem(BuildContext context, Map<String, dynamic> entry,
      NumberFormat formatter) {
    final amount = (entry['amount'] as num).toDouble();
    final date = (entry['date'] as Timestamp).toDate();
    final formattedDate = DateFormat('d MMM, yyyy').format(date);

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[800],
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.account_balance,
              color: Color(0xFF37C8C3), size: 24),
        ),
        const SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Dana Masuk',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(fontWeight: FontWeight.w500)),
            const SizedBox(height: 4),
            Text(formattedDate,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Colors.grey)),
          ],
        ),
        const Spacer(),
        Text('+${formatter.format(amount)}',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: const Color(0xFF37C8C3), fontWeight: FontWeight.bold)),
      ],
    );
  }
}
