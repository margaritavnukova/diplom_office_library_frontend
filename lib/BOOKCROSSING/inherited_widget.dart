import 'package:flutter/material.dart';
import 'login_info_class.dart';

class MyInheritedWidget extends InheritedWidget {
  LoginInfo? login;

  MyInheritedWidget({
    super.key, 
    this.login,
    required super.child
  });

  void setLogin(LoginInfo l){
    login = l;
  }

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