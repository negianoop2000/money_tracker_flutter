import 'package:flutter/material.dart';
import 'package:money_tracker/services/notification_service.dart';
import 'package:provider/provider.dart';
import './models/database_provider.dart';
import './screens/category_screen.dart';
import './screens/expense_screen.dart';
import './screens/all_expenses.dart';
import 'package:timezone/data/latest_all.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();

  final NotificationService notificationService = NotificationService();

  await notificationService.initNotification();
  print("Notification Service Initialized");

  // Schedule the 8 PM daily notification
  await notificationService.scheduleDailyEightPMNotification();
  print("8 PM Daily Notification Scheduled");


  runApp(ChangeNotifierProvider(
    create: (_) => DatabaseProvider(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: CategoryScreen.name,
      routes: {
        CategoryScreen.name: (_) => const CategoryScreen(),
        ExpenseScreen.name: (_) => const ExpenseScreen(),
        AllExpenses.name: (_) => const AllExpenses(),
      },
    );
  }
}
