import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/logger.dart';
import 'providers/cart_provider.dart';
import 'providers/wishlist_provider.dart';
import 'providers/auth_provider.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    AppLogger.firebase('🚀 Initializing Firebase...');
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    AppLogger.firebase('✅ Firebase initialized successfully');
  } catch (e) {
    AppLogger.error('Firebase initialization failed', tag: 'Firebase', error: e);
  }

  try {
    AppLogger.info('🔑 Initializing Google Sign-In...', tag: 'GoogleSignIn');
    await GoogleSignIn.instance.initialize();
    AppLogger.info('✅ Google Sign-In initialized', tag: 'GoogleSignIn');
  } catch (e) {
    AppLogger.error('Google Sign-In initialization failed', tag: 'GoogleSignIn', error: e);
  }

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Color(0xFF090E35),
    systemNavigationBarIconBrightness: Brightness.light,
  ));

  AppLogger.info('🎨 Launching app...');
  runApp(const BelldiApp());
}

class BelldiApp extends StatelessWidget {
  const BelldiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => WishlistProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        title: 'BELLDI Fashion Store',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const SplashScreen(),
      ),
    );
  }
}
