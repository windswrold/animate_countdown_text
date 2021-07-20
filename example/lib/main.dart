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
  DateTime dateTime = DateTime.now().add(Duration(days: 5, hours: 2, minutes: 14));
  DateTime reverseDateTime = DateTime.now().subtract(Duration(days: 6, hours: 6, minutes: 26));

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
                dateTime: dateTime,
                format: _formatHMS,
                characterTextStyle: TextStyle(fontSize: 16),
                suffixTextStyle: TextStyle(fontSize: 14),
                animationType: AnimationType.evaporation),
            SizedBox(height: 30),
            Text("Scale In", style: Theme.of(context).textTheme.headline6),
            AnimateCountdownText(
                dateTime: dateTime,
                format: _formatHMS,
                characterTextStyle: TextStyle(fontSize: 16),
                animationType: AnimationType.scaleIn),
            SizedBox(height: 30),
            Text("Fall Down", style: Theme.of(context).textTheme.headline6),
            AnimateCountdownText(
                dateTime: dateTime,
                format: _formatHMS,
                characterTextStyle: TextStyle(fontSize: 16),
                animationType: AnimationType.fallDown),
            SizedBox(height: 30),
            Text("Bounce In & reverse", style: Theme.of(context).textTheme.headline6),
            AnimateCountdownText(
              dateTime: dateTime,
              format: _formatHMS,
              characterTextStyle: TextStyle(fontSize: 16),
              animationType: AnimationType.bounceIn,
              reverse: true,
            ),
            SizedBox(height: 30),
            Text("Day Hour Minute Second", style: Theme.of(context).textTheme.headline6),
            AnimateCountdownText(
                dateTime: dateTime,
                format: (duration) => _formatDHMS(duration, false),
                characterTextStyle: TextStyle(fontSize: 16),
                expireDuration: null,
                animationType: AnimationType.bounceIn),
            SizedBox(height: 30),
            Text("Year Month Day Hour Minute Second, Reverse", style: Theme.of(context).textTheme.bodyText2),
            AnimateCountdownText(
                dateTime: reverseDateTime,
                format: (duration) => _formatYMDHMS(duration, true),
                characterTextStyle: TextStyle(fontSize: 16),
                reverse: true,
                animationType: AnimationType.bounceIn),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                OutlinedButton(onPressed: _addOneHour, child: Text("Add")),
                OutlinedButton(onPressed: _subtractOneHour, child: Text("Subtract"))
              ],
            )
          ],
        ),
      ),
    );
  }

  _addOneHour() {
    setState(() {
      dateTime = dateTime.add(Duration(hours: 1));
      reverseDateTime = reverseDateTime.add(Duration(hours: 1));
    });
  }

  _subtractOneHour() {
    setState(() {
      dateTime = dateTime.subtract(Duration(hours: 1));
      reverseDateTime = reverseDateTime.subtract(Duration(hours: 1));
    });
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
      daySuffix: "Day",
      hour: hourExist ? "${format[1]}" : null,
      hourSuffix: "Hour",
      minute: minuteExist ? "${format[2]}" : null,
      minuteSuffix: "Min",
      second: secondExist ? "${format[3]}" : null,
      secondSuffix: "Sec",
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
      yearSuffix: "Year",
      month: monthExist ? "${format[1]}" : null,
      monthSuffix: "Mon",
      day: dayExist ? "${format[2]}" : null,
      daySuffix: "Day",
      hour: hourExist ? "${format[3]}" : null,
      hourSuffix: "Hour",
      minute: minuteExist ? "${format[4]}" : null,
      minuteSuffix: "Min",
      second: timeUp
          ? "0"
          : secondExist
              ? "${format[5]}"
              : null,
      secondSuffix: "Sec",
    );
  }
}
