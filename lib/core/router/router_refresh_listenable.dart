import 'dart:async';

import 'package:flutter/foundation.dart';

class RouterRefreshListenable extends ChangeNotifier {
  RouterRefreshListenable(Stream<Object?> stream) {
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<Object?> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
