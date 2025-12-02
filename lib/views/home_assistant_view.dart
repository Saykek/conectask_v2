import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import '../common/constants/constant.dart';
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
  WebViewController? _webViewController;

  @override
  void initState() {
    super.initState();

    if (!kIsWeb) {
      if (WebViewPlatform.instance == null) {
        if (defaultTargetPlatform == TargetPlatform.android) {
          WebViewPlatform.instance = AndroidWebViewPlatform();
        } else if (defaultTargetPlatform == TargetPlatform.iOS) {
          WebViewPlatform.instance = WebKitWebViewPlatform();
        }
      }

      _webViewController = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(const Color(0x00000000))
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageStarted: (url) => debugPrint(AppMessagesConstants.msgCargando),
            onPageFinished: (url) =>
                debugPrint(AppMessagesConstants.msgFinalizado),
            onWebResourceError: (error) =>
                debugPrint("${AppMessagesConstants.msgErrorCarga}: ${error.description}"),
          ),
        )
        ..loadRequest(
          Uri.parse(widget.controller.obtenerUrlLovelace()),
          headers: {
            AppConstants.headerAuthorization:
                "${AppConstants.bearerPrefix}${widget.controller.service.model.accessToken}",

          },
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.controller.puedeAcceder(widget.rolUsuario)) {
      return const Scaffold(
        body: Center(
          child: Text(
            AppMessagesConstants.msgAccesoRestringido,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    if (kIsWeb) {
      return  Scaffold(
        appBar: AppBar(title: Text(AppMessagesConstants.tituloCasa)),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(AppIconsConstants.iconCasa, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                AppMessagesConstants.msgSoloMovil,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      );
    }

    if (_webViewController == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text(AppMessagesConstants.tituloCasa)),
      body: WebViewWidget(controller: _webViewController!),
    );
  }
}
