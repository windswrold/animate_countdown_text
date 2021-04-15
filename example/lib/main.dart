import 'package:animate_countdown_text/animate_countdown_text.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Demo Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text("Evaporation", style: Theme.of(context).textTheme.headline6),
            AnimateCountdownText(
                initDuration: Duration(days: 450, hours: 4, minutes: 10, seconds: 50),
                format: _formatHMS,
                characterTextStyle: TextStyle(fontSize: 16),
                suffixTextStyle: TextStyle(fontSize: 14),
                animationType: AnimationType.evaporation),
            SizedBox(height: 30),
            Text("Scale In", style: Theme.of(context).textTheme.headline6),
            AnimateCountdownText(
                initDuration: Duration(minutes: 1),
                format: _formatHMS,
                characterTextStyle: TextStyle(fontSize: 16),
                animationType: AnimationType.scaleIn),
            SizedBox(height: 30),
            Text("Fall Down", style: Theme.of(context).textTheme.headline6),
            AnimateCountdownText(
                initDuration: Duration(days: 450, hours: 4, minutes: 10, seconds: 50),
                format: _formatHMS,
                characterTextStyle: TextStyle(fontSize: 16),
                animationType: AnimationType.fallDown),
            SizedBox(height: 30),
            Text("Bounce In & reverse", style: Theme.of(context).textTheme.headline6),
            AnimateCountdownText.reverse(
                initDuration: Duration(days: 450, hours: 4, minutes: 10, seconds: 50),
                format: _formatHMS,
                characterTextStyle: TextStyle(fontSize: 16),
                animationType: AnimationType.bounceIn),
            SizedBox(height: 30),
            // Text("YMD", style: Theme.of(context).textTheme.headline6),
            // AnimateCountdownText(
            //     dateTime: DateTime(2021, 4, 15, 12, 31, 10),
            //     format: (duration) => _formatYMD(duration, false),
            //     characterTextStyle: TextStyle(fontSize: 16),
            //     animationType: AnimationType.bounceIn),
            SizedBox(height: 30),
            Text("DHMS", style: Theme.of(context).textTheme.headline6),
            AnimateCountdownText(
                dateTime: DateTime(2020, 7, 16, 5, 13, 10),
                format: (duration) => _formatDHMS(duration, false),
                characterTextStyle: TextStyle(fontSize: 16),
                expireDuration: null,
                animationType: AnimationType.bounceIn),
            SizedBox(height: 30),
            Text("YMDHMS", style: Theme.of(context).textTheme.headline6),
            AnimateCountdownText(
                dateTime: DateTime(2020, 4, 16, 5, 13, 10),
                format: (duration) => _formatYMDHMS(duration, false),
                characterTextStyle: TextStyle(fontSize: 16),
                expireDuration: null,
                animationType: AnimationType.bounceIn),
          ],
        ),
      ),
    );
  }

  DurationFormat _formatHMS(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes - hours * 60;
    final seconds = duration.inSeconds - hours * 60 * 60 - minutes * 60;

    return DurationFormat(
        hour: "$hours",
        hourSuffix: " Hour ",
        minute: "$minutes",
        minuteSuffix: " Min ",
        second: "$seconds",
        secondSuffix: " Sec ");
  }

  DurationFormat _formatDHMS(Duration duration, bool reverse) {
    List<int> format = duration.calculateDHMSDistance();
    bool dayExist = format[0] != 0;
    bool hourExist = format[1] != 0;
    bool minuteExist = format[2] != 0;
    bool secondExist = format[3] != 0;
    return DurationFormat(
      day: dayExist ? "${format[0]}" : null,
      daySuffix: "天",
      hour: hourExist ? "${format[1]}" : null,
      hourSuffix: "时",
      minute: minuteExist ? "${format[2]}" : null,
      minuteSuffix: "分",
      second: secondExist ? "${format[3]}" : null,
      secondSuffix: "秒",
    );
  }

  DurationFormat _formatYMDHMS(Duration duration, bool reverse) {
    List<int> format = duration.calculateYMDHMSDistance(reverse: reverse);
    bool yearExist = format[0] != 0;
    bool monthExist = format[1] != 0;
    bool dayExist = format[2] != 0;
    bool hourExist = format[3] != 0;
    bool minuteExist = format[4] != 0;
    bool secondExist = format[5] != 0;
    bool timeUp = !yearExist && !monthExist && !dayExist && !hourExist && !minuteExist && !secondExist;
    return DurationFormat(
      year: yearExist ? "${format[0]}" : null,
      yearSuffix: "年",
      month: monthExist ? "${format[1]}" : null,
      monthSuffix: "月",
      day: dayExist ? "${format[2]}" : null,
      daySuffix: "天",
      hour: hourExist ? "${format[3]}" : null,
      hourSuffix: "时",
      minute: minuteExist ? "${format[4]}" : null,
      minuteSuffix: "分",
      second: timeUp
          ? "0"
          : secondExist
              ? "${format[5]}"
              : null,
      secondSuffix: "秒",
    );
  }
}
