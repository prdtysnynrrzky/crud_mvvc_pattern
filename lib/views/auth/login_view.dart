import 'package:flutter/material.dart';
import 'package:frontend_mvvc/viewmodels/login_viewmodels.dart';
import 'package:frontend_mvvc/widgets/message/errorMessage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../notes/note_view.dart';

class LoginView extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final loginViewModel = Provider.of<LoginViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Center(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/notes.png')
                        .animate(
                          onComplete: (controller) => controller.repeat(),
                        )
                        .shimmer(
                          delay: 700.ms,
                          duration: 2300.ms,
                          curve: Curves.easeInOut,
                        ),
                    Text(
                      'Masuk untuk mulai mencatat!',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ).animate().fadeIn(
                          duration: 500.ms,
                          curve: Curves.easeIn,
                        ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          hintText: 'Email',
                          hintStyle: GoogleFonts.poppins(
                            color: Colors.grey,
                          ),
                          border: InputBorder.none,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email harus diisi';
                          } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                              .hasMatch(value)) {
                            return 'Format email salah';
                          }
                          return null;
                        },
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 700.ms)
                        .shimmer(delay: 300.ms, duration: 2000.ms),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          hintStyle: GoogleFonts.poppins(
                            color: Colors.grey,
                          ),
                          border: InputBorder.none,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password harus diisi';
                          }
                          return null;
                        },
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 700.ms)
                        .shimmer(delay: 300.ms, duration: 2000.ms),
                    const SizedBox(height: 20),
                    InkWell(
                      onTap: loginViewModel.isLoading
                          ? null
                          : () async {
                              if (_formKey.currentState!.validate()) {
                                // Tutup keyboard saat login
                                FocusScope.of(context).unfocus();

                                bool isSuccess = await loginViewModel.login(
                                  emailController.text,
                                  passwordController.text,
                                );

                                if (isSuccess) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => NoteView(
                                          token: loginViewModel.token!),
                                    ),
                                  );
                                } else {
                                  showErrorMessage(
                                      loginViewModel.getErrorMessage() ??
                                          'Login gagal');
                                }
                              }
                            },
                      child: Container(
                        alignment: Alignment.center,
                        width: 225,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 20),
                        decoration: BoxDecoration(
                          color: loginViewModel.isLoading
                              ? Colors.grey
                              : Colors.black,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: loginViewModel.isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                'Masuk',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    )
                        .animate(
                          onComplete: (controller) => controller.repeat(),
                        )
                        .shimmer(
                          delay: 700.ms,
                          duration: 2300.ms,
                          curve: Curves.easeInOut,
                        ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
