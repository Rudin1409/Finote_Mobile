import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/widgets/add_income_form.dart';
import 'package:myapp/core/theme/app_theme.dart';
import 'package:myapp/widgets/transaction_card.dart';
import 'package:myapp/core/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'package:myapp/core/constants/app_constants.dart';
import 'package:myapp/widgets/transfer_funds_form.dart';

class IncomeScreen extends StatefulWidget {
  final Function(int) onNavigate;
  const IncomeScreen({super.key, required this.onNavigate});

  @override
  State<IncomeScreen> createState() => _IncomeScreenState();
}

class _IncomeScreenState extends State<IncomeScreen> {
  final List<Map<String, dynamic>> _cardData = [
    {
      'type': 'Tunai',
      'color': Colors.green,
      'balance': '0,00',
      'icon': Icons.money,
      'isBalanceVisible': true,
    },
    {
      'type': 'Bank',
      'color': const Color(0xFF45C8B4),
      'balance': '0,00',
      'cardNumber': '****  ****  ****  ****',
      'icon': Icons.account_balance,
      'isBalanceVisible': true,
    },
    {
      'type': 'Dompet Digital',
      'color': Colors.purple,
      'balance': '0,00',
      'icon': Icons.account_balance_wallet,
      'isBalanceVisible': true,
    },
  ];

  void _showAddIncomeForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddIncomeForm(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1C),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C1C1C),
        title: Text(
          'Pemasukan',
          style: FinoteTextStyles.titleLarge,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ElevatedButton.icon(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => const TransferFundsForm(),
                );
              },
              icon: const Icon(Icons.swap_horiz, size: 18, color: Colors.white),
              label: Text('Transfer',
                  style: GoogleFonts.poppins(
                      color: Colors.white, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white, size: 30),
            onPressed: () => _showAddIncomeForm(context),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
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
                ],
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final allTransactions = snapshot.data?.docs ?? [];

          // Calculate totals by source (Income - Expense)
          double totalTunai = 0;
          double totalBank = 0;
          double totalEWallet = 0;

          for (var doc in allTransactions) {
            final data = doc.data() as Map<String, dynamic>;
            final amount = (data['amount'] as num).toDouble();
            final type = data['type'] as String;
            final source = data['source'] as String? ?? 'other';

            if (source == 'cash' || source == 'Tunai') {
              if (type == 'income') {
                totalTunai += amount;
              } else {
                totalTunai -= amount;
              }
            } else if (source == 'bank' || source == 'Bank') {
              if (type == 'income') {
                totalBank += amount;
              } else {
                totalBank -= amount;
              }
            } else if (source == 'digital-wallet' ||
                source == 'Dompet Digital') {
              if (type == 'income') {
                totalEWallet += amount;
              } else {
                totalEWallet -= amount;
              }
            }
          }

          // Filter for history list (only show Income)
          final incomeTransactions = allTransactions.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return data['type'] == 'income';
          }).toList();

          // Update card data
          final currencyFormatter = NumberFormat.currency(
              locale: 'id_ID', symbol: '', decimalDigits: 2);

          // Assuming order: 0: Tunai, 1: Bank, 2: Dompet Digital based on _cardData init
          _cardData[0]['balance'] = currencyFormatter.format(totalTunai);
          _cardData[1]['balance'] = currencyFormatter.format(totalBank);
          _cardData[2]['balance'] = currencyFormatter.format(totalEWallet);

          return Column(
            children: [
              const SizedBox(height: 24),
              _buildCardCarousel(),
              const SizedBox(height: 24),
              _buildHistoryList(incomeTransactions),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCardCarousel() {
    return SizedBox(
      height: 180,
      child: PageView.builder(
        controller: PageController(viewportFraction: 0.85),
        itemCount: _cardData.length,
        itemBuilder: (context, index) {
          return _buildBalanceCard(_cardData[index], index);
        },
      ),
    );
  }

  Widget _buildBalanceCard(Map<String, dynamic> data, int index) {
    return Card(
      color: data['color'] as Color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(data['icon'] as IconData, color: const Color(0xCCFFFFFF)),
                const SizedBox(width: 8),
                Text(
                  data['type'] as String,
                  style: FinoteTextStyles.bodyLarge
                      .copyWith(color: Colors.white.withOpacity(0.8)),
                ),
              ],
            ),
            if (data.containsKey('cardNumber')) ...[
              const SizedBox(height: 8),
              Text(
                data['cardNumber'] as String,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 18,
                  letterSpacing: 2,
                ),
              ),
            ],
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (data['isBalanceVisible'] as bool)
                  Expanded(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: RichText(
                        text: TextSpan(
                          style: GoogleFonts.poppins(color: Colors.white),
                          children: <TextSpan>[
                            const TextSpan(
                              text: 'Rp ',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w300),
                            ),
                            TextSpan(
                              text: (data['balance'] as String).split(',')[0],
                              style: const TextStyle(
                                  fontSize: 36, fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text:
                                  ',${(data['balance'] as String).split(',')[1]}',
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w300),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                else
                  Text(
                    'Rp ****',
                    style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold),
                  ),
                Switch(
                  value: data['isBalanceVisible'] as bool,
                  onChanged: (value) {
                    setState(() {
                      _cardData[index]['isBalanceVisible'] = value;
                    });
                  },
                  activeTrackColor: Colors.white38,
                  activeThumbColor: Colors.white,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryList(List<QueryDocumentSnapshot> transactions) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
        decoration: const BoxDecoration(
          color: Color(0xFF2F2F2F),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                'RIWAYAT PEMASUKAN',
                style: GoogleFonts.poppins(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: transactions.isEmpty
                  ? Center(
                      child: Text('Belum ada data pemasukan',
                          style: FinoteTextStyles.bodyMedium))
                  : ListView.builder(
                      itemCount: transactions.length,
                      itemBuilder: (context, index) {
                        final data =
                            transactions[index].data() as Map<String, dynamic>;
                        final amount = (data['amount'] as num).toDouble();
                        final date = (data['date'] as Timestamp).toDate();
                        final formattedDate =
                            DateFormat('dd MMM, yyyy').format(date);
                        final currencyFormatter = NumberFormat.currency(
                            locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

                        String categoryLabel = data['category'] ?? 'Pemasukan';
                        try {
                          final category = AppConstants.categories.firstWhere(
                            (c) => c.value == data['category'],
                          );
                          categoryLabel = category.label;
                        } catch (e) {
                          // Keep original if not found (e.g. legacy data)
                        }

                        return TransactionCard(
                          index: index,
                          icon: Icons.arrow_downward,
                          title: categoryLabel,
                          subtitle: formattedDate,
                          amount: '+ ${currencyFormatter.format(amount)}',
                          amountColor: Colors.greenAccent,
                          iconColor: FinoteColors.primary,
                          onEdit: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) => AddIncomeForm(
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
                                    style: GoogleFonts.poppins(
                                        color: Colors.white70)),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text('Batal',
                                        style: GoogleFonts.poppins(
                                            color: Colors.grey)),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      Navigator.pop(context);
                                      try {
                                        await FirestoreService()
                                            .deleteTransaction(
                                                transactions[index].id);
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  'Transaksi berhasil dihapus'),
                                              backgroundColor: Colors.green,
                                            ),
                                          );
                                        }
                                      } catch (e) {
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content:
                                                  Text('Gagal menghapus: $e'),
                                              backgroundColor:
                                                  FinoteColors.error,
                                            ),
                                          );
                                        }
                                      }
                                    },
                                    child: Text('Hapus',
                                        style: GoogleFonts.poppins(
                                            color: Colors.red)),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
