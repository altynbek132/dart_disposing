import 'package:disposing/disposing_dart.dart';

abstract class Disposable {
  bool get isDisposed;

  void throwIfNotAvailable([String? target]) {
    if (isDisposed) {
      throw DisposedException(this, target);
    }
  }
}
