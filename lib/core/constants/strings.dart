class AppStrings {
  static const String appName = "Recipe App";
  static const String noInternet =
      'No internet connection. Please check your connection.';
  static const String connectionTimeout =
      'Connection Timeout. Please check your internet connection.';
  static const String requestCancel = 'Request Cancelled. Please try again.';
  static const String error =
      'An unexpected error occurred. Please try again later.';
  static const String noRecipe =
      'No recipes available right now. We\'re working on adding more recipes soon!';
  static const String saveEmpty =
      'Remember to save your favorite recipes for easy access later! Just tap the save icon. 🍽️';
  static const String onBoardingTitle1 = 'Delicious Recipes';
  static const String onBoardingSubTitle1 =
      "Explore a world of flavors with thousands of recipes at your fingertips. Whether you're a beginner or a seasoned chef, we have something for everyone.";
  static const String onBoardingTitle2 = 'Get Personalized Recipe Suggestions';
  static const String onBoardingSubTitle2 =
      'Tell us your preferences, and we’ll tailor recipe recommendations just for you. From dietary restrictions to favorite cuisines, we’ve got you covered.';
  static const String onBoardingTitle3 = 'Save & Share Your Favorite Recipes';
  static const String onBoardingSubTitle3 =
      'Easily save your go-to recipes and share them with friends and family. Cooking has never been so social!';
  static const String terms = '''
<body>
    <p><strong>User Obligations:</strong> Users must use this application responsibly, especially when cooking recipes found within the app.</p>
    <p><strong>Content Ownership:</strong> The recipes and images provided in the app are sourced from the Spoonacular API. This application merely facilitates access to these resources.</p>
    <p><strong>Limitations of Liability:</strong> We are not responsible for any errors, omissions, or consequences arising from the use of the recipes provided by the app.</p>
    <p><strong>Modifications:</strong> Only the developer, Bijith PN, is authorized to make modifications to this application.</p>
    <p><strong>Governing Law:</strong> The governing law is not specified.</p>
</body>
''';
  static const String privacy = '''
<body>
    <p>Your privacy is important to us. This Privacy Policy outlines how we handle your data.</p>
    <p><strong>Data Collection:</strong> We use a local database to save favorite recipes and Firebase to save user login details.</p>
    <p><strong>Data Usage:</strong> We use Firebase Analytics to provide better suggestions based on user activity.</p>
    <p><strong>Third-Party Services:</strong> In addition to using Spoonacular for recipes, we collect user details for login purposes through Firebase and use favorite dishes for recommendations.</p>
    <p><strong>User Rights:</strong> You can delete your data by deleting your account.</p>
    <p><strong>Security Measures:</strong> Your data is securely protected by Firebase, a Google service known for its high-security standards.</p>
</body>
''';
  static const String aboutUs = '''
<body>
    <p><strong>App Name:</strong> Recipe App</p>
    <p>Recipe App is designed to help users explore and discover various cooking recipes. Users can search or view different recipes, see detailed instructions, and get inspired to cook something new.</p>
    <p><strong>Features:</strong></p>
    <ul>
        <li>Recommended Recipes</li>
        <li>Search by Ingredient</li>
        <li>Search by Recipe</li>
        <li>Save Favorite Recipes</li>
        <li>Other Basic App Features</li>
    </ul>
    <p>This is a personal project created by Bijith PN. If you have any questions or need support, please contact us at <a href="mailto:bijithpn@gmail.com">bijithpn@gmail.com</a>.</p>
</body>
''';
}

class StorageStrings {
  static String recipeDB = 'recipes';
  static String settingDB = 'settings';
  static String firstTime = 'firstLunch';
  static String userData = 'userData';
}
