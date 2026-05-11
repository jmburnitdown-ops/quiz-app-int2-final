# Quiz App

Quiz App is a Flutter-based mobile quiz system for Integrative Programming. It allows students to create an account, log in, answer programming-related quizzes, view results, earn badges/certificates, and compare scores through a global leaderboard.

## Features

- Student registration and login using Firebase Authentication
- Extended student profile stored in Cloud Firestore
- Multiple quiz categories, including HTML, CSS, JavaScript, Angular, Dart, Flutter, React, Python, C++, and Swift
- Provider-based quiz state management
- Score tracking, badge assignment, and answer review
- Global leaderboard using Firestore data
- Student profile with academic details, latest quiz results, badges, and certificates
- E-certificate viewing/printing support
- Custom app logo, launcher icon, and APK app name
- Security features for authentication, secure storage, validation, and session timeout
- Basic unit tests for the quiz question model

## Tech Stack

- Flutter
- Dart
- Provider
- Firebase Core
- Firebase Authentication
- Cloud Firestore
- Flutter Secure Storage
- Confetti
- PDF and Printing packages

## Project Structure

```text
lib/
  main.dart
  firebase_options.dart
  models/
    question.dart
  providers/
    quiz_provider.dart
  screens/
    login_screen.dart
    category_screen.dart
    quiz_screen.dart
    results_screen.dart
    review_screen.dart
    leaderboard_screen.dart
    profile_screen.dart
    stats_screen.dart
    about_screen.dart
  services/
    certificate_service.dart
    storage_service.dart
  theme/
    app_colors.dart

assets/
  images/
  sounds/

test/
  question_test.dart
```

## Firebase

This project is connected to Firebase project:

```text
quiz-app-int2-final
```

Firebase is used for:

- User authentication
- User profile records
- Quiz scores
- Earned certificates
- Global leaderboard data

## Security Features

The app includes the following security measures:

- Firebase Authentication for account registration and login
- Firebase HTTPS/TLS communication for backend calls
- Firebase-managed password hashing
- Firebase ID token storage using Flutter Secure Storage
- Token refresh during active sessions
- Secure local data cleanup during logout
- 30-minute inactivity session timeout
- Email format validation
- Strong sign-up password requirement: at least 8 characters with uppercase, lowercase, and number
- Required-field validation for registration inputs
- Basic input sanitization before saving profile data to Firestore
- No SharedPreferences storage for sensitive data

The Firebase configuration is stored in:

```text
firebase.json
lib/firebase_options.dart
android/app/google-services.json
```

## Getting Started

Install dependencies:

```bash
flutter pub get
```

Run the app:

```bash
flutter run
```

Run unit tests:

```bash
dart test test/question_test.dart
```

Run Dart analysis:

```bash
dart analyze
```

Build a debug APK:

```bash
flutter build apk --debug
```

Build a release APK:

```bash
flutter build apk --release
```

The generated APK can usually be found in:

```text
build/app/outputs/flutter-apk/
```

## Main Screens

- Login Screen: sign in or create a student account
- Category Screen: select a programming quiz category
- Quiz Screen: answer category questions
- Results Screen: view score, badge, and completion result
- Review Screen: review selected answers
- Leaderboard Screen: view top active student scores
- Profile Screen: view student profile, badges, certificates, and logout
- Stats Screen: view performance analytics

## Testing

The project includes unit tests in:

```text
test/question_test.dart
```

These tests verify the `Question` model stores:

- Question ID
- Question text
- Answer options
- Correct answer index
- Correct answer lookup

Current test status:

```text
5 unit tests passing
```

## Notes

- The app name shown on Android is `Quiz App`.
- The Android launcher icon has been customized.
- Firestore user documents should remain synced with Firebase Auth accounts. If an account is deleted, its Firestore user document should also be deleted or marked inactive so it no longer appears on the leaderboard.
- Firebase Security Rules should be reviewed before production deployment.
