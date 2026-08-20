import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DDX3X'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const SizedBox(height: 20),

            const Icon(
              Icons.favorite,
              size: 80,
            ),

            const SizedBox(height: 20),

            const Text(
              'DDX3X',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'Associazione DDX3X ODV',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 30),

            // ============================================================
            // SITO DDX3X
            // ============================================================

            Card(
              child: ListTile(
                leading: const Icon(Icons.language),
                title: const Text('Sito DDX3X'),
                subtitle: const Text(
                  'News, informazioni e risorse',
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const WebsitePage(
                        title: 'Sito DDX3X',
                        url: 'https://www.ddx3x.it',
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            // ============================================================
            // DONA ORA
            // ============================================================

            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.volunteer_activism,
                  size: 30,
                ),
                title: const Text('Dona ora'),
                subtitle: const Text(
                  'Sostieni le attività dell’Associazione DDX3X ODV',
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const WebsitePage(
                        title: 'Dona ora',
                        url: 'https://www.ddx3x.it/dona',
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            // ============================================================
            // NOTIFICHE
            // ============================================================

            Card(
              child: ListTile(
                leading: const Icon(Icons.notifications),
                title: const Text('Notifiche'),
                subtitle: const Text(
                  'Comunicazioni e novità dell’associazione',
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const NotificationsPage(),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            // ============================================================
            // SEGUICI SUI SOCIAL
            // ============================================================

            Card(
              child: ListTile(
                leading: const Icon(Icons.share),
                title: const Text('Seguici sui social'),
                subtitle: const Text(
                  'Facebook e Instagram',
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return SafeArea(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(16),
                              child: Text(
                                'Seguici sui social',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            // ==================================================
                            // INSTAGRAM
                            // ==================================================

                            ListTile(
                              leading: const Icon(
                                Icons.camera_alt,
                              ),
                              title: const Text('Instagram'),
                              subtitle: const Text(
                                'Seguici su Instagram',
                              ),
                              trailing: const Icon(
                                Icons.arrow_forward_ios,
                              ),
                              onTap: () async {
                                final uri = Uri.parse(
                                  'https://www.instagram.com/ddx3x_italia/',
                                );

                                Navigator.pop(context);

                                if (await canLaunchUrl(uri)) {
                                  await launchUrl(
                                    uri,
                                    mode: LaunchMode.externalApplication,
                                  );
                                }
                              },
                            ),

                            // ==================================================
                            // FACEBOOK
                            // ==================================================

                            ListTile(
                              leading: const Icon(
                                Icons.facebook,
                              ),
                              title: const Text('Facebook'),
                              subtitle: const Text(
                                'Seguici su Facebook',
                              ),
                              trailing: const Icon(
                                Icons.arrow_forward_ios,
                              ),
                              onTap: () async {
                                final uri = Uri.parse(
                                  'https://www.facebook.com/p/Associazione-DDX3X-ODV-100064708989391/',
                                );

                                Navigator.pop(context);

                                if (await canLaunchUrl(uri)) {
                                  await launchUrl(
                                    uri,
                                    mode: LaunchMode.externalApplication,
                                  );
                                }
                              },
                            ),

                            const SizedBox(height: 10),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// CENTRO NOTIFICHE
// ============================================================

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() =>
      _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  DateTime? _installationDate;
  bool _loadingDate = true;

  Set<String> _deletedNotificationIds = {};

  @override
  void initState() {
    super.initState();
    _loadNotificationSettings();
  }

  Future<void> _loadNotificationSettings() async {
    final preferences =
        await SharedPreferences.getInstance();

    final savedDate = preferences.getString(
      'ddx3x_installation_date',
    );

    if (savedDate == null) {
      final now = DateTime.now();

      await preferences.setString(
        'ddx3x_installation_date',
        now.toIso8601String(),
      );

      _installationDate = now;
    } else {
      _installationDate =
          DateTime.tryParse(savedDate);
    }

    final deletedIds =
        preferences.getStringList(
      'ddx3x_deleted_notification_ids',
    );

    _deletedNotificationIds =
        deletedIds?.toSet() ?? {};

    if (mounted) {
      setState(() {
        _loadingDate = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loadingDate) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Notifiche'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifiche'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.notifications_none,
                size: 70,
              ),
              const SizedBox(height: 20),
              const Text(
                'Notifiche',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Le notifiche push dell’associazione '
                'verranno ricevute direttamente sul dispositivo.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const Text(
                'Il centro comunicazioni è temporaneamente '
                'in fase di aggiornamento.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// WEBVIEW
// ============================================================

class WebsitePage extends StatefulWidget {
  final String title;
  final String url;

  const WebsitePage({
    super.key,
    required this.title,
    required this.url,
  });

  @override
  State<WebsitePage> createState() =>
      _WebsitePageState();
}

class _WebsitePageState extends State<WebsitePage> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(
        JavaScriptMode.unrestricted,
      )
      ..setBackgroundColor(
        const Color(0x00000000),
      )
      ..enableZoom(true)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest:
              (NavigationRequest request) async {
            final uri = Uri.tryParse(
              request.url,
            );

            if (uri == null) {
              return NavigationDecision.prevent;
            }

            if (uri.scheme == 'mailto') {
              final canOpen =
                  await canLaunchUrl(uri);

              if (canOpen) {
                await launchUrl(
                  uri,
                  mode: LaunchMode.externalApplication,
                );
              }

              return NavigationDecision.prevent;
            }

            if (uri.scheme == 'tel') {
              final canOpen =
                  await canLaunchUrl(uri);

              if (canOpen) {
                await launchUrl(
                  uri,
                  mode: LaunchMode.externalApplication,
                );
              }

              return NavigationDecision.prevent;
            }

            if (uri.scheme == 'https' &&
                (uri.host == 'www.ddx3x.it' ||
                    uri.host == 'ddx3x.it')) {
              return NavigationDecision.navigate;
            }

            if (uri.scheme == 'https' ||
                uri.scheme == 'http') {
              final canOpen =
                  await canLaunchUrl(uri);

              if (canOpen) {
                await launchUrl(
                  uri,
                  mode: LaunchMode.externalApplication,
                );
              }

              return NavigationDecision.prevent;
            }

            return NavigationDecision.prevent;
          },
        ),
      )
      ..loadRequest(
        Uri.parse(
          _normalizeUrl(widget.url),
        ),
      );
  }

  String _normalizeUrl(String url) {
    if (url.startsWith('https://ddx3x.it/')) {
      return url.replaceFirst(
        'https://ddx3x.it/',
        'https://www.ddx3x.it/',
      );
    }

    if (url == 'https://ddx3x.it') {
      return 'https://www.ddx3x.it';
    }

    return url;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: WebViewWidget(
        controller: controller,
      ),
    );
  }
}
