# Flutter Screen Off App

A Flutter app for Android that lets you:
- **Lock Device**: Instantly lock your screen.
- **Fake Screen Off**: Launch a full-screen blackout overlay (tap anywhere to wake).

## Concept

This app gives you quick control over your device’s screen state:
1. **Lock Device**: Uses Android’s Device Admin API to lock the screen.
2. **Fake Screen Off**: Displays a dimmed activity that mimics a turned-off screen.

## Enabling Permissions (Android Only)

1. Open the app—on the main screen you’ll see an **Enable Admin** button just below the title.  
2. Tap **Enable Admin**.  
3. In the Android system dialog that appears, tap **Activate** to grant Device Admin rights.  
4. (Optional) To confirm, go to your device’s **Settings** → **Security** (or **Biometrics & security**) → **Device admin apps** and ensure “Flutter Screen Off App” is toggled **ON**.

> ⚠️ **Note:** This feature only works on Android devices.
