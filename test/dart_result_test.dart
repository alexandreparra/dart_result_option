import 'package:dart_result/dart_result.dart';
import 'package:test/test.dart';

void main() {
  Result<int, Exception> sumPositive(int n1, int n2) {
    if (n1 + n2 < 0) {
      return Err(Exception());
    } else {
      return Ok(n1 + n2);
    }
  }

  Result<int, Exception> sumWrap(int n1, int n2) {
    return sumPositive(n1, n2).returnMatch((ok) {
      if (ok == 1) return 5;

      return 6;
    }, (err) => Exception());
  }

  group('match tests', () {
    test('Test match function with an err value', () {
      bool isFalse = false;

      final result = sumPositive(2, -4);
      result.match((ok) => isFalse = false, (err) => isFalse = true);

      expect(isFalse, true);
      expect(isFalse, result.isErr);
    });

    test('Test match function with an ok value', () {
      bool isOk = false;

      final result = sumPositive(5, 5);
      result.match((ok) => isOk = true, (err) => isOk = false);

      expect(isOk, true);
      expect(isOk, result.isOk);
    });
  });

  group('returnMatch tests', () {
    test('Test if the function sumWrap returns the correct Result and is an Ok',
        () async {
      bool isOk = false;

      final result = sumWrap(5, 5);
      result.match((ok) => isOk = true, (err) => isOk = false);

      expect(isOk, true);
      expect(isOk, result.isOk);
      expect(result, isA<Result<int, Exception>>());
    });

    test(
        'Test if the function sumWrap returns the correct Result and is an Error',
        () async {
      bool isErr = false;
      final result = sumWrap(2, -4);
      result.match((ok) => isErr = false, (err) => isErr = true);

      expect(isErr, true);
      expect(isErr, result.isErr);
      expect(result, isA<Result<int, Exception>>());
    });
  });

  group('narrowMatch tests', () {
    test(
        'Narrow the return of positiveSum to a bool and check if Ok was executed',
        () {
      final result =
          sumPositive(5, 5).narrowMatch<bool>((ok) => true, (err) => false);

      expect(result, true);
    });

    test(
        'Narrow the return of positiveSum to a bool and check if Err was executed',
        () {
      final result =
          sumPositive(2, -4).narrowMatch<bool>((ok) => false, (err) => true);

      expect(result, true);
    });
  });

  group('transformMatch tests', () {
    test('transform sumPositive to Result<bool, String> and test the Ok value',
        () {
      bool isOk = false;
      final result = sumPositive(5, 5).transformMatch<bool, String>((ok) {
        if (ok > 5) {
          isOk = true;
          return true;
        }

        return false;
      }, (err) {
        isOk = false;
        return err.toString();
      });

      expect(isOk, true);
      expect(isOk, result.isOk);
      expect(result, isA<Result<bool, String>>());
    });

    test('transform sumPositive to Result<bool, String> and test the Ok value',
        () {
      bool isErr = false;
      final result = sumPositive(2, -4).transformMatch<bool, String>((ok) {
        if (ok > 5) {
          isErr = false;
          return true;
        }

        return false;
      }, (err) {
        isErr = true;
        return err.toString();
      });

      expect(isErr, true);
      expect(isErr, result.isErr);
      expect(result, isA<Result<bool, String>>());
    });
  });
}
