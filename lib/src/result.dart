/*

MIT License

Copyright (c) 2023 Alexandre Parra

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

*/

abstract class Result<T, E> {
  const Result();

  /// Execute the Ok or Err anonymous function based on the provided value.
  /// For example: if a function Returns a Result<int, String>,
  /// and the return value is Ok(5), then the executed function for
  /// your match function is going to be the first anonymous function (the Ok function).
  void match(Function(T ok) okFunc, Function(E err) errFunc);

  /// Execute the Ok or Err anonymous function and return the correspondent
  /// value from each function, this can be useful if your function body only
  /// needs to use the match function on some Result:
  /// ```dart
  ///Result<int, Exception> matchExample() {
  ///  return someFunction().returnMatch((ok) {
  ///    return 42;
  ///  }, (err) => Exception());
  ///}
  /// ```
  /// This means that if the executed function is the Err one, returnMatch
  /// will return an Err value and the same way around for the Ok function.
  Result<T, E> returnMatch(T Function(T ok) okFunc, E Function(E err) errFunc);

  /// Narrows the return value of both the Err and Ok functions to a single type,
  /// in case you need `match` to return exactly the same type.
  B narrowMatch<B>(B Function(T ok) okFunc, B Function(E err) errFunc);

  /// Transforms a Result with a set of types to another Result with other types. If
  /// you have a Result<int, Exception> but want to transform it into a Result<bool, String>
  /// you can use `transformMatch<bool, String>` and return the new values from inside
  /// the Ok and Err function.
  /// Example:
  /// ```dart
  /// Result<bool, String> transformExample() =>
  ///     // someFunction has a return type of Result<int, Exception>
  ///     someFunction.transformMatch<bool, String>(
  ///       // ok is and int.
  ///       (ok) {
  ///          if (ok > 5) return true else false;
  ///       }
  ///       // err is and Exception.
  ///       (err) => err.toString()
  ///     );
  /// ```
  Result<TT, EE> transformMatch<TT, EE>(
      TT Function(T ok) okFunc, EE Function(E err) errFunc);

  /// Return true if the value is an Ok.
  bool get isOk;

  /// Returns true if the value is an Err.
  bool get isErr;
}

class Ok<T, E> extends Result<T, E> {
  final T ok;

  const Ok(this.ok);

  @override
  void match(Function(T ok) okFunc, Function(E err) errFunc) {
    okFunc(this.ok);
  }

  @override
  Result<T, E> returnMatch(T Function(T ok) okFunc, E Function(E err) errFunc) {
    return Ok(okFunc(this.ok));
  }

  @override
  B narrowMatch<B>(B Function(T ok) okFunc, B Function(E err) errFunc) {
    return okFunc(this.ok);
  }

  @override
  Result<TT, EE> transformMatch<TT, EE>(
      TT Function(T ok) okFunc, EE Function(E err) errFunc) {
    return Ok(okFunc(this.ok));
  }

  @override
  bool get isOk => true;

  @override
  bool get isErr => false;
}

class Err<T, E> extends Result<T, E> {
  final E err;

  const Err(this.err);

  @override
  void match(Function(T ok) okFunc, Function(E err) errFunc) {
    errFunc(this.err);
  }

  @override
  Result<T, E> returnMatch(T Function(T ok) okFunc, E Function(E err) errFunc) {
    return Err(errFunc(this.err));
  }

  @override
  B narrowMatch<B>(B Function(T ok) okFunc, B Function(E err) errFunc) {
    return errFunc(this.err);
  }

  @override
  Result<TT, EE> transformMatch<TT, EE>(
      TT Function(T ok) okFunc, EE Function(E err) errFunc) {
    return Err(errFunc(this.err));
  }

  @override
  bool get isOk => false;

  @override
  bool get isErr => true;
}
