import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../main.dart'; // replace with your package name

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with RouteAware {
  late final AudioPlayer _player;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)! as PageRoute);
    _playSound(); // play when first loaded
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    _player.stop();
    _player.dispose();
    super.dispose();
  }

  @override
  void didPopNext() {
    _playSound(); // play again when coming back from another screen
  }

  void _playSound() {
    _player.stop(); // stop any previous instance
    _player.play(AssetSource('halloween-music.mp3'));
  }

  void _stopSound() {
    _player.stop(); // stop immediately
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Welcome to Halloween Storybook"),
        backgroundColor: Colors.deepPurple.shade800,
        foregroundColor: Colors.white,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(color: Colors.deepPurple.shade300),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/ghost.png',
              height: 150,
              width: 150,
              fit: BoxFit.cover,
            ),
            ElevatedButton(
              onPressed: () {
                _stopSound(); // stop before navigating
                Navigator.pushNamed(context, '/spookyroom');
              },
              child: const Text("Go to spooky room"),
            ),
          ],
        ),
        // Center(
        //   child: ElevatedButton(
        //     onPressed: () {
        //       _stopSound(); // stop before navigating
        //       Navigator.pushNamed(context, '/spookyroom');
        //     },
        //     child: const Text("Go to spooky room"),
        //   ),
        // ),
      ),
    );
  }
}
