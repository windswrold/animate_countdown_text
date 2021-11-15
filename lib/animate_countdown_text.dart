library animate_countdown_text;

import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

part 'animate_unit.dart';

part 'animation_type.dart';

part "duration_format.dart";

part 'extensions.dart';

///
///@author shaw
///@date 2021/4/12
///@desc
///

typedef FormatDuration = DurationFormat Function(Duration duration);
typedef AnimationBuilder = Widget Function(Widget child, String? preCharacter, String character);

class AnimateCountdownText extends StatefulWidget {
  AnimateCountdownText(
      {Key? key,
      required this.dateTime,
      required this.format,
      this.animationType = AnimationType.evaporation,
      this.characterTextStyle = const TextStyle(),
      this.suffixTextStyle = const TextStyle(),
      this.interval = const Duration(seconds: 1),
      this.expireDuration = Duration.zero,
      this.reverseExpireDuration,
      this.onDone,
      this.characterPadding = const EdgeInsets.all(1),
      this.animationBuilder,
      this.reverse = false})
      : assert(!interval.isNegative && interval != Duration.zero, "Interval must positive"),
        super(key: key);

  /// DateTime that should be compared with
  final DateTime dateTime;

  /// Format Duration to [DurationFormat]
  final FormatDuration format;

  /// Build-in animation type, will ignore this if [animationBuilder] is provided
  final AnimationType animationType;

  /// Character TextStyle
  final TextStyle characterTextStyle;

  /// Suffix TextStyle
  final TextStyle suffixTextStyle;

  /// Interval to refresh view, default to 1 second
  final Duration interval;

  /// Direction
  /// true: countdown
  /// false: timing
  final bool reverse;

  /// The max duration that should mark countdown as done,
  /// If not null, [format] will return this as duration when timeUp.
  /// default to Duration.zero
  final Duration? expireDuration;

  /// The max duration that should mark reverse countdown as done,
  /// If not null, [format] will return this as duration when timeUp.
  /// default to null
  final Duration? reverseExpireDuration;

  /// Callback when duration == [expireDuration]/[reverseExpireDuration].
  final VoidCallback? onDone;

  /// Padding of characters
  final EdgeInsets characterPadding;

  /// Custom animation
  final AnimationBuilder? animationBuilder;

  @override
  _AnimateCountdownTextState createState() => _AnimateCountdownTextState();
}

class _AnimateCountdownTextState extends State<AnimateCountdownText> {
  late Duration timeLeft;
  late final Stream<DurationFormat> _durationFormatStream;
  late DurationFormat _initDurationFormat;
  late Duration? expireDuration;
  StreamSubscription? subscription;

  @override
  void initState() {
    super.initState();
    _durationFormatStream = Stream<DurationFormat>.periodic(widget.interval, (_) {
      _updateTimeLeft();
      _checkAndHandleTimeUp();
      return widget.format(timeLeft);
    }).asBroadcastStream(onCancel: (subscription) => subscription.cancel());
    _init();
    subscription = _durationFormatStream.listen((format) {
      if (!this._initDurationFormat.sameFormatWith(format)) _refreshInitDurationFormat(format);
    });
  }

  @override
  void didUpdateWidget(covariant AnimateCountdownText oldWidget) {
    if (oldWidget.dateTime != this.widget.dateTime ||
        oldWidget.animationType != this.widget.animationType ||
        oldWidget.interval != this.widget.interval ||
        oldWidget.expireDuration != this.widget.expireDuration ||
        oldWidget.reverseExpireDuration != this.widget.reverseExpireDuration ||
        oldWidget.reverse != this.widget.reverse) {
      _init();
    }
    super.didUpdateWidget(oldWidget);
  }

  void _init() {
    this.expireDuration = widget.reverse ? widget.reverseExpireDuration : widget.expireDuration;

    _updateTimeLeft();

    _checkAndHandleTimeUp();

    _initDurationFormat = widget.format(timeLeft);
  }

  _updateTimeLeft() {
    Duration duration;

    DateTime now = DateTime.now();
    if (widget.dateTime.isUtc) {
      now = now.toUtc();
    }
    duration = widget.reverse ? now.difference(widget.dateTime) : widget.dateTime.difference(now);

    timeLeft = duration;
  }

  _refreshInitDurationFormat(DurationFormat newDurationFormat) {
    if (!mounted) return;
    setState(() {
      this._initDurationFormat = newDurationFormat;
    });
  }

  _checkAndHandleTimeUp() {
    if (this.expireDuration != null) {
      if (widget.reverse && timeLeft >= this.expireDuration! ||
          !widget.reverse && timeLeft <= this.expireDuration!) {
        widget.onDone?.call();
        timeLeft = this.expireDuration!;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> row = [];
    // Year
    if (_initDurationFormat.showYear) {
      row.add(_buildAnimateUnit((event) => event?.year, _initDurationFormat.year!));
      if (_initDurationFormat.showYearSuffix) {
        row.add(_buildSuffixItem(_initDurationFormat.yearSuffix!));
      }
    }

    // Month
    if (_initDurationFormat.showMonth) {
      row.add(_buildAnimateUnit((event) => event?.month, _initDurationFormat.month!));
      if (_initDurationFormat.showMonthSuffix) {
        row.add(_buildSuffixItem(_initDurationFormat.monthSuffix!));
      }
    }

    // Day
    if (_initDurationFormat.showDay) {
      row.add(_buildAnimateUnit((event) => event?.day, _initDurationFormat.day!));
      if (_initDurationFormat.showDaySuffix) {
        row.add(_buildSuffixItem(_initDurationFormat.daySuffix!));
      }
    }

    // Hour
    if (_initDurationFormat.showHour) {
      row.add(_buildAnimateUnit((event) => event?.hour, _initDurationFormat.hour!));
      if (_initDurationFormat.showHourSuffix) {
        row.add(_buildSuffixItem(_initDurationFormat.hourSuffix!));
      }
    }

    // Minute
    if (_initDurationFormat.showMinute) {
      row.add(_buildAnimateUnit((event) => event?.minute, _initDurationFormat.minute!));
      if (_initDurationFormat.showMinuteSuffix) {
        row.add(_buildSuffixItem(_initDurationFormat.minuteSuffix!));
      }
    }
    // Second
    if (_initDurationFormat.showSecond) {
      row.add(_buildAnimateUnit((event) => event?.second, _initDurationFormat.second!));
      if (_initDurationFormat.showSecondSuffix) {
        row.add(_buildSuffixItem(_initDurationFormat.secondSuffix!));
      }
    }

    return Row(
      children: row,
      mainAxisSize: MainAxisSize.min,
    );
  }

  /// Animate content
  _buildAnimateUnit(String? Function(DurationFormat?) streamConvert, String initValue) {
    return AnimateUnit(
        itemStream: _durationFormatStream.map(streamConvert),
        initValue: initValue,
        textStyle: widget.characterTextStyle,
        animationType: widget.animationType,
        padding: widget.characterPadding,
        animationBuilder: widget.animationBuilder);
  }

  /// Suffix
  _buildSuffixItem(String suffix) {
    return Text(suffix, style: widget.suffixTextStyle);
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }
}
