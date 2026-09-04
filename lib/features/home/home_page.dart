import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
                      builder: (_) => const Scaffold(
                      appBar: AppBar(title: Text('Notifiche')),
                      body: Center(child: Text('TEST NOTIFICHE')),
                     ),
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

  Future<void> _deleteNotification(
      String notificationId,
      ) async {
    final preferences =
    await SharedPreferences.getInstance();

    _deletedNotificationIds.add(
      notificationId,
    );

    await preferences.setStringList(
      'ddx3x_deleted_notification_ids',
      _deletedNotificationIds.toList(),
    );

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loadingDate ||
        _installationDate == null) {
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
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('notifications')
            .where(
          'createdAt',
          isGreaterThanOrEqualTo:
          Timestamp.fromDate(
            _installationDate!,
          ),
        )
            .orderBy(
          'createdAt',
          descending: true,
        )
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding:
                const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize:
                  MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 50,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Impossibile caricare le notifiche.',
                      textAlign:
                      TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      snapshot.error
                          .toString(),
                      textAlign:
                      TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          final documents =
              snapshot.data?.docs ?? [];

          final visibleDocuments =
          documents.where((document) {
            return !_deletedNotificationIds
                .contains(document.id);
          }).toList();

          if (visibleDocuments.isEmpty) {
            return const Center(
              child: Padding(
                padding:
                EdgeInsets.all(24),
                child: Column(
                  mainAxisSize:
                  MainAxisSize.min,
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
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Le nuove comunicazioni '
                          'dell’associazione '
                          'appariranno qui.',
                      textAlign:
                      TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.separated(
            padding:
            const EdgeInsets.all(16),
            itemCount:
            visibleDocuments.length,
            separatorBuilder:
                (_, __) =>
            const SizedBox(
              height: 10,
            ),
            itemBuilder:
                (context, index) {
              final document =
              visibleDocuments[index];

              final data =
              document.data()
              as Map<String, dynamic>;

              final notificationId =
                  document.id;

              final title =
                  data['title']
                  as String? ??
                      'DDX3X';

              final body =
                  data['body']
                  as String? ??
                      '';

              final url =
              data['url'] as String?;

              final timestamp =
              data['createdAt']
              as Timestamp?;

              final date =
              timestamp?.toDate();

              return Card(
                child: ListTile(
                  leading:
                  const Icon(
                    Icons.notifications,
                    size: 30,
                  ),

                  title: Text(
                    title,
                    style:
                    const TextStyle(
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),

                  subtitle:
                  Column(
                    crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                    children: [
                      const SizedBox(
                        height: 6,
                      ),
                      Text(body),
                      if (date != null) ...[
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          _formatDate(
                            date,
                          ),
                          style:
                          TextStyle(
                            fontSize: 12,
                            color: Colors
                                .grey
                                .shade600,
                          ),
                        ),
                      ],
                    ],
                  ),

                  isThreeLine: true,

                  trailing:
                  Row(
                    mainAxisSize:
                    MainAxisSize.min,
                    children: [
                      if (url != null &&
                          url.isNotEmpty)
                        IconButton(
                          icon:
                          const Icon(
                            Icons
                                .arrow_forward_ios,
                            size: 18,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    WebsitePage(
                                      title:
                                      title,
                                      url: url,
                                    ),
                              ),
                            );
                          },
                        ),

                      IconButton(
                        icon:
                        const Icon(
                          Icons.delete_outline,
                        ),
                        tooltip:
                        'Cancella notifica',
                        onPressed: () {
                          _deleteNotification(
                            notificationId,
                          );
                        },
                      ),
                    ],
                  ),

                  onTap:
                  url != null &&
                      url.isNotEmpty
                      ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) =>
                            WebsitePage(
                              title:
                              title,
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

  static String _formatDate(
      DateTime date,
      ) {
    final localDate =
    date.toLocal();

    final day = localDate.day
        .toString()
        .padLeft(2, '0');

    final month = localDate.month
        .toString()
        .padLeft(2, '0');

    final year =
    localDate.year.toString();

    final hour = localDate.hour
        .toString()
        .padLeft(2, '0');

    final minute = localDate.minute
        .toString()
        .padLeft(2, '0');

    return '$day/$month/$year alle '
        '$hour:$minute';
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
              (NavigationRequest
          request) async {
            final uri =
            Uri.tryParse(
              request.url,
            );

            if (uri == null) {
              return NavigationDecision
                  .prevent;
            }

            if (uri.scheme ==
                'mailto') {
              final canOpen =
              await canLaunchUrl(
                uri,
              );

              if (canOpen) {
                await launchUrl(
                  uri,
                  mode: LaunchMode
                      .externalApplication,
                );
              }

              return NavigationDecision
                  .prevent;
            }

            if (uri.scheme == 'tel') {
              final canOpen =
              await canLaunchUrl(
                uri,
              );

              if (canOpen) {
                await launchUrl(
                  uri,
                  mode: LaunchMode
                      .externalApplication,
                );
              }

              return NavigationDecision
                  .prevent;
            }

            if (uri.scheme == 'https' &&
                (uri.host ==
                    'www.ddx3x.it' ||
                    uri.host ==
                        'ddx3x.it')) {
              return NavigationDecision
                  .navigate;
            }

            if (uri.scheme == 'https' ||
                uri.scheme == 'http') {
              final canOpen =
              await canLaunchUrl(
                uri,
              );

              if (canOpen) {
                await launchUrl(
                  uri,
                  mode: LaunchMode
                      .externalApplication,
                );
              }

              return NavigationDecision
                  .prevent;
            }

            return NavigationDecision
                .prevent;
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
