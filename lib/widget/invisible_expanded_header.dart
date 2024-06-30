import 'package:flutter/material.dart';

// https://stackoverflow.com/a/71881766

class InvisibleExpandedHeader extends StatefulWidget {
  final Widget child;

  const InvisibleExpandedHeader({super.key, required this.child});

  @override
  InvisibleExpandedHeaderState createState() => InvisibleExpandedHeaderState();
}

class InvisibleExpandedHeaderState extends State<InvisibleExpandedHeader> {
  ScrollPosition? position;
  bool? isVisible;

  @override
  void dispose() {
    removeListener();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    removeListener();
    addListener();
  }

  void addListener() {
    position = Scrollable.of(context).position;
    position?.addListener(positionListener);
    positionListener();
  }

  void removeListener() {
    position?.removeListener(positionListener);
  }

  void positionListener() {
    final FlexibleSpaceBarSettings? settings =
        context.dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>();
    bool visible =
        settings == null || settings.currentExtent <= settings.minExtent;

    if (isVisible != visible) {
      setState(() {
        isVisible = visible;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isVisible ?? false,
      child: widget.child,
    );
  }
}
