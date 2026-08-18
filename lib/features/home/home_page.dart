import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

            // SITO DDX3X
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

            // DONA ORA
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

            // NOTIFICHE
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

            // SOCIAL
            Card(
              child: ListTile(
                leading: const Icon(Icons.share),
                title: const Text('Seguici sui social'),
                subtitle: const Text(
                  'Facebook e Instagram',
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  _showSocialMenu(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void _showSocialMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Seguici sui social',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                ListTile(
                  leading: const Icon(
                    Icons.facebook,
                    size: 32,
                  ),
                  title: const Text('Facebook'),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                  ),
                  onTap: () async {
                    final uri = Uri.parse(
                      'https://www.facebook.com/AssociazioneDDX',
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

                ListTile(
                  leading: const Icon(
                    Icons.camera_alt,
                    size: 32,
                  ),
                  title: const Text('Instagram'),
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
              ],
            ),
          ),
        );
      },
    );
  }
}

// ============================================================
// CENTRO NOTIFICHE
// ============================================================

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifiche'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('notifications')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 50,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Impossibile caricare le notifiche.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      snapshot.error.toString(),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          final documents = snapshot.data?.docs ?? [];

          if (documents.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.notifications_none,
                      size: 70,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Nessuna comunicazione',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Le comunicazioni dell’associazione '
                          'appariranno qui.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: documents.length,
            separatorBuilder: (_, __) =>
            const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final data =
              documents[index].data()
              as Map<String, dynamic>;

              final title =
                  data['title'] as String? ?? 'DDX3X';

              final body =
                  data['body'] as String? ?? '';

              final url =
              data['url'] as String?;

              final timestamp =
              data['createdAt'] as Timestamp?;

              final date = timestamp?.toDate();

              return Card(
                child: ListTile(
                  leading: const Icon(
                    Icons.notifications,
                    size: 30,
                  ),
                  title: Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 6),
                      Text(body),
                      if (date != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          _formatDate(date),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ],
                  ),
                  isThreeLine: true,
                  trailing:
                  url != null && url.isNotEmpty
                      ? const Icon(
                    Icons.arrow_forward_ios,
                  )
                      : null,
                  onTap:
                  url != null && url.isNotEmpty
                      ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            WebsitePage(
                              title: title,
                              url: url,
                            ),
                      ),
                    );
                  }
                      : null,
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Converte l'orario Firestore nell'ora locale
  static String _formatDate(DateTime date) {
    final localDate = date.toLocal();

    final day =
    localDate.day.toString().padLeft(2, '0');

    final month =
    localDate.month.toString().padLeft(2, '0');

    final year =
    localDate.year.toString();

    final hour =
    localDate.hour.toString().padLeft(2, '0');

    final minute =
    localDate.minute.toString().padLeft(2, '0');

    return '$day/$month/$year alle $hour:$minute';
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
            final uri =
            Uri.tryParse(request.url);

            if (uri == null) {
              return NavigationDecision.prevent;
            }

            // POSTA ELETTRONICA
            if (uri.scheme == 'mailto') {
              final canOpen =
              await canLaunchUrl(uri);

              if (canOpen) {
                await launchUrl(
                  uri,
                  mode:
                  LaunchMode.externalApplication,
                );
              }

              return NavigationDecision.prevent;
            }

            // TELEFONO
            if (uri.scheme == 'tel') {
              final canOpen =
              await canLaunchUrl(uri);

              if (canOpen) {
                await launchUrl(
                  uri,
                  mode:
                  LaunchMode.externalApplication,
                );
              }

              return NavigationDecision.prevent;
            }

            // SITO DDX3X
            if (uri.scheme == 'https' &&
                (uri.host == 'www.ddx3x.it' ||
                    uri.host == 'ddx3x.it')) {
              return NavigationDecision.navigate;
            }

            // LINK ESTERNI
            if (uri.scheme == 'https' ||
                uri.scheme == 'http') {
              final canOpen =
              await canLaunchUrl(uri);

              if (canOpen) {
                await launchUrl(
                  uri,
                  mode:
                  LaunchMode.externalApplication,
                );
              }

              return NavigationDecision.prevent;
            }

            return NavigationDecision.prevent;
          },
        ),
      )
      ..loadRequest(
        Uri.parse(widget.url),
      );
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