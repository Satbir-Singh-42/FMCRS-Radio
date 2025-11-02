import 'package:flutter/material.dart';

class AudioVisualizer extends StatelessWidget {
  final bool isPlaying;

  const AudioVisualizer({super.key, required this.isPlaying});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        20,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 4,
          height: isPlaying ? (index % 3 + 1) * 10.0 : 4.0,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          color: const Color(0xFFFFD700),
        ),
      ),
    );
  }
}
