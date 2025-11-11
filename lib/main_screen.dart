
import 'package:flutter/material.dart';
import 'package:myapp/features/home/presentation/screens/home_screen.dart';
import 'package:myapp/features/income/presentation/screens/income_screen.dart';
import 'package:myapp/features/expense/presentation/screens/expense_screen.dart';
import 'package:myapp/features/settings/presentation/screens/settings_screen.dart';
import 'package:myapp/features/savings/presentation/screens/savings_screen.dart';
import 'package:myapp/features/debt/presentation/screens/debt_screen.dart';
import 'package:myapp/features/ai_analysis/presentation/screens/financial_report_screen.dart'; // Import the new report screen
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 2; // Default to HomeScreen

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      // 0: Pemasukan
      IncomeScreen(onNavigate: _onItemTapped),
      // 1: Pengeluaran
      ExpenseScreen(onNavigate: _onItemTapped),
      // 2: Home
      HomeScreen(
        onNavigate: _onItemTapped,
        onNavigateToAi: _navigateToAi, 
        onNavigateToSettings: _navigateToSettings, 
      ),
      // 3: Hutang
      const DebtScreen(),
      // 4: Tabungan
      SavingsScreen(onNavigate: _onItemTapped),
      // Note: Settings and AI screens are not in the main stack anymore
      // They are pushed on top via Navigator.
    ];
  }

  void _onItemTapped(int index) {
    if (index >= 0 && index < _pages.length) {
      setState(() {
        _selectedIndex = index;
      });
    } 
  }

  void _navigateToAi() {
    // Navigate to the new FinancialReportScreen
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const FinancialReportScreen()));
  }

  void _navigateToSettings() {
    // Navigate to the SettingsScreen
     Navigator.of(context).push(MaterialPageRoute(builder: (_) => SettingsScreen(onNavigate: (int index) { 
        // This callback can be used if settings needs to navigate within MainScreen
        _onItemTapped(index);
        // Pop the settings screen to show the main screen at the new index
        Navigator.of(context).pop(); 
     })));
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF37C8C3);

    final navBarItems = <Widget>[
      const Icon(Icons.south_west, size: 30, color: Colors.white),
      const Icon(Icons.north_east, size: 30, color: Colors.white),
      const Icon(Icons.home_filled, size: 30, color: Colors.white),
      const Icon(Icons.receipt_long, size: 30, color: Colors.white), // Hutang Icon
      const Icon(Icons.savings, size: 30, color: Colors.white),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1C),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
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
