import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/screens.dart';
import '../services/auth_service.dart';
import '../models/user.dart';

class ProfileEditPage extends StatefulWidget {
  static const routeName = '/profile-edit';

  const ProfileEditPage({super.key});

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isOldPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  late AuthService _authService;
  User? _currentUser;

  final _usernameController = TextEditingController();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // _authService = context.read<AuthService>();
    // _loadUserData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _authService = Provider.of<AuthService>(context, listen: false);
      _loadUserData();
    });
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      _currentUser = await _authService.getUserFromStore();

      if (_currentUser != null) {
        _usernameController.text = _currentUser!.name ?? '';
        _phoneController.text = _currentUser!.phone ?? '';
        _addressController.text = _currentUser!.address ?? '';
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load user data: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      if (_currentUser == null) {
        throw Exception('User not found');
      }

      if (_oldPasswordController.text.isNotEmpty ||
          _newPasswordController.text.isNotEmpty ||
          _confirmPasswordController.text.isNotEmpty) {
        if (_oldPasswordController.text.isEmpty) {
          throw Exception('Please enter your old password.');
        }

        bool isOldPasswordCorrect = await _authService.verifyPassword(
            _currentUser!.email, _oldPasswordController.text);

        if (!isOldPasswordCorrect) {
          throw Exception('Incorrect old password.');
        }

        if (_newPasswordController.text.length < 8) {
          throw Exception('New password must be at least 8 characters.');
        }

        if (_newPasswordController.text != _confirmPasswordController.text) {
          throw Exception('New password and confirmation do not match.');
        }
      }

      final updatedUser = await _authService.updateUserProfile(
        userId: _currentUser!.id,
        name: _usernameController.text.isNotEmpty
            ? _usernameController.text
            : null,
        address:
            _addressController.text.isNotEmpty ? _addressController.text : null,
        phone: _phoneController.text.isNotEmpty ? _phoneController.text : null,
        oldPassword: _oldPasswordController.text.isNotEmpty
            ? _oldPasswordController.text
            : null,
        password: _newPasswordController.text.isNotEmpty
            ? _newPasswordController.text
            : null,
      );

      if (updatedUser != null) {
        setState(() {
          _currentUser = updatedUser;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        throw Exception('Failed to update user profile.');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update profile: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Edit Profile'),
        ),
        body: _isLoading
            ? const Center(child: Loading())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 30),
                      // Username field
                      TextFormField(
                        controller: _usernameController,
                        decoration: const InputDecoration(
                          labelText: 'Username',
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.black26), // Viền khi chưa focus
                          ),
                        ),
                        validator: (value) {
                          if (value != null &&
                              value.isNotEmpty &&
                              value.length < 3) {
                            return 'Username must be at least 3 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Old Password Field
                      TextFormField(
                        controller: _oldPasswordController,
                        obscureText: !_isOldPasswordVisible,
                        decoration: InputDecoration(
                          labelText: 'Old Password',
                          prefixIcon: const Icon(Icons.lock),
                          border: const OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.black26), // Viền khi chưa focus
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(_isOldPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                _isOldPasswordVisible = !_isOldPasswordVisible;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // New Password Field
                      TextFormField(
                        controller: _newPasswordController,
                        obscureText: !_isNewPasswordVisible,
                        decoration: InputDecoration(
                          labelText: 'New Password',
                          prefixIcon: const Icon(Icons.lock_outline),
                          border: const OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.black26), // Viền khi chưa focus
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(_isNewPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                _isNewPasswordVisible = !_isNewPasswordVisible;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Confirm Password Field
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: !_isConfirmPasswordVisible,
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          prefixIcon: const Icon(Icons.lock_outline),
                          border: const OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.black26), // Viền khi chưa focus
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(_isConfirmPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                _isConfirmPasswordVisible =
                                    !_isConfirmPasswordVisible;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value != null &&
                              value.isNotEmpty &&
                              value.length < 8) {
                            return 'Password must be at least 8 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Phone field
                      TextFormField(
                        controller: _phoneController,
                        decoration: const InputDecoration(
                          labelText: 'Phone Number',
                          prefixIcon: Icon(Icons.phone),
                          border: OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.black26), // Viền khi chưa focus
                          ),
                        ),
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 16),

                      // Address field
                      TextFormField(
                        controller: _addressController,
                        decoration: const InputDecoration(
                          labelText: 'Address',
                          prefixIcon: Icon(Icons.home),
                          border: OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.black26), // Viền khi chưa focus
                          ),
                        ),
                        maxLines: 2,
                      ),
                      const SizedBox(height: 24),

                      // Save button
                      ElevatedButton(
                        onPressed: _saveProfile,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                            side: const BorderSide(
                              color: Color.fromARGB(155, 226, 226, 226),
                              width: 1,
                            ),
                          ),
                        ),
                        child: const Text(
                          'Save Changes',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Cancel button
                      OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: const BorderSide(
                            color: Color.fromARGB(155, 255, 255, 255),
                            width: 1,
                          ),
                          backgroundColor: Color.fromARGB(255, 255, 203, 160),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
