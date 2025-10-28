
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AiAnalysisScreen extends StatelessWidget {
  final Function(int) onNavigate;
  const AiAnalysisScreen({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1C),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C1C1C),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => onNavigate(2), // Navigate back to home
        ),
        title: Text(
          'Analisis AI',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Text(
          'Halaman Analisis AI',
          style: GoogleFonts.poppins(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}
