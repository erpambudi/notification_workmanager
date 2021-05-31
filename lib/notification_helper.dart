import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';

import 'artilce.dart';

final selectNotificationSubject = BehaviorSubject<String>();

class NotificationHelper {
  static NotificationHelper? _instance;

  NotificationHelper._internal() {
    _instance = this;
  }

  factory NotificationHelper() => _instance ?? NotificationHelper._internal();

  Future<void> initNotifications(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (String? payload) async {
        if (payload != null) {
          print('notification payload: ' + payload);
        }

        selectNotificationSubject.add(payload ?? "empty payload");
      },
    );
  }

  Future<void> showNotification(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      Article notificationArticle) async {
    var _channelId = "999";
    var _channelName = "channel_999";
    var _channelDescription = "warta today channel";

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      _channelId,
      _channelName,
      _channelDescription,
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
      styleInformation: DefaultStyleInformation(true, true),
    );

    var iOSPlatformChannelSpecifics = IOSNotificationDetails();

    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    var titleNotification = "<b>Headline News</b>";
    var titleNews = notificationArticle.title;

    ///karena payload hanya menerima data dengan format string maka
    ///parameter model article dirubah formatnya kedalam bentuk Json.
    ///untuk mengirimkan bundle data yang bersumber dari API
    ///haruslah dalam bentuk format JSON yang akan diubah menjadi String.
    await flutterLocalNotificationsPlugin.show(
      0,
      titleNotification,
      titleNews,
      platformChannelSpecifics,
      payload: json.encode(
        notificationArticle.toJson(),
      ),
    );
  }

  ///METHOD KETIKA NOTIFIKASI DIKLIK.
  ///Kemudian pada fungsi configureSelectNotificationSubject
  ///kita melakukan decoding data payload untuk merubah data JSON ke dalam model article
  ///Lalu kita mengirimkannya ke dalam navigasi yang telah kita buat agar dapat ditampilkan di dalam halaman detail.
  void configureSelectNotificationSubject({String? route}) {
    ///membuka stream
    selectNotificationSubject.stream.listen(
      (String payload) async {
        var article = Article.fromJson(json.decode(payload));
        print(article.title);
      },
    );
  }
}
