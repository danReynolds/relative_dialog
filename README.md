# Relative Dialog

A flutter package for displaying a dialog using the [showDialog](https://api.flutter.dev/flutter/material/showDialog.html) API relative to the widget associated with the given BuildContext.

![Basic demo 2 gif](./demo2.gif).

![Basic demo gif](./demo.gif).

# Example

```dart
Builder(
  builder: (context) {
    return ElevatedButton(
      child: Text('Show relative dialog'),
      onPressed: () {
        showRelativeDialog(
          // The context of the widget to show the dialog relative to.
          context: context,
          builder: (context) {
            return Text(
              'Done!',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          }
        );
      },
    );
  }
)
```

# Demo

[Full demo](https://github.com/danReynolds/relative_dialog/blob/master/example/lib/main.dart).
