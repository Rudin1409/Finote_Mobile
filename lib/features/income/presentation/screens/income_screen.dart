
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/widgets/add_income_form.dart'; // Import the form widget

class IncomeScreen extends StatefulWidget {
  final Function(int) onNavigate;
  const IncomeScreen({super.key, required this.onNavigate});

  @override
  State<IncomeScreen> createState() => _IncomeScreenState();
}

class _IncomeScreenState extends State<IncomeScreen> {

  final List<Map<String, dynamic>> _cardData = [
      {
        'type': 'Tunai',
        'color': Colors.green,
        'balance': '5.750,00',
        'icon': Icons.money,
        'isBalanceVisible': true,
      },
      {
        'type': 'Bank',
        'color': const Color(0xFF45C8B4),
        'balance': '22.380,31',
        'cardNumber': '8752  ••••  ••••  5672',
        'icon': Icons.account_balance,
        'isBalanceVisible': true,
      },
      {
        'type': 'Dompet Digital',
        'color': Colors.purple,
        'balance': '1.234,56',
        'icon': Icons.account_balance_wallet,
        'isBalanceVisible': true,
      },
    ];

  void _showAddIncomeForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddIncomeForm(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1C),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C1C1C),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => widget.onNavigate(2),
        ),
        title: Text(
          'Pemasukan',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white, size: 30),
            onPressed: () => _showAddIncomeForm(context),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 24),
          _buildCardCarousel(),
          const SizedBox(height: 24),
          _buildHistoryList(),
        ],
      ),
    );
  }

  Widget _buildCardCarousel() {
    return SizedBox(
      height: 180, // Adjusted height for the card
      child: PageView.builder(
        controller: PageController(viewportFraction: 0.85),
        itemCount: _cardData.length,
        itemBuilder: (context, index) {
          return _buildBalanceCard(_cardData[index], index);
        },
      ),
    );
  }

  Widget _buildBalanceCard(Map<String, dynamic> data, int index) {
    return Card(
      color: data['color'] as Color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(data['icon'] as IconData, color: const Color(0xCCFFFFFF)),
                const SizedBox(width: 8),
                Text(
                  data['type'] as String,
                  style: GoogleFonts.poppins(
                    color: const Color(0xCCFFFFFF),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            if (data.containsKey('cardNumber')) ...[
              const SizedBox(height: 8),
              Text(
                data['cardNumber'] as String,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 18,
                  letterSpacing: 2,
                ),
              ),
            ],
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (data['isBalanceVisible'] as bool)
                  RichText(
                    text: TextSpan(
                      style: GoogleFonts.poppins(color: Colors.white),
                      children: <TextSpan>[
                        const TextSpan(
                          text: 'Rp ',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
                        ),
                        TextSpan(
                          text: (data['balance'] as String).split(',')[0],
                          style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: ',${(data['balance'] as String).split(',')[1]}',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
                        ),
                      ],
                    ),
                  )
                else
                  Text(
                    'Rp ****',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                Switch(
                  value: data['isBalanceVisible'] as bool,
                  onChanged: (value) {
                    setState(() {
                      _cardData[index]['isBalanceVisible'] = value;
                    });
                  },
                  activeTrackColor: Colors.white38,
                  activeThumbColor: Colors.white,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

   Widget _buildHistoryList() {
    final List<Map<String, dynamic>> history = [
      {'icon': Icons.work, 'title': 'Gaji Bulanan', 'date': '01 MAR, 2024', 'amount': '+ Rp 8.500.000', 'color': Colors.greenAccent},
      {'icon': Icons.card_giftcard, 'title': 'Hadiah Ulang Tahun', 'date': '28 FEB, 2024', 'amount': '+ Rp 500.000', 'color': Colors.greenAccent},
      {'icon': Icons.business_center, 'title': 'Proyek Freelance', 'date': '25 FEB, 2024', 'amount': '+ Rp 2.500.000', 'color': Colors.greenAccent},
      {'icon': Icons.assessment, 'title': 'Dividen Saham', 'date': '20 FEB, 2024', 'amount': '+ Rp 750.000', 'color': Colors.greenAccent},
    ];

    return Expanded(
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
        decoration: const BoxDecoration(
          color: Color(0xFF2F2F2F),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                'RIWAYAT PEMASUKAN',
                style: GoogleFonts.poppins(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: history.length,
                itemBuilder: (context, index) {
                  final item = history[index];
                  return Card(
                    color: const Color(0xFF3B3B3B),
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      leading: CircleAvatar(
                        backgroundColor: const Color(0xFF37C8C3).withAlpha(25),
                        child: Icon(item['icon'] as IconData, color: const Color(0xFF37C8C3), size: 22),
                      ),
                      title: Text(
                        item['title'] as String,
                        style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15),
                      ),
                      subtitle: Text(
                        item['date'] as String,
                        style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12),
                      ),
                      trailing: Text(
                        item['amount'] as String,
                        style: GoogleFonts.poppins(color: item['color'] as Color, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
