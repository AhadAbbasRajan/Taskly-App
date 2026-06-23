# Taskly - Flutter Task Management App

Welcome to the repository for **Taskly**, a professionally designed, lightweight, and beautifully simple task management application built with Flutter.

![Taskly Banner](https://via.placeholder.com/800x200.png?text=Taskly+-+Manage+Your+Tasks+Efficiently)

## 🚀 Key Features

* **Complete User Authentication:** Dedicated screens for user registration and secure login.
* **Session Management:** The system records the currently active user to maintain their login session upon app restart.
* **Intelligent Routing:** A splash screen initializes on startup, delays for two seconds, checks the user's current login state, and automatically navigates to either the task dashboard or the login screen.
* **Personalized Data:** Each user's task list is uniquely tied to their specific username.
* **Full CRUD Operations:** Users have the ability to add new tasks, toggle their completion status (which strikes through the text), and permanently delete tasks from their list.
* **Local Persistence:** All user credentials and task data are saved directly to the device utilizing `SharedPreferences`.
* **JSON Serialization:** The core `Task` model is equipped with factory methods to effortlessly convert task data to and from JSON format for local storage compatibility.

## 🎨 Branding & Assets

To ensure the application builds successfully and looks beautiful, you must configure your image assets correctly. 

* The application prominently displays its branding on the splash, login, and signup screens.
* You must include the specific image asset named verbatim as `logo.png`. 
* Ensure this file is placed precisely in the `assets/images/` directory.

Add the following to your `pubspec.yaml` to register the assets:
```yaml
flutter:
  assets:
    - assets/images/logo.png
```

## 🛠️ Technical Stack & Architecture

* **UI Framework:** Built entirely with Flutter and standard Material Design components.
* **Language:** Dart.
* **State Management:** Utilizes Flutter's built-in `StatefulWidget` for dynamic UI updates.
* **Storage:** Relies on the `shared_preferences` package for lightweight, asynchronous key-value storage.
* **Entry Point:** The application initializes via `main.dart`, running `MyApp` which defaults to the `SplashScreen`.

## 📦 Getting Started

### Prerequisites

Ensure you have the following installed on your local machine:
* [Flutter SDK](https://flutter.dev/docs/get-started/install)
* Dart SDK (included with Flutter)
* IDE (Android Studio, VS Code, or IntelliJ) with Flutter plugins installed.

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/taskly.git
   cd taskly
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   Ensure an emulator is running or a physical device is connected.
   ```bash
   flutter run
   ```

## 📂 Project Structure

```text
lib/
│
├── main.dart             # App entry point
├── models/
│   └── task.dart         # Task data model with JSON serialization
├── screens/
│   ├── splash_screen.dart # Initial loading & routing logic
│   ├── login_screen.dart  # User authentication
│   ├── signup_screen.dart # User registration
│   └── home_screen.dart   # Task dashboard & CRUD UI
└── utils/
    └── storage_helper.dart# SharedPreferences wrapper
```

## 🤝 Contributing

Contributions, issues, and feature requests are welcome! Feel free to check the [issues page](https://github.com/yourusername/taskly/issues).

## 📄 License

This project is licensed under the MIT License.
