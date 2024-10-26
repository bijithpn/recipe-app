# 🍲 Flutter Recipe App

A comprehensive Flutter Recipe app that enables users to search, view details of recipes, and follow cooking instructions. Users can log in with Firebase authentication for a personalized experience, and their favorite recipes are saved locally using Hive. The app integrates the Spoonacular API to fetch high-quality recipe data, uses Provider for state management, Dio for network requests, and GoRouter for seamless navigation.

## 📱 Features

- **Recipe Browsing and Search**

  - Discover a variety of recipes with filters based on dietary preferences, cuisine type, and ingredients.
  - Search for recipes by name or ingredient with real-time filtering and suggestions.

- **Detailed Recipe View**

  - Access detailed information for each recipe, including:
    - **Ingredients list** with measurements.
    - **Step-by-step cooking instructions** for easy follow-along.
    - **Nutritional information** (if available).
    - **Images and Videos** to visualize the final dish.

- **User Authentication with Firebase**

  - Sign up or log in using Firebase for a personalized experience.
  - Favorites are stored locally with Hive, enabling offline access to saved recipes.

- **Favorites and History**

  - Save favorite recipes for easy access.
  - View recently viewed recipes, even offline.

- **Navigation and State Management**
  - Efficient app navigation with GoRouter, including deep linking.
  - Provider for state management ensures smooth, responsive updates across screens.

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- An IDE like [Android Studio](https://developer.android.com/studio) or [Visual Studio Code](https://code.visualstudio.com/)
- API key from [Spoonacular](https://spoonacular.com/food-api) and Firebase setup.

### Installation

1. **Clone the repository:**

   ```bash
   git clone https://github.com/bijithpn/recipe-app.git
   cd recipe-app
   ```

2. **Install dependencies:**

   ```bash
   flutter pub get
   ```

3. **Set up API keys and Firebase**

   - Sign up at [Spoonacular](https://spoonacular.com/food-api) to get an API key and add it to the environment file or configuration.
   - Configure Firebase authentication by adding your `google-services.json` or `GoogleService-Info.plist` file for Android and iOS.

4. **Run the app:**
   ```bash
   flutter run
   ```

## 📦 Dependencies

- **State Management**: [Provider](https://pub.dev/packages/provider) - for managing app-wide state.
- **Networking**: [Dio](https://pub.dev/packages/dio) - for efficient API calls and error handling.
- **Local Database**: [Hive](https://pub.dev/packages/hive) - to save favorite recipes and user preferences offline.
- **Navigation**: [GoRouter](https://pub.dev/packages/go_router) - for structured navigation and deep linking support.
- **Authentication**: [Firebase Authentication](https://firebase.google.com/docs/auth) - for user login and account management.

## 🗂️ Project Structure

```plaintext
lib/
├── core/                  # store app constants & route data
├── view_model/            # State management providers for recipes, user, and favorites
├── data/                  # Repositories for API and local database handling
│   ├── api/               # Spoonacular API integration with Dio
│   └── model/             # Models for Recipe, Ingredients, and User data
│   └── repositories/      # repositories class
├── view/                  # Screens for search, recipe details, favorites, and more
├── db/                    # Hive database integration
├── utls/                  # utils functions
├── widgets/               # Reusable components for UI
└── main.dart              # Entry point of the application
```

## 📡 API Integration

- **Spoonacular API:**  
  The app uses the [Spoonacular API](https://api.spoonacular.com/) to fetch recipe data, including ingredients, instructions, and images.

  - Base URL: `https://api.spoonacular.com/`
  - Required headers: `Authorization: YOUR_API_KEY`

- _More details on endpoints and parameters can be added here._

## 📸 Screenshots

<img src="https://github.com/bijithpn/recipe-app/blob/dev/screenshots/recipe_app.gif?raw=true" alt="Recipe app" width="300"/>

## 🔧 Contributing

1. Fork the repository.
2. Create a feature branch (`git checkout -b feature/your-feature-name`).
3. Commit your changes (`git commit -am 'Add new feature'`).
4. Push to the branch (`git push origin feature/your-feature-name`).
5. Create a new Pull Request.

## 📜 License

This project is licensed under the MIT License.
