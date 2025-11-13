import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class GettingStartedScreen extends StatelessWidget {
  const GettingStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo
            Container(
              width: 30.w.clamp(100, 300),
              height: 30.w.clamp(100, 300),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFFFD700), // Yellow accent
                image: DecorationImage(
                  image: AssetImage('assets/logo.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 32),
            // Title
            Text(
              '90.8 MHz FM-CRS',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            // Subtitle
            Text(
              'Radio is a broadcast medium that transmits audio content, such as music, news, and talk shows, over airwaves or the internet for real-time listening.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16.sp, color: Colors.white70),
            ),
            const SizedBox(height: 48),
            // Next Button
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/home');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
              child: const Icon(Icons.arrow_forward, color: Color(0xFF1A1A2E)),
            ),
          ],
        ),
      ),
    );
  }
}
