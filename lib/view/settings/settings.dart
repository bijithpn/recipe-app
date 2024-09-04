import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import '../../core/core.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettinsgPageState();
}

class _SettinsgPageState extends State<SettingsPage> {
  String appVersion = "1.0.0";
  bool isDarkTheme = false;
  bool notificationsEnabled = true;

  String selectedLanguage = 'English';
  Box? settingsBox;
  final shorebirdCodePush = ShorebirdCodePush();

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
    final ThemeManager themeManager =
        Provider.of<ThemeManager>(context, listen: false);
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
                          Routes.cms,
                          arguments: {
                            'title': "About Us",
                            'content': AppStrings.aboutUs
                          },
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
                          Routes.cms,
                          arguments: {
                            'title': "Privacy policy",
                            'content': AppStrings.privacy
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
                          Routes.cms,
                          arguments: {
                            'title': 'Terms of Service',
                            'content': AppStrings.terms
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
        "V$appVersion",
        style: Theme.of(context)
            .textTheme
            .bodyLarge!
            .copyWith(fontWeight: FontWeight.bold, letterSpacing: .5),
      ),
    );
  }
}
