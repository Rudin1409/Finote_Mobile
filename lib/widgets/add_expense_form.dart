import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/core/services/firestore_service.dart';
import 'package:myapp/core/theme/app_theme.dart';
import 'package:intl/intl.dart';
import 'package:myapp/core/constants/app_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddExpenseForm extends StatefulWidget {
  final String? transactionId;
  final Map<String, dynamic>? initialData;

  const AddExpenseForm({super.key, this.transactionId, this.initialData});

  @override
  State<AddExpenseForm> createState() => _AddExpenseFormState();
}

class _AddExpenseFormState extends State<AddExpenseForm> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _dateController = TextEditingController();
  String? _selectedCategory;
  String? _selectedSource;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      final data = widget.initialData!;
      _amountController.text = (data['amount'] as num).toInt().toString();
      _descriptionController.text = data['description'] ?? '';
      _selectedCategory = data['category'];
      _selectedSource = data['source'];

      if (data['date'] != null) {
        final date = (data['date'] as Timestamp).toDate();
        _dateController.text = DateFormat('d/M/yyyy').format(date);
      }
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF37C8C3), // header background color
              onPrimary: Colors.white, // header text color
              onSurface: Colors.white, // body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF37C8C3), // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _dateController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  Future<void> _saveExpense() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final amount = double.parse(
            _amountController.text.replaceAll(RegExp(r'[^0-9]'), ''));
        final date = DateFormat('d/M/yyyy').parse(_dateController.text);

        if (widget.transactionId != null) {
          await FirestoreService().updateTransaction(
            transactionId: widget.transactionId!,
            data: {
              'amount': amount,
              'category': _selectedCategory,
              'date': Timestamp.fromDate(date),
              'description': _descriptionController.text,
              'source': _selectedSource,
            },
          );
        } else {
          await FirestoreService().addTransaction(
            type: 'expense',
            amount: amount,
            category: _selectedCategory!,
            date: date,
            description: _descriptionController.text,
            source: _selectedSource!,
          );
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  widget.transactionId != null
                      ? 'Pengeluaran berhasil diperbarui'
                      : 'Pengeluaran berhasil disimpan',
                  style: FinoteTextStyles.bodyMedium),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pop();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Gagal menyimpan: $e',
                  style: FinoteTextStyles.bodyMedium),
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
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.transactionId != null;

    return FractionallySizedBox(
      heightFactor: 0.9,
      child: Container(
        padding: const EdgeInsets.all(24.0),
        decoration: const BoxDecoration(
          color: Color(0xFF2F2F2F),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isEditing ? 'Edit Pengeluaran' : 'Tambah Pengeluaran',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                Text(
                  isEditing
                      ? 'Perbarui data pengeluaran Anda.'
                      : 'Catat semua pengeluaran Anda di sini untuk melacak keuangan.',
                  style:
                      GoogleFonts.poppins(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 24),
                _buildTextField(
                  controller: _amountController,
                  labelText: 'Jumlah (IDR)',
                  hintText: 'Ex: 5000',
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _descriptionController,
                  labelText: 'Deskripsi',
                  hintText: 'Ex: Jajan',
                ),
                const SizedBox(height: 16),
                _buildDropdownField(
                  labelText: 'Kategori Pengeluaran',
                  hintText: 'Pilih Kategori',
                  value: _selectedCategory,
                  items: AppConstants.categories
                      .where((c) => c.type == 'expense' || c.type == 'all')
                      .map((c) => DropdownMenuItem(
                            value: c.value,
                            child: Row(
                              children: [
                                Icon(c.icon, size: 18, color: Colors.white70),
                                const SizedBox(width: 8),
                                Text(c.label),
                              ],
                            ),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                _buildDropdownField(
                  labelText: 'Sumber Dana',
                  hintText: 'Pilih Sumber Dana',
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
                    controller: _dateController,
                    labelText: 'Tanggal',
                    onTap: _selectDate),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _saveExpense,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF37C8C3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            isEditing ? 'SIMPAN PERUBAHAN' : 'SIMPAN TRANSAKSI',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 16),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
  }) {
    const primaryColor = Color(0xFF37C8C3);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          style: GoogleFonts.poppins(color: Colors.white),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: GoogleFonts.poppins(color: Colors.white54),
            filled: true,
            fillColor: Colors.grey[800],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: primaryColor, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: primaryColor, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide:
                  BorderSide(color: primaryColor.withAlpha(204), width: 2.5),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Mohon isi bidang ini';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String labelText,
    required String hintText,
    required String? value,
    required List<DropdownMenuItem<String>> items,
    required ValueChanged<String?> onChanged,
  }) {
    const primaryColor = Color(0xFF37C8C3);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(labelText,
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 14)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: value,
          hint:
              Text(hintText, style: GoogleFonts.poppins(color: Colors.white54)),
          isExpanded: true,
          dropdownColor: Colors.grey[800],
          style: GoogleFonts.poppins(color: Colors.white),
          icon: const Icon(Icons.arrow_drop_down, color: primaryColor),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[800],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: primaryColor, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: primaryColor, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide:
                  BorderSide(color: primaryColor.withAlpha(204), width: 2.5),
            ),
          ),
          items: items,
          onChanged: onChanged,
          validator: (value) {
            if (value == null) {
              return 'Mohon pilih salah satu';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildDateField({
    required TextEditingController controller,
    required String labelText,
    required VoidCallback onTap,
  }) {
    const primaryColor = Color(0xFF37C8C3);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(labelText,
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 14)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          readOnly: true,
          onTap: onTap,
          style: GoogleFonts.poppins(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Pilih Tanggal',
            hintStyle: GoogleFonts.poppins(color: Colors.white54),
            filled: true,
            fillColor: Colors.grey[800],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: primaryColor, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: primaryColor, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide:
                  BorderSide(color: primaryColor.withAlpha(204), width: 2.5),
            ),
            suffixIcon: const Icon(Icons.calendar_today, color: primaryColor),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Mohon pilih tanggal';
            }
            return null;
          },
        ),
      ],
    );
  }
}
