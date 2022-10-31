## Dart Result
Dart Result is a simple library to handle errors inspired by the [Rust enum Result](https://doc.rust-lang.org/std/result/) which is made of two parts:
- `Ok<T>` that denotes some operation was successful and comes with a value T
- `Err<E>` that denotes some operation failed and comes with a value E

Every language has it's own way of handling errors, for example, Go has the [ok, err idiom](https://go.dev/blog/error-handling-and-go), and Kotlin has the powerful asynchronous [Flow](https://kotlinlang.org/docs/flow.html#transparent-catch) (which has way more capabilities than just error handling).

As Dart is a more object-oriented programming language and implements the try-catch idiom, my goal here is to make simple to pass success or failure through the app layers.

## Proposal
As Dart uses try-catch, some operations may become very verbose if you have a lot of layers on your app (notably if you are using clean architecture), so instead of wrapping everything in try-catch like:

```dart
class SomeUseCase {
  final _repository = SomeRepository()

  SuccessValue call() {
    try {
        _repository.getSomeValue()
    } catch {
      // handle exception
    }
  }
}

class SomeRepository {
  final _dataSource = SomeDataSource()

  SuccessValue getSomeValue() {
    try {
        _dataSource.getSomeValue()
    } catch {
      // handle exception
    }
  }
}

class SomeDataSource {
  SuccessValue getSomeValue() {
    try {
        // some api request
    } catch {
      // handle exception
    }
  }
}
```

This can notably take a lot of space, make readability worse and (maybe) compromise performance. Sometimes you won't be using some of this layers and you just need to passthrough them, Result makes it easy and more readable:

```dart
class SomeUseCase {
  final _repository = SomeRepository()

  Result<int, Exception> call() {
    return _repository.getSomeValue()
  }
}

class SomeRepository {
  final _dataSource = SomeDataSource()

  Result<int, Exception> getSomeValue() {
    return _dataSource.getSomeValue()
  }
}

class SomeDataSource {
  Result<int, Exception> getSomeValue() {
    // try-catch will only be used on one layer.
    try {
      // some api request
      return Ok(42);
    } catch (e) {
      // handle exception
      return Err(e);
    }
  }
}
```

By doing this we only use try-catch once and encapsulate it with an easier to deal and reason about way of handling success and failures. 

A lot of C++ programmers (specially in large code bases) and other modern languages, have moved away from using try-catch to use alternative error handling styles, that's the goal with Result.

## Usage
The simplest way to use Result is by defining a function that can return a Result with 2 possible types

```dart
// We can read this as
Result<String, Exception> myFunction() {
  if ( /* something */) {
    return Ok("Success")
  }

  // else
  return Err(Exception())
}
```
Here we are defining a Result in which a String is the value that represents something that went well (Ok) and an Exception to represent something that went wrong (Err).
This types will let us know what to expect once we are calling `myFunction`

To be sure that we are treating the success and failure path, Result exposes to us some handy functions:

`match` will expose two closures which will capture the success and failure value of a given Result, here we need to declare the two closures so that we can handle the success and failure, making it more explicit that we need to treat both outcomes.

```dart
myFunction.match(
  // ok is a String
  (ok) => /* do something with the string */
  // err is an Exception
  (err) => /* do something with the exception */
)
```
A real world example with Flutter:

```dart
// Here we are trying to open a file and if everything goes correctly 
// we'll display the file contents, if not we are going to compose an error message
// for a snackbar
void openFile(String fileName) {
  // tryOpenFile returns a Result<String, Exception>
  Utils.tryOpenFile.match(
    // Here fileContent is the Ok value which is a String.
    (fileContent) => _fileContents = ok
    (err) => _errorMessage = err.toString()
  )

  // function from the provider package
  notifyListeners();
}
```

`returnMatch` is useful when you need to refine some data and still return the same Result you received.

Here we have a simple function that will call `someFunction` which returns a `Result<int, Exception>` and we'll return the same Result but before that we are going to process the Ok or Err that we received.
```dart
Result<int, Exception> matchExample() {
  return someFunction().returnMatch((ok) {
    if ( /* something */ ) {
      return 42;
    }

    return 50;
  }, (err) => Exception());
}

// or the simple and straightforward syntax.

Result<int, Exception> matchExample() =>
  someFunction().returnMatch(
    (ok) => 42;
    (err) => Exception());
```

`returnMatch` is best used when you have multiple layers on your app and you know that treating everything inside one function will be too large.


`narrowMatch` will narrow the return value from both the Ok and Err to a single type. This is good when you need only one type to come out of the `match` function.

```dart
// We narrow a result that can hold 2 distinct values to a single boolean.
// Notice that both the Ok and Err functions need to return the same type.
bool correctlyReturned() =>
  someFunction().narrowMatch<bool>(
    (ok) => true;
    (err) => false;
  );
```

`transformMatch` will change the return value of your Result making it easy to process from one Result with two different types to another Result with other two types.

```dart
Result<int, Exception> sumPositive(int n1, int n2) {
  if (n1 + n2 < 0) {
    return Err(Exception());
  } else {
    return Ok(n1 + n2);
  }
}

sumPositive(2, -4).transformMatch<bool, String>((ok) {
  if (ok > 5) {
    isErr = false;
    return true;
  }

  return false;
}, (err) {
  isErr = true;
  return err.toString();
});
```

## Notes
There are notable packages which are already used for the same purpose as dart_result like the [dart](https://pub.dev/packages/dartz) package, but dartz is focused on implementing functional programming techniques in the most functional fashion, it's not just exposing the `Either` class. 

dart_result comes with just one purpose, handle success and failure, and makes readability way easier by just using simple class inheritance. 

Even other either implementations come with a lot of functional inclined techniques. dart_result is meant to be simple and use simple inheritance to achieve the same goals, making readability way easier (especially if you're not used to functional programming)

As Rob Pike (one of the Go programming language designers) would say - "A little copying is better than a little dependency", feel free to just copy the Result implementation (which is just one file) and make your changes accordingly to your own needs. There's no 'one size fits all'.

