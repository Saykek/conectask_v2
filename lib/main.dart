import 'package:conectask_v2/controllers/colegio_controller.dart';
import 'package:conectask_v2/controllers/tarea_controller.dart';
import 'package:conectask_v2/controllers/usuario_controller.dart';
import 'package:conectask_v2/theme/app_theme.dart';
import 'package:conectask_v2/views/login_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar Firebase según la plataforma
  if (kIsWeb) {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.web);
  } else {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TareaController()),
        ChangeNotifierProvider(create: (_) => UsuarioController()), 
        ChangeNotifierProvider(create: (_) => ColegioController(),), 
       
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Conectask',
      theme: AppTheme.light,          // tema claro
      darkTheme: AppTheme.dark,       //tema oscuro (si lo defines)
      themeMode: ThemeMode.system,    // o ThemeMode.light / ThemeMode.dark
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es', 'ES'), // español
        Locale('en', 'US'), // inglés opcional
      ],
      home: const LoginView(),
    );
  }
}
