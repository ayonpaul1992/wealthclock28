import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:wealthclock28/screens/each_scheme_details.dart';

// Custom widget that displays a list of schemes
class SchemesListView extends StatelessWidget {
  final List<Map<String, dynamic>> schemes; // List of schemes to display
  final String userName; // Username for passing to the details page

  const SchemesListView(
      {super.key, required this.schemes, required this.userName});

  String maskFolioNumber(String folioNumber) {
    if (folioNumber.length > 4) {
      return '' * (folioNumber.length - 4) +
          folioNumber.substring(folioNumber.length - 4);
    }
    return folioNumber; // If it's less than or equal to 4, show as is
  }

  String calculateGainLoss(dynamic currentVal, dynamic investedVal) {
    double current = double.tryParse(currentVal?.toString() ?? '0') ?? 0.0;
    double invested = double.tryParse(investedVal?.toString() ?? '0') ?? 0.0;
    double difference = current - invested; // Calculate gain/loss

    return difference.toStringAsFixed(2); // Format to 2 decimal places
  }

  @override
  Widget build(BuildContext context) {
    // Filter the schemes to only show those with non-zero values
    var validSchemes = schemes
        .where((scheme) =>
            (scheme['current_val'] ?? 0) != 0 ||
            (scheme['invested_val'] ?? 0) != 0)
        .toList();

    return ListView.builder(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      itemCount: validSchemes.length, // Only count valid schemes
      itemBuilder: (context, index) {
        var scheme = validSchemes[index];

        return Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              backgroundColor: Colors.white,
              padding: EdgeInsets.zero,
            ),
            onPressed: () {
              // Navigate to each scheme details page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => eachSchemeDetails(
                    scheme: scheme,
                    investorName: userName,
                  ),
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.all(15),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          scheme['scheme_name']?.toString() ?? 'N/A',
                          style: GoogleFonts.poppins(
                            color: Color(0xFF0f625c),
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Color(0xFF0d958b),
                        size: 18,
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    NumberFormat.currency(
                      locale: 'en_IN',
                      symbol: '₹ ',
                      decimalDigits: 2,
                    ).format(
                      double.tryParse(scheme['current_val']
                                  ?.toString()
                                  .replaceAll(',', '') ??
                              '0') ??
                          0.00,
                    ),
                    style: GoogleFonts.poppins(
                      color: Color(0xFF0f625c),
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(
                            'Cost Amount',
                            style: GoogleFonts.poppins(
                              color: Color(0xFF8c8c8c),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            NumberFormat.currency(
                              locale: 'en_IN',
                              symbol: '₹ ',
                              decimalDigits: 2,
                            ).format(
                              double.tryParse(scheme['invested_val']
                                          ?.toString()
                                          .replaceAll(',', '') ??
                                      '0') ??
                                  0.00,
                            ),
                            style: GoogleFonts.poppins(
                              color: Color(0xFF303131),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            'Folio No.',
                            style: GoogleFonts.poppins(
                              color: Color(0xFF8c8c8c),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            'XX${maskFolioNumber(scheme['folio_number']?.toString() ?? 'N/A')}',
                            style: GoogleFonts.poppins(
                              color: Color(0xFF303131),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            'Gain/Loss',
                            style: GoogleFonts.poppins(
                              color: Color(0xFF8c8c8c),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Row(
                            children: [
                              Builder(
                                builder: (context) {
                                  double gainLoss = double.tryParse(
                                        calculateGainLoss(
                                          scheme['current_val'],
                                          scheme['invested_val'],
                                        ),
                                      ) ??
                                      0.0;

                                  return Row(
                                    children: [
                                      Icon(
                                        gainLoss >= 0
                                            ? Icons.arrow_upward
                                            : Icons.arrow_downward,
                                        color: gainLoss >= 0
                                            ? Color(0xFF09a99d)
                                            : Color(0xFFD32F2F),
                                        size: 15,
                                      ),
                                      Text(
                                        NumberFormat.currency(
                                          locale: 'en_IN',
                                          symbol: '₹ ',
                                          decimalDigits: 2,
                                        ).format(gainLoss),
                                        style: GoogleFonts.poppins(
                                          color: gainLoss >= 0
                                              ? Color(0xFF09a99d)
                                              : Color(0xFFD32F2F),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 18, bottom: 18),
                    width: double.infinity,
                    color: Color(0xFFd7d7d7),
                    height: 1,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Abs. Ret.: ',
                            style: GoogleFonts.poppins(
                              color: Color(0xFF0f625c),
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            '${((double.tryParse(calculateGainLoss(scheme['current_val'], scheme['invested_val'])) ?? 0.0) / (double.tryParse(scheme['current_val']?.toString() ?? '0') ?? 1.0) * 100).toStringAsFixed(2)}%',
                            style: GoogleFonts.poppins(
                              color: Color(0xFF0f625c),
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 15),
                      Row(
                        children: [
                          Text(
                            'XIRR:',
                            style: GoogleFonts.poppins(
                              color: Color(0xFF0f625c),
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            ' ${scheme['xirr']?.toString() ?? '0'}%',
                            style: GoogleFonts.poppins(
                              color: Color(0xFF0f625c),
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
