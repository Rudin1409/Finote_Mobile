
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/widgets/add_expense_form.dart';

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
      backgroundColor: const Color(0xFF1C1C1C),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C1C1C),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => widget.onNavigate(2), // Navigate to home
        ),
        title: Text(
          'Pengeluaran',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white, size: 30),
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
      style: GoogleFonts.poppins(color: Colors.white),
      decoration: InputDecoration(
        hintText: 'Cari pengeluaran...',
        hintStyle: GoogleFonts.poppins(color: Colors.white54),
        prefixIcon: const Icon(Icons.search, color: Colors.white54),
        filled: true,
        fillColor: const Color(0xFF2F2F2F),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildTransactionList() {
    final List<Map<String, dynamic>> transactions = [
      {'icon': Icons.fastfood, 'category': 'Makanan', 'title': 'Makan siang di warung', 'date': '28 Agu, 2024', 'amount': '- Rp 25.000', 'color': Colors.redAccent},
      {'icon': Icons.train, 'category': 'Transportasi', 'title': 'Tiket KRL ke Bogor', 'date': '28 Agu, 2024', 'amount': '- Rp 5.000', 'color': Colors.redAccent},
      {'icon': Icons.receipt, 'category': 'Tagihan', 'title': 'Bayar tagihan internet', 'date': '27 Agu, 2024', 'amount': '- Rp 350.000', 'color': Colors.redAccent},
      {'icon': Icons.shopping_bag, 'category': 'Belanja', 'title': 'Beli sabun & sampo', 'date': '26 Agu, 2024', 'amount': '- Rp 65.000', 'color': Colors.redAccent},
      {'icon': Icons.movie, 'category': 'Hiburan', 'title': 'Nonton film di bioskop', 'date': '25 Agu, 2024', 'amount': '- Rp 50.000', 'color': Colors.redAccent},
      {'icon': Icons.local_gas_station, 'category': 'Transportasi', 'title': 'Isi bensin motor', 'date': '25 Agu, 2024', 'amount': '- Rp 30.000', 'color': Colors.redAccent},
      {'icon': Icons.health_and_safety, 'category': 'Kesehatan', 'title': 'Beli obat batuk', 'date': '24 Agu, 2024', 'amount': '- Rp 45.000', 'color': Colors.redAccent},
      {'icon': Icons.fastfood, 'category': 'Makanan', 'title': 'Pesan GoFood malam', 'date': '23 Agu, 2024', 'amount': '- Rp 85.000', 'color': Colors.redAccent},

    ];

    return Expanded(
      child: ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final item = transactions[index];
          return Card(
            color: const Color(0xFF2F2F2F),
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: CircleAvatar(
                backgroundColor: const Color(0xFF37C8C3).withAlpha(25),
                child: Icon(item['icon'] as IconData, color: const Color(0xFF37C8C3), size: 22),
              ),
              title: Text(
                item['title'] as String,
                style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15),
              ),
              subtitle: Text(
                item['date'] as String,
                style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12),
              ),
              trailing: Text(
                item['amount'] as String,
                style: GoogleFonts.poppins(color: item['color'] as Color, fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          );
        },
      ),
    );
  }
}
