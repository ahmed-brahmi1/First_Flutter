import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/constants.dart';
import '../../../../config/theme.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';
import '../widgets/auth_form.dart';
import '../../../../config/routes.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.asset(
            'assets/images/phone.png',
            fit: BoxFit.cover,
          ),
          // Semi-transparent overlay for readability
          Container(
            color: Colors.black.withValues(alpha: 0.45),
          ),
          // Main content — Imperial Gold local theme override
          Theme(
            data: Theme.of(context).copyWith(
              colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: const Color(0xFFD4A017),
                onPrimary: const Color(0xFF3B2800),
              ),
              inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF9E9E9E)), // elegant grey
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFA9A9A9), width: 1.5), // elegant light grey
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFD4A017), width: 2), // imperial gold
                ),
                labelStyle: GoogleFonts.playfairDisplay(color: const Color(0xFFA9A9A9), fontSize: 16),
                floatingLabelStyle: GoogleFonts.greatVibes(
                  color: const Color(0xFFD4A017), // imperial gold pour les titres animés
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                ),
                hintStyle: GoogleFonts.playfairDisplay(color: Colors.white.withValues(alpha: 0.4)),
                prefixIconColor: const Color(0xFFA9A9A9), // elegant grey
                filled: true,
                fillColor: Colors.black.withValues(alpha: 0.35),
              ),
              checkboxTheme: CheckboxThemeData(
                fillColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return const Color(0xFFD4A017);
                  }
                  return Colors.transparent;
                }),
                checkColor: WidgetStateProperty.all(const Color(0xFF3B2800)),
                side: const BorderSide(color: Color(0xFFD4A017), width: 2),
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFFA9A9A9), // elegant grey
                  textStyle: GoogleFonts.playfairDisplay(fontSize: 16),
                ),
              ),
            ),
            child: BlocListener<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthAuthenticated) {
                  Navigator.of(context).pushReplacementNamed(AppRoutes.dashboard);
                } else if (state is AuthError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                }
              },
              child: Align(
                alignment: Alignment.topCenter,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16.0, 180.0, 16.0, 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Titre Signature en Or Impérial Dégradé
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFFC9A84C), // or antique
                          Color(0xFFE8C84A), // or brillant
                          Color(0xFFFFE066), // reflet lumineux
                          Color(0xFFD4A017), // or impérial profond
                          Color(0xFF9B7820), // or foncé
                        ],
                      ).createShader(bounds),
                      child: Text(
                        'SmartPet',
                        style: GoogleFonts.greatVibes(
                          fontSize: 64, // Plus grand car c'est une police de signature
                          fontWeight: FontWeight.w400,
                          color: Colors.white, // La couleur vient du ShaderMask
                          shadows: [
                            const Shadow(
                              blurRadius: 10,
                              color: Colors.black87,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                      ),
                    ),
                      const SizedBox(height: 32),
                      const AuthForm(isLogin: true),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(AppRoutes.register);
                        },
                        child: Text(
                          'Don\'t have an account? Register',
                          style: GoogleFonts.playfairDisplay(
                            color: const Color(0xFFA9A9A9),
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
