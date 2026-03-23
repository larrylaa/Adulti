# Firebase Setup Guide — Adulti

This repo is wired to Firebase Auth and Firestore in the app code.
The app now uses a username + password screen that signs users into Firebase
Auth with an internal email alias and stores each user's stats in `users/{uid}`.

## What is already implemented

- `lib/main.dart` initializes Firebase.
- `lib/features/auth/auth_screen.dart` handles username/password sign-in and account creation.
- `lib/services/firestore_database_service.dart` reads and writes Firestore docs.
- `lib/providers/user_stats_provider.dart` uses the Firebase user id instead of a mock uid.
- `android/app/build.gradle.kts` applies the Google Services plugin.

## What you still need to do

### 1. Create the Firebase project

1. Open the [Firebase Console](https://console.firebase.google.com).
2. Create a project for Adulti.
3. Disable Google Analytics unless you want it.

### 2. Register the app platforms

Use the exact ids your Flutter project builds with.

- Android package name: `com.example.adulti`
- iOS bundle id: check `ios/Runner/Info.plist` and your Xcode Runner settings

Download and place the client config files here:

- `android/app/google-services.json`
- `ios/Runner/GoogleService-Info.plist`

If you want web support, also generate `lib/firebase_options.dart` with FlutterFire.

### 3. Enable Authentication

This app currently uses username + password on the UI, backed by Firebase email/password internally.

1. Go to Firebase Console → Authentication.
2. Enable the Email/Password sign-in provider.

The app converts usernames to an internal Firebase email alias, so you do not need to expose real email addresses in the UI.

### 4. Create Firestore

1. Open Firestore Database in the Firebase Console.
2. Create the database in your preferred region.
3. Start in production mode if possible.

The app stores one document per user:

- Collection: `users`
- Document id: Firebase Auth uid

### 5. Set Firestore security rules

Use this as the baseline rule set:

```text
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

This keeps each user isolated to their own document.

## Credentials and config guidance

- `google-services.json` and `GoogleService-Info.plist` are client config files, not secrets.
- Do not commit Firebase service account keys or Admin SDK JSON files into this app.
- Do not hardcode server credentials in Dart files.
- If you later change the package name or bundle id, regenerate the Firebase config files.

## Username rules in the app

- Username must be 3 to 20 characters.
- Allowed characters are letters, numbers, and underscore.
- The app lowercases usernames before converting them to Firebase's internal email alias.

Example:

- Username: `Larry_12`
- Internal Firebase email: `larry_12@adulti.local`

## Refresh steps after setup

After adding the Firebase files in the console, run:

```bash
flutter pub get
flutter analyze
```

Then rebuild the app so Android picks up the Google Services config.

## Security notes

- Keep Firestore rules restrictive.
- If you add email/password or Google sign-in later, keep the same user-scoped document pattern.
- If you add Cloud Functions, keep privileged writes on the server.
- Anonymous auth is fine for MVP, but you should add account linking or recovery before storing important production data.

## If you want web support later

Use FlutterFire to generate `lib/firebase_options.dart` and wire it into Firebase initialization.
The current setup is enough for Android and iOS once the platform config files are in place.
