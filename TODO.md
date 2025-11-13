# TODO List for Live Page Modifications

- [x] Add a private double \_volume = 0.5; variable in \_LiveStationScreenState class
- [x] Remove the entire voice bar animation SizedBox section from the UI
- [x] Add a new Row with two IconButton widgets for volume increase and decrease below the play/pause button
- [x] Implement onPressed handlers for volume buttons to adjust volume by 0.1 steps and call \_audioService.audioPlayer.setVolume(newVolume), clamping between 0.0 and 1.0
