
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:myapp/screens/auth/login_screen.dart';

class HomeScreen extends StatelessWidget {
  final Function(int) onNavigate;
  final VoidCallback onNavigateToAi;
  final VoidCallback onNavigateToSettings;

  const HomeScreen({
    super.key,
    required this.onNavigate,
    required this.onNavigateToAi,
    required this.onNavigateToSettings,
  });

  void _showProfileMenu(BuildContext context) {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

    showMenu(
      context: context,
      position: RelativeRect.fromRect(
        const Rect.fromLTWH(500.0, 80.0, 0.0, 0.0), 
        Rect.fromLTWH(0, 0, overlay.size.width, overlay.size.height)
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      color: const Color(0xFF2F2F2F),
      items: [
        PopupMenuItem(
          enabled: false, // Make it non-selectable
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Rudin", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(Icons.close, color: Colors.white, size: 20),
                  ),
                ],
              ),
              Text("muhammadbahrudin1409@gmail.com", style: GoogleFonts.poppins(color: Colors.grey[400], fontSize: 12)),
              const Divider(color: Colors.grey, thickness: 0.5, height: 20),
            ],
          ),
        ),
        _buildPopupMenuItem(context, icon: Icons.settings_outlined, text: 'Pengaturan', onTap: () {
          Navigator.pop(context); // Close the menu first
          onNavigateToSettings();
        }),
        _buildPopupMenuItem(context, icon: Icons.logout_outlined, text: 'Keluar', onTap: () {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (Route<dynamic> route) => false,
          );
        }),
      ],
    );
  }

  PopupMenuItem _buildPopupMenuItem(BuildContext context, {required IconData icon, required String text, required VoidCallback onTap}) {
    return PopupMenuItem(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: 12),
          Text(text, style: GoogleFonts.poppins(color: Colors.white)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF37C8C3);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundImage: AssetImage('assets/images/avatar.png'),
          ),
        ),
        title: Text('Hi! Rudin', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none, color: Colors.white, size: 30),
                onPressed: () {},
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: primaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
              )
            ],
          ),
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white, size: 30),
            onPressed: () => _showProfileMenu(context), // Show the menu on press
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildBalanceCard(context, primaryColor),
              const SizedBox(height: 24),
              _buildSummarySection(),
            ],
          ),
        ),
      ),
      floatingActionButton: SpeedDial(
        icon: Icons.add,
        activeIcon: Icons.close,
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        activeBackgroundColor: Colors.redAccent,
        activeForegroundColor: Colors.white,
        buttonSize: const Size(60, 60),
        childrenButtonSize: const Size(60, 60),
        curve: Curves.bounceIn,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        spacing: 12,
        spaceBetweenChildren: 8,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.auto_awesome, color: Colors.white),
            backgroundColor: primaryColor,
            label: 'Analisis AI',
            labelStyle: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold),
            labelBackgroundColor: primaryColor.withAlpha(204),
            onTap: onNavigateToAi,
          ),
          SpeedDialChild(
            child: const Icon(Icons.settings, color: Colors.white),
            backgroundColor: primaryColor,
            label: 'Pengaturan',
            labelStyle: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold),
            labelBackgroundColor: primaryColor.withAlpha(204),
            onTap: onNavigateToSettings,
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceCard(BuildContext context, Color primaryColor) {
  const double balance = 29000.45;
  const double change = 2134.42;
  final double percentageChange = (change / (balance - change)) * 100;
  final bool isPositive = change > 0;

  return Container(
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: Colors.grey[900],
      borderRadius: BorderRadius.circular(32),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Saldo Akhir', style: GoogleFonts.poppins(color: Colors.white, fontSize: 18)),
          ],
        ),
        const SizedBox(height: 8),
        Text('Rp ${balance.toStringAsFixed(2)}', style: GoogleFonts.poppins(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(isPositive ? Icons.arrow_upward : Icons.arrow_downward, color: isPositive ? Colors.green : Colors.red, size: 16),
            const SizedBox(width: 4),
            Text('${isPositive ? '+' : ''}${percentageChange.toStringAsFixed(1)}%', style: GoogleFonts.poppins(color: isPositive ? Colors.green : Colors.red)),
            const SizedBox(width: 8),
            Text('(${isPositive ? '+' : '-'}_${change.toStringAsFixed(2)})', style: GoogleFonts.poppins(color: Colors.grey)),
          ],
        ),
        const SizedBox(height: 24),
        SizedBox(
          height: 100,
          child: LineChart(
            _mainData(primaryColor),
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildIncomeExpenseButton(
              icon: Icons.attach_money,
              label: 'PEMASUKAN',
              color: primaryColor,
              onPressed: () => onNavigate(0),
            ),
            _buildIncomeExpenseButton(
              icon: Icons.money_off,
              label: 'PENGELUARAN',
              color: primaryColor,
              onPressed: () => onNavigate(1),
            ),
          ],
        ),
      ],
    ),
  );
}

   Widget _buildIncomeExpenseButton({required IconData icon, required String label, required Color color, required VoidCallback onPressed}) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: color, size: 18),
      label: Text(label, style: GoogleFonts.poppins(color: Colors.white, fontSize: 12)),
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: Colors.grey[700]!),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }

  LineChartData _mainData(Color primaryColor) {
    return LineChartData(
      gridData: const FlGridData(show: false),
      titlesData: const FlTitlesData(show: false),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 3), FlSpot(2.6, 2), FlSpot(4.9, 5), FlSpot(6.8, 3.1), FlSpot(8, 4), FlSpot(9.5, 3), FlSpot(11, 4),
          ],
          isCurved: true,
          color: primaryColor,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            gradient: const LinearGradient(
              colors: [Color(0x4D37C8C3), Color(0x0037C8C3)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummarySection() {
    return SizedBox(
      height: 150,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildSummaryCard(icon: Icons.arrow_downward, title: 'Pengeluaran', amount: 'Rp 10.244,81', progress: 0.6),
          _buildSummaryCard(icon: Icons.account_balance_wallet, title: 'Tabungan', amount: 'Rp 5.244,81', progress: 0.4),
          _buildSummaryCard(icon: Icons.credit_card, title: 'Hutang', amount: 'Rp 1.000,00', progress: 0.2),
        ],
      ),
    );
  }

  Widget _buildSummaryCard({required IconData icon, required String title, required String amount, required double progress}) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 50,
            height: 50,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 6,
                  backgroundColor: Colors.grey[800],
                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF37C8C3)),
                ),
                const Icon(Icons.monetization_on_outlined, color: Colors.white, size: 24),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(amount, style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          Text(title, style: GoogleFonts.poppins(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }
}
