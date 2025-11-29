import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:myapp/features/auth/presentation/screens/login_screen.dart';
import 'package:shimmer/shimmer.dart';
import 'package:myapp/core/theme/app_theme.dart';
import 'package:myapp/core/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:myapp/core/constants/app_constants.dart';
import 'package:myapp/features/income/presentation/screens/income_screen.dart';
import 'package:myapp/features/expense/presentation/screens/expense_screen.dart';

class HomeScreen extends StatefulWidget {
  final Function(int) onNavigate;

  const HomeScreen({
    super.key,
    required this.onNavigate,
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
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

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
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child:
                        const Icon(Icons.close, color: Colors.white, size: 20),
                  ),
                ],
              ),
              Text("muhammadbahrudin1409@gmail.com",
                  style: GoogleFonts.poppins(
                      color: Colors.grey[400], fontSize: 12)),
              const Divider(color: Colors.grey, thickness: 0.5, height: 20),
            ],
          ),
        ),
        _buildPopupMenuItem(context,
            icon: Icons.logout_outlined, text: 'Keluar', onTap: () {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (Route<dynamic> route) => false,
          );
        }),
      ],
    );
  }

  PopupMenuItem _buildPopupMenuItem(BuildContext context,
      {required IconData icon,
      required String text,
      required VoidCallback onTap}) {
    return PopupMenuItem(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: FinoteColors.textPrimary, size: 20),
          const SizedBox(width: 12),
          Text(text,
              style: FinoteTextStyles.bodyMedium
                  .copyWith(color: FinoteColors.textPrimary)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FinoteColors.background,
      appBar: AppBar(
        backgroundColor: FinoteColors.background,
        elevation: 0,
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundImage: AssetImage('assets/images/avatar.png'),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Halo, Rudin!', style: FinoteTextStyles.titleLarge),
            Text('Selamat Datang Kembali',
                style: FinoteTextStyles.bodyMedium.copyWith(fontSize: 12)),
          ],
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none,
                    color: FinoteColors.textPrimary, size: 30),
                onPressed: () {},
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: FinoteColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              )
            ],
          ),
          IconButton(
            icon: const Icon(Icons.menu,
                color: FinoteColors.textPrimary, size: 30),
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
          child: const Icon(Icons.arrow_downward, color: Colors.white),
          backgroundColor: Colors.green,
          label: 'Pemasukan',
          labelStyle: GoogleFonts.poppins(
              color: Colors.white, fontWeight: FontWeight.bold),
          labelBackgroundColor: Colors.green.withAlpha(204),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => IncomeScreen(
                  onNavigate: (index) => Navigator.pop(context),
                ),
              ),
            );
          },
        ),
        SpeedDialChild(
          child: const Icon(Icons.arrow_upward, color: Colors.white),
          backgroundColor: Colors.red,
          label: 'Pengeluaran',
          labelStyle: GoogleFonts.poppins(
              color: Colors.white, fontWeight: FontWeight.bold),
          labelBackgroundColor: Colors.red.withAlpha(204),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ExpenseScreen(
                  onNavigate: (index) => Navigator.pop(context),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildActualContent() {
    return StreamBuilder<QuerySnapshot>(
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
          return _buildShimmerLoading();
        }

        final transactions = snapshot.data?.docs ?? [];
        double totalIncome = 0;
        double totalExpense = 0;

        for (var doc in transactions) {
          final data = doc.data() as Map<String, dynamic>;
          final amount = (data['amount'] as num).toDouble();
          final type = data['type'] as String;
          final category = data['category'] as String?;

          if (category != 'transfer') {
            if (type == 'income') {
              totalIncome += amount;
            } else {
              totalExpense += amount;
            }
          }
        }

        final balance = totalIncome - totalExpense;

        return RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(const Duration(seconds: 1));
            setState(() {});
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildBalanceCard(
                      context, balance, totalIncome, totalExpense),
                  const SizedBox(height: 24),
                  _buildExpenseChart(transactions),
                  const SizedBox(height: 24),
                  _buildSummarySection(totalExpense),
                ],
              ),
            ),
          ),
        );
      },
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
                    Container(height: 100, color: Colors.white),
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
                      child: CircleAvatar(
                          radius: 80,
                          backgroundColor: Colors.white.withAlpha(25)),
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

  Widget _buildBalanceCard(
      BuildContext context, double balance, double income, double expense) {
    final currencyFormatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            FinoteColors.surface,
            FinoteColors.surface.withOpacity(0.8),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Saldo Akhir',
                    style: FinoteTextStyles.titleMedium
                        .copyWith(color: FinoteColors.textSecondary)),
                const SizedBox(height: 8),
                Text(currencyFormatter.format(balance),
                    style: FinoteTextStyles.displayLarge),
                const SizedBox(height: 8),
                const SizedBox(height: 24),
                SizedBox(
                  height: 100,
                  child: LineChart(_mainData(FinoteColors.primary)),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildIncomeExpenseButton(
                      icon: Icons.arrow_downward,
                      label: 'PEMASUKAN',
                      color: Colors.greenAccent,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => IncomeScreen(
                              onNavigate: (index) {},
                            ),
                          ),
                        );
                      },
                    ),
                    _buildIncomeExpenseButton(
                      icon: Icons.arrow_upward,
                      label: 'PENGELUARAN',
                      color: Colors.redAccent,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ExpenseScreen(
                              onNavigate: (index) {},
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIncomeExpenseButton(
      {required IconData icon,
      required String label,
      required Color color,
      required VoidCallback onPressed}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: Icon(icon, color: Colors.black, size: 18),
          label: Text(label,
              style: FinoteTextStyles.titleMedium
                  .copyWith(color: Colors.black, fontSize: 12)),
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.black,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            padding: const EdgeInsets.symmetric(vertical: 12),
            elevation: 5,
            shadowColor: color.withOpacity(0.5),
          ),
        ),
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

  Widget _buildExpenseChart(List<QueryDocumentSnapshot> transactions) {
    Map<String, double> categoryTotals = {};
    double totalExpense = 0;

    for (var doc in transactions) {
      final data = doc.data() as Map<String, dynamic>;
      if (data['type'] == 'expense' && data['category'] != 'transfer') {
        final amount = (data['amount'] as num).toDouble();
        final category = data['category'] as String? ?? 'Lainnya';
        categoryTotals[category] = (categoryTotals[category] ?? 0) + amount;
        totalExpense += amount;
      }
    }

    var sortedEntries = categoryTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    List<MapEntry<String, double>> topCategories;
    if (sortedEntries.length > 4) {
      topCategories = sortedEntries.take(3).toList();
      double otherTotal =
          sortedEntries.skip(3).fold(0, (sum, item) => sum + item.value);
      topCategories.add(MapEntry('Lainnya', otherTotal));
    } else {
      topCategories = sortedEntries;
    }

    final List<Color> colors = [
      const Color(0xFF0293ee),
      const Color(0xFFf8b250),
      const Color(0xFF845bef),
      const Color(0xFF13d38e),
    ];

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
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                borderData: FlBorderData(show: false),
                sectionsSpace: 2,
                centerSpaceRadius: 40,
                sections: totalExpense == 0
                    ? [
                        PieChartSectionData(
                          color: Colors.grey[850],
                          value: 1,
                          title: '',
                          radius: 50,
                          showTitle: false,
                        )
                      ]
                    : showingSections(topCategories, totalExpense, colors),
              ),
            ),
          ),
          const SizedBox(height: 20),
          if (totalExpense > 0)
            _buildLegend(topCategories, colors)
          else
            Text("Belum ada data",
                style: GoogleFonts.poppins(color: Colors.grey)),
        ],
      ),
    );
  }

  List<PieChartSectionData> showingSections(
      List<MapEntry<String, double>> categories,
      double total,
      List<Color> colors) {
    return List.generate(categories.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 20.0 : 14.0;
      final radius = isTouched ? 60.0 : 50.0;
      final percentage = (categories[i].value / total * 100).toStringAsFixed(0);

      return PieChartSectionData(
        color: colors[i % colors.length],
        value: categories[i].value,
        title: '$percentage%',
        radius: radius,
        titleStyle: GoogleFonts.poppins(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    });
  }

  Widget _buildLegend(
      List<MapEntry<String, double>> categories, List<Color> colors) {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: List.generate(categories.length, (i) {
        String categoryValue = categories[i].key;
        String label = categoryValue;

        if (categoryValue == 'Lainnya') {
          label = 'Lainnya';
        } else {
          try {
            final category = AppConstants.categories.firstWhere(
              (c) => c.value == categoryValue,
            );
            label = category.label;
          } catch (e) {
            // Keep original if not found
          }
        }

        return Indicator(
          color: colors[i % colors.length],
          text: label,
          isSquare: true,
        );
      }),
    );
  }

  Widget _buildSummarySection(double totalExpense) {
    final currencyFormatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    return SizedBox(
      height: 150,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildSummaryCard(
              icon: Icons.arrow_downward,
              title: 'Pengeluaran',
              amount: currencyFormatter.format(totalExpense),
              progress:
                  0.6, // TODO: Calculate progress based on budget if available
              color: Colors.red),
          StreamBuilder<QuerySnapshot>(
            stream: FirestoreService().getSavingsStream(),
            builder: (context, snapshot) {
              double totalSavings = 0;
              if (snapshot.hasData) {
                for (var doc in snapshot.data!.docs) {
                  final data = doc.data() as Map<String, dynamic>;
                  totalSavings += (data['currentAmount'] as num).toDouble();
                }
              }
              return _buildSummaryCard(
                  icon: Icons.account_balance_wallet,
                  title: 'Tabungan',
                  amount: currencyFormatter.format(totalSavings),
                  progress: 0.5, // Placeholder progress
                  color: Colors.green);
            },
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirestoreService().getDebtsStream(),
            builder: (context, snapshot) {
              double totalDebt = 0;
              if (snapshot.hasData) {
                for (var doc in snapshot.data!.docs) {
                  final data = doc.data() as Map<String, dynamic>;
                  totalDebt += (data['amount'] as num).toDouble();
                }
              }
              return _buildSummaryCard(
                  icon: Icons.credit_card,
                  title: 'Hutang',
                  amount: currencyFormatter.format(totalDebt),
                  progress: 0.3, // Placeholder progress
                  color: Colors.orange);
            },
          ),
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
        color: FinoteColors.surface,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
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
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
          Text(title,
              style: GoogleFonts.poppins(color: Colors.grey, fontSize: 12)),
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
        const SizedBox(
          width: 4,
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        )
      ],
    );
  }
}
