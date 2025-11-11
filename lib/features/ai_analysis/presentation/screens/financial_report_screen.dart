
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';

class FinancialReportScreen extends StatefulWidget {
  const FinancialReportScreen({super.key});

  @override
  State<FinancialReportScreen> createState() => _FinancialReportScreenState();
}

class _FinancialReportScreenState extends State<FinancialReportScreen> {
  int _selectedPeriod = 0; // 0 for Daily, 1 for Monthly, 2 for Yearly

  void _showAIAnalysisPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          backgroundColor: const Color(0xFF37C8C3),
          child: Container(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Hasil Analisis AI',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Keuanganmu terlihat menjanjikan, teruskan tren positif ini!',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.greenAccent),
                    const SizedBox(width: 8),
                    Text(
                      'Hal Positif',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.only(left: 32.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '• Pendapatan dari Investasi (JP) sangat kuat, pertahankan dan tingkatkan!',
                        style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '• Kamu berhasil memenuhi Kebutuhan Pokok.',
                        style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    const Icon(Icons.lightbulb, color: Colors.yellowAccent),
                    const SizedBox(width: 8),
                    Text(
                      'Area Peningkatan',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.only(left: 32.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '• Pengeluaran untuk \'MAKAN\' cukup besar (Rp 10.000.000). Coba cari alternatif makanan yang lebih hemat atau masak sendiri lebih sering.',
                        style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '• Pertimbangkan untuk membuat anggaran bulanan agar pengeluaran lebih terkontrol dan kamu bisa mengalokasikan lebih banyak dana untuk investasi.',
                        style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF37C8C3);

    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C1C1E),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Laporan Keuangan',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {}, // _navigateToSettings,
            tooltip: 'Settings',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Analisis pemasukan dan pengeluaran Anda.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(color: Colors.grey[400]),
            ),
            const SizedBox(height: 24),
            _buildPeriodSelector(),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _showAIAnalysisPopup,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'ANALISIS DENGAN AI',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
                decoration: BoxDecoration(
                    color: const Color(0xFF2F2F2F),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(128),
                        blurRadius: 10,
                      )
                    ]),
                child: Column(
                  children: [
                    Text(
                      'LAPORAN HARIAN - MINGGU KE-3',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Expanded(
                      child: _buildBarChart(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _periodButton('HARIAN', 0),
        const SizedBox(width: 12),
        _periodButton('BULANAN', 1),
        const SizedBox(width: 12),
        _periodButton('TAHUNAN', 2),
      ],
    );
  }

  Widget _periodButton(String text, int index) {
    final isSelected = _selectedPeriod == index;
    return ElevatedButton(
      onPressed: () => setState(() => _selectedPeriod = index),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? const Color(0xFF37C8C3) : const Color(0xFF2F2F2F),
        foregroundColor: isSelected ? Colors.black : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: isSelected
              ? BorderSide.none
              : const BorderSide(color: Color(0xFF555555)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildBarChart() {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceBetween,
        maxY: 100,
        barTouchData: const BarTouchData(enabled: false),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                if (value == 0 ||
                    value == 25 ||
                    value == 50 ||
                    value == 75 ||
                    value == 100) {
                  return Text(
                    value.toInt().toString(),
                    style: GoogleFonts.poppins(color: Colors.grey, fontSize: 10),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        barGroups: _getBarGroups(),
        groupsSpace: 20,
      ),
    );
  }

  List<BarChartGroupData> _getBarGroups() {
    return [
      _makeGroupData(0, 55, 30),
      _makeGroupData(1, 35, 20),
      _makeGroupData(2, 60, 45),
      _makeGroupData(3, 70, 60),
      _makeGroupData(4, 80, 75),
      _makeGroupData(5, 45, 50),
      _makeGroupData(6, 75, 65),
    ];
  }

  BarChartGroupData _makeGroupData(int x, double incomeY, double expenseY) {
    const double width = 7;
    const incomeColor = Color(0xFF37C8C3);
    const expenseColor = Colors.red;

    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: incomeY,
          color: incomeColor,
          width: width,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(4),
          ),
        ),
        BarChartRodData(
          toY: expenseY,
          color: expenseColor,
          width: width,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(4),
          ),
        ),
      ],
    );
  }
}
