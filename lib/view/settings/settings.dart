import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:hive/hive.dart';
import '../../core/core.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettinsgPageState();
}

class _SettinsgPageState extends State<SettingsPage> {
  final String aboutUs = '''
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

  String appVersion = "1.0.0";
  bool isDarkTheme = false;
  bool notificationsEnabled = true;
  final String privacy = '''
<body>
    <p>Your privacy is important to us. This Privacy Policy outlines how we handle your data.</p>
    <p><strong>Data Collection:</strong> We use a local database to save favorite recipes and Firebase to save user login details.</p>
    <p><strong>Data Usage:</strong> We use Firebase Analytics to provide better suggestions based on user activity.</p>
    <p><strong>Third-Party Services:</strong> In addition to using Spoonacular for recipes, we collect user details for login purposes through Firebase and use favorite dishes for recommendations.</p>
    <p><strong>User Rights:</strong> You can delete your data by deleting your account.</p>
    <p><strong>Security Measures:</strong> Your data is securely protected by Firebase, a Google service known for its high-security standards.</p>
</body>
''';

  String selectedLanguage = 'English';
  Box? settingsBox;
  final shorebirdCodePush = ShorebirdCodePush();
  final String terms = '''
<body>
    <p><strong>User Obligations:</strong> Users must use this application responsibly, especially when cooking recipes found within the app.</p>
    <p><strong>Content Ownership:</strong> The recipes and images provided in the app are sourced from the Spoonacular API. This application merely facilitates access to these resources.</p>
    <p><strong>Limitations of Liability:</strong> We are not responsible for any errors, omissions, or consequences arising from the use of the recipes provided by the app.</p>
    <p><strong>Modifications:</strong> Only the developer, Bijith PN, is authorized to make modifications to this application.</p>
    <p><strong>Governing Law:</strong> The governing law is not specified.</p>
</body>
''';

  ThemeManager themeManager = ThemeManager();

  @override
  void initState() {
    super.initState();
    initHive();
    shorebirdCodePush.currentPatchNumber().then((value) => setState(() {
          if (value != null) {
            appVersion = value.toString();
          }
        }));
  }

  Future<void> initHive() async {
    settingsBox = await Hive.openBox(StorageStrings.settingDB);
    setState(() {
      isDarkTheme = settingsBox?.get('isDarkTheme', defaultValue: false);
      notificationsEnabled =
          settingsBox?.get('notificationsEnabled', defaultValue: true);
      selectedLanguage =
          settingsBox?.get('selectedLanguage', defaultValue: 'English');
    });
  }

  Future<void> checkForUpdates() async {
    final isUpdateAvailable =
        await shorebirdCodePush.isNewPatchAvailableForDownload();
    if (isUpdateAvailable) {
      await shorebirdCodePush.downloadUpdateIfAvailable();
    }
  }

  @override
  Widget build(BuildContext context) {
    final headingStyle = Theme.of(context)
        .textTheme
        .bodyLarge!
        .copyWith(fontWeight: FontWeight.bold);
    final subHeadingStyle = Theme.of(context)
        .textTheme
        .bodyMedium!
        .copyWith(fontWeight: FontWeight.bold);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        title: Text(
          "Settings",
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: ThemeSwitcher.switcher(
          clipper: const ThemeSwitcherCircleClipper(),
          builder: (context, switcher) {
            return SettingsList(
              sections: [
                SettingsSection(
                  title: Text(
                    'General',
                    style: headingStyle,
                  ),
                  tiles: [
                    SettingsTile.navigation(
                      title: Text(
                        'Language',
                        style: subHeadingStyle,
                      ),
                      leading:
                          Icon(Icons.language, color: ColorPalette.primary),
                      onPressed: (context) {},
                    ),
                    SettingsTile.switchTile(
                        leading: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          transitionBuilder:
                              (Widget child, Animation<double> animation) {
                            return FadeTransition(
                                opacity: animation, child: child);
                          },
                          child: Icon(
                              isDarkTheme ? Icons.dark_mode : Icons.light_mode,
                              color: ColorPalette.primary),
                        ),
                        initialValue: isDarkTheme,
                        onToggle: (value) {
                          themeManager.toggleTheme(value);
                          switcher.changeTheme(
                              theme: themeManager.currentTheme);
                          setState(() {
                            isDarkTheme = value;
                            settingsBox?.put('isDarkTheme', value);
                          });
                        },
                        title: Text(
                          "Theme",
                          style: subHeadingStyle,
                        )),
                    SettingsTile.switchTile(
                        leading: Icon(Icons.notifications,
                            color: ColorPalette.primary),
                        initialValue: notificationsEnabled,
                        onToggle: (value) {
                          setState(() {
                            notificationsEnabled = value;
                            settingsBox?.put('notificationsEnabled', value);
                          });
                        },
                        title: Text(
                          "Notifications",
                          style: subHeadingStyle,
                        )),
                    SettingsTile.navigation(
                      leading: Icon(Icons.storage, color: ColorPalette.primary),
                      title: Text(
                        'Clear Cache',
                        style: subHeadingStyle,
                      ),
                      onPressed: (context) {},
                    ),
                  ],
                ),
                SettingsSection(
                  title: Text(
                    'App settings',
                    style: headingStyle,
                  ),
                  tiles: [
                    SettingsTile.navigation(
                      leading: Icon(Icons.description_outlined,
                          color: ColorPalette.primary),
                      title: Text(
                        'About Us',
                        style: subHeadingStyle,
                      ),
                      onPressed: (context) {
                        Navigator.pushNamed(
                          context,
                          '/cms',
                          arguments: {'title': "About Us", 'content': aboutUs},
                        );
                      },
                    ),
                    SettingsTile.navigation(
                      leading: Icon(Icons.admin_panel_settings_outlined,
                          color: ColorPalette.primary),
                      title: Text(
                        'Privacy Policy',
                        style: subHeadingStyle,
                      ),
                      onPressed: (context) {
                        Navigator.pushNamed(
                          context,
                          '/cms',
                          arguments: {
                            'title': "Privacy policy",
                            'content': privacy
                          },
                        );
                      },
                    ),
                    SettingsTile.navigation(
                      leading: Icon(Icons.gavel_outlined,
                          color: ColorPalette.primary),
                      title: Text(
                        'Terms of Service',
                        style: subHeadingStyle,
                      ),
                      onPressed: (context) {
                        Navigator.pushNamed(
                          context,
                          '/cms',
                          arguments: {
                            'title': 'Terms of Service',
                            'content': terms
                          },
                        );
                      },
                    ),
                    SettingsTile.navigation(
                      leading: Icon(Icons.system_update,
                          color: ColorPalette.primary),
                      title: Text(
                        'Check for Update',
                        style: subHeadingStyle,
                      ),
                      onPressed: (context) async {
                        await checkForUpdates();
                      },
                    ),
                  ],
                ),
              ],
            );
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Text(
        "V${appVersion}",
        style: Theme.of(context)
            .textTheme
            .bodyLarge!
            .copyWith(fontWeight: FontWeight.bold, letterSpacing: .5),
      ),
    );
  }
}
