# Threee

A Flutter package that provides an animated 3D-style geometric logo widget with smooth bouncing animations and gradient effects.

## Features

- 🎨 Beautiful 3D-style geometric logo design
- ✨ Smooth bouncing animations
- 🌈 Animated gradient effects
- 📦 Lightweight and easy to use
- 🎯 Fully customizable size and colors

## Getting started

Add this package to your `pubspec.yaml`:

```yaml
dependencies:
  threee: ^0.0.1
```

Then run:

```bash
flutter pub get
```

## Usage

Import the package:

```dart
import 'package:threee/threee.dart';
```

Use the `AnimatedLogo` widget:

```dart
AnimatedLogo(
  size: 200,
  backgroundColor: Color(0xFF414141),
)
```

### Example

```dart
import 'package:flutter/material.dart';
import 'package:threee/threee.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color(0xFF414141),
        body: Center(
          child: AnimatedLogo(
            size: 200,
            backgroundColor: Color(0xFF414141),
          ),
        ),
      ),
    );
  }
}
```

## Parameters

- `size` (double): The width and height of the logo. Default: `200`
- `backgroundColor` (Color): The background color of the container. Default: `Color(0xFF414141)`

## Animations

The logo includes several synchronized animations:

- **Bounce**: Two polygons with vertical bouncing motion (4s ease-in-out)
- **Umbral**: Animated gradient color transitions (4s infinite)
- **Particles**: Small decorative particles with vertical movement (4s ease-in-out)

All animations run continuously and are optimized for smooth performance.

## Example App

Check out the `example/` directory for a complete example app demonstrating the widget.

## License

See the LICENSE file for details.
