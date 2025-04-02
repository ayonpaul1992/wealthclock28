import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InvestmentOpportunities extends StatelessWidget {
  final List<Map<String, dynamic>> investmentOptions = [
    {
      'icon': 'assets/images/nw_fnd.png',
      'label': 'New Fund Offer',
      'bgColor': Color(0xFFb2daf4),
    },
    {
      'icon': 'assets/images/thm_invst.png',
      'label': 'Themed Investment',
      'bgColor': Color(0xFFefecdb),
    },
    {
      'icon': 'assets/images/int_mtfnd.png',
      'label': 'International Mutual Funds',
      'bgColor': Color(0xFFa5d9d5),
    },
    {
      'icon': 'assets/images/brs_amc.png',
      'label': 'Browse By AMCs',
      'bgColor': Color(0xFFaadad5),
    },
    {
      'icon': 'assets/images/inv_tx.png',
      'label': 'Invest To Save Tax',
      'bgColor': Color(0xFFabd9f4),
    },
    {
      'icon': 'assets/images/ctg_tprs.png',
      'label': 'Category Toppers',
      'bgColor': Color(0xFFedebdb),
    },
  ];

  InvestmentOpportunities({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 30, bottom: 20),
          child: Text(
            'Explore Investment Opportunities'.toUpperCase(),
            style: GoogleFonts.poppins(
              color: Color(0xFF0f625c),
              fontWeight: FontWeight.w600,
              fontSize: 17,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 34),
          child: Wrap(
            spacing: 12,
            runSpacing: 28,
            children: List.generate(investmentOptions.length, (index) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildInvestmentItem(
                    investmentOptions[index]['icon'],
                    investmentOptions[index]['label'],
                    investmentOptions[index]['bgColor'],
                  ),
                  if (index < investmentOptions.length - 1)
                    Container(
                      width: 1,
                      height: 100,
                      color: Color(0xFFc7d1d0),
                    ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildInvestmentItem(String icon, String label, Color bgColor) {
    return InkWell(
      onTap: () {
        // Define action here
      },
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        width: 100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: Center(
                child: Image.asset(icon),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: GoogleFonts.poppins(
                color: Color(0xFF0f625c),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
