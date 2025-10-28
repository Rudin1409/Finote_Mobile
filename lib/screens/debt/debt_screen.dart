
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myapp/screens/debt/debt_detail_screen.dart';

class DebtScreen extends StatefulWidget {
  const DebtScreen({super.key});

  @override
  State<DebtScreen> createState() => _DebtScreenState();
}

class _DebtScreenState extends State<DebtScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1C),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C1C1C),
        title: const Text('Hutang', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () {
              // TODO: Implement add debt functionality
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const FaIcon(
                FontAwesomeIcons.moneyBillWave,
                color: Color(0xFF37C8C3),
                size: 60,
              ),
              const SizedBox(height: 16),
              const Text(
                'Rp 12,902',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'JENIS JENIS HUTANG',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const DebtDetailScreen()),
                  );
                },
                child: _buildDebtItem(
                  icon: FontAwesomeIcons.creditCard,
                  title: 'Paylater',
                  amount: 300,
                  progress: 0.7,
                ),
              ),
              const SizedBox(height: 16),
              _buildDebtItem(
                icon: FontAwesomeIcons.car,
                title: 'Leptop',
                amount: 1200,
                progress: 0.4,
              ),
              const SizedBox(height: 16),
              _buildDebtItem(
                icon: FontAwesomeIcons.desktop,
                title: 'PC',
                amount: 2000,
                progress: 0.9,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDebtItem({
    required IconData icon,
    required String title,
    required double amount,
    required double progress,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2C),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          FaIcon(
            icon,
            color: const Color(0xFF37C8C3),
            size: 30,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey[800],
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFF37C8C3),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '\$${amount.toStringAsFixed(2)} LEFT',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
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
