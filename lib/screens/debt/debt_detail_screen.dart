
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DebtDetailScreen extends StatelessWidget {
  const DebtDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF37C8C3);

    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1C),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C1C1C),
        elevation: 0,
        title: const Text('Paylater', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            CircularPercentIndicator(
              radius: 100.0,
              lineWidth: 15.0,
              percent: 0.75, // Example progress
              center: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Next Payment',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Rp 655.00',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                   Text(
                    'Sisa: Rp 5.500.000',
                    style: TextStyle(color: primaryColor, fontSize: 14),
                  ),
                ],
              ),
              progressColor: primaryColor,
              backgroundColor: const Color(0xFF2C2C2C),
              circularStrokeCap: CircularStrokeCap.round,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                'BAYAR CICILAN',
                style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: Color(0xFF2C2C2C),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'DETAIL',
                      style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'CICILAN: RP 500.000 / BULAN\\nDURASI: 12 BULAN\\nPERKIRAAN SISA: 11X CICILAN',
                      style: TextStyle(color: primaryColor, fontSize: 14, height: 1.5),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'JATUH TEMPO: 05 NOV 2025 16 HARI LAGI',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'RIWAYAT PEMBAYARAN',
                      style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView(
                        children: [
                          _buildPaymentHistoryItem(),
                          _buildPaymentHistoryItem(),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentHistoryItem() {
    return const Padding(
      padding: EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Color(0xFF3b3b3b),
            child: FaIcon(FontAwesomeIcons.landmark, color: Colors.white, size: 20),
          ),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Funds received', style: TextStyle(color: Colors.white, fontSize: 16)),
              SizedBox(height: 4),
              Text('17 FEB, 2018', style: TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
          Spacer(),
          Text('+\$700.00', style: TextStyle(color: Color(0xFF37C8C3), fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
