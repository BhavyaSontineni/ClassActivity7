import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeData _lightTheme = ThemeData.light();
  ThemeData _darkTheme = ThemeData.dark();
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _isDarkMode ? _darkTheme : _lightTheme,
      home: FadingTextScreen(toggleTheme: _toggleTheme),
    );
  }

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }
}

class FadingTextScreen extends StatefulWidget {
  final VoidCallback toggleTheme;

  FadingTextScreen({required this.toggleTheme});

  @override
  _FadingTextScreenState createState() => _FadingTextScreenState();
}

class _FadingTextScreenState extends State<FadingTextScreen> {
  bool _isVisible = true;
  Color _textColor = Colors.black;
  bool _showFrame = false;
  bool _isRotating = false;

  void _toggleVisibility() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  void _changeTextColor() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Pick a text color"),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: _textColor,
              onColorChanged: (color) {
                setState(() {
                  _textColor = color;
                });
              },
            ),
          ),
          actions: [
            TextButton(
              child: const Text("Done"),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fading Text Animation'),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: widget.toggleTheme,
          ),
          IconButton(
            icon: const Icon(Icons.color_lens),
            onPressed: _changeTextColor,
          ),
        ],
      ),
      body: PageView(
        children: [
          _buildFadingTextPage(const Duration(seconds: 1)),
          _buildFadingTextPage(const Duration(seconds: 3)),
          _buildAnimatedImage(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleVisibility,
        child: const Icon(Icons.play_arrow),
      ),
    );
  }

  Widget _buildFadingTextPage(Duration duration) {
    return Center(
      child: AnimatedOpacity(
        opacity: _isVisible ? 1.0 : 0.0,
        duration: duration,
        curve: Curves.easeInOut,
        child: Text(
          'Hello, Flutter!',
          style: TextStyle(fontSize: 24, color: _textColor),
        ),
      ),
    );
  }

  Widget _buildAnimatedImage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _isRotating = !_isRotating;
            });
          },
          child: AnimatedRotation(
            turns: _isRotating ? 1.0 : 0.0,
            duration: const Duration(seconds: 2),
            curve: Curves.easeInOut,
            child: AnimatedContainer(
              duration: const Duration(seconds: 1),
              decoration: BoxDecoration(
                border: _showFrame ? Border.all(color: Colors.blue, width: 4) : null,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Image.network(
                'https://flutter.dev/assets/homepage/carousel/slide_1-layer_0-6bdeab06e71d1a1579a054c5391b2937.png',
                width: 200,
                height: 200,
              ),
            ),
          ),
        ),
        SwitchListTile(
          title: const Text('Show Frame'),
          value: _showFrame,
          onChanged: (bool value) {
            setState(() {
              _showFrame = value;
            });
          },
        ),
      ],
    );
  }
}
