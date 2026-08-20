import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'firebase_options.dart';
import 'features/home/home_page.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

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

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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

  final token = await messaging.getToken();

  print('DDX3X FCM TOKEN:');
  print(token);

  await messaging.subscribeToTopic('ddx3x_tutti');

  print('DDX3X - Iscritto al topic: ddx3x_tutti');

  FirebaseMessaging.onMessage.listen(
    (RemoteMessage message) {
      print('DDX3X - Notifica ricevuta in primo piano');
      print('Titolo: ${message.notification?.title}');
      print('Testo: ${message.notification?.body}');
      print('Dati: ${message.data}');
    },
  );

  FirebaseMessaging.onMessageOpenedApp.listen(
    (RemoteMessage message) {
      print('DDX3X - Notifica aperta dall’utente');
      print('Dati: ${message.data}');

      _openNotificationLink(message);
    },
  );

  final initialMessage = await messaging.getInitialMessage();

  runApp(const Ddx3xApp());

  if (initialMessage != null) {
    print('DDX3X - App aperta tramite notifica');
    print('Dati: ${initialMessage.data}');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _openNotificationLink(initialMessage);
    });
  }
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
