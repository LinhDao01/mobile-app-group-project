import 'package:flutter/material.dart';

import '../auth/auth_card.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({
    super.key,
  });
  static const routeName = "/login";

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.sizeOf(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          // ignore: deprecated_member_use
          backgroundColor: Theme.of(context).colorScheme.background,
          body: SingleChildScrollView(
            child: SizedBox(
                height: deviceSize.height,
                width: deviceSize.width,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      //logo
                      ClipRRect(
                        borderRadius: BorderRadius.circular(50), // Bo tròn góc
                        child: Image.asset(
                          'assets/logo1.jpg',
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),

                      const SizedBox(height: 15),

                      //login/register form
                      Flexible(
                        child: const AuthCard(),
                      ),
                    ],
                  ),
                )),
          )),
    );
  }
}