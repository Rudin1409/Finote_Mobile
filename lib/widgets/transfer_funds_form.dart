import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:myapp/core/services/firestore_service.dart';
import 'package:myapp/core/theme/app_theme.dart';
import 'package:myapp/core/constants/app_constants.dart';

class TransferFundsForm extends StatefulWidget {
  const TransferFundsForm({super.key});

  @override
  State<TransferFundsForm> createState() => _TransferFundsFormState();
}

class _TransferFundsFormState extends State<TransferFundsForm> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? _fromSource;
  String? _toSource;
  bool _isLoading = false;

  @override
  void dispose() {
    _amountController.dispose();
    _dateController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_amountController.text.isEmpty ||
        _dateController.text.isEmpty ||
        _fromSource == null ||
        _toSource == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon lengkapi semua data')),
      );
      return;
    }

    if (_fromSource == _toSource) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Sumber dana asal dan tujuan tidak boleh sama')),
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

      await FirestoreService().transferFunds(
        amount: amount,
        fromSource: _fromSource!,
        toSource: _toSource!,
        date: date,
        description: _descriptionController.text.isEmpty
            ? 'Transfer Dana'
            : _descriptionController.text,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Transfer berhasil'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal melakukan transfer: $e'),
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
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.only(
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
                icon:
                    Icon(Icons.close, color: Theme.of(context).iconTheme.color),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            Text(
              'Transfer Dana',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: Theme.of(context).textTheme.titleLarge?.color,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Pindahkan dana antar sumber dana Anda.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.color
                    ?.withOpacity(0.7),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),
            _buildTextField(
              context: context,
              label: 'Jumlah (IDR)',
              hint: 'Contoh: 100000',
              controller: _amountController,
              isNumber: true,
            ),
            const SizedBox(height: 16),
            _buildDropdownField(
              context: context,
              label: 'Dari Sumber',
              hint: 'Pilih Sumber',
              value: _fromSource,
              items: AppConstants.sourcesOfFunds,
              onChanged: (value) {
                setState(() {
                  _fromSource = value;
                });
              },
            ),
            const SizedBox(height: 16),
            _buildDropdownField(
              context: context,
              label: 'Ke Sumber',
              hint: 'Pilih Tujuan',
              value: _toSource,
              items: AppConstants.sourcesOfFunds,
              onChanged: (value) {
                setState(() {
                  _toSource = value;
                });
              },
            ),
            const SizedBox(height: 16),
            _buildTextField(
              context: context,
              label: 'Deskripsi (Opsional)',
              hint: 'Contoh: Ambil tunai dari ATM',
              controller: _descriptionController,
            ),
            const SizedBox(height: 16),
            _buildDateField(
              context,
              label: 'Tanggal',
              hint: 'Pilih Tanggal',
              controller: _dateController,
            ),
            const SizedBox(height: 32),
            _buildButton(
              text: _isLoading ? 'MENYIMPAN...' : 'Simpan Transfer',
              onPressed: _isLoading ? () {} : _submit,
              color: const Color(0xFF00E676),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required BuildContext context,
    required String label,
    required String hint,
    required TextEditingController controller,
    bool isNumber = false,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.poppins(
                color: Theme.of(context).textTheme.bodyMedium?.color,
                fontSize: 14)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          style: GoogleFonts.poppins(
              color: Theme.of(context).textTheme.bodyLarge?.color),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.poppins(
                color: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.color
                    ?.withOpacity(0.5)),
            filled: true,
            fillColor: isDark ? const Color(0xFF1C1C1C) : Colors.grey[200],
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
              borderSide:
                  BorderSide(color: Theme.of(context).primaryColor, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required BuildContext context,
    required String label,
    required String hint,
    required List<SourceOfFund> items,
    String? value,
    required void Function(String?) onChanged,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.poppins(
                color: Theme.of(context).textTheme.bodyMedium?.color,
                fontSize: 14)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1C1C1C) : Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF37C8C3)),
          ),
          child: DropdownButtonFormField<String>(
            initialValue: value,
            hint: Text(hint,
                style: GoogleFonts.poppins(
                    color: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.color
                        ?.withOpacity(0.5),
                    fontSize: 12)),
            items: items.map((s) {
              return DropdownMenuItem<String>(
                value: s.value,
                child: Row(
                  children: [
                    Icon(s.icon,
                        size: 16, color: Theme.of(context).iconTheme.color),
                    const SizedBox(width: 8),
                    Text(s.label,
                        style: GoogleFonts.poppins(
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                            fontSize: 12)),
                  ],
                ),
              );
            }).toList(),
            onChanged: onChanged,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            dropdownColor: Theme.of(context).cardColor,
            icon: Icon(Icons.arrow_drop_down,
                color: Theme.of(context).iconTheme.color),
            isExpanded: true,
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.poppins(
                color: Theme.of(context).textTheme.bodyMedium?.color,
                fontSize: 14)),
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
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: Theme.of(context).colorScheme.copyWith(
                          primary: const Color(0xFF37C8C3),
                          onPrimary: Colors.white,
                          onSurface:
                              Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                    textButtonTheme: TextButtonThemeData(
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF37C8C3),
                      ),
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (pickedDate != null) {
              String formattedDate = DateFormat('d/M/yyyy').format(pickedDate);
              controller.text = formattedDate;
            }
          },
          style: GoogleFonts.poppins(
              color: Theme.of(context).textTheme.bodyLarge?.color),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.poppins(
                color: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.color
                    ?.withOpacity(0.5)),
            filled: true,
            fillColor: isDark ? const Color(0xFF1C1C1C) : Colors.grey[200],
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
      bool isPrimary = true,
      Color? color}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor:
            color ?? (isPrimary ? const Color(0xFF37C8C3) : Colors.transparent),
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
          color: Colors.black, // Button text usually explicitly contrasted
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }
}
