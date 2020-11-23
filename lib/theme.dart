import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppThemeNew extends InheritedWidget {
  final Brightness brightness;

  const AppThemeNew({@required Widget child, this.brightness = Brightness.light}) : super(child: child);

  CupertinoThemeData get cupertinoTheme => CupertinoThemeData(
        brightness: brightness,
      );

  ThemeData get materialTheme => (_isLight ? ThemeData.light() : ThemeData.dark()).copyWith(
        primaryColor: _isLight ? Colors.white : Colors.black,
      );

  TextStyle get bodyTextStyle => Platform.isIOS
      ? CupertinoTextThemeData().textStyle.copyWith(color: textColor)
      : materialTheme.textTheme.bodyText1.copyWith(color: textColor);

  Color get textColor => _isLight ? Color(0xff222222) : Color(0xffdddddd);
  Color get chordColor => _isLight ? Color(0xff3961ad) : Color(0xff4dc0b5);

  bool get _isLight => brightness == Brightness.light;

  @override
  bool updateShouldNotify(AppThemeNew oldWidget) => brightness != oldWidget.brightness;

  static AppThemeNew of(BuildContext context) => context.dependOnInheritedWidgetOfExactType();
}

class AppTheme {
  AppTheme._();

  static final AppTheme shared = AppTheme._();

  final ThemeData light = ThemeData.light().copyWith(
    primaryColor: Colors.white,
    primaryIconTheme: IconThemeData(color: Color(0xff222222)),
    primaryTextTheme: TextTheme(headline6: TextStyle(color: Color(0xff222222))),
    scaffoldBackgroundColor: Colors.white,
    backgroundColor: Colors.white,
    bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.white),
  );

  final ThemeData dark = ThemeData.dark().copyWith(
    primaryColor: Colors.black,
    primaryIconTheme: IconThemeData(color: Color(0xffdddddd)),
    primaryTextTheme: TextTheme(headline6: TextStyle(color: Color(0xffdddddd))),
    scaffoldBackgroundColor: Colors.black,
    backgroundColor: Colors.black,
    bottomSheetTheme: BottomSheetThemeData(backgroundColor: Color(0xff252525)),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(backgroundColor: Color(0xff101010)),
  );

  Color textColor(BuildContext context) => _isLight(context) ? Color(0xff222222) : Color(0xffdddddd);

  Color chordColor(BuildContext context) => _isLight(context) ? Color(0xff3961ad) : Color(0xff4dc0b5);

  Color appBarDividerColor(BuildContext context) => _isLight(context) ? Color(0xff888888) : Color(0xff777777);

  Color borderColor(BuildContext context) => _isLight(context) ? Color(0xff7d8185) : Color(0xff827e7a);

  Color highlightColor(BuildContext context) => _isLight(context) ? Color(0xffdfdfdf) : Color(0xff202020);

  // selector theme

  Color selectedRowBackgroundColor(BuildContext context) => _isLight(context) ? Color(0x15005af7) : Color(0x3300f7de);

  Color selectedRowColor(BuildContext context) => chordColor(context);

  Color selectedColor(BuildContext context) => _isLight(context) ? Color(0xff9a9a9a) : Color(0xff656565);

  Color unSelectedColor(BuildContext context) => _isLight(context) ? Color(0xffd7d7d7) : Color(0xff282828);

  // search theme

  Color searchFieldIconColor(BuildContext context) => _isLight(context) ? Color(0xff5e6368) : Color(0xffa19c97);

  Color _searchFieldPlaceholderColor(BuildContext context) => _isLight(context) ? Color(0xff9aa0a5) : Color(0xff655f5a);

  TextStyle searchFieldPlaceholderColorTextStyle(BuildContext context) =>
      AppThemeNew.of(context).bodyTextStyle.copyWith(
            color: _searchFieldPlaceholderColor(context),
          );

  // filters theme
  Color filtersTextColor(BuildContext context) => _isLight(context) ? Color(0xff222529) : Color(0xffdddad6);

  Color filtersSectionSeparatorColor(BuildContext context) => _isLight(context) ? Color(0xffe8e8e8) : Color(0xff171717);

  Color filterBorderColor(BuildContext context) => _isLight(context) ? Color(0xffd1d1d1) : Color(0xff2e2e2e);

  bool _isLight(BuildContext context) => MediaQuery.platformBrightnessOf(context) == Brightness.light;
}
