import 'package:flutter/material.dart';
import 'package:threee/threee.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Threee Logo Demo',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const LogoDemoPage(),
    );
  }
}

class LogoDemoPage extends StatelessWidget {
  const LogoDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF414141),
      appBar: AppBar(
        title: const Text('Animated Logo Demo'),
        backgroundColor: const Color(0xFF414141),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const AnimatedLogo(size: 200, backgroundColor: Color(0xFF414141)),
            const SizedBox(height: 40),
            const Text(
              'Animated 3D Logo',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Bouncing animations with gradient effects',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedLogo(
                  size: 100,
                  backgroundColor: const Color(0xFF414141),
                ),
                const SizedBox(width: 20),
                AnimatedLogo(
                  size: 150,
                  backgroundColor: const Color(0xFF414141),
                ),
                const SizedBox(width: 20),
                AnimatedLogo(
                  size: 100,
                  backgroundColor: const Color(0xFF414141),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
