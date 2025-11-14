import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../components/custom_bottom_nav_bar.dart';
import 'package:wealthclock28/components/custom_drawer.dart';
import 'package:wealthclock28/components/custom_app_bar.dart';

class ChangePasswordPage extends StatefulWidget {
  // final String chngpsd;

  const ChangePasswordPage({
    super.key,
    // required this.chngpsd,
  });

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final changePasswordText = TextEditingController();
  final changeRePasswordText = TextEditingController();

  // control whether validators show messages
  bool _hideValidation = false;

  @override
  void initState() {
    super.initState();

    // typing => show validation again and revalidate live
    changePasswordText.addListener(() {
      if (_hideValidation) {
        setState(() => _hideValidation = false);
      }
      // re-run validators to update error text immediately
      _formKey.currentState?.validate();
    });

    changeRePasswordText.addListener(() {
      if (_hideValidation) {
        setState(() => _hideValidation = false);
      }
      _formKey.currentState?.validate();
    });
  }

  @override
  void dispose() {
    changePasswordText.dispose();
    changeRePasswordText.dispose();
    super.dispose();
  }

  bool _isPassVisible = false;
  bool _isRePassVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        scaffoldKey: _scaffoldKey,
        userId: '',
        showLeading: false,
        prflId: '',
        rqsrvcId: '',
      ),
      drawer: CustomDrawer(
        activeTile: 'Home',
        onTileTap: (selectedTile) {},
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          // hide keyboard and suppress validation messages immediately
          FocusScope.of(context).unfocus();
          setState(() => _hideValidation = true);
          // re-run validators so they return null and clear displayed errors
          _formKey.currentState?.validate();
        },
        child: Container(
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFfffaf5), Color(0xFFe7f6f5)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'CHANGE YOUR PASSWORD',
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF0f625c),
                        fontSize: 19,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // PASSWORD FIELD
                    TextFormField(
                      controller: changePasswordText,
                      obscureText: !_isPassVisible, // Toggle text visibility
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: _inputDecoration('**********').copyWith(
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPassVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Color(0xFF648683),
                          ),
                          onPressed: () {
                            setState(() {
                              _isPassVisible =
                                  !_isPassVisible; // Toggle visibility
                            });
                          },
                        ),
                      ),
                      style: const TextStyle(
                        color: Color(0xFF648683),
                        fontSize: 15,
                      ),
                      validator: (value) {
                        if (_hideValidation) return null; // suppress
                        if (value == null || value.isEmpty) {
                          return 'Password cannot be empty';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),

// RE-ENTER PASSWORD FIELD
                    TextFormField(
                      controller: changeRePasswordText,
                      obscureText: !_isRePassVisible,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: _inputDecoration('**********').copyWith(
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isRePassVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Color(0xFF648683),
                          ),
                          onPressed: () {
                            setState(() {
                              _isRePassVisible =
                                  !_isRePassVisible; // Toggle visibility
                            });
                          },
                        ),
                      ),
                      style: const TextStyle(
                        color: Color(0xFF648683),
                        fontSize: 15,
                      ),
                      validator: (value) {
                        if (_hideValidation) return null; // suppress
                        if (value == null || value.isEmpty) {
                          return 'Please re-enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        // if matches, no error
                        if (value == changePasswordText.text) {
                          return null;
                        }
                        return 'Passwords do not match';
                      },
                    ),

                    const SizedBox(height: 20),

                    // SUBMIT BUTTON
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _hideValidation =
                              false; // show validation after submit
                        });

                        if (_formKey.currentState!.validate()) {
                          // VALID — do nothing for now
                          // You can add your API call or logic here later
                          debugPrint("Form valid!");
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFfdd1a0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 35,
                        ),
                      ),
                      child: Text(
                        'SUBMIT',
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF222222),
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(selectedIndex: -1),
    );
  }

  // INPUT DECORATION WITHOUT RED BORDER
  InputDecoration _inputDecoration(String hintText) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50),
        borderSide: const BorderSide(color: Colors.white, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50),
        borderSide: const BorderSide(color: Color(0xFF0f625c), width: 1),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50),
        borderSide: const BorderSide(color: Colors.white, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50),
        borderSide: const BorderSide(color: Colors.white, width: 1),
      ),
      errorStyle: const TextStyle(color: Colors.red, fontSize: 13),
      hintText: hintText,
      hintStyle: GoogleFonts.poppins(
        color: const Color(0xFF648683),
        fontSize: 15,
      ),
    );
  }
}
