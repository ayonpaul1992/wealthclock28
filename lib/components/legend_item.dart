import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LegendItem extends StatelessWidget {
  final String title;
  final String percentage;
  final Color color;
  final String amount;

  const LegendItem({
    super.key,
    required this.title,
    required this.percentage,
    required this.color,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          color: color,
          width: 3,
          height: 30,
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 60,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  color: const Color(0xFF303131),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '$percentage%',
                style: GoogleFonts.poppins(
                  color: const Color(0xFF8c8c8c),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 3),
        Text(
          amount,
          style: GoogleFonts.poppins(
            color: const Color(0xFF0f625c),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
