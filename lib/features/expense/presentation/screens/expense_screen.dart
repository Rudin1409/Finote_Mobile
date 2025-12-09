import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/widgets/add_expense_form.dart';
import 'package:myapp/core/theme/app_theme.dart';
import 'package:myapp/widgets/transaction_card.dart';
import 'package:myapp/core/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:myapp/features/auth/presentation/screens/login_screen.dart';
import 'package:myapp/core/constants/app_constants.dart';

class ExpenseScreen extends StatefulWidget {
  final Function(int) onNavigate;
  const ExpenseScreen({super.key, required this.onNavigate});

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  void _showAddExpenseForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddExpenseForm(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        title: Text(
          'Pengeluaran',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add,
                color: Theme.of(context).iconTheme.color, size: 30),
            onPressed: _showAddExpenseForm,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const SizedBox(height: 24),
            _buildSearchBar(),
            const SizedBox(height: 24),
            _buildTransactionList(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      style: Theme.of(context).textTheme.bodyMedium,
      decoration: InputDecoration(
        hintText: 'Cari pengeluaran...',
        hintStyle: Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(color: Colors.grey),
        prefixIcon:
            Icon(Icons.search, color: Theme.of(context).iconTheme.color),
        filled: true,
        fillColor: Theme.of(context).cardColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildTransactionList() {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirestoreService().getTransactionsStream(),
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

          final transactions = snapshot.data?.docs.where((doc) {
                final data = doc.data() as Map<String, dynamic>;
                return data['type'] == 'expense';
              }).toList() ??
              [];

          if (transactions.isEmpty) {
            return Center(
                child: Text('Belum ada data pengeluaran',
                    style: FinoteTextStyles.bodyMedium));
          }

          return ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final data = transactions[index].data() as Map<String, dynamic>;
              final amount = (data['amount'] as num).toDouble();
              final date = (data['date'] as Timestamp).toDate();
              final formattedDate = DateFormat('dd MMM, yyyy').format(date);
              final currencyFormatter = NumberFormat.currency(
                  locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

              String categoryLabel = data['category'] ?? 'Pengeluaran';
              try {
                final category = AppConstants.categories.firstWhere(
                  (c) => c.value == data['category'],
                );
                categoryLabel = category.label;
              } catch (e) {
                // Keep original if not found
              }

              return TransactionCard(
                index: index,
                icon: Icons.arrow_upward, // Default icon for expense
                title: categoryLabel,
                subtitle: formattedDate,
                amount: '- ${currencyFormatter.format(amount)}',
                amountColor: Colors.redAccent,
                iconColor: FinoteColors.error,
                onEdit: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => AddExpenseForm(
                      transactionId: transactions[index].id,
                      initialData: data,
                    ),
                  );
                },
                onDelete: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: const Color(0xFF2F2F2F),
                      title: Text('Hapus Transaksi?',
                          style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      content: Text(
                          'Apakah Anda yakin ingin menghapus transaksi ini?',
                          style: GoogleFonts.poppins(color: Colors.white70)),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Batal',
                              style: GoogleFonts.poppins(color: Colors.grey)),
                        ),
                        TextButton(
                          onPressed: () async {
                            Navigator.pop(context);
                            try {
                              await FirestoreService()
                                  .deleteTransaction(transactions[index].id);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Transaksi berhasil dihapus'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Gagal menghapus: $e'),
                                    backgroundColor: FinoteColors.error,
                                  ),
                                );
                              }
                            }
                          },
                          child: Text('Hapus',
                              style: GoogleFonts.poppins(color: Colors.red)),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
