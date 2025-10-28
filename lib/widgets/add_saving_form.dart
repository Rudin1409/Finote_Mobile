import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class AddSavingForm extends StatefulWidget {
  const AddSavingForm({super.key});

  @override
  State<AddSavingForm> createState() => _AddSavingFormState();
}

class _AddSavingFormState extends State<AddSavingForm> {
  bool isTargetSelected = true; // Default to TARGET
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF37C8C3);

    return Container(
      padding: const EdgeInsets.all(25.0),
      decoration: const BoxDecoration(
        color: Color(0xFF2F2F2F),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  'Tambah Tabungan Baru',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white, size: 28),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Buat tabungan baru untuk Anda capai.',
              style: GoogleFonts.poppins(color: Colors.grey[400], fontSize: 14),
            ),
            const SizedBox(height: 30),
            _buildSavingTypeSelector(primaryColor),
            const SizedBox(height: 25),
            _buildTextField(label: 'Nama Tabungan', hint: isTargetSelected ? 'Ex: Motor' : 'Ex: Dana Darurat'),
            const SizedBox(height: 15),
            if (isTargetSelected)
              Column(
                children: [
                  _buildTextField(label: 'Jumlah Target (IDR)', hint: 'Ex: 50000', keyboardType: TextInputType.number),
                  const SizedBox(height: 15),
                  _buildDateField(),
                ],
              ),
            const SizedBox(height: 35),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement create saving logic
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              ),
              child: Text(
                'BUAT TABUNGAN',
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSavingTypeSelector(Color primaryColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Pilih Jenis Tabungan', style: GoogleFonts.poppins(color: Colors.white, fontSize: 16)),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _buildTypeButton('TARGET', isTargetSelected, primaryColor, () {
                setState(() => isTargetSelected = true);
              }),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: _buildTypeButton('BIASA', !isTargetSelected, primaryColor, () {
                setState(() => isTargetSelected = false);
              }),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTypeButton(String text, bool isSelected, Color color, VoidCallback onPressed) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: isSelected ? color : Colors.transparent,
        side: BorderSide(color: isSelected ? color : Colors.grey[600]!, width: 1.5),
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          color: isSelected ? Colors.white : Colors.grey[400],
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTextField({required String label, required String hint, TextInputType keyboardType = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.poppins(color: Colors.white, fontSize: 16)),
        const SizedBox(height: 8),
        TextField(
          keyboardType: keyboardType,
          style: GoogleFonts.poppins(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.poppins(color: Colors.grey[600]),
            filled: true,
            fillColor: const Color(0xFF1C1C1C),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: Color(0xFF37C8C3), width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: Colors.white, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Tanggal Target', style: GoogleFonts.poppins(color: Colors.white, fontSize: 16)),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2101)
            );
            if (pickedDate != null) {
              setState(() {
                _selectedDate = pickedDate;
              });
            }
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF1C1C1C),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: const Color(0xFF37C8C3), width: 1.5),
            ),
            child: Text(
              _selectedDate == null
                  ? 'Pilih Tanggal'
                  : DateFormat('dd MMMM yyyy').format(_selectedDate!),
              style: GoogleFonts.poppins(
                  color: _selectedDate == null ? Colors.grey[600] : Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
