import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'firebase_options.dart';
import 'features/home/home_page.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

String? pendingNotificationUrl;

const AndroidNotificationChannel notificationChannel =
AndroidNotificationChannel(
  'ddx3x_notifications',
  'DDX3X Notifiche',
  description: 'Notifiche dell’app DDX3X',
  importance: Importance.max,
  playSound: true,
);

void openNotificationUrl(String? url) {
  if (url == null || url.isEmpty) {
    return;
  }

  debugPrint('DDX3X - Apertura URL dalla notifica: $url');

  final navigator = navigatorKey.currentState;

  if (navigator == null) {
    pendingNotificationUrl = url;
    return;
  }

  navigator.push(
    MaterialPageRoute(
      builder: (_) => WebsitePage(
        title: 'DDX3X',
        url: url,
      ),
    ),
  );
}

@pragma('vm:entry-point')
void notificationResponseHandler(
    NotificationResponse response,
    ) {
  final payload = response.payload;

  debugPrint(
    'DDX3X - Tap sulla notifica locale. Payload: $payload',
  );

  if (payload != null && payload.isNotEmpty) {
    pendingNotificationUrl = payload;
  }
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(
    RemoteMessage message,
    ) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  debugPrint('DDX3X - Notifica ricevuta in background');
  debugPrint('Titolo: ${message.notification?.title}');
  debugPrint('Testo: ${message.notification?.body}');
  debugPrint('Dati: ${message.data}');

  final title = message.notification?.title ?? 'DDX3X';
  final body = message.notification?.body ?? '';
  final url = message.data['url'] ?? '';

  await flutterLocalNotificationsPlugin.show(
    message.hashCode,
    title,
    body,
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'ddx3x_notifications',
        'DDX3X Notifiche',
        channelDescription: 'Notifiche dell’app DDX3X',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
      ),
    ),
    payload: url,
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  const androidInitializationSettings =
  AndroidInitializationSettings('@mipmap/ic_launcher');

  const initializationSettings = InitializationSettings(
    android: androidInitializationSettings,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: notificationResponseHandler,
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(notificationChannel);

  FirebaseMessaging.onBackgroundMessage(
    firebaseMessagingBackgroundHandler,
  );

  final messaging = FirebaseMessaging.instance;

  final settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  debugPrint(
    'DDX3X - Permesso notifiche: ${settings.authorizationStatus}',
  );

  final token = await messaging.getToken();

  debugPrint('DDX3X FCM TOKEN:');
  debugPrint(token);

  await messaging.subscribeToTopic('ddx3x_tutti');

  debugPrint('DDX3X - Iscritto al topic: ddx3x_tutti');

  FirebaseMessaging.onMessage.listen(
        (RemoteMessage message) async {
      debugPrint('DDX3X - Notifica ricevuta in primo piano');
      debugPrint('Titolo: ${message.notification?.title}');
      debugPrint('Testo: ${message.notification?.body}');
      debugPrint('Dati: ${message.data}');

      final title = message.notification?.title ?? 'DDX3X';
      final body = message.notification?.body ?? '';
      final url = message.data['url'] ?? '';

      await flutterLocalNotificationsPlugin.show(
        message.hashCode,
        title,
        body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'ddx3x_notifications',
            'DDX3X Notifiche',
            channelDescription: 'Notifiche dell’app DDX3X',
            importance: Importance.max,
            priority: Priority.high,
            playSound: true,
          ),
        ),
        payload: url,
      );
    },
  );

  FirebaseMessaging.onMessageOpenedApp.listen(
        (RemoteMessage message) {
      debugPrint('DDX3X - Notifica push aperta dall’utente');
      debugPrint('Dati: ${message.data}');

      final url = message.data['url'];

      if (url != null && url.isNotEmpty) {
        openNotificationUrl(url);
      }
    },
  );

  final initialMessage = await messaging.getInitialMessage();

  if (initialMessage != null) {
    debugPrint(
      'DDX3X - App aperta tramite notifica push',
    );

    debugPrint(
      'Dati notifica: ${initialMessage.data}',
    );

    final url = initialMessage.data['url'];

    if (url != null && url.isNotEmpty) {
      pendingNotificationUrl = url;
    }
  }

  runApp(const Ddx3xApp());

  WidgetsBinding.instance.addPostFrameCallback(
        (_) {
      if (pendingNotificationUrl != null) {
        final url = pendingNotificationUrl;

        pendingNotificationUrl = null;

        openNotificationUrl(url);
      }
    },
  );
}

class Ddx3xApp extends StatelessWidget {
  const Ddx3xApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'DDX3X',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}






