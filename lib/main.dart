import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'firebase_options.dart';
import 'features/home/home_page.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

const AndroidNotificationChannel notificationChannel =
    AndroidNotificationChannel(
  'ddx3x_notifications',
  'DDX3X Notifiche',
  description: 'Notifiche dell’app DDX3X',
  importance: Importance.max,
  playSound: true,
);

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(
  RemoteMessage message,
) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  print('DDX3X - Notifica ricevuta in background');
  print('Titolo: ${message.notification?.title}');
  print('Testo: ${message.notification?.body}');
  print('Dati: ${message.data}');
}

Future<void> _openNotificationLink(RemoteMessage message) async {
  final url = message.data['url'];

  if (url == null || url.toString().isEmpty) {
    print('DDX3X - Nessun link nella notifica');
    return;
  }

  print('DDX3X - Apertura link: $url');

  final navigator = navigatorKey.currentState;

  if (navigator == null) {
    print('DDX3X - Navigator non disponibile');
    return;
  }

  navigator.push(
    MaterialPageRoute(
      builder: (_) => WebsitePage(
        title: message.notification?.title ?? 'DDX3X',
        url: url.toString(),
      ),
    ),
  );
}

Future<void> _initializeServices() async {
  try {
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
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        final payload = response.payload;

        if (payload == null || payload.isEmpty) {
          return;
        }

        print('DDX3X - Apertura notifica locale');
        print('DDX3X - Link: $payload');

        final navigator = navigatorKey.currentState;

        if (navigator == null) {
          return;
        }

        navigator.push(
          MaterialPageRoute(
            builder: (_) => WebsitePage(
              title: 'DDX3X',
              url: payload,
            ),
          ),
        );
      },
    );

    if (Platform.isAndroid) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(notificationChannel);
    }

    FirebaseMessaging.onBackgroundMessage(
      firebaseMessagingBackgroundHandler,
    );

    final messaging = FirebaseMessaging.instance;

    final settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    print(
      'DDX3X - Permesso notifiche: ${settings.authorizationStatus}',
    );

    if (Platform.isIOS) {
      final apnsToken = await messaging.getAPNSToken();

      print('DDX3X APNs TOKEN:');
      print(apnsToken);

      if (apnsToken != null) {
        final token = await messaging.getToken();

        print('DDX3X FCM TOKEN:');
        print(token);
      } else {
        print('DDX3X - Token APNs non ancora disponibile');
      }
    } else {
      final token = await messaging.getToken();

      print('DDX3X FCM TOKEN:');
      print(token);
    }

    await messaging.subscribeToTopic('ddx3x_tutti');

    print('DDX3X - Iscritto al topic: ddx3x_tutti');

    messaging.onTokenRefresh.listen((token) {
      print('DDX3X - FCM TOKEN AGGIORNATO:');
      print(token);
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('DDX3X - Notifica ricevuta in primo piano');
      print('Titolo: ${message.notification?.title}');
      print('Testo: ${message.notification?.body}');
      print('Dati: ${message.data}');

      if (Platform.isAndroid) {
        final title = message.notification?.title ?? 'DDX3X';
        final body = message.notification?.body ?? '';
        final url = message.data['url']?.toString();

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
    });

    FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage message) {
        print('DDX3X - Notifica aperta dall’utente');
        print('Dati: ${message.data}');

        _openNotificationLink(message);
      },
    );

    final initialMessage = await messaging.getInitialMessage();

    if (initialMessage != null) {
      print('DDX3X - App aperta tramite notifica');
      print('Dati: ${initialMessage.data}');

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _openNotificationLink(initialMessage);
      });
    }
  } catch (e, stackTrace) {
    print('DDX3X - ERRORE INIZIALIZZAZIONE SERVIZI:');
    print(e);
    print(stackTrace);
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const Ddx3xApp());

  await _initializeServices();
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