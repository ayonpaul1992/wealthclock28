import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'privacy_policy.dart';

class TermsCondPage extends StatefulWidget {
  const TermsCondPage({super.key});

  @override
  State<TermsCondPage> createState() => _TermsCondPageState();
}

class _TermsCondPageState extends State<TermsCondPage> {

  Future<void> _launchURL() async {
    final Uri url = Uri.parse('https://m.moneycontrol.com/');
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
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
          'Terms and Conditions',
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
                        Text.rich(
                          TextSpan(
                            text: "Terms and Conditions of Use and its acceptance",
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
                                'By either accessing wealthclockadvisors.com (herein referred to as “website”) as a visitor or by registering with the website (This website is owned and operated by Wealthclock Advisors, herein referred to as “Wealthclock”, a proprietary concern, you are agreeing to be bound by the Terms and conditions of use as given below. In case you do not agree to the terms and conditions of Use then please stop using the services and information provided by the Website. Continued use of the website would be deemed as your acceptance to the Terms and Conditions, Privacy Policy and Disclaimers of this website.',
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
                                'Wealthclock reserved the right, at its sole discretion, to modify, amend, add or delete certain sections of the Terms and Conditions of Use, Privacy Policy and Disclaimers. We encourage you to visit these sections on our website from time to time to keep yourself abreast of the latest Terms and Conditions, Privacy Policy and Disclaimers. Your continued usage of our website would be deemed as acceptance to the Terms and Conditions, Privacy Policy and Disclaimers of this website.',
                            style: GoogleFonts.poppins(
                              color: Color(0xFF0f625c),
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        )
                      ],
                    ),
                    Wrap(
                      alignment: WrapAlignment.start,
                      runSpacing: 10,
                      children: [
                        Text.rich(
                          TextSpan(
                            text: "Privacy Policy and Data Protection",
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
                        RichText(
                          text: TextSpan(
                            style: GoogleFonts.poppins(
                              color: Color(0xFF0f625c),
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                            children: [
                              TextSpan(
                                text: 'Wealthclock privacy policy can be accessed at ',
                              ),
                              TextSpan(
                                text: 'privacy-policy',
                                style: GoogleFonts.poppins(
                                  color: Colors.blue,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.blue,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => PrivacyPolicyPage()),
                                    );
                                  },
                              ),
                              TextSpan(
                                text:
                                '. This privacy policy governs and explains the usage of your personal/technical and other data that Wealthclock has. You hereby agree with the Wealthclock privacy policy and give your consent to Wealthclock to use this data.',
                              ),
                            ],
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            text:
                            'The use of Wealthlock website does not grant you any ownership of the Intellectual Property Rights, logo, brand, designs and algorithms owned by Wealthclock. You are not allowed to use this without explicit approvals from Wealthclock.',
                            style: GoogleFonts.poppins(
                              color: Color(0xFF0f625c),
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        )
                      ],
                    ),
                    Wrap(
                      alignment: WrapAlignment.start,
                      runSpacing: 10,
                      children: [
                        Text.rich(
                          TextSpan(
                            text: "Registration to the Website",
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
                            'While you register to the website by providing requisite details like email ID, Mobile Number, PAN Card Number, Address details, Aadhar Card Number, Name, or any other detail sought, it would be your responsibility to provide the correct information. This information can be shared with the Regulatory bodies like SEBI/RBI/Reliance Mutual Fund if and when sought from Wealthclock by these regulators.',
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
                            'It would be your responsibly to ensure that your details with us are most current and correct. Please note that to access this website as a Registered user you would be required to have a “Login ID” and “Password”. Wealthclcok retains the right to allocate the Login ID to you as per their own discretion. You must ensure that you keep this Login ID and Password secure with yourself and do not share your password with anyone to prevent unauthorized access. Wealthclock shall have no liability in case of unauthorized access that results with your sharing of password with others.',
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
                            'Wealthclock shall use the Mobile number / Email Address / Address Details provided by you to communicate with you. You may opt out of some of these communications, if you deem fit. Wealthclock would not be held responsible for non-delivery of these communications as these communications are carried through third party service providers which may be beyond Wealthclock’s control.',
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
                            'Wealthlock would also generate alerts and news flash for you in your account. These could also be sent as SMS on your Mobile number or as emails on your email address provided to Wealthclock. You hereby agree to receive all these communications and alerts from Wealthclock.',
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
                            'It would be your responsibility to maintain the computers/Mobile device/Tablets/Internet Access required to access and utilize this site.',
                            style: GoogleFonts.poppins(
                              color: Color(0xFF0f625c),
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        )
                      ],
                    ),
                    Wrap(
                      alignment: WrapAlignment.start,
                      runSpacing: 10,
                      children: [
                        Text.rich(
                          TextSpan(
                            text: "Investing through the Website",
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
                            'While you register on the website and start investing, it would be your responsibility to provide correct information on your PAN, Residential and Contact Address, Bank Account Details, Tax related and other Personal details. You would also be required to upload relevant documents like PAN card Copy, Address Proof Copy, Bank Statement/Cheque Book and Signature copy. This information would be used for facilitating your transaction and this information would also be shared with regulators, Asset Management Companies (AMC), Registrar and Transfer Agents (RTA), Bombay Stock Exchange (BSE), Payment Gateway Providers and other relevant entities. Your account would only be activated once your Know your Client (KYC) details have been assessed and checked and found to be correct as per the SEBI mandated laws and rules for KYC. In case Wealthclock observes any discrepancy then your request for registration can be cancelled. Any change in personal, PAN, Bank details should be shared with Wealthclock as soon as possible. Before investing in any Mutual Funds through Wealthclock website, you must read the scheme offer documents carefully.',
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
                            'The scheme offer documents are available on the Asset Management Company Websites. The links to the Asset Management websites are also available on Wealthclock website. All Mutual Fund purchases must be done only and only from all your own bank account. If you transfer funds from any other bank account then your order may not be processed or even if it has been processed it can be reversed later by RTA/BSE. It is also your responsibility to ensure that all the amounts invested in Mutual Funds are through legitimate sources only and are not in contravention of any Regulations, Rules, Acts, Notifications, and Provisions of the Income Tax Act, Anti-Money Laundering Laws, Anti-Corruption Laws or any other applicable laws enacted by the Government of India. If you are an NRI, then you confirm that you are a Non Resident of Indian nationality or origin and have remitted funds only through your own Non Resident External / Non Resident Ordinary account. Wealthclock might not be able to serve all geographies for distribution of its products and reserves the right to not offer its products and services to any customer as per its sole discretion.',
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
                            'The registration to the Wealthclock website to invest in Mutual Funds has been done solely by you after having read all the terms and conditions. Wealthclock does not share your login information with anyone and you must ensure that you do not share your login credentials (User ID and Password) with any third parties. You would be solely responsible for any unauthorized access of your account due to this sharing. You must also intimate Wealthclock immediately of any such unauthorized access. Your continued use of the Wealthclock website implies that you have read the terms and conditions and have agreed to adhere to those terms and conditions. Wealthclock reserves the right to terminate your account in case of any violations of the terms and conditions as per its sole discretion.',
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
                            'Wealthclock receives commissions from the AMCs for the Fund schemes being distributed from our Wealthclock and offline channels as Wealthclock is an AMFI registered Mutual Fund Distributor. The Commissions have been displayed on our website for ready reference of all customers (under the Disclosure link) and have been disclosed to you adequately. You must go through the document. Wealthclock has disclosed all commissions that it would receive (upfront and trail or all trail) in the document. You also agree that Wealthclcok has not offered any Cash backs, Gifts or rebates from the commissions to influence you directly or indirectly to invest in the mutual fund schemes.',
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
                            'Wealthclock has taken great care and effort in doing research in putting together the information, data and analysis to facilitate and help you in taking investment decisions that you could be best for you to meet your investment goals. The information available on the Wealthclock website, the recommendations and other data available does not amount to Investment Advice. You must take independent financial planning, legal, accounting, tax or other professional advice before investing or withdrawing from Mutual Funds schemes being offered by Wealthclock on our website or through our Offline channels.',
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
                            'Wealthclock has tied up with Bombay Stock Exchange (BSE) Star MF platform to process all your Mutual Fund Buy / Purchase / Switch / Systematic Investment Plan (SIP) / Systematic Transfer Plans (STP) / Systematic Withdrawal Plan (SWP) etc. and pass them to the relevant AMC and RTA for processing. The Payment Gateway available on the Wealthclock website is also provided by BSE Star MF platform. Wealthclock does not offer all mutual Fund schemes for investing for its registered users and is not obliged to do that. Wealthclock would only be able to offer schemes that are available on the BSE Star MF platform. Wealthclock only distributed AMC products and does not warranty or guaranty the AMC or any mutual fund schemes that they offer. Your details like PAN, Address Details, FATCA declaration, Bank Details and Documents, Your Signature, etc would be shared with BSE Star MF platform to facilitate your Mutual Fund order and Payment processing to be passed onto relevant AMCs and RTAs. Such records may be used by the Wealthclock/BSE/AMC/RTA, in physical/offline/Online mode, for authorizing the transactions that have been submitted by you. Wealthclock and BSE would be sending your messages on the Mobile Number and email ID provided by you to inform you status of your orders/ Investments/Portfolio/New schemes etc and this consent will override any registration for Do Not Call ("DNC") / National Do Not Call ("NDNC") registry.',
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
                            'For investment in Systematic Investment Plans, your NACH/ECS mandate would need to be sent to BSE and further to your Bank for registration. Only post this successful registration and subsequent successful money transfer, your requests for subscriptions will be sent to the relevant AMCs. Subscription to the Fund Schemes is subject to realization of funds. The instructions would be processed for the same day if they are received before the cut off times prescribed by Wealthclock and BSE. BSE and Wealthclock reserve the right, at their sole discretion, to keep these cut offs ahead of the cut offs prescribed by AMCs and RTAs. The Wealthclock and BSE cut offs are kept ahead of the AMC/RTA cut off keeping in mind the processing time required at their end for checking / validating and reconciling the order and the payments before passing them onto the AMCs/RTAs. AMCs are not obliged to accept any subscriptions to the various Mutual Fund Schemes offered by them.',
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
                            'Wealthclock would not be liable to any loss of interest and/ or opportunity loss and /or any loss arising due to movement of Net Asset Value (NAV), notional or otherwise, due to any subscription/redemption/SIP/STP/SWP etc order not being processed, rejected or being delayed at AMC, RTA, Bank, BSE or Wealthclock due to manual or auto processing, breakdown of technology systems and connectivity, website out of service etc. Any order placed on a holiday or after cut off time on the day just before the holiday would be processed on the next business day and the NAV would be applicable as per the respective scheme related documents. All directions given by you for SIP/STP/SWP would be considered as the bona fide orders placed by you and would be sent for processing to BSE and subsequently to AMCs and RTAs. You agree to these terms and conditions by registering with Wealthclock.',
                            style: GoogleFonts.poppins(
                              color: Color(0xFF0f625c),
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        )
                      ],
                    ),
                    Wrap(
                      alignment: WrapAlignment.start,
                      runSpacing: 10,
                      children: [
                        Text.rich(
                          TextSpan(
                            text: "Joint Accounts",
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
                            'If an User Account is opened or maintained in the name of more than one individual or a partnership:-',
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
                            'The term “Customer” shall refer to each individual or partner jointly and severally, and the liability of each such individual or partner to Wealthclock shall be joint and several; and Wealthclock shall be entitled to recover any sum due or owed to Wealthclock by any of the individuals in whose name the Investment Account is opened or maintained or constituting the Customer.',
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
                            'No individual constituting the Customer shall be discharged, nor shall his liability be affected by any discharge, release, time, indulgence, concession, waiver or consent given at any time in relation to any one or more of the other such individuals constituting the Customer.',
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
                            'In respect of each Investment Account opened in the name of 2 or more individuals or a partnership, the first holder of Investment Account in case of joint account or authorized signatories in case of partnership, are authorized to give Orders in relation to transaction and any other instruction to Wealthclock. Any correspondence, mail, notice or communication addressed and sent by Wealthclock to the first holder and such communication in respect of a Joint Account shall be deemed to have been addressed and sent to all the individuals named in respect of such Joint Account.',
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
                            'In a Joint Account, if Wealthclock, prior to acting on any instructions given by one signatory, receives contradictory instructions from the other signatory, Wealthclock may thereafter only act on the instructions of all signatories for the said Joint Account.',
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
                            'The doctrine of survivorship shall apply to any Investment Account opened in the joint names of more than one individual or in the name of a partnership. Accordingly, in the event of the death of such individual or any partner constituting the Customer, the Investment Account shall immediately vest in the surviving individual(s) or partner(s) (as the case may be).',
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
                            'The password for the User Account shall be assigned only to the first applicant as listed in the Application Form.',
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
                            'The provisions in this Clause apply to any other services provided by Wealthclock or any other Person or Service Provider appointed by Wealthclock from time to time in this regard.',
                            style: GoogleFonts.poppins(
                              color: Color(0xFF0f625c),
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        )
                      ],
                    ),
                    Wrap(
                      alignment: WrapAlignment.start,
                      runSpacing: 10,
                      children: [
                        Text.rich(
                          TextSpan(
                            text: "Third Party Service providers and Links to Website",
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
                            'The services / content/ information /views/ opinions /blogs/Communications etc are and could be facilitated through various third-party Service Providers. Wealthclock, at its sole discretion, can replace/stop/add services of the existing third-party service providers.',
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
                            'The website operated by Wealthclock shall and can have links to third party websites. These links/websites are not under the control of Wealthlock. Wealthclock does not endorse or review these websites and in no way warrant or guarantee the products, services, information, content, views, opinions, data offered on these websites and would be not responsible in any way for the same.',
                            style: GoogleFonts.poppins(
                              color: Color(0xFF0f625c),
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Wrap(
                      alignment: WrapAlignment.start,
                      runSpacing: 10,
                      children: [
                        Text.rich(
                          TextSpan(
                            text: "Disclaimer",
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
                            'Wealthclock disclaimers can be accessed at www.wealthclockadvisors.com page. We encourage you to keep yourself abreast of the lastest Disclaimer by visiting the page from time to time. Any changes to the disclaimers would be updated. Your past and continued use of the website would be deemed as complete and correct understanding of the Disclaimer put up on this website. We do not promise / warrant / guarantee any commitments about the products / services / opinions / data / information / blogs etc. on this website. The service is provided ‘AS IS”.',
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
                            'The data, analysis, information compiled by us on our website is done to help you take informed decisions. You must independently validate these yourself to your complete satisfaction before taking financial or other decisions. The information provided by us does not constitute advice in any manner whatsoever.',
                            style: GoogleFonts.poppins(
                              color: Color(0xFF0f625c),
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Wrap(
                      alignment: WrapAlignment.start,
                      runSpacing: 10,
                      children: [
                        Text.rich(
                          TextSpan(
                            text: "Liability",
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
                            'The “registered users” and “visitors” agree that your use of this website is at your Sole Risk.',
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
                            'This website could be unavailable / delayed due to technical maintenance, disruptions and interruptions. There can be factual or typographical errors, unintentional factual inaccuracies on the content /data / information / views / opinions/ blogs etc. Wealthclock, its employees/ vendors / third party service providers / directors / authorized personnel shall not be liable for any direct, indirect, special, incidental, punitive or consequential damages arising out of or in any way connected to the use of this website, in any event.',
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
                            'Wealthclcok and its third-party partners shall not be will not be responsible for lost profits, revenues, or data, financial losses, or any damages.',
                            style: GoogleFonts.poppins(
                              color: Color(0xFF0f625c),
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Wrap(
                      alignment: WrapAlignment.start,
                      runSpacing: 10,
                      children: [
                        Text.rich(
                          TextSpan(
                            text: "Indemnification",
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
                            'You agree to Indemnify, protect, fully compensate, defend and hold harmless, Wealthclock and its Directors, Employees, Affiliates, Group Companies, Authorized Personnel, Sub Brokers, Agents, Representatives, contractors, from any losses imposed or claims asserted and incurred due to you accessing this website, your violation and infringement of the terms and conditions or any violations of intellectual property.',
                            style: GoogleFonts.poppins(
                              color: Color(0xFF0f625c),
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Wrap(
                      alignment: WrapAlignment.start,
                      runSpacing: 10,
                      children: [
                        Text.rich(
                          TextSpan(
                            text: "Rules for posting Comments and content",
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
                            'While posting any comments or content on this website:\nYou shall not post anything defamatory, libelous, threatening, infringing, obscene, indecent, unlawful, abusive, racially or ethnically offensive, pornographic, or hateful in nature.',
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
                            'You agree that Wealthclock shall have the license to use, reproduce, distribute, display and modify all or portion of your posts. You agree that Wealthclock shall have the necessary rights and license to the same at no bearable costs to you.',
                            style: GoogleFonts.poppins(
                              color: Color(0xFF0f625c),
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Wrap(
                      alignment: WrapAlignment.start,
                      runSpacing: 10,
                      children: [
                        Text.rich(
                          TextSpan(
                            text: "Interference and Malicious Access",
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
                            'You agree that you would not infect the website with viruses/ Trojans or any other malicious softwares that would impact the functioning of the website or any of its features adversely.',
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
                            'You agree that you would not indulge in any denial of service attacks on this website.\n'
                                'You agree not to run any computer programmes for scraping data, copying any portion of the website, slowing down the website performance, or re-engineering models and algorithms used by this website.',
                            style: GoogleFonts.poppins(
                              color: Color(0xFF0f625c),
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Wrap(
                      alignment: WrapAlignment.start,
                      runSpacing: 10,
                      children: [
                        Text.rich(
                          TextSpan(
                            text: "Termination",
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
                            'These Terms and conditions of use shall remain in force till you remain a “registered user” or “visitor” to this site. Wealthclock reserves the right to terminate the rights granted to you incase of non compliance to the terms and conditions.',
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
                            'This User Agreement and the license rights granted hereunder shall remain in full force and effect unless terminated or canceled for any of the following reasons: (a) immediately by ',
                            style: GoogleFonts.poppins(
                              color: Color(0xFF0f625c),
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                            children: [
                              // First clickable link
                              TextSpan(
                                text: 'moneycontrol.com',
                                style: TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.blue,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = _launchURL, // Call the function when tapped
                              ),
                              TextSpan(
                                text:
                                ' for any unauthorized access or use by you (b) immediately by ',
                                style: GoogleFonts.poppins(
                                  color: Color(0xFF0f625c),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              // Another clickable link
                              TextSpan(
                                text: 'moneycontrol.com',
                                style: TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.blue,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = _launchURL, // Call the function when tapped
                              ),
                              TextSpan(
                                text:
                                ' if you assign or transfer (or attempt the same) any rights granted to you under this Agreement; (c) immediately, if you violate any of the other terms and conditions of this User Agreement. Termination or cancellation of this Agreement shall not affect any right or relief to which moneycontrol.com may be entitled, at law or in equity. Upon termination of this User Agreement, all rights granted to you will terminate and revert to ',
                                style: GoogleFonts.poppins(
                                  color: Color(0xFF0f625c),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              // Last clickable link
                              TextSpan(
                                text: 'moneycontrol.com',
                                style: TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.blue,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = _launchURL, // Call the function when tapped
                              ),
                              TextSpan(
                                text:
                                '. Except as set forth herein, regardless of the reason for cancellation or termination of this User Agreement, the fee charged if any for access to moneycontrol.com is non-refundable for any reason.',
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
                    Wrap(
                      alignment: WrapAlignment.start,
                      runSpacing: 10,
                      children: [
                        Text.rich(
                          TextSpan(
                            text: "SEBI Disclaimer",
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
                            'Past performance of Mutual Funds is not an indicator of future returns. All Mutual fund investments are subject to market risks. Please read all scheme-related documents carefully before investing.',
                            style: GoogleFonts.poppins(
                              color: Color(0xFF0f625c),
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Wrap(
                      alignment: WrapAlignment.start,
                      runSpacing: 10,
                      children: [
                        Text.rich(
                          TextSpan(
                            text: "Arbitration",
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
                            'As per the Arbitration and Conciliation Act, 1996, any dispute arising out of this agreement shall be settled by a arbitrator to be appointed mutually by Wealthclock and you. In case of no settlement, we agree to appoint a panel of three arbitrators, one appointed by each one of us and third arbitrator to be appointed by the two arbitrators. The venue of arbitration would be Mumbai.',
                            style: GoogleFonts.poppins(
                              color: Color(0xFF0f625c),
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Wrap(
                      alignment: WrapAlignment.start,
                      runSpacing: 10,
                      children: [
                        Text.rich(
                          TextSpan(
                            text: "Jurisdiction",
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
                            'The usage of this Website is exclusively subject to the laws of India and jurisdiction to the courts of Mumbai in India. Wealthclock hereby expressly disclaims any implied warranties imputed by the laws of any other jurisdiction. This website is specifically designed for users in the territory of India though the access to users outside India is not denied. Wealthclock shall not have any legal liabilities whatsoever in any laws of any jurisdiction other than India.',
                            style: GoogleFonts.poppins(
                              color: Color(0xFF0f625c),
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
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
