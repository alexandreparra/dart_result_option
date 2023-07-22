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

abstract class Option<T> {
  factory Option.of(T value) {
    if (value == null) {
      return None();
    } else {
      return Some(value);
    }
  }

  /// unwrap function mimics the match pattern of Some(x) and None in Rust.
  /// If the result from an Option is a Some, then the [someFunc] function is executed,
  /// if not, the [noneFunc] function is executed.
  /// Example usage:
  /// ```dart
  /// functionThatReturnsOption()
  ///   .match((some) {/* Some branch with value T*/}, () {/* None branch */})
  /// ```
  void match(Function(T) someFunc, Function() noneFunc);

  /// Indicates if the Option is as Some or None.
  bool get isNone;
}

class Some<T> implements Option<T> {
  final T value;

  const Some(this.value);

  @override
  bool get isNone => false;

  @override
  void match(Function(T some) someFunc, Function() noneFunc) {
    someFunc(value);
  }
}

class None<_> implements Option<_> {
  const None();

  @override
  bool get isNone => true;

  @override
  void match(Function(_ some) someFunc, Function() noneFunc) {
    noneFunc();
  }
}
