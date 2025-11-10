import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wealthclock28/screens/ProfileAfterLogin.dart';
import 'package:wealthclock28/screens/RequestService.dart';
import 'package:wealthclock28/screens/dashboard_after_login.dart';
import 'package:wealthclock28/screens/family_portfolio.dart';
import 'package:wealthclock28/screens/individual_portfolio.dart';

class CustomBottomNavBar extends StatefulWidget {
  final int selectedIndex;

  const CustomBottomNavBar({super.key, required this.selectedIndex});

  @override
  // ignore: library_private_types_in_public_api
  _CustomBottomNavBarState createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  String memberName = '';

  @override
  void initState() {
    super.initState();
    _loadMemberName();
  }

  Future<void> _loadMemberName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      memberName = prefs.getString('user_name') ?? 'Guest';
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox(); // Show nothing until SharedPreferences is loaded
        }

        final prefs = snapshot.data as SharedPreferences;
        String fetchedMemberName = prefs.getString('user_name') ?? 'Guest';

        List<Map<String, dynamic>> items = [
          {
            'icon': 'assets/images/ftr_hmm.png',
            'label': 'Home',
            'route': const dashboardAfterLogin(userId: ''),
          },
          {
            'icon': 'assets/images/ftr_prtflo.png',
            'label': 'Portfolio',
            'route': const IndividualPortfolioPage(
              memberPan: '',
              userId: '',
            ),
          },
          {
            'icon': 'assets/images/bttm_user.png',
            'label': 'Profile',
            'route': ProfileAfterLogin(
              userId: '',
              prflId: '',
            ),
          },
          {
            'icon': 'assets/images/rptt.png',
            'label': 'Family',
            'route': FamilyPortfolioPage(memberName: fetchedMemberName),
          },
          {
            'icon': 'assets/images/bttm_email.png',
            'label': 'Contact',
            'route': RequestServicePage(
              rqsrvcId: '',
            ),
          },
        ];

        return SafeArea(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 5,
                  spreadRadius: 0,
                  offset: const Offset(0, -4), // Pushes shadow to the top
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(items.length, (index) {
                return InkWell(
                  onTap: () {
                    if (widget.selectedIndex != index) {
                      if (items[index]['route'] == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "${items[index]['label']} screen is under development!",
                            ),
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => items[index]['route']!,
                          ),
                        );
                      }
                    }
                  },
                  child: SizedBox(
                    width: 60,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(items[index]['icon']!, fit: BoxFit.contain),
                        Text(
                          items[index]['label']!,
                          style: GoogleFonts.poppins(
                            color: widget.selectedIndex == index
                                ? Colors.blue
                                : const Color(0xFF648683),
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        );
      },
    );
  }
}
