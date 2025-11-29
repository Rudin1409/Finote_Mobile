import 'package:flutter/material.dart';
import 'package:myapp/features/home/presentation/screens/home_screen.dart';
import 'package:myapp/features/settings/presentation/screens/settings_screen.dart';
import 'package:myapp/features/savings/presentation/screens/savings_screen.dart';
import 'package:myapp/features/debt/presentation/screens/debt_screen.dart';
import 'package:myapp/features/ai_analysis/presentation/screens/financial_report_screen.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key}); // Updated navigation structure

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 2; // Default to HomeScreen

  void _onItemTapped(int index) {
    if (index >= 0 && index < 5) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF37C8C3);

    final List<Widget> pages = [
      // 0: Hutang
      DebtScreen(onNavigate: _onItemTapped),
      // 1: Tabungan
      SavingsScreen(onNavigate: _onItemTapped),
      // 2: Home
      HomeScreen(
        onNavigate: _onItemTapped,
      ),
      // 3: Analisis AI
      const FinancialReportScreen(),
      // 4: Pengaturan
      SettingsScreen(onNavigate: _onItemTapped),
    ];

    final navBarItems = <Widget>[
      const Icon(Icons.receipt_long, size: 30, color: Colors.white), // Hutang
      const Icon(Icons.savings, size: 30, color: Colors.white), // Tabungan
      const Icon(Icons.home_filled, size: 30, color: Colors.white), // Home
      const Icon(Icons.auto_awesome, size: 30, color: Colors.white), // AI
      const Icon(Icons.settings, size: 30, color: Colors.white), // Settings
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1C),
      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedIndex,
        height: 60.0,
        items: navBarItems,
        color: primaryColor,
        buttonBackgroundColor: primaryColor,
        backgroundColor: Colors.transparent,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 400),
        onTap: _onItemTapped,
        letIndexChange: (index) => true,
      ),
    );
  }
}
