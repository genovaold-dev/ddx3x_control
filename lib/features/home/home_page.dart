import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..enableZoom(true)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) async {
            final uri = Uri.parse(request.url);

            debugPrint('LINK APERTO: ${request.url}');

            // Link speciali: email, telefono, app esterne
            if (uri.scheme != 'http' && uri.scheme != 'https') {
              try {
                await launchUrl(
                  uri,
                  mode: LaunchMode.externalApplication,
                );
              } catch (e) {
                debugPrint('Errore apertura link: $e');
              }

              return NavigationDecision.prevent;
            }

            // Rimane dentro l'app il sito DDX3X
            if (uri.host.contains('ddx3x.it')) {
              return NavigationDecision.navigate;
            }

            // Tutti gli altri siti esterni
            try {
              await launchUrl(
                uri,
                mode: LaunchMode.externalApplication,
              );
            } catch (e) {
              debugPrint('Errore apertura link esterno: $e');
            }

            return NavigationDecision.prevent;
          },
        ),
      )
      ..loadRequest(
        Uri.parse('https://www.ddx3x.it'),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DDX3X'),
      ),
      body: WebViewWidget(
        controller: controller,
      ),
    );
  }
}