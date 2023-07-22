import 'package:dart_result_option/dart_result_option.dart';
import 'package:test/test.dart';

void main() {
  // Function that can return Some or None
  Option<int> testOption(int value) {
    if (value <= 2) {
      return None();
    } else {
      return Some(value * value);
    }
  }

  group('Dart 3.0 test', () {
    test('Test Option-Some-None with switch pattern', () {
      bool isSome = false;
      final option = testOption(5);

      switch (option) {
        case Some(value: var some):
          expect(some, 25);
          isSome = true;
        case None():
          isSome = false;
      }

      expect(isSome, true);
    });
  });

  group('Test a function that returns an Optional', () {
    test('Passing a value greater than 2 to testOption returns a Some<int>',
        () {
      final result = testOption(5);
      expect(result, isA<Some<int>>());
    });

    test('Passing a value less or equals 2 to testOption returns None<int>',
        () {
      final result = testOption(2);
      expect(result, isA<None<int>>());
    });
  });

  group('Use the unwrap method from Optional', () {
    test('Execute the Some branch of unwrap', () {
      bool isSome = false;

      testOption(5).match((some) {
        isSome = true;
      }, () {
        isSome = false;
      });

      expect(isSome, true);
    });

    test('Execute the None branch of unwrap', () {
      bool isNone = false;

      testOption(2).match((some) {
        isNone = false;
      }, () {
        isNone = true;
      });

      expect(isNone, true);
    });
  });

  group('isNone getter tests', () {
    test('isNone should be false on a Some instance', () {
      bool isNone = testOption(5).isNone;
      expect(isNone, false);
    });

    test('isNone should be true on a None instance', () {
      bool isNone = testOption(2).isNone;
      expect(isNone, true);
    });
  });
}
