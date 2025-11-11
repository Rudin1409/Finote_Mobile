
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:myapp/features/auth/presentation/screens/login_screen.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatefulWidget {
  final Function(int) onNavigate;
  final VoidCallback onNavigateToAi;
  final VoidCallback onNavigateToSettings;

  const HomeScreen({
    super.key,
    required this.onNavigate,
    required this.onNavigateToAi,
    required this.onNavigateToSettings,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int touchedIndex = -1;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    // Simulate network request
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showProfileMenu(BuildContext context) {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

    showMenu(
      context: context,
      position: RelativeRect.fromRect(
          const Rect.fromLTWH(500.0, 80.0, 0.0, 0.0),
          Rect.fromLTWH(0, 0, overlay.size.width, overlay.size.height)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      color: const Color(0xFF2F2F2F),
      items: [
        PopupMenuItem(
          enabled: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Rudin",
                      style: GoogleFonts.poppins(
                          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(Icons.close, color: Colors.white, size: 20),
                  ),
                ],
              ),
              Text("muhammadbahrudin1409@gmail.com",
                  style: GoogleFonts.poppins(color: Colors.grey[400], fontSize: 12)),
              const Divider(color: Colors.grey, thickness: 0.5, height: 20),
            ],
          ),
        ),
        _buildPopupMenuItem(context, icon: Icons.settings_outlined, text: 'Pengaturan', onTap: () {
          Navigator.pop(context);
          widget.onNavigateToSettings();
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

  PopupMenuItem _buildPopupMenuItem(BuildContext context,
      {required IconData icon, required String text, required VoidCallback onTap}) {
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
        title: Text('Hi! Rudin',
            style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
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
                    color: Color(0xFF37C8C3),
                    shape: BoxShape.circle,
                  ),
                ),
              )
            ],
          ),
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white, size: 30),
            onPressed: () => _showProfileMenu(context),
          ),
        ],
      ),
      body: _isLoading ? _buildShimmerLoading() : _buildActualContent(),
      floatingActionButton: _isLoading ? null : _buildFloatingActionButton(),
    );
  }

  Widget _buildFloatingActionButton() {
    const primaryColor = Color(0xFF37C8C3);
    return SpeedDial(
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
          onTap: widget.onNavigateToAi,
        ),
        SpeedDialChild(
          child: const Icon(Icons.settings, color: Colors.white),
          backgroundColor: primaryColor,
          label: 'Pengaturan',
          labelStyle: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold),
          labelBackgroundColor: primaryColor.withAlpha(204),
          onTap: widget.onNavigateToSettings,
        ),
      ],
    );
  }

  Widget _buildActualContent() {
    const primaryColor = Color(0xFF37C8C3);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildBalanceCard(context, primaryColor),
            const SizedBox(height: 24),
            _buildExpenseChart(),
            const SizedBox(height: 24),
            _buildSummarySection(),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[850]!,
      highlightColor: Colors.grey[700]!,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Shimmer for Balance Card
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(width: 100, height: 20, color: Colors.white),
                    const SizedBox(height: 12),
                    Container(width: 200, height: 40, color: Colors.white),
                    const SizedBox(height: 12),
                    Container(width: 150, height: 16, color: Colors.white),
                    const SizedBox(height: 30),
                    Container(
                      height: 100,
                      color: Colors.white,
                    ),
                     const SizedBox(height: 30),
                      Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                       children: [
                         Container(width: 120, height: 40, color: Colors.white),
                         Container(width: 120, height: 40, color: Colors.white),
                       ],
                     )
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Shimmer for Expense Chart
              Container(
                height: 300,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(32),
                ),
                 child: Column(
                   children: [
                     Container(width: 200, height: 24, color: Colors.white),
                     const SizedBox(height: 24),
                     Expanded(
                       child: CircleAvatar(radius: 80, backgroundColor: Colors.white.withAlpha(25)),
                     ),
                      const SizedBox(height: 24),
                       Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                       children: [
                         Container(width: 100, height: 20, color: Colors.white),
                         Container(width: 100, height: 20, color: Colors.white),
                       ],
                     )
                   ],
                 ),
              ),
              const SizedBox(height: 24),
              // Shimmer for Summary Section
              SizedBox(
                height: 150,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 3,
                  itemBuilder: (context, index) => Container(
                    width: 150,
                    margin: const EdgeInsets.only(right: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(32),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
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
          Text('Saldo Akhir', style: GoogleFonts.poppins(color: Colors.white, fontSize: 18)),
          const SizedBox(height: 8),
          Text('Rp ${balance.toStringAsFixed(2)}',
              style: GoogleFonts.poppins(
                  color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                  color: isPositive ? Colors.green : Colors.red, size: 16),
              const SizedBox(width: 4),
              Text('${isPositive ? '+' : ''}${percentageChange.toStringAsFixed(1)}%',
                  style: GoogleFonts.poppins(color: isPositive ? Colors.green : Colors.red)),
              const SizedBox(width: 8),
              Text('(${isPositive ? '+' : '-'}_${change.toStringAsFixed(2)})',
                  style: GoogleFonts.poppins(color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 100,
            child: LineChart(_mainData(primaryColor)),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildIncomeExpenseButton(
                icon: Icons.attach_money,
                label: 'PEMASUKAN',
                color: primaryColor,
                onPressed: () => widget.onNavigate(0),
              ),
              _buildIncomeExpenseButton(
                icon: Icons.money_off,
                label: 'PENGELUARAN',
                color: primaryColor,
                onPressed: () => widget.onNavigate(1),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIncomeExpenseButton(
      {required IconData icon, required String label, required Color color, required VoidCallback onPressed}) {
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
            FlSpot(0, 3),
            FlSpot(2.6, 2),
            FlSpot(4.9, 5),
            FlSpot(6.8, 3.1),
            FlSpot(8, 4),
            FlSpot(9.5, 3),
            FlSpot(11, 4),
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

  Widget _buildExpenseChart() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        children: [
          Text("Komposisi Pengeluaran",
              style: GoogleFonts.poppins(
                  color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                pieTouchData: PieTouchData(
                  touchCallback: (FlTouchEvent event, pieTouchResponse) {
                    setState(() {
                      if (!event.isInterestedForInteractions ||
                          pieTouchResponse == null ||
                          pieTouchResponse.touchedSection == null) {
                        touchedIndex = -1;
                        return;
                      }
                      touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                    });
                  },
                ),
                borderData: FlBorderData(show: false),
                sectionsSpace: 0,
                centerSpaceRadius: 40,
                sections: showingSections(),
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildLegend(),
        ],
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(4, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: const Color(0xFF0293ee),
            value: 40,
            title: '40%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize, fontWeight: FontWeight.bold, color: Colors.white, shadows: shadows),
          );
        case 1:
          return PieChartSectionData(
            color: const Color(0xFFf8b250),
            value: 30,
            title: '30%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize, fontWeight: FontWeight.bold, color: Colors.white, shadows: shadows),
          );
        case 2:
          return PieChartSectionData(
            color: const Color(0xFF845bef),
            value: 15,
            title: '15%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize, fontWeight: FontWeight.bold, color: Colors.white, shadows: shadows),
          );
        case 3:
          return PieChartSectionData(
            color: const Color(0xFF13d38e),
            value: 15,
            title: '15%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize, fontWeight: FontWeight.bold, color: Colors.white, shadows: shadows),
          );
        default:
          throw Error();
      }
    });
  }

  Widget _buildLegend() {
    return const Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Indicator(color: Color(0xFF0293ee), text: 'Makanan', isSquare: true),
            const Indicator(color: Color(0xFFf8b250), text: 'Transportasi', isSquare: true),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Indicator(color: Color(0xFF845bef), text: 'Hiburan', isSquare: true),
            const Indicator(color: Color(0xFF13d38e), text: 'Tagihan', isSquare: true),
          ],
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
          _buildSummaryCard(
              icon: Icons.arrow_downward,
              title: 'Pengeluaran',
              amount: 'Rp 10.244,81',
              progress: 0.6,
              color: Colors.red),
          _buildSummaryCard(
              icon: Icons.account_balance_wallet,
              title: 'Tabungan',
              amount: 'Rp 5.244,81',
              progress: 0.4,
              color: Colors.green),
          _buildSummaryCard(
              icon: Icons.credit_card,
              title: 'Hutang',
              amount: 'Rp 1.000,00',
              progress: 0.2,
              color: Colors.orange),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
      {required IconData icon,
      required String title,
      required String amount,
      required double progress,
      required Color color}) {
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
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
                Icon(icon, color: Colors.white, size: 24),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(amount,
              style: GoogleFonts.poppins(
                  color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          Text(title, style: GoogleFonts.poppins(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }
}

class Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color textColor;

  const Indicator({
    super.key,
    required this.color,
    required this.text,
    this.isSquare = false,
    this.size = 16,
    this.textColor = const Color(0xff505050),
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.white,
          ),
        )
      ],
    );
  }
}
