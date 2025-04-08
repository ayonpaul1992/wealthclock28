import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TermsCondPage extends StatefulWidget {
  const TermsCondPage({super.key});

  @override
  State<TermsCondPage> createState() => _TermsCondPageState();
}

class _TermsCondPageState extends State<TermsCondPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black), // Back arrow
          onPressed: () {
            Navigator.pop(context); // You can replace this with any other back navigation
          },
        ),
      ),
      
      body: Container(
        width: double.infinity,
        height: double.infinity,
        margin: EdgeInsets.only(top: 15,left: 20),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFfffaf5),
              Color(0xFFe7f6f5),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
       child: Text('Coming soon...',style: GoogleFonts.poppins(
         color: const Color(0xFF0f625c),
         fontSize: 19,
         fontWeight: FontWeight.w600,
       ),),
      ),
    );
  }
}
