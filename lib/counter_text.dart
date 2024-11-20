import 'package:flutter/material.dart';

class CounterText extends ImplicitlyAnimatedWidget {
  final int value;
  final TextStyle? style;

  const CounterText({
    super.key,
    required super.duration,
    required this.value,
    this.style,
  });

  @override
  ImplicitlyAnimatedWidgetState<CounterText> createState() => _CounterTextState();
}

class _CounterTextState extends AnimatedWidgetBaseState<CounterText> {
  IntTween? _counter;

  @override
  Widget build(BuildContext context) {
    return Text(
      '${_counter?.evaluate(animation) ?? widget.value}',
      style: widget.style,
    );
  }

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _counter = visitor(
      _counter,
      widget.value,
      (dynamic value) => IntTween(begin: value as int),
    ) as IntTween?;
  }
}
