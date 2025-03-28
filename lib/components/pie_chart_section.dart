import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PieChartSection {
  static PieChartSectionData create({
    required double value,
    required Color color,
    required String title,
  }) {
    return PieChartSectionData(
      color: color,
      value: value,
      title: value > 0 ? '$value%' : '',
      titleStyle: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: Colors.transparent,
      ),
      radius: 50,
      borderSide: const BorderSide(
        color: Colors.white, // Adjust the border color
        width: 0, // Adjust the border thickness
      ),
    );
  }
}
