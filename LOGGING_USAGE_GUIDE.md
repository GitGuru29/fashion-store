# Logging System - Usage Guide

## Quick Start

The logging system is automatically integrated and ready to use. You don't need to do anything special - just run the app and watch the logs!

---

## Viewing Logs

### Option 1: Android Studio / IntelliJ
1. Click **Logcat** tab at bottom
2. Search/Filter by:
   - `Auth` - Show only authentication logs
   - `Firebase` - Show only Firebase logs
   - `ERROR` - Show only error logs

### Option 2: VS Code
1. Open **Debug Console** (View → Debug Console)
2. Run `flutter logs`
3. Logs appear in real-time

### Option 3: Command Line
```bash
# View all logs
flutter logs

# Filter by tag
flutter logs | grep "Auth"
flutter logs | grep "Firebase"

# Filter by emoji (shows only errors)
flutter logs | grep "❌"

# Real-time search
flutter logs | grep -E "(Auth|ERROR)"
```

---

## Understanding Log Output

### Log Format
```
[EMOJI] [MESSAGE] [TAG]
```

### Emoji Guide
| Emoji | Meaning | Action |
|-------|---------|--------|
| 🔐 | Security/Auth | Check authentication flow |
| 🔑 | Login/Auth process | Check sign-in flow |
| ✅ | Success | Good sign! Process completed |
| ❌ | Error/Failure | Something went wrong |
| ⚠️ | Warning/Cancelled | User action or edge case |
| 📝 | Sign-up | Registration flow |
| 📱 | Device action | Mobile-specific step |
| 🔄 | Processing/Loading | Operation in progress |
| 🚀 | Startup/Init | App initialization |
| 🎨 | UI/Theme | Visual setup |
| 🔧 | Debug/Technical | Development info |
| ℹ️ | Information | General info |

---

## Common Scenarios

### Scenario 1: Google Sign-In Success
**What to look for:**
```
🔑 Starting Google Sign-In
📱 Prompting user for Google account selection...
✅ Google account selected: user@gmail.com
🔐 Obtaining authentication tokens...
✅ Authentication tokens obtained
🔄 Signing in to Firebase with Google credentials...
✅ Firebase sign-in successful for: user@gmail.com
✅ User logged in: user@gmail.com
```

**Expected duration:** 2-5 seconds

---

### Scenario 2: Google Sign-In Cancelled
**What to look for:**
```
🔑 Starting Google Sign-In
📱 Prompting user for Google account selection...
⚠️  Google Sign-In cancelled by user
```

**Expected action:** User can try again

---

### Scenario 3: Google Sign-In Failed
**What to look for:**
```
🔑 Starting Google Sign-In
📱 Prompting user for Google account selection...
❌ Firebase Google Sign-In failed: INVALID_CREDENTIAL
   Error: FirebaseAuthException([firebase_auth/invalid-credential] ...)
```

**Possible causes:**
- Invalid credentials from Google
- Firebase misconfiguration
- Network issues
- OAuth scopes problem

---

### Scenario 4: Email/Password Sign-Up
**What to look for:**
```
📝 Starting sign-up with email: user@example.com
✅ Sign-up successful for: user@example.com
✅ User logged in: user@example.com
```

---

### Scenario 5: Sign-Out
**What to look for:**
```
🚪 Starting sign-out process
📱 Signing out from Google...
✅ Google sign-out successful
🔐 Signing out from Firebase...
✅ Firebase sign-out successful
🚪 User logged out
```

---

## Troubleshooting

### Problem: "No logs appearing"

**Solution:**
1. Make sure you're filtering correctly (check tag names)
2. Press Ctrl+K (Cmd+K on Mac) to clear logs
3. Run app again
4. Check **Verbose** log level in filtering options

**Command:**
```bash
flutter logs --verbose
```

---

### Problem: "Firebase initialization failed"

**What to check:**
1. **internetConnection** - Is device connected?
2. **firebase_options.dart** - Is Firebase config correct?
3. **Google Cloud Console** - Is Firebase project enabled?
4. **Android/iOS** - Check platform-specific configs

**Action:**
```bash
flutter clean
flutter pub get
flutter run
```

---

### Problem: "Google Sign-In initialization failed"

**What to check:**
1. **Google Cloud Project** - OAuth 2.0 credentials configured?
2. **Android SHA-1 fingerprint** - Is it registered?
3. **iOS URL Schemes** - Are they configured?
4. **Internet connection** - Working properly?

**Verify Android:**
```bash
# Get SHA-1 fingerprint
./gradlew signingReport

# Should be registered in Google Cloud Console
```

---

### Problem: "INVALID_CREDENTIAL error"

**What to check:**
1. **App ID** - Matches Google Cloud Console?
2. **OAuth credentials** - Correct Web/Android/iOS setup?
3. **Scopes** - Are they correct?
4. **Package name** - Matches in Firebase?

**Fix Android:**
1. Open `android/app/build.gradle`
2. Check `applicationId` matches Firebase console
3. Run `flutter clean && flutter pub get && flutter run`

---

## Adding Custom Logging

### For Developers
If you want to add logging to your own code:

```dart
import 'package:fashionstore/core/utils/logger.dart';

// In your code
AppLogger.info('Processing order...', tag: 'OrderService');
AppLogger.auth('Verifying user credentials');
AppLogger.error('Failed to load products', tag: 'ProductService', error: exception);
AppLogger.debug('User ID: ${user.id}', tag: 'UserService');
```

### Log Levels
```dart
// Debug (only in development)
AppLogger.debug('Verbose technical details');

// Info (general information)
AppLogger.info('User action completed');

// Warning (something unexpected)
AppLogger.warning('High memory usage detected');

// Error (something failed)
AppLogger.error('Operation failed', error: exception, stackTrace: stackTrace);
```

---

## Performance Considerations

### Logging Overhead
- **Minimal** in production (debug logs disabled)
- ~2-5ms per log call
- No significant impact on app performance

### Production Logging
- Debug logs automatically disabled (`if (kDebugMode)`)
- Error logs still captured for crash reporting
- Can be sent to analytics service

---

## Log Retention

### When Do Logs Clear?
1. App restart
2. Device reboot
3. You clear cache manually

### Manual Clear
```bash
adb logcat -c          # Android
log clear             # iOS
flutter logs --clear  # Both
```

---

## Integration with Crash Reporting

To capture errors in crash reporting services:

```dart
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

// In error handler
AppLogger.error('Something failed', tag: 'MyService', error: exception);
FirebaseCrashlytics.instance.recordError(exception, stackTrace);
```

---

## Security & Privacy

### What's NOT logged
- Passwords
- Private tokens
- Sensitive user data
- Credit card info

### What IS logged
- Email addresses (for user identification)
- Error codes and messages
- Operation success/failure
- User actions (login, logout, sign-up)

### Production
- All sensitive debug info removed
- Only errors and important events logged
- Can be sent to backend for monitoring

---

## Debugging Auth Issues

### Step 1: Check App Startup
```
Look for:
✅ Firebase initialized successfully
✅ Google Sign-In initialized
🎨 Launching app...
```

### Step 2: Check User State
```
Look for:
🔐 AuthProvider initialized
✅ User logged in: [email]
```

### Step 3: Check Sign-In Process
```
Look for complete sequence:
🔑 Starting Google Sign-In
✅ Google account selected
✅ Authentication tokens obtained
✅ Firebase sign-in successful
```

### Step 4: Find Errors
```
Search for: ❌
Check for: Error codes and details
```

### Step 5: Take Screenshot
If reporting a bug, include:
1. Full log output (Filter: `Auth` or `Firebase`)
2. Error code mentioned
3. Steps to reproduce

---

## Common Error Codes

### Firebase Errors
| Code | Meaning | Solution |
|------|---------|----------|
| `INVALID_CREDENTIAL` | Auth failed | Check OAuth setup |
| `NETWORK_ERROR` | No internet | Check connection |
| `OPERATION_NOT_ALLOWED` | Sign-in disabled | Enable in Firebase |
| `USER_DISABLED` | User blocked | Check Firebase console |
| `EMAIL_ALREADY_IN_USE` | Duplicate account | Use different email |
| `WEAK_PASSWORD` | Password too simple | Use stronger password (6+ chars) |

### Google Sign-In Errors
| Code | Meaning | Solution |
|------|---------|----------|
| `SIGN_IN_CANCELLED` | User cancelled | OK, user can retry |
| `SIGN_IN_IN_PROGRESS` | Already signing in | Wait for completion |
| `NETWORK_ERROR` | Connection failed | Check internet |
| `SIGN_IN_FAILED` | Generic error | Check logs for details |

---

## Tips & Tricks

### Quick Filter in Terminal
```bash
# See only auth errors
flutter logs | grep -E "Auth.*ERROR"

# See only failures
flutter logs | grep "❌"

# See only Google events
flutter logs | grep "Google"

# See timeline of events
flutter logs | grep -E "🔑|📱|✅|✅"
```

### Save Logs to File
```bash
flutter logs > logs.txt

# Or with filtering
flutter logs | grep "Auth" > auth_logs.txt
```

### Real-time Monitoring
```bash
# Watch logs continuously
flutter logs --follow

# Follow with grep filter
flutter logs --follow | grep "Auth"
```

---

## Next Steps

1. **Run the app** and look at the logs
2. **Try Google Sign-In** and watch the log sequence
3. **Check for any errors** and note error codes
4. **Report issues** with full log output
5. **Monitor in production** by sending logs to backend

---

**For More Help:**
- Check `LOGGING_FIX_SUMMARY.md` for changes overview
- Check `TECHNICAL_DETAILS.md` for implementation details
- Look at logs when reporting bugs

**Status:** ✅ All systems operational

