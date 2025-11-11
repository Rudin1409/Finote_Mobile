
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class PayDebtForm extends StatefulWidget {
  final String paymentUrl;

  const PayDebtForm({super.key, required this.paymentUrl});

  @override
  PayDebtFormState createState() => PayDebtFormState();
}

class PayDebtFormState extends State<PayDebtForm> {

   Future<void> _launchURL() async {
    final Uri uri = Uri.parse(widget.paymentUrl);
    if (!await launchUrl(uri)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch ${widget.paymentUrl}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        decoration: const BoxDecoration(
          color: Color(0xFF2C2C2C),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            Text(
              'Bayar Hutang:',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Catat pembayaran untuk melunasi hutang Anda.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(color: Colors.grey[400]),
            ),
            const SizedBox(height: 24),
            _buildTextField(label: 'Jumlah Pembayaran (IDR)', hint: 'Ex : 50000'),
            const SizedBox(height: 16),
            _buildDropdownField(label: 'Sumber Dana', hint: 'Pilih Sumber Dana'),
            const SizedBox(height: 16),
            _buildDateField(label: 'Tanggal Pembayaran', hint: 'Pilih Tanggal'),
            const SizedBox(height: 32),
            _buildButton(text: 'LINK PEMBAYARAN', onPressed: _launchURL),
            const SizedBox(height: 16),
            _buildButton(text: 'CATAT PEMBAYARAN', isPrimary: false, onPressed: () {
              Navigator.of(context).pop();
            }),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({required String label, required String hint}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.poppins(color: Colors.white, fontSize: 14)),
        const SizedBox(height: 8),
        TextField(
          keyboardType: TextInputType.number,
          style: GoogleFonts.poppins(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.poppins(color: Colors.grey[600]),
            filled: true,
            fillColor: const Color(0xFF1C1C1C),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF37C8C3)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF37C8C3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.white, width: 2),
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildDropdownField({required String label, required String hint}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.poppins(color: Colors.white, fontSize: 14)),
        const SizedBox(height: 8),
        Container(
           padding: const EdgeInsets.symmetric(horizontal: 12.0),
           decoration: BoxDecoration(
                color: const Color(0xFF1C1C1C),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF37C8C3)),
            ),
          child: DropdownButtonFormField<String>(
            hint: Text(hint, style: GoogleFonts.poppins(color: Colors.grey[600])),
            items: const [], // Dummy
            onChanged: (value) {},
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
            dropdownColor: const Color(0xFF2C2C2C),
            icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildDateField({required String label, required String hint}) {
     return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.poppins(color: Colors.white, fontSize: 14)),
        const SizedBox(height: 8),
        TextField(
          readOnly: true,
          onTap: () async {
            // Date picker logic
          },
          style: GoogleFonts.poppins(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.poppins(color: Colors.grey[600]),
            filled: true,
            fillColor: const Color(0xFF1C1C1C),
            suffixIcon: const Icon(Icons.calendar_today, color: Color(0xFF37C8C3)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF37C8C3)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF37C8C3)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildButton({required String text, required VoidCallback onPressed, bool isPrimary = true}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary ? const Color(0xFF37C8C3) : Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: isPrimary ? BorderSide.none : const BorderSide(color: Color(0xFF37C8C3)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }
}
