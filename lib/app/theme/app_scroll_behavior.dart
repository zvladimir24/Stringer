import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// A regular Windows mouse has no horizontal wheel, and Flutter's default
/// [ScrollBehavior] only allows touch/trackpad/stylus pointers to drag-scroll
/// - a mouse click-drag does nothing out of the box. This adds the mouse to
/// the allowed drag devices so wide content (like the debtors table) can be
/// panned left-right by clicking and dragging, not just via wheel/trackpad.
class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    ...super.dragDevices,
    PointerDeviceKind.mouse,
  };
}
