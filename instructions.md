# Firebase Setup Guide — Adulti

Deprecated. Use [firebase_instructions.md](firebase_instructions.md) for the current app-specific setup steps.

This document is the complete blueprint for wiring real Firebase (Auth + Firestore)
into the Adultin app. The mock database layer was designed to make this a
**near-zero-friction swap**. Follow these steps in order.

## Prerequisites

## Step 1 — Create a Firebase Project

1. Go to [https://console.firebase.google.com](https://console.firebase.google.com)
2. Click **Add project** → name it `adultin-prod` (or similar)
3. Disable Google Analytics (optional for MVP)
4. Click **Continue** until the project is created

## Step 2 — Register Your App Platforms

### Android

1. In the Firebase Console → Project Overview → Add app → Android
2. Use the package name from `android/app/build.gradle.kts`: `com.example.adulti`

- Rename it to something like `com.yourdomain.adulti` for production

3. Download `google-services.json` → place it at `android/app/google-services.json`

### iOS

1. Add app → iOS
2. Use the Bundle ID from `ios/Runner/Info.plist` (default: `com.example.adultin`)
3. Download `GoogleService-Info.plist` → place it inside `ios/Runner/`
4. Open Xcode → drag the plist into the Runner target (ensure "Copy items if needed" is checked)

## Step 3 — Configure FlutterFire

Run this from the project root. It auto-configures all platforms:

```bash
flutterfire configure --project=adultin-prod
```

This generates `lib/firebase_options.dart` automatically.

## Step 4 — Add Firebase Packages

In `pubspec.yaml`, add under `dependencies`:

```yaml
firebase_core: ^3.6.0
firebase_auth: ^5.3.1
cloud_firestore: ^5.4.3
```

Then run:

```bash
flutter pub get
```

## Step 5 — Initialize Firebase in main.dart

Replace `lib/main.dart` `main()` function:

```dart
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const ProviderScope(
      child: AdultinApp(),
    ),
  );
}
```

## Step 6 — Create FirestoreDatabaseService

Create a new file `lib/services/firestore_database_service.dart`:

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'database_service.dart';

class FirestoreDatabaseService implements DatabaseService {
  final _db = FirebaseFirestore.instance;

  @override
  Future<void> updateUserStats(String uid, Map<String, dynamic> statsMap) async {
    await _db
        .collection('users')
        .doc(uid)
        .set(statsMap, SetOptions(merge: true));
  }

  @override
  Future<Map<String, dynamic>?> getUserStats(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    return doc.exists ? doc.data() : null;
  }
}
```

## Step 7 — Swap the Database Provider

In `lib/providers/user_stats_provider.dart`, replace:

```dart
// BEFORE (mock)
final _db = MockDatabaseService();
```

with:

```dart
// AFTER (real Firestore)
final _db = FirestoreDatabaseService();
```

That's the **only change needed** in the entire provider/model layer.

## Step 8 — Enable Anonymous Auth (Recommended for MVP)

Instead of building a full auth flow immediately, use Anonymous Auth as a bridge:

1. Firebase Console → Authentication → Sign-in method → Anonymous → Enable
2. Add to `main()` before `runApp`:

```dart
import 'package:firebase_auth/firebase_auth.dart';

final user = await FirebaseAuth.instance.signInAnonymously();
// user.user!.uid replaces 'mock_uid' throughout the app
```

3. Replace every instance of `kMockUid` with a provider that reads the current user's UID:

```dart
// lib/providers/auth_provider.dart
final authUidProvider = StreamProvider<String?>((ref) {
  return FirebaseAuth.instance.authStateChanges()
      .map((user) => user?.uid);
});
```

Then in `UserStatsNotifier`, inject the uid as a dependency rather than using the constant.

## Step 9 — Firestore Security Rules

In Firebase Console → Firestore → Rules, paste:

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

This ensures each user can only read/write their own data.

## Step 10 — Build a Proper Auth Screen (Future)

When you're ready to replace anonymous auth with real accounts, create:

```
lib/features/auth/
  auth_gate.dart         # StreamBuilder on authStateChanges; routes to splash or onboarding
  login_screen.dart      # Email/password + Google Sign-In
  register_screen.dart   # Registration form
```

The `AppRouter` gains two new routes (`/login`, `/register`) and `auth_gate.dart`
becomes the `initialRoute`.

## Summary of Files to Touch

| File                                           | Change                                                          |
| ---------------------------------------------- | --------------------------------------------------------------- |
| `pubspec.yaml`                                 | Add `firebase_core`, `firebase_auth`, `cloud_firestore`         |
| `lib/main.dart`                                | Initialize Firebase, add async to `main()`                      |
| `lib/firebase_options.dart`                    | Auto-generated by FlutterFire CLI                               |
| `lib/services/firestore_database_service.dart` | **New file**                                                    |
| `lib/providers/user_stats_provider.dart`       | 1-line swap: `MockDatabaseService` → `FirestoreDatabaseService` |
| `android/app/google-services.json`             | **New file** (from Firebase Console)                            |
| `ios/Runner/GoogleService-Info.plist`          | **New file** (from Firebase Console)                            |

**Total app code changes: 1 line.** Everything else is configuration.
