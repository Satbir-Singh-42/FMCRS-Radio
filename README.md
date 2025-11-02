# FMCRS Radio App

A complete Flutter radio app for streaming live audio from an Icecast server, with metadata parsing, background playback, and a dark theme UI.

## Features

### Core Radio

- ✅ Live Streaming: Stream live audio using your Icecast server URL.
- ✅ Metadata Parsing: Fetch song title, artist, and show name dynamically from Icecast headers or JSON endpoint.
- ✅ Background Playback: Continue playing even when app is minimized, using just_audio_background.
- ✅ Media Controls: Show notification with play/pause & live info on lock screen.
- ✅ Auto Reconnect: Automatically reconnect when stream drops or user switches networks.
- ✅ Stream Status: Display "🔴 LIVE" or "Station Offline" dynamically.
- ✅ Volume Control: Adjust system volume within app.
- ✅ Audio Buffer Handling: Smooth playback with retry on buffer underrun.
- ❌ Sleep Timer: Optional feature to stop stream after selected duration (not implemented).
- ❌ Equalizer / Visualizer: Animated waveform or bar equalizer synced with audio output (not implemented).
- ✅ Internet Check: Show offline alert if network disconnected.

### Library / Archives

- ✅ Program List: Display shows or podcasts (stored locally or fetched via API) (placeholder implemented).
- ✅ On-Demand Playback: Play archived audio (MP3 or Icecast mount points) (seekable progress bar implemented).
- ✅ Metadata Display: Show show name, host, date, duration (implemented).
- ❌ Download Option: Allow users to download past episodes (optional toggle) (not implemented).
- ❌ Search & Filter: Search by show name or host (not implemented).

### UI / UX

- ✅ Splash / Intro Screen: Logo and description of station with navigation to Home.
- ✅ Home Screen: Trending shows, search, and Discover/Live tab navigation.
- ✅ Live Station Screen: Current live show with metadata, waveform, and controls.
- ❌ Persistent Player: Mini player at bottom of Home when playing live or archive (not implemented).
- ✅ Dark Theme: Deep navy (#1A1A2E) with golden accent (#FFD700).
- ✅ Responsive Layout: Optimized for all mobile sizes and orientations.
- ✅ Branding: Station logo & name "90.8 MHz FM-CRS".

### Admin / Server

- ✅ Config File: Store Icecast base URL, mountpoints, and metadata URL in config.dart.
- ❌ API Integration: Option to fetch program list from server JSON or CMS (Drupal/Strapi) (not implemented).
- ❌ Dynamic Update: Library updates when new archive file added on server (not implemented).
- ✅ SSL Support: Works with HTTPS Icecast endpoints.

## Setup Instructions

### Prerequisites

- Flutter SDK (^3.9.0)
- Android Studio or Xcode for iOS development
- Icecast server (version 2.4+ recommended)

### 1. Icecast Server Setup

#### Install Icecast

**On Ubuntu/Debian:**

```bash
sudo apt update
sudo apt install icecast2
```

**On CentOS/RHEL:**

```bash
sudo yum install icecast
```

**On macOS (using Homebrew):**

```bash
brew install icecast
```

#### Configure Icecast

1. Edit `/etc/icecast2/icecast.xml` (or equivalent path):

   ```xml
   <icecast>
     <hostname>your-server-domain.com</hostname>
     <listen-socket>
       <port>8000</port>
     </listen-socket>
     <authentication>
       <source-password>your-source-password</source-password>
       <relay-password>your-relay-password</relay-password>
       <admin-password>your-admin-password</admin-password>
     </authentication>
     <mount>
       <mount-name>/stream</mount-name>
       <fallback-mount>/fallback.mp3</fallback-mount>
       <fallback-override>1</fallback-override>
     </mount>
   </icecast>
   ```

2. Start Icecast:

   ```bash
   sudo systemctl start icecast2
   sudo systemctl enable icecast2
   ```

3. Access admin interface at `http://your-server:8000/admin/`

#### Streaming to Icecast

Use tools like:

- **Liquidsoap:** For advanced streaming with metadata
- **DarkIce:** Simple command-line streamer
- **IceS:** Icecast source client

Example with Liquidsoap:

```liquidsoap
#!/usr/bin/liquidsoap

# Input from file or microphone
input = single("/path/to/audio/file.mp3")

# Set metadata
input = metadata.map(update=true, input)

# Output to Icecast
output.icecast(
  %mp3,
  host="localhost",
  port=8000,
  password="your-source-password",
  mount="/stream",
  name="FMCRS Radio",
  description="90.8 MHz FM-CRS",
  input
)
```

### 2. Backend Setup (Optional for Archives)

If you want to add program archives, set up a simple backend:

#### Using Node.js/Express

```javascript
const express = require("express");
const app = express();

app.get("/programs.json", (req, res) => {
  res.json([
    {
      id: 1,
      title: "Morning Show",
      host: "John Doe",
      date: "2023-10-01",
      duration: "02:00:00",
      audioUrl: "https://your-server.com/archives/morning-show.mp3",
    },
  ]);
});

app.listen(3000, () => console.log("Backend running on port 3000"));
```

#### Using Django

```python
from django.http import JsonResponse

def programs_api(request):
    programs = [
        {
            'id': 1,
            'title': 'Morning Show',
            'host': 'John Doe',
            'date': '2023-10-01',
            'duration': '02:00:00',
            'audioUrl': 'https://your-server.com/archives/morning-show.mp3'
        }
    ]
    return JsonResponse(programs, safe=False)
```

### 3. App Configuration

Edit `lib/utils/config.dart`:

```dart
class Config {
  static const String icecastBaseUrl = 'https://play.global.audio'; // Use HTTPS for SSL
  static const String liveStreamUrl = 'https://play.global.audio/novahi.aac'; // Live stream URL
  static const String metadataUrl = '$icecastBaseUrl/status-json.xsl'; // Metadata endpoint
  static const String programsApiUrl = '$icecastBaseUrl/programs.json'; // For archives (if available)
}
```

### 4. Making Discover and Library Pages Work Properly

#### Discover Page (Home Screen)

The Discover page (`lib/screens/home_screen.dart`) displays trending shows in a grid layout. To make it fully functional:

1. **Fetch Real Data:** Replace the placeholder grid with actual API calls to fetch trending programs.

   Example implementation in `lib/services/network_service.dart`:

   ```dart
   Future<List<Map<String, dynamic>>> fetchTrendingPrograms() async {
     final response = await http.get(Uri.parse(Config.programsApiUrl));
     if (response.statusCode == 200) {
       return List<Map<String, dynamic>>.from(json.decode(response.body));
     } else {
       throw Exception('Failed to load programs');
     }
   }
   ```

2. **Update Home Screen:** Modify `lib/screens/home_screen.dart` to use the fetched data:

   ```dart
   class _HomeScreenState extends State<HomeScreen> {
     List<Map<String, dynamic>> _trendingPrograms = [];

     @override
     void initState() {
       super.initState();
       _loadTrendingPrograms();
     }

     Future<void> _loadTrendingPrograms() async {
       try {
         final programs = await NetworkService().fetchTrendingPrograms();
         setState(() {
           _trendingPrograms = programs;
         });
       } catch (e) {
         // Handle error
       }
     }

     @override
     Widget build(BuildContext context) {
       return Scaffold(
         // ... existing code ...
         Expanded(
           child: GridView.builder(
             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
               crossAxisCount: 2,
               crossAxisSpacing: 16,
               mainAxisSpacing: 16,
               childAspectRatio: 0.8,
             ),
             itemCount: _trendingPrograms.length,
             itemBuilder: (context, index) {
               final program = _trendingPrograms[index];
               return GestureDetector(
                 onTap: () {
                   // Navigate to live or library based on program type
                   if (program['isLive'] == true) {
                     Navigator.pushNamed(context, '/live');
                   } else {
                     Navigator.pushNamed(context, '/library');
                   }
                 },
                 child: Container(
                   decoration: BoxDecoration(
                     color: Colors.white.withValues(alpha: 0.1),
                     borderRadius: BorderRadius.circular(16),
                   ),
                   child: Column(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       Container(
                         width: 20.w,
                         height: 20.w,
                         decoration: BoxDecoration(
                           color: const Color(0xFFFFD700),
                           borderRadius: BorderRadius.circular(8),
                         ),
                         child: const Icon(
                           Icons.music_note,
                           color: Colors.white,
                         ),
                       ),
                       const SizedBox(height: 8),
                       Text(
                         program['title'] ?? 'Program ${index + 1}',
                         style: TextStyle(
                           fontSize: 14.sp,
                           fontWeight: FontWeight.bold,
                           color: Colors.white,
                         ),
                         textAlign: TextAlign.center,
                       ),
                       Text(
                         program['host'] ?? 'Host Name',
                         style: TextStyle(
                           fontSize: 12.sp,
                           color: Colors.white70,
                         ),
                         textAlign: TextAlign.center,
                       ),
                     ],
                   ),
                 ),
               );
             },
           ),
         ),
         // ... existing code ...
       );
     }
   }
   ```

3. **Search Functionality:** Implement search by modifying the TextField in the Home screen to filter the grid based on user input.

#### Library Page

The Library page (`lib/screens/library_screen.dart`) displays archived shows with on-demand playback. To make it fully functional:

1. **Fetch Real Archive Data:** Replace the placeholder list with actual API calls.

   Add to `lib/services/network_service.dart`:

   ```dart
   Future<List<Map<String, dynamic>>> fetchArchivedPrograms() async {
     final response = await http.get(Uri.parse('${Config.programsApiUrl}/archives'));
     if (response.statusCode == 200) {
       return List<Map<String, dynamic>>.from(json.decode(response.body));
     } else {
       throw Exception('Failed to load archived programs');
     }
   }
   ```

2. **Update Library Screen:** Modify `lib/screens/library_screen.dart` to use fetched data and implement real playback:

   ```dart
   class _LibraryScreenState extends State<LibraryScreen> {
     List<Map<String, dynamic>> _archivedPrograms = [];
     late RadioAudioService _audioService;
     double _progress = 0.0;
     bool _isPlaying = false;
     int? _playingIndex;

     @override
     void initState() {
       super.initState();
       _audioService = RadioAudioService();
       _loadArchivedPrograms();
       _audioService.init();
     }

     Future<void> _loadArchivedPrograms() async {
       try {
         final programs = await NetworkService().fetchArchivedPrograms();
         setState(() {
           _archivedPrograms = programs;
         });
       } catch (e) {
         // Handle error
       }
     }

     void _playArchive(int index) async {
       final program = _archivedPrograms[index];
       await _audioService.playArchive(program['audioUrl']);
       setState(() {
         _playingIndex = index;
         _isPlaying = true;
       });
       // Listen to position updates for progress
       _audioService.player.positionStream.listen((position) {
         setState(() {
           _progress = position.inSeconds / _audioService.player.duration!.inSeconds;
         });
       });
     }

     @override
     Widget build(BuildContext context) {
       return Scaffold(
         // ... existing code ...
         Expanded(
           child: ListView.builder(
             itemCount: _archivedPrograms.length,
             itemBuilder: (context, index) {
               final program = _archivedPrograms[index];
               final isCurrentlyPlaying = _playingIndex == index && _isPlaying;
               return Container(
                 margin: const EdgeInsets.only(bottom: 16),
                 padding: const EdgeInsets.all(16),
                 decoration: BoxDecoration(
                   color: Colors.white.withValues(alpha: 0.1),
                   borderRadius: BorderRadius.circular(16),
                 ),
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Row(
                       children: [
                         Container(
                           width: 12.w,
                           height: 12.w,
                           decoration: BoxDecoration(
                             color: const Color(0xFFFFD700),
                             borderRadius: BorderRadius.circular(8),
                           ),
                           child: const Icon(
                             Icons.music_note,
                             color: Colors.white,
                           ),
                         ),
                         const SizedBox(width: 16),
                         Expanded(
                           child: Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               Text(
                                 program['title'] ?? 'Show ${index + 1}',
                                 style: TextStyle(
                                   fontSize: 16.sp,
                                   fontWeight: FontWeight.bold,
                                   color: Colors.white,
                                 ),
                               ),
                               Text(
                                 program['host'] ?? 'Host Name',
                                 style: TextStyle(
                                   fontSize: 14.sp,
                                   color: Colors.white70,
                                 ),
                               ),
                               Text(
                                 'Duration: ${program['duration'] ?? '02:30:00'}',
                                 style: TextStyle(
                                   fontSize: 12.sp,
                                   color: Colors.white54,
                                 ),
                               ),
                             ],
                           ),
                         ),
                         IconButton(
                           onPressed: () {
                             if (isCurrentlyPlaying) {
                               _audioService.pause();
                               setState(() {
                                 _isPlaying = false;
                               });
                             } else {
                               _playArchive(index);
                             }
                           },
                           icon: Icon(
                             isCurrentlyPlaying ? Icons.pause : Icons.play_arrow,
                             color: const Color(0xFFFFD700),
                             size: 24,
                           ),
                         ),
                       ],
                     ),
                     if (isCurrentlyPlaying) ...[
                       const SizedBox(height: 16),
                       Slider(
                         value: _progress,
                         onChanged: (value) {
                           setState(() {
                             _progress = value;
                           });
                           final duration = _audioService.player.duration!;
                           _audioService.player.seek(duration * value);
                         },
                         activeColor: const Color(0xFFFFD700),
                         inactiveColor: Colors.white24,
                       ),
                       Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                           Text(
                             '${(_progress * (_audioService.player.duration?.inSeconds ?? 0)).toInt() ~/ 60}:${((_progress * (_audioService.player.duration?.inSeconds ?? 0)).toInt() % 60).toString().padLeft(2, '0')}',
                             style: TextStyle(
                               fontSize: 12.sp,
                               color: Colors.white70,
                             ),
                           ),
                           Text(
                             '${(_audioService.player.duration?.inMinutes ?? 0)}:${((_audioService.player.duration?.inSeconds ?? 0) % 60).toString().padLeft(2, '0')}',
                             style: TextStyle(
                               fontSize: 12.sp,
                               color: Colors.white70,
                             ),
                           ),
                         ],
                       ),
                     ],
                   ],
                 ),
               );
             },
           ),
         ),
         // ... existing code ...
       );
     }
   }
   ```

3. **Add Archive Playback to Audio Service:** Extend `lib/services/audio_service.dart` to support archive playback:

   ```dart
   Future<void> playArchive(String url) async {
     await player.setUrl(url);
     await player.play();
   }
   ```

4. **Backend for Archives:** Ensure your backend provides archive data in the expected format.

By following these steps, the Discover and Library pages will be fully functional with real data fetching, search, and playback capabilities.

### 4. Run the App

1. Install dependencies:

   ```bash
   flutter pub get
   ```

2. Run on Android:

   ```bash
   flutter run
   ```

3. Run on iOS:

   ```bash
   flutter run --device-id=<iOS-device-id>
   ```

4. Build for production:
   ```bash
   flutter build apk --release  # Android
   flutter build ios --release  # iOS
   ```

### 5. Permissions

Add to `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.WAKE_LOCK" />
<uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
```

Add to `ios/Runner/Info.plist`:

```xml
<key>NSAppTransportSecurity</key>
<dict>
  <key>NSAllowsArbitraryLoads</key>
  <true/>
</dict>
<key>UIBackgroundModes</key>
<array>
  <string>audio</string>
</array>
```

### Troubleshooting

- **Stream not playing:** Check Icecast logs: `sudo journalctl -u icecast2`
- **Metadata not updating:** Ensure Icecast is configured to send metadata
- **Background playback not working:** Verify permissions and just_audio_background setup
- **SSL issues:** Use HTTPS URLs and ensure certificates are valid

### Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

### License

This project is licensed under the MIT License.
