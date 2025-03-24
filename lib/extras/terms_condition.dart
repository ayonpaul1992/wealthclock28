import 'package:flutter/material.dart';

class termsCondPage extends StatefulWidget {
  const termsCondPage({super.key});

  @override
  State<termsCondPage> createState() => _termsCondPageState();
}

class _termsCondPageState extends State<termsCondPage> {
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
       child: Text('Hello',style: TextStyle(color: Colors.red,fontSize: 24,fontWeight: FontWeight.w600),),
      ),
    );
  }
}
