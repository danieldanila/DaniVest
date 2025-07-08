import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/tracking/tracking_service.dart';

class TrackingTextController extends TextEditingController {
  String _previousText = "";
  DateTime _lastChangeTime = DateTime.now();

  static bool _handlerAdded = false;

  TrackingTextController({String? text}) : super(text: text) {
    _previousText = text ?? "";

    if (!_handlerAdded) {
      HardwareKeyboard.instance.addHandler(_globalHandleKeyEvent);
      _handlerAdded = true;
      print("Global Keyboard Handler Added.");
    }
  }

  bool _globalHandleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      final keyName = event.logicalKey.debugName ?? "Unknown Key";
      final keyId = event.logicalKey.keyId;

      TrackingService.instance.logKeyEvent(
        keyId: keyId,
        keyName: keyName,
        eventType: "down",
      );
    } else if (event is KeyUpEvent) {
      final keyName = event.logicalKey.debugName ?? "Unknown Key";
      final keyId = event.logicalKey.keyId;

      TrackingService.instance.logKeyEvent(
        keyId: keyId,
        keyName: keyName,
        eventType: "up",
      );
    }

    return false;
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_globalHandleKeyEvent);
    _handlerAdded = false;
    super.dispose();
  }

  @override
  void notifyListeners() {
    final now = DateTime.now();
    final currentText = text;

    if (_previousText != currentText) {
      final duration = now.difference(_lastChangeTime);

      TrackingService.instance.logKeystrokeChange(
        previous: _previousText,
        current: currentText,
        interval: duration,
      );

      _previousText = currentText;
      _lastChangeTime = now;
    }

    super.notifyListeners();
  }
}
