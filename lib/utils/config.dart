class Config {
  static const String icecastBaseUrl = 'https://play.global.audio';
  static const String liveStreamUrl = 'https://play.global.audio/novahi.aac';
  static const String metadataUrl =
      '$icecastBaseUrl/status-json.xsl'; // Example for Icecast metadata
  static const String programsApiUrl =
      '$icecastBaseUrl/programs.json'; // For library/programs
}
