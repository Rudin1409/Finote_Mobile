import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:myapp/core/services/firestore_service.dart';
import 'package:myapp/core/theme/app_theme.dart';

class AddFundsScreen extends StatefulWidget {
  final String savingGoalName;
  final String savingId;

  const AddFundsScreen({
    super.key,
    required this.savingGoalName,
    required this.savingId,
  });

  @override
  State<AddFundsScreen> createState() => _AddFundsScreenState();
}

class _AddFundsScreenState extends State<AddFundsScreen> {
  String _amount = '0';
  bool _isLoading = false;

  void _onKeyPress(String value) {
    setState(() {
      if (value == 'backspace') {
        if (_amount.length > 1) {
          _amount = _amount.substring(0, _amount.length - 1);
        } else {
          _amount = '0';
        }
      } else {
        if (_amount.length < 12) {
          // Limit input to 12 digits
          if (_amount == '0') {
            _amount = value;
          } else {
            _amount += value;
          }
        }
      }
    });
  }

  Future<void> _addFunds() async {
    final amount = double.parse(_amount);
    if (amount <= 0) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await FirestoreService().addSavingEntry(
        savingId: widget.savingId,
        amount: amount,
        date: DateTime.now(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Dana berhasil ditambahkan'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menambahkan dana: $e'),
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
    final formatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final formattedAmount = formatter.format(double.parse(_amount));

    return Scaffold(
      backgroundColor: const Color(0xFF37C8C3),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Tambah Dana untuk\n${widget.savingGoalName}',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'BERAPA?',
                  style: GoogleFonts.poppins(
                    color: Colors.white.withAlpha(204),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      formattedAmount,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  width: 200,
                  height: 1,
                  color: Colors.white.withAlpha(128),
                ),
              ],
            ),
          ),
          _buildNumpad(),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              onPressed: _isLoading ? null : _addFunds,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF37C8C3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        color: Color(0xFF37C8C3),
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      'TAMBAH DANA',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNumpad() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: const BoxDecoration(
        color: Color(0x33FFFFFF),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNumpadButton('1'),
              _buildNumpadButton('2'),
              _buildNumpadButton('3'),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNumpadButton('4'),
              _buildNumpadButton('5'),
              _buildNumpadButton('6'),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNumpadButton('7'),
              _buildNumpadButton('8'),
              _buildNumpadButton('9'),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(width: 70),
              _buildNumpadButton('0'),
              _buildNumpadButton('backspace'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNumpadButton(String value) {
    return InkWell(
      onTap: () => _onKeyPress(value),
      borderRadius: BorderRadius.circular(40),
      child: Container(
        width: 70,
        height: 70,
        alignment: Alignment.center,
        child: value == 'backspace'
            ? const Icon(Icons.backspace_outlined,
                color: Colors.white, size: 28)
            : Text(
                value,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}
