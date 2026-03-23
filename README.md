# Adulti

Step confidently into adulthood.

## Android release setup

To build a Play Store release:

1. Create an upload keystore locally.
2. Save the Android signing values in `android/key.properties`.
3. Build the app bundle with `flutter build appbundle --release`.
4. Upload `build/app/outputs/bundle/release/app-release.aab` to Play Console.

`android/key.properties` is ignored by git. Use `android/key.properties.example` as the template.
