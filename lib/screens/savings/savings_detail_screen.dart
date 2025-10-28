import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/screens/savings/add_funds_screen.dart';
import 'package:percent_indicator/percent_indicator.dart';

class SavingsDetailScreen extends StatelessWidget {
  final String title;

  const SavingsDetailScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF37C8C3);

    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1C),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C1C1C),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(title, style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          _buildHeader(context, primaryColor),
          const SizedBox(height: 20),
          _buildHistorySection(),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Color primaryColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Column(
        children: [
          CircularPercentIndicator(
            radius: 100.0,
            lineWidth: 20.0,
            animation: true,
            percent: 0.6,
            center: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '60% tercapai',
                  style: GoogleFonts.poppins(color: Colors.grey[400], fontSize: 16),
                ),
                Text(
                  'Rp 655.00',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            circularStrokeCap: CircularStrokeCap.round,
            progressColor: primaryColor,
            backgroundColor: Colors.grey[800]!,
          ),
          const SizedBox(height: 20),
          Text(
            'Target: 18 Oct 2028',
            style: GoogleFonts.poppins(color: Colors.grey, fontSize: 16),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddFundsScreen(savingGoalName: title)),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              minimumSize: const Size(double.infinity, 55),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            ),
            child: Text(
              'TAMBAH DANA',
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistorySection() {
    return Expanded(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(25.0),
        decoration: BoxDecoration(
          color: const Color(0xFF2F2F2F),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(76),
              spreadRadius: 5,
              blurRadius: 15,
              offset: const Offset(0, -5),
            )
          ]
        ),
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
              child: ListView.separated(
                itemCount: 5, // Example count
                separatorBuilder: (context, index) => const Divider(color: Colors.transparent, height: 15),
                itemBuilder: (context, index) {
                  return _buildHistoryItem();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryItem() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[800],
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.account_balance, color: Color(0xFF37C8C3), size: 24),
        ),
        const SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Funds received', style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
            const SizedBox(height: 4),
            Text('17 FEB, 2018', style: GoogleFonts.poppins(color: Colors.grey[500], fontSize: 12)),
          ],
        ),
        const Spacer(),
        Text('+\$700.00', style: GoogleFonts.poppins(color: const Color(0xFF37C8C3), fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
