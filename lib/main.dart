import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'screens/getting_started_screen.dart';
import 'screens/live_station_screen.dart';

Future<void> main() async {
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.main_fmcrs.audio.channel',
    androidNotificationChannelName: 'FM-CRS Audio',
    androidNotificationOngoing: true,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return MaterialApp(
          title: '90.8 MHz FM-CRS',
          debugShowCheckedModeBanner: false,
          theme: ThemeData.dark().copyWith(
            primaryColor: const Color(0xFFFFD700),
            scaffoldBackgroundColor: const Color(0xFF1A1A2E),
          ),
          initialRoute: '/',
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case '/':
                return MaterialPageRoute(
                  builder: (_) => const GettingStartedScreen(),
                );

              case '/live':
                return PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      const LiveStationScreen(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                        const begin = Offset(1.0, 0.0);
                        const end = Offset.zero;
                        const curve = Curves.easeInOut;
                        var tween = Tween(
                          begin: begin,
                          end: end,
                        ).chain(CurveTween(curve: curve));
                        var offsetAnimation = animation.drive(tween);
                        return SlideTransition(
                          position: offsetAnimation,
                          child: child,
                        );
                      },
                );

              default:
                return MaterialPageRoute(
                  builder: (_) => const GettingStartedScreen(),
                );
            }
          },
        );
      },
    );
  }
}
