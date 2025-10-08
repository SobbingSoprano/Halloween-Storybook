import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:math';

class SpookyRoomScreen extends StatefulWidget {
  const SpookyRoomScreen({super.key});

  @override
  State<SpookyRoomScreen> createState() => _SpookyRoomScreenState();
}

class _SpookyRoomScreenState extends State<SpookyRoomScreen>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<Offset>> _animations;
  late List<String> _images;
  late List<Offset> _directions;
  late List<bool> _isTreat; // Track which images give treats
  
  final double _imageSize = 60.0;
  final Random _random = Random();
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    
    // Define the 4 base images and create 3-4 duplicates of each
    List<String> baseImages = [
      'assets/blackcat.png',
      'assets/ghost.png', 
      'assets/pumpkin.png',
      'assets/skull.png'
    ];
    
    _images = [];
    _isTreat = [];
    
    // Track which image type has already been assigned as a treat
    Set<String> treatAssigned = {};
    
    for (String image in baseImages) {
      // Add 3-4 duplicates of each image
      int duplicates = 3 + _random.nextInt(2);
      for (int i = 0; i < duplicates; i++) {
        _images.add(image);
        
        // Assign one of each image type as a treat (only the first one)
        if (!treatAssigned.contains(image)) {
          _isTreat.add(true);
          treatAssigned.add(image);
        } else {
          _isTreat.add(false);
        }
      }
    }
    
    _controllers = [];
    _animations = [];
    _directions = [];
    
    // Create animations for each floating image
    for (int i = 0; i < _images.length; i++) {
      AnimationController controller = AnimationController(
        duration: Duration(seconds: 3 + _random.nextInt(4)),
        vsync: this,
      );
      
      _controllers.add(controller);
      
      // Random starting position and direction
      double startX = _random.nextDouble();
      double startY = _random.nextDouble();
      double dirX = (_random.nextBool() ? 1 : -1) * (0.3 + _random.nextDouble() * 0.7);
      double dirY = (_random.nextBool() ? 1 : -1) * (0.3 + _random.nextDouble() * 0.7);
      
      _directions.add(Offset(dirX, dirY));
      
      Animation<Offset> animation = Tween<Offset>(
        begin: Offset(startX, startY),
        end: Offset(startX + dirX, startY + dirY),
      ).animate(CurvedAnimation(parent: controller, curve: Curves.linear));
      
      _animations.add(animation);
      
      controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    for (AnimationController controller in _controllers) {
      controller.dispose();
    }
    _audioPlayer.dispose();
    super.dispose();
  }

  void _playTreatSound() {
    _audioPlayer.play(AssetSource('sounds/tada.wav'));
  }
  
  void _playBlackCatSound() {
    _audioPlayer.play(AssetSource('sounds/cat.wav'));
  }
  
  void _playGhostSound() {
    _audioPlayer.play(AssetSource('sounds/boo.wav'));
  }
  
  void _playPumpkinSound() {
    _audioPlayer.play(AssetSource('sounds/pumpkinlaugh.wav'));
  }
  
  void _playSkullSound() {
    _audioPlayer.play(AssetSource('sounds/chattering.wav'));
  }

  void _showTrickPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.deepOrange.shade800,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Row(
            children: [
              Icon(Icons.warning_amber, color: Colors.white, size: 30),
              SizedBox(width: 10),
              Text(
                'You Got a Trick!',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Text(
            'Better luck next time! Test your luck again?',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'OK',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showTreatPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.green.shade700,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Row(
            children: [
              Icon(Icons.celebration, color: Colors.white, size: 30),
              SizedBox(width: 10),
              Text(
                'Success! You Got a Treat!',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Text(
            'Test your luck again?',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Awesome!',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _onImageTap(String imagePath, int index) {
    String imageName = imagePath.split('/').last.split('.').first;
    
    // Check if this image is a treat
    if (_isTreat[index]) {
      // Play treat sound and show treat popup
      _playTreatSound();
      _showTreatPopup();
    } else {
      // Plays trick sound for trick images
      switch (imageName) {
        case 'blackcat':
          _playBlackCatSound();
          break;
        case 'ghost':
          _playGhostSound();
          break;
        case 'pumpkin':
          _playPumpkinSound();
          break;
        case 'skull':
          _playSkullSound();
          break;
      }
      
      // Show trick popup
      _showTrickPopup();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Spooky Room'),
        backgroundColor: Colors.deepPurple.shade800,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.0,
                colors: [
                  Colors.deepPurple.shade900,
                  Colors.black,
                ],
              ),
            ),
          ),
          // Floating images
          ...List.generate(_images.length, (index) {
            return AnimatedBuilder(
              animation: _animations[index],
              builder: (context, child) {
                return Positioned(
                  left: _animations[index].value.dx * 
                        (MediaQuery.of(context).size.width - _imageSize),
                  top: _animations[index].value.dy * 
                       (MediaQuery.of(context).size.height - _imageSize - 100),
                  child: GestureDetector(
                    onTap: () => _onImageTap(_images[index], index),
                    child: Container(
                      width: _imageSize,
                      height: _imageSize,
                      child: Image.asset(
                        _images[index],
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                );
              },
            );
          }),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Center(
              child: Text(
                'Trick or Treat! Click an image for a suprise...',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      blurRadius: 5.0,
                      color: Colors.black,
                      offset: Offset(2.0, 2.0),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
