import 'dart:async';

import 'package:flutter/foundation.dart';

typedef TimerFactory = Timer Function(Duration duration, VoidCallback callback);

Timer createTimer(Duration duration, VoidCallback callback) {
  return Timer(duration, callback);
}
