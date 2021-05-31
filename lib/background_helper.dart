import 'dart:math';

import 'package:notification_workmanager/api_service.dart';
import 'package:workmanager/workmanager.dart';

import 'artilce.dart';
import 'main.dart';
import 'notification_helper.dart';

const periodic1HourTask = "periodic1HourTask";
const periodic6HourTask = "periodic6HourTask";

void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    switch (taskName) {
      case periodic1HourTask:
        final NotificationHelper _notificationHelper = NotificationHelper();
        var result = await ApiService().topHeadlines();

        final _randomIndex = Random();
        Article notification =
            result.articles![_randomIndex.nextInt(result.articles!.length)];

        await _notificationHelper.showNotification(
            flutterLocalNotificationsPlugin, notification);

        print("$periodic1HourTask was executed");
        break;
      case periodic6HourTask:
        print("$periodic6HourTask was executed");
    }
    return Future.value(true);
  });
}
