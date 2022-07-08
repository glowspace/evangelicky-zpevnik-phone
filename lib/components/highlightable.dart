import 'package:flutter/material.dart';

class Highlightable extends StatefulWidget {
  final Widget child;

  final Function()? onTap;
  final Function()? onLongPress;

  final Color? color;
  final Color? highlightColor;

  final EdgeInsets? padding;

  final bool highlightBackground;

  // to ignore highlight when highlightable child should be highlighted
  final List<GlobalKey>? highlightableChildKeys;

  const Highlightable({
    Key? key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.color,
    this.highlightColor,
    this.padding,
    this.highlightBackground = false,
    this.highlightableChildKeys,
  }) : super(key: key);

  @override
  State<Highlightable> createState() => _HighlightableState();
}

class _HighlightableState extends State<Highlightable> {
  bool _isHighlighted = false;

  @override
  Widget build(BuildContext context) {
    Color? color = widget.color ?? Colors.transparent;
    Color? highlightColor =
        widget.highlightColor ?? (widget.highlightBackground ? Theme.of(context).highlightColor : Colors.white);

    if (widget.highlightBackground && _isHighlighted) {
      color = Color.alphaBlend(highlightColor, color);
    }

    Widget child = Container(
      color: color,
      padding: widget.padding,
      child: widget.child,
    );

    if (!widget.highlightBackground) {
      child = ColorFiltered(
        colorFilter: ColorFilter.mode(highlightColor.withOpacity(_isHighlighted ? 0.5 : 1), BlendMode.modulate),
        child: child,
      );
    }

    return GestureDetector(
      onPanDown: (details) => setState(() => _isHighlighted = !_containsChild(details)),
      onPanEnd: (_) => setState(() => _isHighlighted = false),
      // delayed, so the highlight is visible when fast tap happens
      onPanCancel: () => setState(() => _isHighlighted = false),
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      behavior: HitTestBehavior.translucent,
      child: child,
    );
  }

  bool _containsChild(DragDownDetails details) {
    if (widget.highlightableChildKeys == null) return false;

    for (final key in widget.highlightableChildKeys!) {
      final renderBox = key.currentContext?.findRenderObject() as RenderBox?;

      if (renderBox != null) {
        final rectangle = renderBox.localToGlobal(Offset.zero) & renderBox.size;

        if (rectangle.contains(details.globalPosition)) return true;
      }
    }

    return false;
  }
}
