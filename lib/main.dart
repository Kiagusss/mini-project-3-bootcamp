import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mini_project_3_bootcamp/bloc/product_cart_cubit/product_detail_cubit.dart';
import 'package:mini_project_3_bootcamp/pages/login_oage.dart';
import 'package:mini_project_3_bootcamp/services/repository/cart_repository.dart';
import 'package:mini_project_3_bootcamp/shared/style.dart';
import 'package:provider/provider.dart';
import 'bloc/cart_bloc/cart_bloc.dart';
import 'bloc/product_bloc/product_bloc.dart';
import 'bloc/product_cart_cubit/product_cart_cubit.dart';
import 'bloc/profile_bloc/profile_bloc.dart';

import 'services/repository/product_repository.dart';
import 'services/repository/profile_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NotificationHelper().initLocalNotifications();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ProfileBloc(ProfileRepository()),
        ),
        Provider<CartRepository>(create: (_) => CartRepository()),
        BlocProvider(
          create: (context) => CartBloc()..add(LoadCartEvent()),
        ),
        BlocProvider<ProductDetailCubit>(
          create: (context) => ProductDetailCubit(
            cartRepository: CartRepository(),
          ),
        ),
        BlocProvider(
          create: (context) => ProductCartCubit(),
        ),
        BlocProvider(
          create: (context) => ProductBloc(ProductRepository()),
        ),
      ],
      child: const MaterialApp(
          debugShowCheckedModeBanner: false, home: SplashScreen()),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.forward();
    Timer(const Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const LoginPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeTransition(
        opacity: _animation,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 250),
                    Image.asset(
                      fit: BoxFit.cover,
                      "assets/images/logo1.png",
                      width: 110,
                      height: 122,
                    ),
                    const SizedBox(height: 20),
                    Text('Belanjain',
                        style: title.copyWith(
                            color: primaryColor,
                            fontSize: 40,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Text('Belanja Lebih Mudah',
                        style: title.copyWith(
                            color: const Color(0xff454545),
                            fontSize: 25,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Aplikasi Belanja Online No.1 di Indonesia',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NotificationHelper {
  /// Flutter Local Notification Plugin
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Notification Payload
  static ValueNotifier<String> payload = ValueNotifier("");

  /// Set the payload
  void setPayload(String newPayload) {
    payload.value = newPayload;
  }

  /// Inisialisasikan Settingan Channel Notifikasi untuk Android.
  static AndroidNotificationDetails androidNotificationDetails =
      const AndroidNotificationDetails(
    'Belanjain',
    'Belanja Mudah? Belanjain Aja!',
    channelDescription: 'Untuk percobaan Local Notif',
    importance: Importance.max,
    priority: Priority.high,
    icon: '@mipmap/ic_launcher',
    playSound: true,
    enableVibration: true,
  );

  /// Inisialisasikan Setting Channel Notifikasi untuk iOS/MacOS
  static DarwinNotificationDetails iOSNotificationDetails =
      const DarwinNotificationDetails(
    threadIdentifier: 'local_notif',
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );

  /// Notifications Details untuk multi platform
  static NotificationDetails notificationDetails = NotificationDetails(
    android: androidNotificationDetails,
    iOS: iOSNotificationDetails,
  );

  /// Inisialisasi flutter_local_notifications
  Future<void> initLocalNotifications() async {
    /// Config for Android
    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    /// Config for iOS & MacOS
    const initializationSettingsIOS = DarwinInitializationSettings();

    /// Initializations
    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    /// Inisialisasikan Konfigurasi dari Local Notification.
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        /// Handle ketika notifikasi ditekan.
        debugPrint("Notifikasi Ditekan ${details.payload}");
        setPayload(details.payload ?? '');
      },
    );

    /// Request Permission untuk Android 13 ke atas.
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    /// Request Permission untuk iOS
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }
}
