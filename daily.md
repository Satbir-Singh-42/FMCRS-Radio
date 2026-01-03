# Daily Dairy: FMCRS Radio App Development Plan

This document outlines a 12-day development plan for the FMCRS Radio App, a Flutter-based radio streaming application. The work is distributed equally across the days, focusing on completing core features, implementing missing functionalities, improving UI/UX, and ensuring thorough testing and documentation.

## Overview of Key Areas

- **Core Radio Features**: Live streaming, metadata parsing, background playback, media controls, auto-reconnect, volume control, internet check.
- **Library/Archives**: Program list, on-demand playback, metadata display, search/filter, download option.
- **UI/UX**: Splash screen, home screen, live station screen, persistent player, dark theme, responsive layout.
- **Admin/Server**: Config management, API integration, dynamic updates.
- **Additional Features**: Sleep timer, equalizer/visualizer.
- **Testing & Documentation**: Unit tests, integration tests, README updates, troubleshooting guides.

## 12-Day Development Plan

### Day 1: Review and Finalize Core Radio Features

- **Morning**: Review live streaming implementation in `audio_service.dart` and `live_station_screen.dart`. Ensure Icecast integration is working.
- **Afternoon**: Test metadata parsing from Icecast JSON endpoint. Verify title/artist updates in real-time.
- **Evening**: Implement any missing auto-reconnect logic and volume control enhancements.

### Day 2: Background Playback and Media Controls

- **Morning**: Enhance background playback using `just_audio_background`. Ensure notifications show correctly on lock screen.
- **Afternoon**: Test media controls (play/pause) from notification and lock screen.
- **Evening**: Add buffer handling improvements for smoother playback.

### Day 3: UI/UX Improvements - Home Screen

- **Morning**: Review and enhance `home_screen.dart` for better Discover tab layout.
- **Afternoon**: Implement search functionality in the Home screen to filter trending programs.
- **Evening**: Add responsive design adjustments for different screen sizes.

### Day 4: UI/UX Improvements - Live Station Screen

- **Morning**: Polish `live_station_screen.dart` UI, including waveform animation and controls.
- **Afternoon**: Add "Station Offline" indicator when stream is unavailable.
- **Evening**: Implement volume slider with better visual feedback.

### Day 5: Library/Archives - Basic Implementation

- **Morning**: Review `library_screen.dart` and ensure placeholder program list is displayed.
- **Afternoon**: Integrate real API calls for fetching archived programs (using `network_service.dart`).
- **Evening**: Implement on-demand playback for archived audio files.

### Day 6: Library/Archives - Advanced Features

- **Morning**: Add progress bar and seek functionality for archive playback.
- **Afternoon**: Implement search and filter options for programs by title/host/date.
- **Evening**: Add download option for episodes (with permission handling).

### Day 7: Additional Features - Sleep Timer

- **Morning**: Design and implement sleep timer feature in `live_station_screen.dart`.
- **Afternoon**: Add timer controls (start/stop) with user-selectable durations.
- **Evening**: Test timer functionality and ensure it stops playback correctly.

### Day 8: Additional Features - Equalizer/Visualizer

- **Morning**: Research and integrate a basic equalizer using `just_audio` plugins.
- **Afternoon**: Add animated waveform or bar visualizer synced with audio.
- **Evening**: Test visualizer performance and adjust for smooth animation.

### Day 9: Persistent Player and Navigation

- **Morning**: Implement persistent mini-player at the bottom of Home screen.
- **Afternoon**: Ensure mini-player shows current track and controls, with navigation to full player.
- **Evening**: Test navigation between screens and mini-player state persistence.

### Day 10: API Integration and Dynamic Updates

- **Morning**: Set up backend API endpoints for program lists and archives.
- **Afternoon**: Implement dynamic library updates when new content is added on server.
- **Evening**: Add error handling for API failures and offline scenarios.

### Day 11: Testing and Bug Fixes

- **Morning**: Run unit tests for services (`audio_service.dart`, `metadata_service.dart`).
- **Afternoon**: Perform integration testing: full app flow from splash to live playback.
- **Evening**: Fix any bugs found, especially related to connectivity and playback.

### Day 12: Documentation and Final Touches

- **Morning**: Update README.md with complete setup instructions and troubleshooting.
- **Afternoon**: Add inline code comments and improve code organization.
- **Evening**: Final build test on Android/iOS, update version numbers, and prepare for release.

## Daily Work Distribution Notes

- Each day focuses on 2-3 specific tasks to maintain balance and avoid burnout.
- Morning sessions: Core implementation and coding.
- Afternoon sessions: Feature integration and testing.
- Evening sessions: Polish, bug fixes, and documentation.
- Total estimated time per day: 6-8 hours, with breaks.
- Dependencies: Ensure Flutter SDK, Icecast server, and necessary plugins are set up before starting.
- Milestones: Days 1-4 complete core functionality, Days 5-8 add advanced features, Days 9-12 focus on polish and testing.

## Progress Tracking

- [ ] Day 1
- [ ] Day 2
- [ ] Day 3
- [ ] Day 4
- [ ] Day 5
- [ ] Day 6
- [ ] Day 7
- [ ] Day 8
- [ ] Day 9
- [ ] Day 10
- [ ] Day 11
- [ ] Day 12

This plan ensures comprehensive development of the FMCRS Radio App, with equal distribution of work across 12 days.
