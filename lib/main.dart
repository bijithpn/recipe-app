import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'core/core.dart';
import 'data/data.dart';
import 'db/db.dart';
import 'firebase_options.dart';
import 'view_models/view_models.dart';

final getIt = GetIt.instance;
final navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load(fileName: ".env");
  initializeClient();
  await initHive();
  await GetStorage.init();
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
  Hive.registerAdapter(ExtendedIngredientAdapter());
  Hive.registerAdapter(AnalyzedInstructionAdapter());
  Hive.registerAdapter(InstructionStepAdapter());
  Hive.registerAdapter(IngredientAdapter());
  Hive.registerAdapter(EquipmentAdapter());
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
          create: (_) => HomeProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ThemeManager(),
        ),
        ChangeNotifierProvider(
          create: (_) => SearchProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
      ],
      child: ThemeProvider(
        initTheme: themeManager.currentTheme,
        builder: (_, myTheme) {
          return MaterialApp(
            navigatorKey: navigatorKey,
            title: AppStrings.appName,
            theme: myTheme,
            debugShowCheckedModeBanner: false,
            initialRoute: '/',
            onGenerateRoute: RouteGenerator.generateRoute,
          );
        },
      ),
    );
  }
}

// class InitialRouteWidget extends StatelessWidget {
//   const InitialRouteWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final authProvider = Provider.of<AuthProvider>(context, listen: false);
//     String initialRoute = authProvider.getIntialPath(context);
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Navigator.of(context).pushReplacementNamed(initialRoute);
//     });
//     return const SizedBox.shrink();
//   }
// }
