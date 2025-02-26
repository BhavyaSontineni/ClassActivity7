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
          title: Text("Pick a text color"),
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
              child: Text("Done"),
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
        title: Text('Fading Text Animation'),
        actions: [
          IconButton(
            icon: Icon(Icons.brightness_6),
            onPressed: widget.toggleTheme,
          ),
          IconButton(
            icon: Icon(Icons.color_lens),
            onPressed: _changeTextColor,
          ),
        ],
      ),
      body: PageView(
        children: [
          _buildFadingTextPage(Duration(seconds: 1)),
          _buildFadingTextPage(Duration(seconds: 3)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleVisibility,
        child: Icon(Icons.play_arrow),
      ),
    );
  }

  Widget _buildFadingTextPage(Duration duration) {
    return Center(
      child: AnimatedOpacity(
        opacity: _isVisible ? 1.0 : 0.0,
        duration: duration,
        child: Text(
          'Hello, Flutter!',
          style: TextStyle(fontSize: 24, color: _textColor),
        ),
      ),
    );
  }
}