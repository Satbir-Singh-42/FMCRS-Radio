import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../services/audio_service.dart';

class LiveStationScreen extends StatefulWidget {
  const LiveStationScreen({super.key});

  @override
  State<LiveStationScreen> createState() => _LiveStationScreenState();
}

class _LiveStationScreenState extends State<LiveStationScreen>
    with TickerProviderStateMixin {
  late RadioAudioService _audioService;
  late Connectivity _connectivity;
  late AnimationController _animationController;
  double _volume = 0.5;

  @override
  void initState() {
    super.initState();
    _audioService = RadioAudioService();
    _connectivity = Connectivity();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _initAudio();
    _listenToConnectivity();
  }

  Future<void> _initAudio() async {
    await _audioService.init();
    setState(() {});
  }

  void _listenToConnectivity() {
    _connectivity.onConnectivityChanged.listen((result) {
      if (result.contains(ConnectivityResult.none)) {
        _audioService.isOnline = false;
        setState(() {});
      } else {
        _audioService.isOnline = true;
        _initAudio(); // Reconnect
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _audioService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A2E),
        automaticallyImplyLeading: false,
        title: Text(
          'Live Station',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 32),
                    // Artwork
                    Container(
                      width: constraints.maxWidth > 600
                          ? 300
                          : 50.w.clamp(150, 400),
                      height: constraints.maxWidth > 600
                          ? 300
                          : 50.w.clamp(150, 400),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        image: const DecorationImage(
                          image: AssetImage('assets/logo.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Metadata
                    _audioService.currentTitle == 'Loading...'
                        ? const CircularProgressIndicator(
                            color: Color(0xFFFFD700),
                          )
                        : Column(
                            children: [
                              Text(
                                _audioService.currentTitle,
                                style: TextStyle(
                                  fontSize: constraints.maxWidth > 600
                                      ? 24
                                      : 20.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              _audioService.currentArtist == 'Artist'
                                  ? const SizedBox.shrink()
                                  : Text(
                                      'by ${_audioService.currentArtist}',
                                      style: TextStyle(
                                        fontSize: constraints.maxWidth > 600
                                            ? 18
                                            : 16.sp,
                                        color: Colors.white70,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                            ],
                          ),
                    const SizedBox(height: 16),
                    // LIVE Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'LIVE',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Audio Controls
                    GestureDetector(
                      onTap: () {
                        if (_audioService.isPlaying) {
                          _audioService.pause();
                        } else {
                          _audioService.play();
                        }
                        setState(() {});
                      },
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFFFD700),
                        ),
                        child: Icon(
                          _audioService.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Volume Control Slider
                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.volume_down,
                            color: Colors.white,
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          SizedBox(
                            width: 200,
                            child: Slider(
                              value: _volume,
                              min: 0.0,
                              max: 1.0,
                              divisions: 10,
                              activeColor: const Color(0xFFFFD700),
                              inactiveColor: Colors.white70,
                              onChanged: (value) {
                                setState(() {
                                  _volume = value;
                                  _audioService.audioPlayer.setVolume(_volume);
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.volume_up,
                            color: Colors.white,
                            size: 24,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32), // Add bottom padding
                  ],
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF1A1A2E),
        selectedItemColor: const Color(0xFFFFD700),
        unselectedItemColor: Colors.white70,
        currentIndex: 1,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Discover'),
          BottomNavigationBarItem(icon: Icon(Icons.radio), label: 'Live'),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_music),
            label: 'Library',
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/home');
          } else if (index == 2) {
            Navigator.pushReplacementNamed(context, '/library');
          }
        },
      ),
    );
  }
}
