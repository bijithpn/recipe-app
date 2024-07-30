import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
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
  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  Hive.registerAdapter(RecipeDBAdapter());
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  FlutterError.onError = (FlutterErrorDetails details) {
    debugPrint('Flutter Error : ${details.exception}');
    debugPrint('Flutter StackTrace :${details.stack}');
  };
  runApp(const MyApp());
}

initializeClient() async {
  final apiClient = ApiClient();
  getIt.registerSingleton<RecipeDatabase>(RecipeDatabase.instance);
  getIt.registerSingleton<ApiClient>(apiClient);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: 'Recipe App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: ColorPalette.primary),
          useMaterial3: true,
          scaffoldBackgroundColor: ColorPalette.scaffoldBg,
          appBarTheme: AppBarTheme(
              backgroundColor: ColorPalette.scaffoldBg,
              foregroundColor: ColorPalette.scaffoldBg,
              surfaceTintColor: ColorPalette.scaffoldBg,
              elevation: 0,
              scrolledUnderElevation: 0),
          textTheme: GoogleFonts.poppinsTextTheme(),
        ),
        initialRoute: '/',
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );
  }
}
