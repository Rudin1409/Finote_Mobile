import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:myapp/core/services/firestore_service.dart';
import 'package:myapp/core/theme/app_theme.dart';

class AddDebtForm extends StatefulWidget {
  const AddDebtForm({super.key});

  @override
  State<AddDebtForm> createState() => _AddDebtFormState();
}

class _AddDebtFormState extends State<AddDebtForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _lenderController = TextEditingController();
  final _amountController = TextEditingController();
  final _dueDateController = TextEditingController();
  final _installmentAmountController = TextEditingController();
  final _durationController = TextEditingController();
  final _startDateController = TextEditingController();
  final _monthlyPaymentDateController = TextEditingController();
  final _paymentLinkController = TextEditingController();
  bool _isInstallment = true; // Default to Cicilan
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _lenderController.dispose();
    _amountController.dispose();
    _dueDateController.dispose();
    _installmentAmountController.dispose();
    _durationController.dispose();
    _startDateController.dispose();
    _monthlyPaymentDateController.dispose();
    _paymentLinkController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
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
        int? paymentDayOfMonth;

        // Parse common fields
        if (_isInstallment) {
          // For installment, amount is calculated or just the total expected
          // Here we might want to calculate total from installment * duration if not explicitly set
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

          if (_monthlyPaymentDateController.text.isNotEmpty) {
            DateTime paymentDate = DateFormat('dd/MM/yyyy')
                .parse(_monthlyPaymentDateController.text);
            paymentDayOfMonth = paymentDate.day;
          }
        } else {
          // Lump sum
          amount = double.tryParse(
                  _amountController.text.replaceAll(RegExp(r'[^0-9]'), '')) ??
              0;
          if (_dueDateController.text.isNotEmpty) {
            dueDate = DateFormat('dd/MM/yyyy').parse(_dueDateController.text);
          }
        }

        await FirestoreService().addDebt(
          name: _nameController.text,
          creditor: _lenderController.text,
          amount: amount,
          debtType: _isInstallment ? 'installment' : 'lump_sum',
          dueDate: dueDate,
          installmentAmount: _isInstallment
              ? double.tryParse(_installmentAmountController.text
                      .replaceAll(RegExp(r'[^0-9]'), '')) ??
                  0
              : null,
          durationInMonths:
              _isInstallment ? int.tryParse(_durationController.text) : null,
          paymentDayOfMonth: paymentDayOfMonth,
          startDate: startDate,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Hutang berhasil disimpan',
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
              content: Text('Gagal menyimpan hutang: $e',
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
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 16,
        left: 16,
        right: 16,
      ),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: const BoxDecoration(
          color: Color(0xFF2F2F2F),
          borderRadius: BorderRadius.only(
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
                      'Tambah Hutang Baru',
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
                  'Buat catatan hutang baru.',
                  style: GoogleFonts.poppins(color: Colors.grey[400]),
                ),
                const SizedBox(height: 20),
                Text(
                  'Tipe Hutang',
                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 16),
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
                  selectedColor: Colors.black,
                  color: Colors.white,
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
                  _buildInstallmentForm()
                else
                  _buildOneTimeForm(),
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
                          'SIMPAN TRANSAKSI',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
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

  Widget _buildOneTimeForm() {
    return Column(
      children: [
        _buildTextField(
          controller: _nameController,
          labelText: 'Nama Hutang',
          hintText: 'Ex: Pinjam Uang',
        ),
        const SizedBox(height: 20),
        _buildTextField(
          controller: _lenderController,
          labelText: 'Pemberi Hutang',
          hintText: 'Ex: Budi',
        ),
        const SizedBox(height: 20),
        _buildTextField(
          controller: _amountController,
          labelText: 'Total Hutang',
          hintText: 'Ex: 500000',
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 20),
        _buildDateField('Tanggal Jatuh Tempo', _dueDateController),
      ],
    );
  }

  Widget _buildInstallmentForm() {
    return Column(
      children: [
        _buildTextField(
          controller: _nameController,
          labelText: 'Nama Hutang',
          hintText: 'Ex: Cicilan Motor',
        ),
        const SizedBox(height: 20),
        _buildTextField(
          controller: _lenderController,
          labelText: 'Pemberi Hutang',
          hintText: 'Ex: Budi',
        ),
        const SizedBox(height: 20),
        _buildTextField(
          controller: _installmentAmountController,
          labelText: 'Cicilan per Bulan (IDR)',
          hintText: 'Ex: 50000',
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 20),
        _buildTextField(
          controller: _durationController,
          labelText: 'Durasi Cicilan (Bulan)',
          hintText: 'Ex: 12',
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 20),
        _buildDateField('Tanggal Mulai Cicilan', _startDateController),
        const SizedBox(height: 20),
        _buildDateField(
            'Tanggal Pembayaran per Bulan', _monthlyPaymentDateController),
        const SizedBox(height: 20),
        _buildTextField(
          controller: _paymentLinkController,
          labelText: 'Link Pembayaran (opsional)',
          hintText: 'link',
          isOptional: true,
        ),
      ],
    );
  }

  Widget _buildTextField({
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
          style: GoogleFonts.poppins(color: Colors.white, fontSize: 16),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          style: GoogleFonts.poppins(color: Colors.white),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: GoogleFonts.poppins(color: Colors.grey),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF37C8C3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.white),
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

  Widget _buildDateField(String labelText, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: GoogleFonts.poppins(color: Colors.white, fontSize: 16),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          readOnly: true,
          onTap: () => _selectDate(context, controller),
          style: GoogleFonts.poppins(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Pilih Tanggal',
            hintStyle: GoogleFonts.poppins(color: Colors.grey),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF37C8C3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.white),
            ),
            suffixIcon:
                const Icon(Icons.calendar_today, color: Color(0xFF37C8C3)),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Tanggal tidak boleh kosong';
            }
            return null;
          },
        ),
      ],
    );
  }
}
