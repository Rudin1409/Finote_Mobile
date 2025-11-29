import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:myapp/core/services/firestore_service.dart';

class FinancialReportScreen extends StatefulWidget {
  const FinancialReportScreen({super.key});

  @override
  State<FinancialReportScreen> createState() => _FinancialReportScreenState();
}

class _FinancialReportScreenState extends State<FinancialReportScreen> {
  int _selectedPeriod =
      0; // 0 for Daily (This Week), 1 for Monthly, 2 for Yearly
  bool _isAnalyzing = false;

  Future<void> _handleAnalyze(double totalIncome, double totalExpense,
      Map<String, double> categoryExpenses) async {
    setState(() {
      _isAnalyzing = true;
    });

    // Simulate network delay for AI analysis
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // Generate Rule-Based Insights
    List<String> positivePoints = [];
    List<String> improvementPoints = [];
    String summaryText = "";

    // 1. Cash Flow Analysis
    if (totalIncome > totalExpense) {
      summaryText =
          "Keuanganmu terlihat sehat! Pemasukan melebihi pengeluaran.";
      positivePoints.add("Surplus arus kas yang positif.");
    } else if (totalExpense > totalIncome) {
      summaryText = "Perhatian! Pengeluaranmu melebihi pemasukan periode ini.";
      improvementPoints.add(
          "Kurangi pengeluaran tidak penting untuk menyeimbangkan neraca.");
    } else {
      summaryText = "Pemasukan dan pengeluaran seimbang.";
    }

    if (totalIncome > 0) {
      positivePoints.add("Memiliki sumber pendapatan aktif.");
    }

    // 2. Savings Potential (Simple heuristic)
    if (totalIncome > totalExpense * 1.2) {
      positivePoints.add("Potensi menabung yang baik (margin > 20%).");
    }

    // 3. Category Analysis
    if (categoryExpenses.isNotEmpty) {
      // Find top expense category
      var sortedEntries = categoryExpenses.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));

      if (sortedEntries.isNotEmpty) {
        final topCategory = sortedEntries.first;
        improvementPoints.add(
            "Pengeluaran terbesar di '${topCategory.key}' (${NumberFormat.compactCurrency(locale: 'id_ID', symbol: 'Rp').format(topCategory.value)}). Coba evaluasi.");
      }

      // Check for specific categories if they exist
      if (categoryExpenses.containsKey('makan') &&
          categoryExpenses['makan']! > totalExpense * 0.4) {
        improvementPoints
            .add("Biaya makan > 40% total pengeluaran. Bisa lebih hemat?");
      }
    } else {
      positivePoints.add("Belum ada pengeluaran signifikan tercatat.");
    }

    // Fallbacks if empty
    if (positivePoints.isEmpty)
      positivePoints.add("Terus catat transaksi untuk analisis lebih baik.");
    if (improvementPoints.isEmpty)
      improvementPoints.add("Pertahankan kebiasaan baikmu!");

    setState(() {
      _isAnalyzing = false;
    });

    _showAIAnalysisPopup(summaryText, positivePoints, improvementPoints);
  }

  void _showAIAnalysisPopup(
      String summary, List<String> positives, List<String> improvements) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          backgroundColor: const Color(0xFF2F2F2F),
          child: Container(
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF2F2F2F), Color(0xFF1C1C1E)],
              ),
              border: Border.all(color: const Color(0xFF37C8C3), width: 1),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.auto_awesome,
                            color: Color(0xFF37C8C3)),
                        const SizedBox(width: 8),
                        Text(
                          'Analisis AI',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.grey),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  summary,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 24),
                if (positives.isNotEmpty)
                  _buildAnalysisSection(
                    'Hal Positif',
                    Icons.check_circle,
                    Colors.greenAccent,
                    positives,
                  ),
                const SizedBox(height: 16),
                if (improvements.isNotEmpty)
                  _buildAnalysisSection(
                    'Area Peningkatan',
                    Icons.lightbulb,
                    Colors.yellowAccent,
                    improvements,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnalysisSection(
      String title, IconData icon, Color color, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: GoogleFonts.poppins(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...items.map((item) => Padding(
              padding: const EdgeInsets.only(left: 28.0, bottom: 4),
              child: Text(
                '• $item',
                style:
                    GoogleFonts.poppins(color: Colors.grey[300], fontSize: 13),
              ),
            )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF37C8C3);

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
        title: Text(
          'Laporan Keuangan',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirestoreService().getTransactionsStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final transactions = snapshot.data?.docs ?? [];
          final processedData = _processData(transactions);
          final totalIncome = processedData['totalIncome'] as double;
          final totalExpense = processedData['totalExpense'] as double;
          final categoryExpenses =
              processedData['categoryExpenses'] as Map<String, double>;
          final barGroups =
              processedData['barGroups'] as List<BarChartGroupData>;
          final maxY = processedData['maxY'] as double;

          return RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(const Duration(seconds: 1));
              setState(() {});
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildPeriodSelector(),
                    const SizedBox(height: 24),
                    _buildSummaryCards(totalIncome, totalExpense),
                    const SizedBox(height: 24),
                    _buildAIButton(primaryColor, totalIncome, totalExpense,
                        categoryExpenses),
                    const SizedBox(height: 24),
                    _buildChartSection(barGroups, maxY),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Map<String, dynamic> _processData(List<QueryDocumentSnapshot> docs) {
    double totalIncome = 0;
    double totalExpense = 0;
    List<BarChartGroupData> barGroups = [];
    double maxY = 0;
    Map<String, double> categoryExpenses = {};

    final now = DateTime.now();
    Map<int, Map<String, double>> groupedData = {};

    // Initialize skeleton based on period
    if (_selectedPeriod == 0) {
      // Daily (This Week: Mon-Sun)
      // 1 = Mon, 7 = Sun
      for (int i = 1; i <= 7; i++) {
        groupedData[i] = {'income': 0, 'expense': 0};
      }
    } else if (_selectedPeriod == 1) {
      // Monthly (Weeks 1-4/5)
      for (int i = 1; i <= 5; i++) {
        groupedData[i] = {'income': 0, 'expense': 0};
      }
    } else {
      // Yearly (Jan-Dec)
      for (int i = 1; i <= 12; i++) {
        groupedData[i] = {'income': 0, 'expense': 0};
      }
    }

    for (var doc in docs) {
      final data = doc.data() as Map<String, dynamic>;
      final amount = (data['amount'] as num).toDouble();
      final type = data['type'] as String;
      final category = data['category'] as String?;
      final date = (data['date'] as Timestamp).toDate();

      // Filter logic
      bool include = false;
      int groupKey = -1;

      if (_selectedPeriod == 0) {
        // Daily: Filter for this week
        final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        final startOfNextWeek = startOfWeek.add(const Duration(days: 7));
        final startOfWeekMidnight =
            DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);
        final startOfNextWeekMidnight = DateTime(
            startOfNextWeek.year, startOfNextWeek.month, startOfNextWeek.day);

        if (date.isAfter(
                startOfWeekMidnight.subtract(const Duration(seconds: 1))) &&
            date.isBefore(startOfNextWeekMidnight)) {
          include = true;
          groupKey = date.weekday; // 1=Mon, 7=Sun
        }
      } else if (_selectedPeriod == 1) {
        // Monthly: Filter for this month
        if (date.year == now.year && date.month == now.month) {
          include = true;
          // Calculate week of month roughly
          groupKey = ((date.day - 1) / 7).floor() + 1;
          if (groupKey > 5) groupKey = 5;
        }
      } else {
        // Yearly: Filter for this year
        if (date.year == now.year) {
          include = true;
          groupKey = date.month;
        }
      }

      if (include && groupKey != -1) {
        // Exclude "transfer" from Income/Expense report as it's just moving funds
        if (category == 'transfer') {
          continue;
        }

        // "debt_payment" counts as expense for cash flow visualization
        bool isExpense = type == 'expense';
        if (category == 'debt_payment') {
          isExpense = true;
        }

        if (type == 'income' && !isExpense) {
          groupedData[groupKey]!['income'] =
              groupedData[groupKey]!['income']! + amount;
          totalIncome += amount;
        } else {
          // Treat as expense
          groupedData[groupKey]!['expense'] =
              groupedData[groupKey]!['expense']! + amount;
          totalExpense += amount;

          // Track category expenses
          if (category != null && category.isNotEmpty) {
            categoryExpenses[category] =
                (categoryExpenses[category] ?? 0) + amount;
          } else {
            categoryExpenses['Lainnya'] =
                (categoryExpenses['Lainnya'] ?? 0) + amount;
          }
        }
      }
    }

    // Convert to BarChartGroupData
    groupedData.forEach((key, value) {
      final income = value['income']!;
      final expense = value['expense']!;
      if (income > maxY) maxY = income;
      if (expense > maxY) maxY = expense;

      barGroups.add(_makeGroupData(key - 1, income, expense)); // x is 0-indexed
    });

    // Add some buffer to maxY
    if (maxY == 0) {
      maxY = 100;
    } else {
      maxY = maxY * 1.2;
    }

    return {
      'totalIncome': totalIncome,
      'totalExpense': totalExpense,
      'categoryExpenses': categoryExpenses,
      'barGroups': barGroups,
      'maxY': maxY,
    };
  }

  Widget _buildPeriodSelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Row(
        children: [
          _periodButton('Harian', 0),
          _periodButton('Bulanan', 1),
          _periodButton('Tahunan', 2),
        ],
      ),
    );
  }

  Widget _periodButton(String text, int index) {
    final isSelected = _selectedPeriod == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedPeriod = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF37C8C3) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: const Color(0xFF37C8C3).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    )
                  ]
                : [],
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.black : Colors.grey,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCards(double income, double expense) {
    final currencyFormatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Row(
      children: [
        Expanded(
          child: _buildSummaryItem(
            'Pemasukan',
            currencyFormatter.format(income),
            Colors.greenAccent,
            Icons.arrow_downward_rounded,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildSummaryItem(
            'Pengeluaran',
            currencyFormatter.format(expense),
            Colors.redAccent,
            Icons.arrow_upward_rounded,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryItem(
      String title, String amount, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 16),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.poppins(
                  color: Colors.grey[400],
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              amount,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAIButton(Color primaryColor, double income, double expense,
      Map<String, double> categories) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _isAnalyzing
            ? null
            : () => _handleAnalyze(income, expense, categories),
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: _isAnalyzing
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.black,
                  strokeWidth: 2,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.auto_awesome, color: Colors.black),
                  const SizedBox(width: 10),
                  Text(
                    'ANALISIS DENGAN AI',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildChartSection(List<BarChartGroupData> barGroups, double maxY) {
    String title = 'Minggu Ini';
    if (_selectedPeriod == 1) title = 'Bulan Ini';
    if (_selectedPeriod == 2) title = 'Tahun Ini';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey[800]!),
      ),
      height: 350,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Statistik',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  title,
                  style: GoogleFonts.poppins(
                    color: Colors.grey[400],
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Expanded(
            child: _buildBarChart(barGroups, maxY),
          ),
        ],
      ),
    );
  }

  Widget _buildBarChart(List<BarChartGroupData> barGroups, double maxY) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceBetween,
        maxY: maxY,
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (group) => const Color(0xFF2F2F2F),
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final currencyFormatter = NumberFormat.compactCurrency(
                  locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);
              return BarTooltipItem(
                currencyFormatter.format(rod.toY),
                GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (_selectedPeriod == 0) {
                  // Daily
                  const titles = ['S', 'S', 'R', 'K', 'J', 'S', 'M'];
                  if (value.toInt() < titles.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        titles[value.toInt()],
                        style: GoogleFonts.poppins(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    );
                  }
                } else if (_selectedPeriod == 1) {
                  // Monthly
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      'M${value.toInt() + 1}',
                      style: GoogleFonts.poppins(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  );
                } else {
                  // Yearly
                  const titles = [
                    'J',
                    'F',
                    'M',
                    'A',
                    'M',
                    'J',
                    'J',
                    'A',
                    'S',
                    'O',
                    'N',
                    'D'
                  ];
                  if (value.toInt() < titles.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        titles[value.toInt()],
                        style: GoogleFonts.poppins(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    );
                  }
                }

                return const SizedBox();
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 35,
              getTitlesWidget: (value, meta) {
                // Show fewer labels to avoid clutter
                if (value == 0) return const SizedBox();

                // Show about 4-5 labels
                double interval = maxY / 4;
                if (value % interval < interval * 0.1) {
                  // Approximate check
                  final currencyFormatter = NumberFormat.compactCurrency(
                      locale: 'id_ID', symbol: '', decimalDigits: 0);
                  return Text(
                    currencyFormatter.format(value),
                    style: GoogleFonts.poppins(
                      color: Colors.grey[600],
                      fontSize: 10,
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: maxY / 5,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey[800],
              strokeWidth: 1,
              dashArray: [5, 5],
            );
          },
        ),
        borderData: FlBorderData(show: false),
        barGroups: barGroups,
        groupsSpace: 12,
      ),
    );
  }

  BarChartGroupData _makeGroupData(int x, double incomeY, double expenseY) {
    const double width = 8;
    const incomeColor = Color(0xFF37C8C3);
    const expenseColor = Color(0xFFFF5252);

    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: incomeY,
          color: incomeColor,
          width: width,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
        ),
        BarChartRodData(
          toY: expenseY,
          color: expenseColor,
          width: width,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
        ),
      ],
    );
  }
}
