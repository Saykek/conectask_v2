import 'package:conectask_v2/controllers/colegio_controller.dart';
import 'package:conectask_v2/controllers/home_assistant_controller.dart';
import 'package:conectask_v2/controllers/tarea_controller.dart';
import 'package:conectask_v2/controllers/usuario_controller.dart';
import 'package:conectask_v2/models/home_assistant_model.dart';
import 'package:conectask_v2/services/home_assistant_service.dart';
import 'package:conectask_v2/common/theme/app_theme.dart';
import 'package:conectask_v2/common/constants/constant.dart';
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
        ChangeNotifierProvider(create: (_) => ColegioController()),

        // 👉 Añadimos HomeAssistantController como Provider
        Provider(
          create: (_) {
            final model = HomeAssistantModel(
              baseUrl: AppUrlsConstants.baseUrl, // tu instancia HA
              accessToken:
                  "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiIwODI1OGEzN2ZlN2Y0ODgxOGNmYmI0OWU1NmJiM2RmNSIsImlhdCI6MTc2NDQ1NDM0OCwiZXhwIjoyMDc5ODE0MzQ4fQ.iItdBiON4nNhyN3uf8yJtCATGmk_U4NQaTRmXZHqsFw", // token de acceso
              panel: "default", // panel Lovelace
              soloAdmin: true, // restringir a admin
            );
            final service = HomeAssistantService(model);
            return HomeAssistantController(service);
          },
        ),
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
      title: AppThemeConstants.titulo,
      theme: AppTheme.light, // tema claro
      darkTheme: AppTheme.dark, //tema oscuro
      themeMode: ThemeMode.system, // o ThemeMode.light / ThemeMode.dark
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
