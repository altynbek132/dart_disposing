import 'dart:async';

import 'package:disposing/disposing_dart.dart';

typedef UsingBody<T, R> = FutureOr<R> Function(T value);

Future<R> using<T extends Disposable, R>(T value, UsingBody<T, R> body) async {
  AsyncDisposable disp;
  if (value is SyncDisposable) {
    value.throwIfNotAvailable();
    disp = value.asAsync();
  } else if (value is AsyncDisposable) {
    value.throwIfNotAvailable();
    disp = value;
  } else {
    throw UnknownDisposableException(value);
  }

  try {
    return await body(value);
  } finally {
    await disp.disposeAsync();
  }
}

Future<R> usingValue<T, R>(
  AsyncValueDisposable<T> disposable,
  UsingBody<T, R> body,
) async {
  return using(disposable, (value) {
    return body(disposable.value);
  });
}
