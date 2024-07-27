import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:recipe_app/core/constants/api_config.dart';
import 'package:recipe_app/core/constants/colors.dart';
import 'package:recipe_app/data/services/api_service.dart';
import 'package:recipe_app/view/home/home.dart';
import 'package:recipe_app/view_models/details_provider.dart';
import 'package:recipe_app/view_models/home_provider.dart';

final getIt = GetIt.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    initData();
  }

  initData() async {
    final apiClient = ApiClient();
    apiClient.initialize(
        ApiConfig.baseUrl, dotenv.env['SPOONACULAR_KEY'] ?? '');
    getIt.registerSingleton<ApiClient>(apiClient);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ApiClient>(create: (_) => ApiClient()),
        ChangeNotifierProvider(
          create: (context) => HomeProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => DetailsProvider(),
        ),
      ],
      child: MaterialApp(
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
        home: const HomeScreen(),
      ),
    );
  }
}
