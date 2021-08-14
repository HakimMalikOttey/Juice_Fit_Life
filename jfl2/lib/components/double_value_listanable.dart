import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class DoubleValueListenable<A, B> extends StatelessWidget {
  final ValueListenable<Object?> first;
  final ValueListenable<Object?> second;
  final Widget child;
  final Widget Function(BuildContext context, A a, B b, Widget child) builder;
  DoubleValueListenable(
      {required this.first,
      required this.second,
      required this.builder,
      required this.child});
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: first,
        builder: (_, value1, __) {
          return ValueListenableBuilder(
              valueListenable: second,
              builder: (context, value2, __) {
                return builder(context, value1 as A, value2 as B, child);
              });
        });
  }
}
