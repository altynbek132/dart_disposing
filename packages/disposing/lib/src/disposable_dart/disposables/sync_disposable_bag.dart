import 'package:disposing/disposing_dart.dart';

class SyncDisposableBag extends Iterable<SyncDisposable>
    implements SyncDisposable {
  late final SyncCallbackDisposable _disposable;
  final _disposables = <SyncDisposable>[];

  SyncDisposableBag() {
    _disposable = SyncCallbackDisposable(_disposeInternal);
  }

  @override
  bool get isDisposed => _disposable.isDisposed;

  int get length => _disposables.length;

  @override
  Iterator<SyncDisposable> get iterator => _disposables.iterator;

  @override
  void throwIfNotAvailable([String? target]) {
    _disposable.throwIfNotAvailable(target);
  }

  void add(SyncDisposable disposable) {
    disposable.throwIfNotAvailable();
    throwIfNotAvailable('add');
    _disposables.add(disposable);
  }

  void remove(SyncDisposable disposable) {
    throwIfNotAvailable('remove');
    _disposables.remove(disposable);
  }

  void removeAt(int index) {
    throwIfNotAvailable('removeAt');
    _disposables.removeAt(index);
  }

  void clear() {
    throwIfNotAvailable('clear');
    _disposables.clear();
  }

  void dispose() {
    _disposable.dispose();
  }

  void _disposeInternal() {
    final Map<Disposable, Object> _exs = {};
    for (final d in _disposables) {
      try {
        d.dispose();
      } on Object catch (e) {
        _exs[d] = e;
      }
    }

    _disposables.clear();

    if (_exs.length > 0) {
      throw BagAggregateException(_exs);
    }
  }
}
