// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:frontend_mvvc/viewmodels/login_viewmodels.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../auth/login_view.dart';
import '../notes/note_view.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 3));

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null) {
      Provider.of<LoginViewModel>(context, listen: false).setToken(token);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => NoteView(token: token)),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginView()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/notes.png',
            )
                .animate()
                .fadeIn(
                  delay: 200.ms,
                  curve: Curves.easeIn,
                  duration: 500.ms,
                )
                .shimmer(
                  delay: 700.ms,
                  duration: 2300.ms,
                  curve: Curves.easeInOut,
                ),
            Text(
              'CATATANKU..',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            )
                .animate()
                .fadeIn(
                  delay: 200.ms,
                  curve: Curves.easeIn,
                  duration: 500.ms,
                )
                .shimmer(
                  delay: 700.ms,
                  duration: 2300.ms,
                  curve: Curves.easeInOut,
                )
          ],
        ),
      ),
    );
  }
}
