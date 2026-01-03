class Config {
  static const String icecastBaseUrl = 'http://10.194.18.155:8000';
  static const String liveStreamUrl = '$icecastBaseUrl/live';
  static const String metadataUrl = '$icecastBaseUrl/status-json.xsl';
  static const String programsApiUrl = '$icecastBaseUrl/programs.json';
}
