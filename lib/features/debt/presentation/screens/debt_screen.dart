import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:myapp/features/debt/presentation/screens/debt_detail_screen.dart';
import 'package:myapp/widgets/add_debt_form.dart';
import 'package:myapp/core/theme/app_theme.dart';
import 'package:myapp/core/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/features/auth/presentation/screens/login_screen.dart';

class DebtScreen extends StatelessWidget {
  final Function(int)? onNavigate;
  const DebtScreen({super.key, this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1C),
      appBar: AppBar(
        backgroundColor: FinoteColors.background,
        title: Text('Hutang', style: FinoteTextStyles.titleLarge),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            if (onNavigate != null) {
              onNavigate!(2); // Pindah ke tab Home
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => const AddDebtForm(),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirestoreService().getDebtsStream(),
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

          final debts = snapshot.data?.docs ?? [];
          double totalDebt = 0;
          for (var doc in debts) {
            final data = doc.data() as Map<String, dynamic>;
            totalDebt += (data['amount'] as num).toDouble();
          }

          final currencyFormatter = NumberFormat.currency(
              locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

          return RefreshIndicator(
            onRefresh: () async {
              // Simulate refresh or reload data if needed
              await Future.delayed(const Duration(seconds: 1));
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const FaIcon(
                      FontAwesomeIcons.moneyBillWave,
                      color: Color(0xFF37C8C3),
                      size: 60,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      currencyFormatter.format(totalDebt),
                      style: FinoteTextStyles.displayLarge,
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'JENIS JENIS HUTANG',
                      style: FinoteTextStyles.titleMedium
                          .copyWith(color: FinoteColors.textSecondary),
                    ),
                    const SizedBox(height: 16),
                    if (debts.isEmpty)
                      Center(
                          child: Padding(
                        padding: const EdgeInsets.only(top: 32.0),
                        child: Text('Belum ada hutang',
                            style: FinoteTextStyles.bodyMedium),
                      ))
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: debts.length,
                        itemBuilder: (context, index) {
                          final data =
                              debts[index].data() as Map<String, dynamic>;
                          final amount = (data['amount'] as num).toDouble();
                          final paid = (data['paidAmount'] as num).toDouble();
                          final progress = amount > 0 ? paid / amount : 0.0;
                          final debtId = debts[index].id;
                          final title = data['name'] ?? 'Hutang';

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DebtDetailScreen(
                                          debtId: debtId,
                                          title: title,
                                        )),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: _buildAnimatedDebtItem(
                                index: index,
                                icon:
                                    FontAwesomeIcons.creditCard, // Default icon
                                title: title,
                                totalAmount: amount,
                                progress: progress,
                              ),
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAnimatedDebtItem({
    required int index,
    required IconData icon,
    required String title,
    required double totalAmount,
    required double progress,
  }) {
    final currencyFormatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final formattedTotalAmount = currencyFormatter.format(totalAmount);

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
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: FinoteColors.surface,
          borderRadius: BorderRadius.circular(16),
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
            FaIcon(
              icon,
              color: FinoteColors.primary,
              size: 30,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: FinoteTextStyles.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 8,
                      backgroundColor: Colors.grey[800],
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        FinoteColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Total: $formattedTotalAmount',
                    style: FinoteTextStyles.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
