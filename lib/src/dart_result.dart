abstract class Result<T, E> {
  const Result();

  /// Execute the Ok or Err anonymous function based on the provided value.
  /// For example: if a function Returns a Result<int, String>,
  /// and the return value is Ok(5), then the executed function for
  /// your match function is going to be the first anonymous function (the Ok function).
  void match(Function(T ok) ok, Function(E err) err);

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
  Result<T, E> returnMatch(T Function(T ok) ok, E Function(E err) err);

  /// Narrows the return value of both the Err and Ok functions to a single type,
  /// in case you need `match` to return exactly the same type.
  B narrowMatch<B>(B Function(T ok) ok, B Function(E err) err);

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
      TT Function(T ok) ok, EE Function(E err) err);

  /// Return true if the value is an Ok.
  bool get isOk;

  /// Returns true if the value is an Err.
  bool get isErr;
}

class Ok<T, E> extends Result<T, E> {
  final T _ok;
  const Ok(this._ok);

  @override
  void match(Function(T ok) ok, Function(E err) err) {
    ok(_ok);
  }

  @override
  Result<T, E> returnMatch(T Function(T ok) ok, E Function(E err) err) {
    return Ok(ok(_ok));
  }

  @override
  B narrowMatch<B>(B Function(T ok) ok, B Function(E err) err) {
    return ok(_ok);
  }

  @override
  Result<TT, EE> transformMatch<TT, EE>(
      TT Function(T ok) ok, EE Function(E err) err) {
    return Ok(ok(_ok));
  }

  @override
  bool get isOk => true;

  @override
  bool get isErr => false;
}

class Err<T, E> extends Result<T, E> {
  final E _err;
  const Err(this._err);

  @override
  void match(Function(T ok) ok, Function(E err) err) {
    err(_err);
  }

  @override
  Result<T, E> returnMatch(T Function(T ok) ok, E Function(E err) err) {
    return Err(err(_err));
  }

  @override
  B narrowMatch<B>(B Function(T ok) ok, B Function(E err) err) {
    return err(_err);
  }

  @override
  Result<TT, EE> transformMatch<TT, EE>(
      TT Function(T ok) ok, EE Function(E err) err) {
    return Err(err(_err));
  }

  @override
  bool get isOk => false;

  @override
  bool get isErr => true;
}
