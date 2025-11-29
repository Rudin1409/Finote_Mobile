import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/core/services/firestore_service.dart';
import 'package:myapp/core/theme/app_theme.dart';
import 'package:intl/intl.dart';
import 'package:myapp/core/constants/app_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddIncomeForm extends StatefulWidget {
  final String? transactionId;
  final Map<String, dynamic>? initialData;

  const AddIncomeForm({super.key, this.transactionId, this.initialData});

  @override
  State<AddIncomeForm> createState() => _AddIncomeFormState();
}

class _AddIncomeFormState extends State<AddIncomeForm> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedCategory;
  String? _selectedSource;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
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

  Future<void> _saveIncome() async {
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
            type: 'income',
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
                      ? 'Pemasukan berhasil diperbarui'
                      : 'Pemasukan berhasil disimpan',
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
    const primaryColor = Color(0xFF37C8C3);
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
                      isEditing ? 'Edit Pemasukan' : 'Tambah Pemasukan',
                      style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                Text(
                  isEditing
                      ? 'Perbarui data pemasukan Anda.'
                      : 'Catat semua sumber pemasukan Anda di sini.',
                  style:
                      GoogleFonts.poppins(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 24),
                _buildTextFormField(
                  label: 'Jumlah (IDR)',
                  hint: 'Ex : 5000',
                  keyboardType: TextInputType.number,
                  controller: _amountController,
                ),
                const SizedBox(height: 16),
                _buildTextFormField(
                  label: 'Deskripsi',
                  hint: 'Ex : Gajian',
                  controller: _descriptionController,
                ),
                const SizedBox(height: 16),
                _buildDropdownField(
                  label: 'Kategori Pemasukan',
                  hint: 'Pilih Kategori',
                  value: _selectedCategory,
                  items: AppConstants.categories
                      .where((c) => c.type == 'income' || c.type == 'all')
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
                _buildDateField(context, 'Tanggal'),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _saveIncome,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
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

  Widget _buildTextFormField({
    required String label,
    required String hint,
    TextInputType? keyboardType,
    required TextEditingController controller,
  }) {
    const primaryColor = Color(0xFF37C8C3);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 14)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          style: GoogleFonts.poppins(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
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
              return '$label tidak boleh kosong';
            }
            return null;
          },
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
    const primaryColor = Color(0xFF37C8C3);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 14)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: value,
          hint: Text(hint, style: GoogleFonts.poppins(color: Colors.white54)),
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
            if (value == null || value.isEmpty) {
              return '$label tidak boleh kosong';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildDateField(BuildContext context, String label) {
    const primaryColor = Color(0xFF37C8C3);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 14)),
        const SizedBox(height: 8),
        TextFormField(
          controller: _dateController,
          readOnly: true,
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
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
            );
            if (pickedDate != null) {
              String formattedDate =
                  "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
              setState(() {
                _dateController.text = formattedDate;
              });
            }
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '$label tidak boleh kosong';
            }
            return null;
          },
        ),
      ],
    );
  }
}
