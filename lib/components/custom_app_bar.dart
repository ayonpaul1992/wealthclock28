import 'package:flutter/material.dart';
import 'package:wealthclock28/screens/ProfileAfterLogin.dart';
import '../screens/dashboard_after_login.dart'; // Adjust the path as needed

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final VoidCallback? onBackPressed;
  final VoidCallback? onTitleTapped;
  final String userId;
  final bool showLeading;

  const CustomAppBar({
    super.key,
    required this.scaffoldKey,
    required this.userId,
    this.onBackPressed,
    this.onTitleTapped,
    this.showLeading = true,
    required String prflId, required String rqsrvcId,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      leading: showLeading // ✅ Show leading only if true
          ? IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: onBackPressed ?? () => Navigator.pop(context),
            )
          : null,
      title: InkWell(
        onTap: onTitleTapped ??
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => dashboardAfterLogin(userId: userId),
                ),
              );
            },
        child: Image.asset(
          'assets/images/dshb_logo.png',
          height: 40, // Adjust height if needed
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            // Add notification functionality here
          },
          style: TextButton.styleFrom(
            minimumSize: const Size(20, 20),
            padding: EdgeInsets.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Image.asset(
            'assets/images/bell-svgrepo-com.png',
            height: 20,
            width: 20,
          ),
        ),
        const SizedBox(width: 10),
        TextButton(
          onPressed: () {
            // scaffoldKey.currentState?.openDrawer();

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileAfterLogin(
                  userId: userId,
                  prflId: '',
                ),
              ),
            );
          },
          style: TextButton.styleFrom(
            minimumSize: const Size(20, 20),
            padding: EdgeInsets.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Image.asset(
            'assets/images/user-svgrepo-com.png',
            height: 20,
            width: 20,
          ),
        ),
        const SizedBox(width: 20),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
