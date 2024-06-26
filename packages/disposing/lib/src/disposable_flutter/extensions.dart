import 'package:disposing/disposing_dart.dart';
import 'package:flutter/foundation.dart';

extension LitenableExtension on Listenable {
  SyncDisposable addDisposableListener(VoidCallback callback) {
    addListener(callback);
    return SyncCallbackDisposable(() => removeListener(callback));
  }
}

extension ChangeNotifierExtension on ChangeNotifier {
  void syncDisposeOn(SyncDisposableBag bag) {
    bag.add(this.asDisposable());
  }

  void disposeOn(DisposableBag bag) {
    bag.add(this.asDisposable());
  }

  SyncValueDisposable<T> asDisposable<T extends ChangeNotifier>() {
    return SyncValueDisposable<T>(this as T, dispose);
  }
}
