import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zpevnik/platform/mixin.dart';

class PlatformSwitch extends StatelessWidget with PlatformMixin {
  final bool value;
  final Function(bool)? onChanged;

  const PlatformSwitch({Key? key, required this.value, this.onChanged}) : super(key: key);

  @override
  Widget buildAndroid(BuildContext context) => Switch(value: value, onChanged: onChanged);
  @override
  Widget buildIos(BuildContext context) => CupertinoSwitch(value: value, onChanged: onChanged);
}
