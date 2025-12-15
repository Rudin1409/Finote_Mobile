import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:myapp/core/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditDebtForm extends StatefulWidget {
  final String debtId;
  final Map<String, dynamic> initialData;

  const EditDebtForm({
    super.key,
    required this.debtId,
    required this.initialData,
  });

  @override
  State<EditDebtForm> createState() => _EditDebtFormState();
}

class _EditDebtFormState extends State<EditDebtForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _lenderController;
  late TextEditingController _amountController;
  late TextEditingController _dueDateController;
  late TextEditingController _installmentAmountController;
  late TextEditingController _durationController;
  late TextEditingController _startDateController;
  late bool _isInstallment;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final data = widget.initialData;

    _isInstallment = data['debtType'] == 'installment';
    _nameController = TextEditingController(text: data['name'] ?? '');
    _lenderController = TextEditingController(text: data['creditor'] ?? '');
    _amountController = TextEditingController(
        text: (data['amount'] as num?)?.toStringAsFixed(0) ?? '');
    _installmentAmountController = TextEditingController(
        text: (data['installmentAmount'] as num?)?.toStringAsFixed(0) ?? '');
    _durationController = TextEditingController(
        text: (data['durationInMonths'] as int?)?.toString() ?? '');

    // Parse dates
    final dueDate = data['dueDate'] != null
        ? (data['dueDate'] as Timestamp).toDate()
        : null;
    _dueDateController = TextEditingController(
        text: dueDate != null ? DateFormat('dd/MM/yyyy').format(dueDate) : '');

    final startDate = data['startDate'] != null
        ? (data['startDate'] as Timestamp).toDate()
        : null;
    _startDateController = TextEditingController(
        text: startDate != null
            ? DateFormat('dd/MM/yyyy').format(startDate)
            : '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _lenderController.dispose();
    _amountController.dispose();
    _dueDateController.dispose();
    _installmentAmountController.dispose();
    _durationController.dispose();
    _startDateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
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
                  onSurface: Theme.of(context).textTheme.bodyLarge?.color,
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
    if (picked != null) {
      setState(() {
        controller.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  Future<void> _saveDebt() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        double amount = 0;
        DateTime? dueDate;
        DateTime? startDate;

        if (_isInstallment) {
          double installmentAmount = double.tryParse(
                  _installmentAmountController.text
                      .replaceAll(RegExp(r'[^0-9]'), '')) ??
              0;
          int duration = int.tryParse(_durationController.text) ?? 0;
          amount = installmentAmount * duration;

          if (_startDateController.text.isNotEmpty) {
            startDate =
                DateFormat('dd/MM/yyyy').parse(_startDateController.text);
          }
        } else {
          amount = double.tryParse(
                  _amountController.text.replaceAll(RegExp(r'[^0-9]'), '')) ??
              0;
          if (_dueDateController.text.isNotEmpty) {
            dueDate = DateFormat('dd/MM/yyyy').parse(_dueDateController.text);
          }
        }

        await FirestoreService().updateDebt(widget.debtId, {
          'name': _nameController.text,
          'creditor': _lenderController.text,
          'amount': amount,
          'debtType': _isInstallment ? 'installment' : 'lump_sum',
          'dueDate': dueDate != null ? Timestamp.fromDate(dueDate) : null,
          'installmentAmount': _isInstallment
              ? double.tryParse(_installmentAmountController.text
                      .replaceAll(RegExp(r'[^0-9]'), '')) ??
                  0
              : null,
          'durationInMonths':
              _isInstallment ? int.tryParse(_durationController.text) : null,
          'startDate': startDate != null ? Timestamp.fromDate(startDate) : null,
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Hutang berhasil diperbarui'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pop();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Gagal memperbarui hutang: $e'),
              backgroundColor: Colors.red,
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
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 16,
        left: 16,
        right: 16,
      ),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Edit Hutang',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.titleLarge?.color,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close,
                          color: Theme.of(context).iconTheme.color),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                Text(
                  'Ubah detail hutang Anda.',
                  style: GoogleFonts.poppins(
                      color: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.color
                          ?.withValues(alpha: 0.7)),
                ),
                const SizedBox(height: 20),
                Text(
                  'Tipe Hutang',
                  style: GoogleFonts.poppins(
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                      fontSize: 16),
                ),
                const SizedBox(height: 10),
                ToggleButtons(
                  isSelected: [!_isInstallment, _isInstallment],
                  onPressed: (index) {
                    setState(() {
                      _isInstallment = index == 1;
                    });
                  },
                  borderRadius: BorderRadius.circular(8),
                  selectedColor: Colors.white,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                  fillColor: const Color(0xFF37C8C3),
                  borderColor: const Color(0xFF37C8C3),
                  selectedBorderColor: const Color(0xFF37C8C3),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text('SEKALI BAYAR',
                          style:
                              GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text('CICILAN',
                          style:
                              GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                if (_isInstallment)
                  _buildInstallmentForm(context)
                else
                  _buildOneTimeForm(context),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _isLoading ? null : _saveDebt,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF37C8C3),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
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
                          'SIMPAN PERUBAHAN',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOneTimeForm(BuildContext context) {
    return Column(
      children: [
        _buildTextField(
          context,
          controller: _nameController,
          labelText: 'Nama Hutang',
          hintText: 'Ex: Pinjam Uang',
        ),
        const SizedBox(height: 20),
        _buildTextField(
          context,
          controller: _lenderController,
          labelText: 'Pemberi Hutang',
          hintText: 'Ex: Budi',
        ),
        const SizedBox(height: 20),
        _buildTextField(
          context,
          controller: _amountController,
          labelText: 'Total Hutang',
          hintText: 'Ex: 500000',
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 20),
        _buildDateField(context, 'Tanggal Jatuh Tempo', _dueDateController),
      ],
    );
  }

  Widget _buildInstallmentForm(BuildContext context) {
    return Column(
      children: [
        _buildTextField(
          context,
          controller: _nameController,
          labelText: 'Nama Hutang',
          hintText: 'Ex: Cicilan Motor',
        ),
        const SizedBox(height: 20),
        _buildTextField(
          context,
          controller: _lenderController,
          labelText: 'Pemberi Hutang',
          hintText: 'Ex: Budi',
        ),
        const SizedBox(height: 20),
        _buildTextField(
          context,
          controller: _installmentAmountController,
          labelText: 'Cicilan per Bulan (IDR)',
          hintText: 'Ex: 50000',
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 20),
        _buildTextField(
          context,
          controller: _durationController,
          labelText: 'Durasi Cicilan (Bulan)',
          hintText: 'Ex: 12',
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 20),
        _buildDateField(context, 'Tanggal Mulai Cicilan', _startDateController),
      ],
    );
  }

  Widget _buildTextField(
    BuildContext context, {
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    bool isOptional = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: GoogleFonts.poppins(
              color: Theme.of(context).textTheme.bodyLarge?.color,
              fontSize: 16),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          style: GoogleFonts.poppins(
              color: Theme.of(context).textTheme.bodyLarge?.color),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: GoogleFonts.poppins(
                color: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.color
                    ?.withValues(alpha: 0.5)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF37C8C3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Theme.of(context).primaryColor),
            ),
          ),
          validator: (value) {
            if (!isOptional && (value == null || value.isEmpty)) {
              return 'Kolom ini tidak boleh kosong';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildDateField(BuildContext context, String labelText,
      TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: GoogleFonts.poppins(
              color: Theme.of(context).textTheme.bodyLarge?.color,
              fontSize: 16),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          readOnly: true,
          onTap: () => _selectDate(context, controller),
          style: GoogleFonts.poppins(
              color: Theme.of(context).textTheme.bodyLarge?.color),
          decoration: InputDecoration(
            hintText: 'Pilih Tanggal',
            hintStyle: GoogleFonts.poppins(
                color: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.color
                    ?.withValues(alpha: 0.5)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF37C8C3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Theme.of(context).primaryColor),
            ),
            suffixIcon:
                const Icon(Icons.calendar_today, color: Color(0xFF37C8C3)),
          ),
        ),
      ],
    );
  }
}
