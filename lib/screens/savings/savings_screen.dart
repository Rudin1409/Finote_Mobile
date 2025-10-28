import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/screens/savings/savings_detail_screen.dart';
import 'package:myapp/widgets/add_saving_form.dart'; // Import the form widget

class SavingsScreen extends StatelessWidget {
  final Function(int) onNavigate;

  const SavingsScreen({super.key, required this.onNavigate});

  void _navigateToDetail(BuildContext context, String title) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SavingsDetailScreen(title: title),
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
      backgroundColor: const Color(0xFF1C1C1C),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C1C1C),
        elevation: 0,
        title: Text('Tabungan', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => onNavigate(2), // Navigate back to Home
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white, size: 30),
            onPressed: () => _showAddSavingForm(context), // Show the modal
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
            child: _buildTotalSavings(primaryColor),
          ),
          Expanded(
            child: _buildSavingsListContainer(context, primaryColor),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalSavings(Color primaryColor) {
    return Column(
      children: [
        Icon(
          Icons.savings_outlined, // Placeholder icon
          color: primaryColor,
          size: 60,
        ),
        const SizedBox(height: 10),
        Text(
          'Rp 12,902',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

    Widget _buildSavingsListContainer(BuildContext context, Color primaryColor) {
    return Container(
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
                padding: const EdgeInsets.fromLTRB(25, 25, 25, 20),
                child: Text(
                  'JENIS JENIS TABUNGAN',
                  style: GoogleFonts.poppins(
                    color: Colors.grey[400],
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  children: [
                     GestureDetector(
                        onTap: () => _navigateToDetail(context, 'Motor'),
                        child: _buildSavingGoalCard(
                          icon: Icons.two_wheeler,
                          title: 'Motor',
                          amountLeft: '\$300.00 LEFT',
                          progress: 0.7,
                          color: primaryColor,
                        ),
                      ),
                      const SizedBox(height: 15),
                      GestureDetector(
                        onTap: () => _navigateToDetail(context, 'Leptop'),
                        child: _buildSavingGoalCard(
                          icon: Icons.laptop_mac,
                          title: 'Leptop',
                          amountLeft: '\$1,200.00 LEFT',
                          progress: 0.4,
                          color: primaryColor,
                        ),
                      ),
                      const SizedBox(height: 15),
                      GestureDetector(
                        onTap: () => _navigateToDetail(context, 'PC'),
                        child: _buildSavingGoalCard(
                          icon: Icons.desktop_windows,
                          title: 'PC',
                          amountLeft: '\$800.00 LEFT',
                          progress: 0.9,
                          color: primaryColor,
                        ),
                      ),
                      const SizedBox(height: 15),
                       GestureDetector(
                        onTap: () => _navigateToDetail(context, 'PC'),
                        child: _buildSavingGoalCard(
                          icon: Icons.desktop_windows,
                          title: 'PC',
                          amountLeft: '\$800.00 LEFT',
                          progress: 0.9,
                          color: primaryColor,
                        ),
                      ),
                  ],
                ),
              )
           ],
        ),
    );
  }


  Widget _buildSavingGoalCard({
    required IconData icon,
    required String title,
    required String amountLeft,
    required double progress,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1C),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Color(0xFF2F2F2F), 
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
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor: Colors.grey[800],
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  amountLeft,
                  style: GoogleFonts.poppins(
                    color: Colors.grey[400],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
