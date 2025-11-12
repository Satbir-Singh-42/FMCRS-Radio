class Config {
  static const String icecastBaseUrl = 'http://10.102.176.192:8000/';
  static const String liveStreamUrl = 'http://10.102.176.192:8000/stream';
  static const String metadataUrl =
      '$icecastBaseUrl/status-json.xsl'; // Example for Icecast metadata
  static const String programsApiUrl =
      '$icecastBaseUrl/programs.json'; // For library/programs
}
