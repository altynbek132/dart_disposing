import 'dart:async';

import 'package:disposing/disposing_dart.dart';

extension DisposableBagExtension on DisposableBag {
  void addCallback(Future<void> callback()) {
    add(AsyncCallbackDisposable(callback));
  }
}

extension SyncDisposableExtension on SyncDisposable {
  void syncDisposeOn(SyncDisposableBag bag) {
    bag.add(this);
  }

  void disposeOn(DisposableBag bag) {
    bag.add(this);
  }

  AsyncDisposable asAsync() {
    return AsyncCallbackDisposable(() async => dispose());
  }
}

extension AsyncDisposableExtension on AsyncDisposable {
  void disposeOn(DisposableBag bag) {
    bag.add(this);
  }
}

extension StreamSubscriptionExtension<T> on StreamSubscription<T> {
  void disposeOn(DisposableBag bag) {
    bag.add(this.asDisposable());
  }

  AsyncValueDisposable<StreamSubscription<T>> asDisposable() {
    return AsyncValueDisposable(this, this.cancel);
  }
}

extension StreamControllerExtension<T> on StreamController<T> {
  void disposeOn(DisposableBag bag) {
    bag.add(this.asDisposable());
  }

  AsyncValueDisposable<StreamController<T>> asDisposable() {
    return AsyncValueDisposable(this, this.close);
  }
}

extension TimerExtension on Timer {
  void syncDisposeOn(SyncDisposableBag bag) {
    bag.add(this.asDisposable());
  }

  void disposeOn(DisposableBag bag) {
    bag.add(this.asDisposable());
  }

  SyncValueDisposable<Timer> asDisposable() {
    return SyncValueDisposable(this, this.cancel);
  }
}
