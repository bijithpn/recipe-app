import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'core/core.dart';
import 'data/data.dart';
import 'db/db.dart';
import 'view_models/view_models.dart';

final getIt = GetIt.instance;
final navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  initializeClient();
  await initHive();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  FlutterError.onError = (FlutterErrorDetails details) {
    debugPrint('Flutter Error : ${details.exception}');
    debugPrint('Flutter StackTrace :${details.stack}');
  };
  runApp(MyApp());
}

Future<void> initHive() async {
  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  Hive.registerAdapter(RecipeDBAdapter());
  await Hive.openBox(StorageStrings.settingDB);
}

void initializeClient() async {
  final apiClient = ApiClient();
  getIt.registerSingleton<RecipeDatabase>(RecipeDatabase.instance);
  getIt.registerSingleton<ApiClient>(apiClient);
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final ThemeManager themeManager = ThemeManager();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => HomeProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => DetailsProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => SearchProvider(),
          ),
        ],
        child: ThemeProvider(
            initTheme: themeManager.currentTheme,
            builder: (_, myTheme) {
              return MaterialApp(
                navigatorKey: navigatorKey,
                title: 'Recipe App',
                theme: myTheme,
                debugShowCheckedModeBanner: false,
                initialRoute: '/',
                onGenerateRoute: RouteGenerator.generateRoute,
              );
            }));
  }
}
