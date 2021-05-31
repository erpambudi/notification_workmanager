import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notification_workmanager/background_helper.dart';
import 'package:workmanager/workmanager.dart';

import 'notification_helper.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final NotificationHelper _notificationHelper = NotificationHelper();

  await Workmanager().initialize(
    callbackDispatcher,
  );

  await _notificationHelper.initNotifications(flutterLocalNotificationsPlugin);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Workmanager().registerPeriodicTask(
                      "10",
                      periodic1HourTask,
                    );
                  },
                  child: Text("Aktifkan Notifikasi"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Workmanager().cancelByUniqueName("10");
                  },
                  child: Text("Matikan Notifikasi"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
