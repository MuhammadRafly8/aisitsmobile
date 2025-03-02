import 'package:aisits_mobileApp/service/weather_service.dart';
import 'service/loading_service.dart';
import 'service/ship_provider.dart';
import 'service/json_service_provider.dart';
import 'package:flutter/material.dart';
import 'screen/login_screen.dart';
import 'screen/splash_screen.dart';
import 'screen/map_screen.dart';
import 'screen/alert_screen.dart';
import 'screen/danger_screen.dart';
import 'package:provider/provider.dart';
import 'service/notification_service.dart';
import 'widget/app_wrapper.dart';
import 'screen/weather_screen.dart';
import 'screen/markship_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    final jsonServiceProvider = JsonServiceProvider();
    await jsonServiceProvider.initializeData();
    final notificationService = NotificationService();
    final weatherService = WeatherService();  // Add this

    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => LoadingService()),
          ChangeNotifierProvider.value(value: notificationService),  
          ChangeNotifierProvider.value(value: jsonServiceProvider),
          Provider.value(value: weatherService),  // Add this
          ChangeNotifierProvider(
            create: (context) => ShipProvider(
              jsonService: Provider.of<JsonServiceProvider>(context, listen: false).jsonService,
              notificationService: notificationService,
              onMarkerTap: (shipData) {
                print("Marker tapped for ship: ${shipData.name}");
              },
            ),
          ),
        ],
        child: const MyApp(),
      ),
    );
  } catch (e) {
    print('Error inisialisasi aplikasi: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Early Warning System',
      builder: (context, child) {
        return AppWrapper(child: child ?? const SizedBox());
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
        brightness: Brightness.light,
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 2,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
        ),
      ),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/map': (context) => const MapScreen(),
        '/alert': (context) => const AlertScreen(),
        '/danger': (context) => const DangerScreen(),
        '/weather': (context) => const WeatherScreen(),
        '/markship': (context) => const MarkShipScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}