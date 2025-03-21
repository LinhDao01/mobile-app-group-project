import 'dart:developer' show log;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import '../screens/screens.dart';
import '../components/my_button.dart';
import '../components/mytextfield.dart';
import '../components/dialog.dart';
// import 'auth_manager.dart';

// ignore: constant_identifier_names
enum AuthMode { Register, Login }

class AuthCard extends StatefulWidget {
  const AuthCard({
    super.key,
  });

  @override
  State<AuthCard> createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  final _isSubmitting = ValueNotifier<bool>(false);
  final _passwordController = TextEditingController();

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    // Check password length
    if (_authData['password']!.length < 8) {
      if (mounted) {
        showErrorDialog(
            context, 'Password must be at least 8 characters long.');
      }
      return;
    }

    _isSubmitting.value = true;

    try {
      if (_authMode == AuthMode.Login) {
        await context.read<AuthManager>().login(
              _authData['email']!,
              _authData['password']!,
            );
        // Navigate to homepage
      } else {
        await context.read<AuthManager>().signup(
              _authData['email']!,
              _authData['password']!,
            );
        // Auto-login with the same credentials
        // ignore: use_build_context_synchronously
        await context.read<AuthManager>().login(
              _authData['email']!,
              _authData['password']!,
            );
        // Navigate to homepage
      }
    } catch (e) {
      log('Error: $e');
      if (mounted) {
        showErrorDialog(context, e.toString());
      }
    }

    _isSubmitting.value = false;
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Register;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.sizeOf(context);
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              if (_authMode == AuthMode.Login) _loginMessage(),
              if (_authMode == AuthMode.Register) _registerMessage(),
              const SizedBox(height: 10),
              _buildEmailField(),
              const SizedBox(height: 10),
              _buildPasswordField(),
              const SizedBox(height: 10),
              if (_authMode == AuthMode.Register) _buildPasswordConfirmField(),
              const SizedBox(height: 10),
              ValueListenableBuilder<bool>(
                valueListenable: _isSubmitting,
                builder: (ctx, isSubmitting, child) {
                  if (isSubmitting) {
                    return Loading();
                  }
                  return _buildSubmitButton();
                },
              ),
              const SizedBox(height: 10),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(
                  _authMode == AuthMode.Login
                      ? "Don't have an account?"
                      : "already have an account?",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
                _buildAuthModeSwitch(),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _loginMessage() {
    return Padding(
        padding: const EdgeInsets.only(left: 40),
        child: Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Hi there,",
                    style: GoogleFonts.rowdies(
                      fontSize: 40,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    )),
                Text("You're Back!",
                    style: GoogleFonts.rowdies(
                      fontSize: 30,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    )),
              ],
            )));
  }

  Widget _registerMessage() {
    return Text("Let's create your account!",
        style: GoogleFonts.sora(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.inversePrimary,
        ));
  }

  Widget _buildAuthModeSwitch() {
    return GestureDetector(
      onTap: _switchAuthMode,
      child: Text(
        _authMode == AuthMode.Login ? ' Register now!' : ' Login now!',
        style: TextStyle(
          color: Theme.of(context).colorScheme.inversePrimary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return MyButton(
      onTap: _submit,
      text: _authMode == AuthMode.Login ? 'Login' : 'Register',
      textColor: Theme.of(context).colorScheme.outline,
      btnColor: Theme.of(context).colorScheme.inversePrimary,
    );
  }

  Widget _buildPasswordField() {
    return Mytextfield(
      controller: _passwordController,
      prefixIcon: Icon(Icons.lock_outline),
      hintText: 'Password',
      // hintStyle: TextStyle(color: Colors.red),
      obscureText: true,
      validator: (value) {
        if (value == null || value.length < 7) {
          return 'Password must be at least 8 characters long!';
        }
        return null;
      },
      onSaved: (value) {
        _authData['password'] = value!;
      },
    );
  }

  Widget _buildPasswordConfirmField() {
    final confirmPasswordController = TextEditingController();
    return Mytextfield(
      controller: confirmPasswordController,
      prefixIcon: Icon(Icons.lock_outline),
      hintText: 'Confirm Password',
      obscureText: true,
      enabled: _authMode == AuthMode.Register,
      validator: _authMode == AuthMode.Register
          ? (value) {
              if (value != _passwordController.text) {
                return 'Passwords do not match!';
              }
              return null;
            }
          : null,
    );
  }

  Widget _buildEmailField() {
    return Mytextfield(
      controller: TextEditingController(),
      prefixIcon: Icon(Icons.person),
      hintText: 'Email',
      obscureText: false,
      validator: (value) {
        if (value == null || !value.contains('@')) {
          return 'Invalid email!';
        }
        return null;
      },
      onSaved: (value) {
        _authData['email'] = value!;
      },
    );
  }
}
