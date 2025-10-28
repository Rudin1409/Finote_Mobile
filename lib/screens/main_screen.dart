
import 'package:flutter/material.dart';
import 'package:myapp/screens/ai_analysis/ai_analysis_screen.dart';
import 'package:myapp/screens/home/home_screen.dart';
import 'package:myapp/screens/income/income_screen.dart';
import 'package:myapp/screens/expense/expense_screen.dart';
import 'package:myapp/screens/settings/settings_screen.dart';
import 'package:myapp/screens/savings/savings_screen.dart';
import 'package:myapp/screens/debt/debt_screen.dart'; // Import the new screen
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
      // 5: AI Analysis (Not in bottom nav)
      AiAnalysisScreen(onNavigate: _onItemTapped),
      // 6: Settings (Not in bottom nav)
      SettingsScreen(onNavigate: _onItemTapped),
    ];
  }

  void _onItemTapped(int index) {
    if (index >= 0 && index < 5) {
      setState(() {
        _selectedIndex = index;
      });
    } else if (index == 2) { // Special case to return to home
       setState(() {
        _selectedIndex = 2;
      });
    }
  }

  void _navigateToAi() {
    setState(() {
      _selectedIndex = 5; // Index for AiAnalysisScreen
    });
  }

  void _navigateToSettings() {
    setState(() {
      _selectedIndex = 6; // Index for SettingsScreen
    });
  }

  @override
  Widget build(BuildContext context) {
    bool showNavBar = _selectedIndex >= 0 && _selectedIndex < 5;

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
      bottomNavigationBar: showNavBar
          ? CurvedNavigationBar(
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
            )
          : null,
    );
  }
}
