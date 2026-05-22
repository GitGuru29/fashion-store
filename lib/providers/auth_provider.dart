import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import '../core/utils/logger.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  User? _user;
  bool _isLoading = false;
  String? _errorMessage;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _user != null;

  AuthProvider() {
    AppLogger.auth('🔐 AuthProvider initialized');
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      if (user != null) {
        AppLogger.auth('✅ User logged in: ${user.email}');
      } else {
        AppLogger.auth('🚪 User logged out');
      }
      notifyListeners();
    });
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  // ── Email / Password Registration ──────────────────────────────────────
  Future<bool> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    AppLogger.auth('📝 Starting sign-up with email: $email');
    _setLoading(true);
    _setError(null);
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      AppLogger.auth('✅ Sign-up successful for: ${userCredential.user?.email}');
      _setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      AppLogger.error(
        'Sign-up failed with error: ${e.code}',
        tag: 'Auth',
        error: e,
      );
      _setLoading(false);
      _setError(_friendlyError(e));
      return false;
    } catch (e) {
      AppLogger.error('Unexpected error during sign-up', tag: 'Auth', error: e);
      _setLoading(false);
      _setError(e.toString());
      return false;
    }
  }

  // ── Email / Password Sign-In ────────────────────────────────────────────
  Future<bool> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    AppLogger.auth('🔑 Starting sign-in with email: $email');
    _setLoading(true);
    _setError(null);
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      AppLogger.auth('✅ Email sign-in successful for: ${userCredential.user?.email}');
      _setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      AppLogger.error(
        'Email sign-in failed with error: ${e.code}',
        tag: 'Auth',
        error: e,
      );
      _setLoading(false);
      _setError(_friendlyError(e));
      return false;
    } catch (e) {
      AppLogger.error('Unexpected error during email sign-in', tag: 'Auth', error: e);
      _setLoading(false);
      _setError(e.toString());
      return false;
    }
  }

  // ── Google Sign-In ──────────────────────────────────────────────────────
  Future<bool> signInWithGoogle() async {
    AppLogger.auth('🔑 Starting Google Sign-In');
    _setLoading(true);
    _setError(null);
    try {
      AppLogger.auth('📱 Prompting user for Google account selection...');
      final GoogleSignInAccount? googleUser = await _googleSignIn.authenticate();

      if (googleUser == null) {
        AppLogger.auth('⚠️  Google Sign-In cancelled by user');
        _setLoading(false);
        return false;
      }

      AppLogger.auth('✅ Google account selected: ${googleUser.email}');
      AppLogger.auth('🔐 Obtaining authentication tokens...');

      final googleAuth = await googleUser.authentication;
      AppLogger.auth('✅ Authentication tokens obtained');

      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      AppLogger.auth('🔄 Signing in to Firebase with Google credentials...');
      final userCredential = await _auth.signInWithCredential(credential);
      AppLogger.auth('✅ Firebase sign-in successful for: ${userCredential.user?.email}');

      _setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      AppLogger.error(
        'Firebase Google Sign-In failed: ${e.code}',
        tag: 'Auth',
        error: e,
      );
      _setLoading(false);
      _setError(_friendlyError(e));
      return false;
    } catch (e) {
      AppLogger.error('Unexpected error during Google Sign-In', tag: 'Auth', error: e);
      _setLoading(false);
      _setError(e.toString());
      return false;
    }
  }

  // ── Facebook Sign-In ────────────────────────────────────────────────────
  Future<bool> signInWithFacebook() async {
    AppLogger.auth('🔑 Starting Facebook Sign-In');
    _setLoading(true);
    _setError(null);
    try {
      AppLogger.auth('📱 Prompting user for Facebook login...');
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        AppLogger.auth('✅ Facebook login successful, obtaining tokens...');
        final AccessToken accessToken = result.accessToken!;
        
        final OAuthCredential credential = FacebookAuthProvider.credential(accessToken.token);
        
        AppLogger.auth('🔄 Signing in to Firebase with Facebook credentials...');
        final userCredential = await _auth.signInWithCredential(credential);
        AppLogger.auth('✅ Firebase sign-in successful for: ${userCredential.user?.email}');
        
        _setLoading(false);
        return true;
      } else if (result.status == LoginStatus.cancelled) {
        AppLogger.auth('⚠️  Facebook Sign-In cancelled by user');
        _setLoading(false);
        return false;
      } else {
        AppLogger.error('Facebook login failed: ${result.message}', tag: 'Auth');
        _setLoading(false);
        _setError(result.message);
        return false;
      }
    } on FirebaseAuthException catch (e) {
      AppLogger.error(
        'Firebase Facebook Sign-In failed: ${e.code}',
        tag: 'Auth',
        error: e,
      );
      _setLoading(false);
      _setError(_friendlyError(e));
      return false;
    } catch (e) {
      AppLogger.error('Unexpected error during Facebook Sign-In', tag: 'Auth', error: e);
      _setLoading(false);
      _setError(e.toString());
      return false;
    }
  }

  // ── Sign-Out ────────────────────────────────────────────────────────────
  Future<void> signOut() async {
    AppLogger.auth('🚪 Starting sign-out process');
    _setLoading(true);
    _setError(null);
    try {
      AppLogger.auth('📱 Signing out from Google...');
      await _googleSignIn.signOut();
      AppLogger.auth('✅ Google sign-out successful');

      AppLogger.auth('🔐 Signing out from Firebase...');
      await _auth.signOut();
      AppLogger.auth('✅ Firebase sign-out successful');
    } catch (e) {
      AppLogger.error('Error during sign-out', tag: 'Auth', error: e);
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // ── Helpers ─────────────────────────────────────────────────────────────
  String _friendlyError(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'An account with this email already exists.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'weak-password':
        return 'Password must be at least 6 characters.';
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      default:
        return e.message ?? 'An unexpected error occurred.';
    }
  }
}
