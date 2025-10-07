import 'package:flutter/material.dart';

class SpookyRoomScreen extends StatefulWidget {
  const SpookyRoomScreen({super.key});

  @override
  State<SpookyRoomScreen> createState() => _SpookyRoomScreenState();
}

class _SpookyRoomScreenState extends State<SpookyRoomScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('spooky room'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
      ),
      body: Text('spooky room'),
    );
  }
}
