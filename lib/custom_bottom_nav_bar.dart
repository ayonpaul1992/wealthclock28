import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;

  const CustomBottomNavBar({super.key, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> items = [
      {'icon': 'assets/images/ftr_hmm.png', 'label': 'Home', 'route': '/home'},
      {
        'icon': 'assets/images/ftr_prtflo.png',
        'label': 'Portfolio',
        'route': '/portfolio'
      },
      {
        'icon': 'assets/images/ftr_invst.png',
        'label': 'Invest',
        'route': '/invest'
      },
      {'icon': 'assets/images/rptt.png', 'label': 'Report', 'route': '/report'},
      {
        'icon': 'assets/images/stng.png',
        'label': 'Settings',
        'route': '/settings'
      },
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(items.length, (index) {
          return InkWell(
            onTap: () {
              if (selectedIndex != index) {
                Navigator.pushReplacementNamed(context, items[index]['route']!);
              }
            },
            child: SizedBox(
              width: 60,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    items[index]['icon']!,
                    fit: BoxFit.contain,
                  ),
                  Text(
                    items[index]['label']!,
                    style: GoogleFonts.poppins(
                      color: selectedIndex == index
                          ? Colors.blue
                          : const Color(0xFF648683),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
