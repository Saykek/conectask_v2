import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../controllers/home_assistant_controller.dart';

class HomeAssistantView extends StatefulWidget {
  final HomeAssistantController controller;
  final String rolUsuario; // "admin" o "niño"

  const HomeAssistantView({
    Key? key,
    required this.controller,
    required this.rolUsuario,
  }) : super(key: key);

  @override
  State<HomeAssistantView> createState() => _HomeAssistantViewState();
}

class _HomeAssistantViewState extends State<HomeAssistantView> {
  late final WebViewController _webViewController;

  @override
  void initState() {
    super.initState();

    // Inicializamos el controlador de WebView
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            debugPrint("Cargando: $url");
          },
          onPageFinished: (url) {
            debugPrint("Finalizado: $url");
          },
          onWebResourceError: (error) {
            debugPrint("Error: ${error.description}");
          },
        ),
      )
      ..loadRequest(
      Uri.parse(widget.controller.obtenerUrlLovelace()),
    headers: {
      "Authorization": "Bearer ${widget.controller.service.model.accessToken}",
    },
  );
  }


  @override
  Widget build(BuildContext context) {
    // Validar permisos
    if (!widget.controller.puedeAcceder(widget.rolUsuario)) {
      return const Scaffold(
        body: Center(
          child: Text(
            "Acceso restringido: solo administradores pueden ver el módulo de Casa",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Casa - Home Assistant"),
      ),
      body: WebViewWidget(controller: _webViewController),
    );
  }
}