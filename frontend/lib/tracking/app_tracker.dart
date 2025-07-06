import 'package:flutter/material.dart';
import 'package:frontend/tracking/tracking_service.dart';

class AppTracker extends StatefulWidget {
  final Widget child;
  const AppTracker({super.key, required this.child});

  @override
  State<AppTracker> createState() => _AppTrackerState();
}

class _AppTrackerState extends State<AppTracker> {
  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: TrackingService.instance.logTouchEvent,
      onPointerMove: TrackingService.instance.logTouchEvent,
      onPointerUp: TrackingService.instance.logTouchEvent,
      child: widget.child,
    );
  }
}
