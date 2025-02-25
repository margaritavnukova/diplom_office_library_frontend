import 'package:flutter/material.dart';
import 'login_info_class.dart';

class MyInheritedWidget extends InheritedWidget {
  final LoginInfo? login;

  const MyInheritedWidget({
    super.key, 
    this.login,
    required super.child
  });

  static MyInheritedWidget? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MyInheritedWidget>();
  }

  static MyInheritedWidget of(BuildContext context) {
    final MyInheritedWidget? result = maybeOf(context);
    assert(result != null, 'No MyInheritedWidget found in context');
    return result!;
  }
  
  @override
  bool updateShouldNotify(MyInheritedWidget oldWidget) =>
    login != oldWidget.login;
}