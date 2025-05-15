import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacyPolicyPage extends StatefulWidget {
  const PrivacyPolicyPage({super.key});

  @override
  State<PrivacyPolicyPage> createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends State<PrivacyPolicyPage> {

  Future<void> _launchURL() async {
    const url = 'https://m.moneycontrol.com/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFfffaf5),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black), // Back arrow
          onPressed: () {
            Navigator.pop(
                context); // You can replace this with any other back navigation
          },
        ),
        centerTitle: true,
        title:  Text(
          'Privacy Policy',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF0f625c),
          ),
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Container(
                child: Column(
                  spacing: 10,
                  children: [
                    Wrap(
                      alignment: WrapAlignment.start,
                      runSpacing: 10,
                      children: [
                        // Text.rich(
                        //   TextSpan(
                        //     text: "Terms and Conditions of Use and its acceptance",
                        //     style: GoogleFonts.poppins(
                        //       fontSize: 17,
                        //       fontWeight: FontWeight.w600,
                        //       color: Color(0xFF09a99d),
                        //       decoration: TextDecoration.underline,
                        //       decorationColor: Color(0xFF09a99d),
                        //       decorationThickness: 1.5,
                        //       decorationStyle: TextDecorationStyle.solid,
                        //     ),
                        //   ),
                        // ),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'Wealthclock Advisors (Wealthclock, Website ',
                                style: GoogleFonts.poppins(
                                  color: Color(0xFF0f625c),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              TextSpan(
                                text: 'www.wealthclockadvisors.com',
                                style: GoogleFonts.poppins(
                                  color: Colors.blue,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.blue, // <-- Underline color
                                  decorationThickness: 1.2,     // Optional: makes the line slightly thicker
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () async {
                                    final url = Uri.parse('https://www.wealthclockadvisors.com');
                                    if (await canLaunchUrl(url)) {
                                      await launchUrl(url);
                                    }
                                  },
                              ),
                              TextSpan(
                                text:
                                ') intends to help you in discovering and analyzing the world of financial products towards meeting your financial goals. In this endeavor, we do our best to provide you with accurate, timely and insightful information. At the same time we are totally committed to your right of privacy and protect your personal information with us.',
                                style: GoogleFonts.poppins(
                                  color: Color(0xFF0f625c),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            text:
                            'Our Privacy statement details out the various information that we collect from you and how we protect and use it. We encourage you to go through our privacy statement.',
                            style: GoogleFonts.poppins(
                              color: Color(0xFF0f625c),
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            text: "What personal information is collected and why?",
                            style: GoogleFonts.poppins(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF09a99d),
                              decoration: TextDecoration.underline,
                              decorationColor: Color(0xFF09a99d),
                              decorationThickness: 1.5,
                              decorationStyle: TextDecorationStyle.solid,
                            ),
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            text:
                            'It is our belief that no two individuals have the same Personal context, Risk appetite and Financial goals. Wealthclock collects personal information from you to understand your financial goals, provide customized insight & features that can benefit you directly and to service your financial needs better.',
                            style: GoogleFonts.poppins(
                              color: Color(0xFF0f625c),
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            text:
                            'We collect your personally identifiable data only when you specifically and knowingly provide it. We can collect personal information like your Name, Email address, Phone numbers, Physical address, Birth Date, PAN Details, Aadhar Number, Marital Status, Spouse working status, Dependents status, Income, Gender, Bank Details etc on our website for the registration process and enabling you to get personalized/customized insights on various financial products and your financial goals.',
                            style: GoogleFonts.poppins(
                              color: Color(0xFF0f625c),
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text:
                                'We would also use the Email/Physical Address and Contact details to provide you insights and information on financial products and goals relevant to you. Additionally, the relevant details would be used to ensure that the Know Your Customer (KYC) norms specified by regulatory bodies are met for customers who wish to buy financial products like Mutual Funds, ETFs, Corporate Bonds and Deposits, Tax free Bonds and other financial products through ',
                                style: GoogleFonts.poppins(
                                  color: Color(0xFF0f625c),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              TextSpan(
                                text: 'www.wealthclockadvisors.com',
                                style: GoogleFonts.poppins(
                                  color: Colors.blue,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.blue, // Underline color
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () async {
                                    final url = Uri.parse('https://www.wealthclockadvisors.com');
                                    if (await canLaunchUrl(url)) {
                                      await launchUrl(url);
                                    }
                                  },
                              ),
                              TextSpan(
                                text: ' platform.',
                                style: GoogleFonts.poppins(
                                  color: Color(0xFF0f625c),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            text:
                            'Wealthclock would use google analytics which uses first-party cookies to collect user interactions with our web based services. Cookies are pieces of information stored on computer/mobile device. The cookies store non-personally identifiable information which helps us in understanding what sort of information and content interests you the most. Please note that if there are any advertisements on our site for other companies, they may use their own cookies when you access their sites. We do not have control or access to that information being collected. Please note that none of the information would be shared with google analytics.',
                            style: GoogleFonts.poppins(
                              color: Color(0xFF0f625c),
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            text:
                            'We also may use the unique identifier of your mobile or computer device to track any suspicious activity.',
                            style: GoogleFonts.poppins(
                              color: Color(0xFF0f625c),
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            text: "Your Information with us is secure",
                            style: GoogleFonts.poppins(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF09a99d),
                              decoration: TextDecoration.underline,
                              decorationColor: Color(0xFF09a99d),
                              decorationThickness: 1.5,
                              decorationStyle: TextDecorationStyle.solid,
                            ),
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            text:
                            'We take utmost care and precaution to ensure that your personal data is secure with us. Your password is not to be shared with anyone and must be kept safe by you at all times. We also ensure that that your password is kept in encrypted and in a secure environment with us.',
                            style: GoogleFonts.poppins(
                              color: Color(0xFF0f625c),
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            text:
                            'Your personal information belongs to you and you can change the information stored with us or ask for the same from us. You can visit the personal information section on our site to do the same.',
                            style: GoogleFonts.poppins(
                              color: Color(0xFF0f625c),
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            text: "Changes to Privacy policy",
                            style: GoogleFonts.poppins(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF09a99d),
                              decoration: TextDecoration.underline,
                              decorationColor: Color(0xFF09a99d),
                              decorationThickness: 1.5,
                              decorationStyle: TextDecorationStyle.solid,
                            ),
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            text:
                            'If there are any changes to the privacy policy then the same would be updated on this page on our website. We encourage you to check our privacy policy from time to time. Incase there are any major changes to our Privacy Policy then the same would be updated to you through email explicitly by us.',
                            style: GoogleFonts.poppins(
                              color: Color(0xFF0f625c),
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'Incase you have any concerns or grievances then please email us at ',
                                style: GoogleFonts.poppins(
                                  color: Color(0xFF0f625c),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              TextSpan(
                                text: 'contact@wealthclockadvisors.com',
                                style: GoogleFonts.poppins(
                                  color: Colors.blue,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.blue,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () async {
                                    final Uri emailUri = Uri(
                                      scheme: 'mailto',
                                      path: 'contact@wealthclockadvisors.com',
                                    );
                                    if (await canLaunchUrl(emailUri)) {
                                      await launchUrl(emailUri);
                                    }
                                  },
                              ),
                              TextSpan(
                                text: '.',
                                style: GoogleFonts.poppins(
                                  color: Color(0xFF0f625c),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20,)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
