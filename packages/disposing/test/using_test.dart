import 'package:disposing/disposing_dart.dart';
import 'package:test/test.dart';

void main() async {
  group('using', () {
    test('dispose after using', () async {
      final disp = AsyncCallbackDisposable(
          () => Future.delayed(Duration(milliseconds: 100)));
      await using(disp, (_) async {});
      expect(disp.isDisposed, true);
    });

    test('throw if disposed', () async {
      final disp = AsyncCallbackDisposable(
          () => Future.delayed(Duration(milliseconds: 100)));
      final dispFuture = disp.disposeAsync();

      expect(
        () => using(disp, (_) async {}),
        throwsA(isA<DisposingException>()),
      );
      await dispFuture;
      expect(
        () => using(disp, (_) async {}),
        throwsA(isA<DisposedException>()),
      );
    });
  });

  group('usingValue', () {
    const value = 'TEST_VALUE';

    test('correct argument', () async {
      final disp = AsyncValueDisposable(value, () async => {});
      await usingValue(disp, (actual) async {
        expect(actual, value);
      });
    });

    test('dispose after using', () async {
      final disp = AsyncValueDisposable(value, () async => {});
      await usingValue(disp, (_) async {});
      expect(disp.isDisposed, true);
    });

    test('throw if disposed', () async {
      final disp = AsyncValueDisposable(value, () async => {});
      final dispFuture = disp.disposeAsync();

      expect(
        () => using(disp, (_) async {}),
        throwsA(isA<DisposingException>()),
      );
      await dispFuture;
      expect(
        () => using(disp, (_) async {}),
        throwsA(isA<DisposedException>()),
      );
    });
  });
}
