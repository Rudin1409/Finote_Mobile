
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
        hintText: 'Search for...',
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
      {'icon': Icons.electrical_services, 'title': 'Electricity', 'date': '21 FEB, 2018', 'amount': '- Rp 180.000', 'color': Colors.red},
      {'icon': Icons.fastfood, 'title': 'McDonalds', 'date': '19 FEB, 2018', 'amount': '- Rp 75.000', 'color': Colors.red},
      {'icon': Icons.music_note, 'title': 'Langganan Spotify', 'date': '11 FEB, 2018', 'amount': '- Rp 55.000', 'color': Colors.red},
      {'icon': Icons.fastfood, 'title': 'McDonalds', 'date': '10 FEB, 2018', 'amount': '- Rp 60.000', 'color': Colors.red},
    ];

    return Expanded(
      child: ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final item = transactions[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: const Color(0x1A45C8B4),
              child: Icon(item['icon'] as IconData, color: const Color(0xFF45C8B4), size: 20),
            ),
            title: Text(
              item['title'] as String,
              style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              item['date'] as String,
              style: GoogleFonts.poppins(color: Colors.white54, fontSize: 12),
            ),
            trailing: Text(
              item['amount'] as String,
              style: GoogleFonts.poppins(color: item['color'] as Color, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          );
        },
      ),
    );
  }
}
