import 'package:pocketbase/pocketbase.dart';
import 'package:flutter/material.dart';

import '../models/user.dart';
import 'pocketbase_client.dart';

class AuthService with ChangeNotifier {
  void Function(User? user)? onAuthChange;

  AuthService({this.onAuthChange}) {
    if (onAuthChange != null) {
      getPocketbaseInstance().then((pb) {
        pb.authStore.onChange.listen((event) {
          onAuthChange!(event.record == null
              ? null
              : User.fromJson(event.record!.toJson()));
        });
      });
    }
  }

  Future<User> signup(String email, String password) async {
    final pb = await getPocketbaseInstance();

    try {
      // Create a user with default values for required fields
      final record = await pb.collection('users').create(body: {
        'email': email,
        'password': password,
        'passwordConfirm': password,
        'name': 'unknown',
        'address': 'unknown',
        'phone': '0123456789',
      });

      return User.fromJson(record.toJson());
    } catch (e) {
      if (e is ClientException) {
        print("PocketBase Error: ${e.response}");
        throw Exception(e.response['message']);
      }
      print("Unexpected Error: $e");
      throw Exception('An error occurred while signing up');
    }
  }

  Future<User> login(String email, String password) async {
    final pb = await getPocketbaseInstance();

    try {
      final authData =
          await pb.collection('users').authWithPassword(email, password);

      // Use the record from the auth response
      final userData = authData.record!.toJson();

      // Create a User instance with the received data
      return User.fromJson(userData);
    } catch (e) {
      if (e is ClientException) {
        print("Login failed: ${e.response}");
        throw Exception(e.response['message'] ?? 'Login failed');
      }

      print("Unexpected Error: $e");
      throw Exception('An error occurred while logging in');
    }
  }

  Future<void> logout() async {
    final pb = await getPocketbaseInstance();
    pb.authStore.clear();
  }

  Future<User?> getUserFromStore() async {
    final pb = await getPocketbaseInstance();
    final model = pb.authStore.record;

    if (model == null) {
      return null;
    }

    return User.fromJson(model.toJson());
  }

  Future<bool> verifyPassword(String email, String password) async {
    final pb = await getPocketbaseInstance();

    try {
      await pb.collection('users').authWithPassword(email, password);
      return true;
    } catch (e) {
      if (e is ClientException) {
        print("Password verification failed: ${e.response}");
        return false;
      }

      print("Unexpected Error: $e");
      throw Exception('An error occurred while verifying the password');
    }
  }

  Future<User> updateUserProfile({
    required String userId,
    String? name,
    String? address,
    String? phone,
    String? password,
    String? oldPassword,
  }) async {
    try {
      final pb = await getPocketbaseInstance();

      final Map<String, dynamic> body = {};

      if (name != null) body['name'] = name;
      if (address != null) body['address'] = address;
      if (phone != null) body['phone'] = phone;
      // if (password != null && password.isNotEmpty) body['password'] = password;
      // Handle password update if provided
      if (password != null && password.isNotEmpty) {
        // Check password length
        if (password.length < 8) {
          throw Exception('Password must be at least 8 characters long.');
        }

        body['oldPassword'] = oldPassword;
        body['password'] = password;
        body['passwordConfirm'] = password;
      }

      final record = await pb.collection('users').update(
            userId,
            body: body,
          );

      return User.fromJson(record.toJson());
    } catch (e) {
      if (e is ClientException) {
        print("Update failed: ${e.response}");
        throw Exception(e.response['message'] ?? 'Profile update failed');
      }

      print("Unexpected Error: $e");
      throw Exception('An error occurred while updating profile');
    }
  }
}
