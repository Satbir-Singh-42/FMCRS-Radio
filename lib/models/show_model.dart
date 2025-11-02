class Program {
  final String id;
  final String title;
  final String host;
  final String description;
  final String audioUrl;
  final String imageUrl;
  final DateTime date;
  final Duration duration;

  Program({
    required this.id,
    required this.title,
    required this.host,
    required this.description,
    required this.audioUrl,
    required this.imageUrl,
    required this.date,
    required this.duration,
  });

  factory Program.fromJson(Map<String, dynamic> json) {
    return Program(
      id: json['id'] ?? '',
      title: json['title'] ?? 'Unknown Title',
      host: json['host'] ?? 'Unknown Host',
      description: json['description'] ?? '',
      audioUrl: json['audio_url'] ?? '',
      imageUrl: json['image_url'] ?? '',
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      duration: Duration(seconds: json['duration'] ?? 0),
    );
  }
}
