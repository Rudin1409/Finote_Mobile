import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:myapp/features/savings/presentation/screens/savings_detail_screen.dart';
import 'package:myapp/widgets/add_saving_form.dart';
import 'package:myapp/core/theme/app_theme.dart';
import 'package:myapp/core/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:myapp/features/auth/presentation/screens/login_screen.dart';

import 'package:flutter/services.dart';

class SavingsScreen extends StatelessWidget {
  final Function(int) onNavigate;

  const SavingsScreen({super.key, required this.onNavigate});

  void _navigateToDetail(BuildContext context, String title, String savingId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            SavingsDetailScreen(title: title, savingId: savingId),
      ),
    );
  }

  void _showAddSavingForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, // Make it transparent
      builder: (context) => const AddSavingForm(),
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
        title: Text('Tabungan', style: Theme.of(context).textTheme.titleLarge),
        leading: IconButton(
          icon:
              Icon(Icons.arrow_back, color: Theme.of(context).iconTheme.color),
          onPressed: () => onNavigate(2), // Navigate back to Home
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add,
                color: Theme.of(context).iconTheme.color, size: 30),
            onPressed: () => _showAddSavingForm(context), // Show the modal
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirestoreService().getSavingsStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Terjadi kesalahan',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Gagal memuat data. Silakan login ulang.',
                    style: GoogleFonts.poppins(color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                        (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF37C8C3),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 12),
                    ),
                    child: Text(
                      'Login Ulang',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final savings = snapshot.data?.docs ?? [];
          double totalSavings = 0;
          for (var doc in savings) {
            final data = doc.data() as Map<String, dynamic>;
            totalSavings += (data['currentAmount'] as num).toDouble();
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 20.0),
                child: _buildTotalSavings(primaryColor, totalSavings),
              ),
              Expanded(
                child:
                    _buildSavingsListContainer(context, primaryColor, savings),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTotalSavings(Color primaryColor, double total) {
    final currencyFormatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    return Column(
      children: [
        Icon(
          Icons.savings_outlined, // Placeholder icon
          color: primaryColor,
          size: 60,
        ),
        const SizedBox(height: 10),
        Text(
          currencyFormatter.format(total),
          style: FinoteTextStyles.displayLarge,
        ),
      ],
    );
  }

  Widget _buildSavingsListContainer(BuildContext context, Color primaryColor,
      List<QueryDocumentSnapshot> savings) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(25, 25, 25, 20),
            child: Text(
              'JENIS JENIS TABUNGAN',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.color
                        ?.withOpacity(0.7),
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await Future.delayed(const Duration(seconds: 1));
              },
              child: savings.isEmpty
                  ? SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Container(
                        height: 400, // Ensure enough height to pull
                        alignment: Alignment.center,
                        child: Text('Belum ada tabungan',
                            style: FinoteTextStyles.bodyMedium),
                      ),
                    )
                  : ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      itemCount: savings.length,
                      itemBuilder: (context, index) {
                        final data =
                            savings[index].data() as Map<String, dynamic>;
                        final target = (data['targetAmount'] as num).toDouble();
                        final current =
                            (data['currentAmount'] as num).toDouble();
                        final progress = target > 0 ? current / target : 0.0;
                        final remaining = target - current;
                        final currencyFormatter = NumberFormat.currency(
                            locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

                        return Column(
                          children: [
                            _buildAnimatedSavingCard(
                              context,
                              index,
                              Icons.savings, // Default icon
                              data['name'] ?? 'Tabungan',
                              '${currencyFormatter.format(remaining)} TERSISA',
                              progress,
                              FinoteColors.primary,
                              savings[index].id,
                            ),
                            const SizedBox(height: 15),
                          ],
                        );
                      },
                    ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildAnimatedSavingCard(
    BuildContext context,
    int index,
    IconData icon,
    String title,
    String amountLeft,
    double progress,
    Color color,
    String savingId,
  ) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 400 + (index * 100)),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: GestureDetector(
        onTap: () => _navigateToDetail(context, title, savingId),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 10,
                        backgroundColor: Colors.grey[800],
                        valueColor: AlwaysStoppedAnimation<Color>(color),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      amountLeft,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
