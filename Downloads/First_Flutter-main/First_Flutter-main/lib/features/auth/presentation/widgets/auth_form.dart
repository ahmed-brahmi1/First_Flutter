import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthForm extends StatefulWidget {
  final bool isLogin;

  const AuthForm({super.key, required this.isLogin});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  bool _rememberMe = false;
  bool _biometricEnabled = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      if (widget.isLogin) {
        context.read<AuthBloc>().add(
              LoginRequested(
                email: _emailController.text.trim(),
                password: _passwordController.text,
              ),
            );
      } else {
        context.read<AuthBloc>().add(
              RegisterRequested(
                email: _emailController.text.trim(),
                password: _passwordController.text,
                name: _nameController.text.trim(),
              ),
            );
      }
    }
  }

  Future<void> _authenticateWithBiometric() async {
    // TODO: Implement biometric authentication using local_auth package
    // For now, this is a placeholder
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Biometric authentication coming soon')),
    );
  }

  @override
  void initState() {
    super.initState();
    // TODO: Check if biometric is available and enabled
    // _checkBiometricAvailability();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Form(
          key: _formKey,
          child: Column(
            children: [
              if (!widget.isLogin) ...[
                TextFormField(
                  controller: _nameController,
                  style: GoogleFonts.playfairDisplay(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
              ],
              TextFormField(
                controller: _emailController,
                style: GoogleFonts.playfairDisplay(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                style: GoogleFonts.playfairDisplay(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (value.length < 6) {
                    return 'Invalid Password';
                  }
                  return null;
                },
              ),
              if (widget.isLogin) ...[
                const SizedBox(height: 16),
                Row(
                  children: [
                    Checkbox(
                      value: _rememberMe,
                      onChanged: (value) {
                        setState(() {
                          _rememberMe = value ?? false;
                        });
                      },
                    ),
                    Text(
                      'Remember me',
                      style: GoogleFonts.playfairDisplay(color: const Color(0xFFA9A9A9), fontSize: 15),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        // TODO: Implement forgot password
                      },
                      child: Text('Forgot Password?', style: GoogleFonts.playfairDisplay(color: const Color(0xFFA9A9A9), fontSize: 15)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (_biometricEnabled)
                  OutlinedButton.icon(
                    onPressed: state is AuthLoading ? null : _authenticateWithBiometric,
                    icon: const Icon(Icons.fingerprint),
                    label: const Text('Use Biometric'),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                    ),
                  ),
              ],
              const SizedBox(height: 24),
              // Imperial Gold Gradient Button
              GestureDetector(
                onTap: state is AuthLoading ? null : _submit,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: double.infinity,
                  height: 52,
                  decoration: BoxDecoration(
                    gradient: state is AuthLoading
                        ? const LinearGradient(
                            colors: [Color(0xFF9E8A5A), Color(0xFFB8A46A)],
                          )
                        : const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFFC9A84C), // or antique
                              Color(0xFFE8C84A), // or brillant
                              Color(0xFFFFE066), // reflet lumineux
                              Color(0xFFD4A017), // or impérial profond
                              Color(0xFF9B7820), // or foncé
                            ],
                            stops: [0.0, 0.25, 0.5, 0.75, 1.0],
                          ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: state is AuthLoading
                        ? []
                        : [
                            BoxShadow(
                              color: const Color(0xFFD4A017).withValues(alpha: 0.6),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                            BoxShadow(
                              color: const Color(0xFFFFE066).withValues(alpha: 0.3),
                              blurRadius: 4,
                              offset: const Offset(0, -1),
                            ),
                          ],
                  ),
                  child: Center(
                    child: state is AuthLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            widget.isLogin ? 'Login' : 'Register',
                            style: GoogleFonts.greatVibes(
                              color: const Color(0xFF3B2800), // Marron très foncé pour contraster avec l'or
                              fontSize: 32, // Plus grand pour la signature
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1.2,
                              shadows: [
                                const Shadow(
                                  color: Color(0x33FFFFFF),
                                  blurRadius: 4,
                                  offset: Offset(0, 1),
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
      },
    );
  }
}

