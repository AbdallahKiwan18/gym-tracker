# 🏋️‍♂️ Gym Tracker App

A comprehensive, offline-first Flutter application designed to help you track your gym workouts, log your progress, and stay consistent with your fitness goals.

## ✨ Features

- **🎯 Structured Workout Plans**: Pre-built categories for Push, Pull, Leg, and CrossFit days.
- **📚 Exercise Library**: A comprehensive library of exercises complete with integrated YouTube video tutorials.
- **📝 Automatic Workout Logging**: Log your sets, reps, and weights easily. The app remembers your last workout so you can see your previous stats while training.
- **🗑️ Manage Logs**: Added the ability to completely delete your sets and recorded workouts after saving them.
- **📊 Progress Tracking**: Visual charts to compare your performance month over month and week over week to clearly track your improvement.
- **💾 Local Storage**: Entirely offline! Uses a local SQLite database for instant access and data persistence.
- **🚀 State Management**: Architected cleanly using `flutter_bloc` for robust state management.


## 🛠️ Technology Stack

- **Framework**: [Flutter](https://flutter.dev/)
- **Language**: Dart
- **State Management**: `flutter_bloc`
- **Database**: `sqflite` (Local Database)

## 🚀 Getting Started

Follow these steps to run the application locally on your machine.

### Prerequisites
- Flutter SDK installed
- Android Studio or Xcode (for iOS)

### Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/AbdallahKiwan18/gym-tracker.git
   ```
2. Navigate to the project directory:
   ```bash
   cd gym-tracker
   ```
3. Get the packages:
   ```bash
   flutter pub get
   ```
4. Run the app:
   ```bash
   flutter run
   ```

## 📦 Generating iOS App (IPA)
This repository includes a GitHub Action to automatically build an unsigned `.ipa` for iOS.
1. Push your changes to the `main` branch.
2. Go to the **Actions** tab on GitHub.
3. Download the `gym-tracker-ipa` artifact.
4. Sideload it to your iOS device using tools like **Scarlet**, **AltStore**, or **Sideloadly**.

---
*Built with Kiwan's touch*
