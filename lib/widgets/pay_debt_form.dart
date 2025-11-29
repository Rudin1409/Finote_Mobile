import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:myapp/core/services/firestore_service.dart';
import 'package:myapp/core/theme/app_theme.dart';
import 'package:intl/intl.dart';
import 'package:myapp/core/constants/app_constants.dart';

class PayDebtForm extends StatefulWidget {
  final String paymentUrl;
  final String debtId;

  const PayDebtForm({
    super.key,
    required this.paymentUrl,
    required this.debtId,
  });

  @override
  PayDebtFormState createState() => PayDebtFormState();
}

class PayDebtFormState extends State<PayDebtForm> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  String? _selectedSource;
  bool _isLoading = false;

  @override
  void dispose() {
    _amountController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _launchURL() async {
    final Uri uri = Uri.parse(widget.paymentUrl);
    if (!await launchUrl(uri)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch ${widget.paymentUrl}')),
      );
    }
  }

  Future<void> _payDebt() async {
    if (_amountController.text.isEmpty ||
        _dateController.text.isEmpty ||
        _selectedSource == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon lengkapi semua data')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final amount = double.parse(
          _amountController.text.replaceAll(RegExp(r'[^0-9]'), ''));
      final date = DateFormat('d/M/yyyy').parse(_dateController.text);

      await FirestoreService().addDebtEntry(
        debtId: widget.debtId,
        amount: amount,
        date: date,
        source: _selectedSource!,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pembayaran berhasil dicatat'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal mencatat pembayaran: $e'),
            backgroundColor: FinoteColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
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
            _buildTextField(
              label: 'Jumlah Pembayaran (IDR)',
              hint: 'Ex : 50000',
              controller: _amountController,
              isNumber: true,
            ),
            const SizedBox(height: 16),
            _buildDropdownField(
              label: 'Sumber Dana',
              hint: 'Pilih Sumber Dana',
              value: _selectedSource,
              items: AppConstants.sourcesOfFunds
                  .map((s) => DropdownMenuItem(
                        value: s.value,
                        child: Row(
                          children: [
                            Icon(s.icon, size: 18, color: Colors.white70),
                            const SizedBox(width: 8),
                            Text(s.label),
                          ],
                        ),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedSource = value;
                });
              },
            ),
            const SizedBox(height: 16),
            _buildDateField(
              context,
              label: 'Tanggal Pembayaran',
              hint: 'Pilih Tanggal',
              controller: _dateController,
            ),
            const SizedBox(height: 32),
            _buildButton(text: 'LINK PEMBAYARAN', onPressed: _launchURL),
            const SizedBox(height: 16),
            _buildButton(
              text: _isLoading ? 'MENYIMPAN...' : 'CATAT PEMBAYARAN',
              isPrimary: false,
              onPressed: _isLoading ? () {} : _payDebt,
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    bool isNumber = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 14)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
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

  Widget _buildDropdownField({
    required String label,
    required String hint,
    required List<DropdownMenuItem<String>> items,
    String? value,
    required void Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 14)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          decoration: BoxDecoration(
            color: const Color(0xFF1C1C1C),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF37C8C3)),
          ),
          child: DropdownButtonFormField<String>(
            value: value,
            hint:
                Text(hint, style: GoogleFonts.poppins(color: Colors.grey[600])),
            items: items,
            onChanged: onChanged,
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

  Widget _buildDateField(
    BuildContext context, {
    required String label,
    required String hint,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 14)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          readOnly: true,
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
            );
            if (pickedDate != null) {
              String formattedDate = DateFormat('d/M/yyyy').format(pickedDate);
              controller.text = formattedDate;
            }
          },
          style: GoogleFonts.poppins(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.poppins(color: Colors.grey[600]),
            filled: true,
            fillColor: const Color(0xFF1C1C1C),
            suffixIcon:
                const Icon(Icons.calendar_today, color: Color(0xFF37C8C3)),
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

  Widget _buildButton(
      {required String text,
      required VoidCallback onPressed,
      bool isPrimary = true}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor:
            isPrimary ? const Color(0xFF37C8C3) : Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: isPrimary
              ? BorderSide.none
              : const BorderSide(color: Color(0xFF37C8C3)),
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
