# 🏠 Home Cache

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![GetX](https://img.shields.io/badge/GetX-8C4FFF?style=for-the-badge&logo=getx&logoColor=white)](https://pub.dev/packages/get)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)

**Home Cache** is a comprehensive home management ecosystem designed to help homeowners organize, track, and maintain everything under their roof. From managing appliance warranties to scheduling routine maintenance and storing critical documents, Home Cache is your digital home companion.

---

## 🌟 Key Features

### 📦 Inventory & Appliance Tracking
- **Digital Catalog**: Keep a detailed record of every appliance and piece of home equipment.
- **Warranty Management**: Store purchase dates, serial numbers, and warranty documents to never miss an expiration.
- **Material Logging**: Track paint colors, flooring types, and other materials used in each room for easy matching later.

### 🛠️ Maintenance & Tasks
- **Smart Scheduling**: Pre-set maintenance tasks (e.g., filter changes, HVAC service) with recurring reminders.
- **Task Management**: Create and track one-off home improvement projects or repairs.
- **Health Checks**: Monitor the "health" of your home systems through integrated status boards.

### 📄 Secure Document Vault
- **Digital Storage**: Store insurance policies, floor plans, and receipts securely.
- **Room-Based Organization**: Link documents directly to specific rooms or appliances for instant retrieval.

### 🤝 Service Provider Directory
- **Contacts**: Keep your preferred plumbers, electricians, and contractors in one place.
- **Service History**: Track when providers last visited and what work was performed.

### 🤖 AI Assistance
- **AI-Powered Insights**: Integrated AI chat to help with home maintenance questions and troubleshooting.

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (3.0.0 or higher)
- [Dart SDK](https://dart.dev/get-dart)
- Android Studio / Xcode / VS Code with Flutter extensions

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-username/home_cache.git
   cd home_cache
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Set up environment variables**
   Create a `.env` file in the root directory and add your API keys (e.g., Google Maps, AI services):
   ```env
   GOOGLE_MAPS_API_KEY=your_key_here
   AI_SERVICE_URL=your_url_here
   ```

4. **Run the application**
   ```bash
   flutter run
   ```

---

## 🏗️ Project Structure

```text
lib/
├── config/             # Theme, routes, and app configuration
├── constants/          # App-wide constants and assets paths
├── controller/         # GetX controllers (Business logic)
├── model/              # Data models and API wrappers
├── services/           # External service integrations
├── utils/              # Helper functions and utilities
└── view/               # UI components and screens
    ├── auth/           # Authentication screens
    └── home/           # Dashboard, scheduling, and feature screens
```

---

## 🛠️ Tech Stack

- **Framework:** [Flutter](https://flutter.dev)
- **State Management:** [GetX](https://pub.dev/packages/get)
- **Local Storage:** [Shared Preferences](https://pub.dev/packages/shared_preferences)
- **Maps Integration:** [Google Maps Flutter](https://pub.dev/packages/google_maps_flutter)
- **Styling:** [Flutter ScreenUtil](https://pub.dev/packages/flutter_screenutil) for responsive UI
- **Networking:** [HTTP](https://pub.dev/packages/http)
- **Environment:** [Flutter Dotenv](https://pub.dev/packages/flutter_dotenv)

---

## 🤝 Contributing

Contributions are welcome! If you have a feature request or bug report, please open an issue. To contribute code:

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git checkout -b feature/AmazingFeature`)
5. Open a Pull Request

---

## 📄 License

Distributed under the MIT License. See `LICENSE` for more information.

---

Project Link: [https://github.com/your-username/home_cache](https://github.com/Shougotmollik/home_cache)

<p align="center">
  Built with ❤️ for better home management.
</p>
