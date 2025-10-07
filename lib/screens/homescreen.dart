import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Welcome to Halloween Storybook"),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
      ),
      body: ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, '/spookyroom');
        },
        child: Text("Go to spooky room"),
      ),
    );
  }
}
