import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import '../services/auth_service.dart';
import 'screens/screens.dart';
import 'themes/light_mode.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  try {
    await dotenv.load(fileName: "assets/.env");
    print("Dotenv loaded successfully!");
  } catch (e) {
    print("Error loading dotenv: $e");
  }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    initialization();
  }

  void initialization() async {
    print('pausing...');
    await Future.delayed(const Duration(seconds: 3));
    print('unpausing.');
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Menu()),
//         ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (ctx) => AuthManager()),
        ChangeNotifierProvider(create: (context) => CartsManager()),
        ChangeNotifierProvider(create: (ctx) => AuthService()),
        ChangeNotifierProvider(create: (ctx) => OrdersManager()),
      ],
      child: Consumer<AuthManager>(builder: (ctx, authManager, child) {
        return MaterialApp(
          title: 'Food Delivery App',
          theme: lightmode,
          debugShowCheckedModeBanner: false,
          home: authManager.isAuth
              ? const SafeArea(child: HomePage())
              : FutureBuilder(
                  future: authManager.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) {
                    return authResultSnapshot.connectionState ==
                            ConnectionState.waiting
                        ? const SafeArea(child: Loading())
                        : const SafeArea(child: AuthPage());
                  },
                ),
          routes: {
            HomePage.routeName: (context) => const HomePage(),
            CartScreen.routeName: (context) => const CartScreen(),
            AuthPage.routeName: (context) => const AuthPage(),
            ProfileEditPage.routeName: (context) =>
                const SafeArea(child: ProfileEditPage()),
            OrdersPage.routeName: (context) =>
                const SafeArea(child: OrdersPage()),
            OrderConfirmPage.routeName: (context) =>
                const SafeArea(child: OrderConfirmPage()),
          },
        );
      }),
    );
  }
}
