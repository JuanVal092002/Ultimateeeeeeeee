class Foto {
  final String url;
  final String filename;

  Foto({required this.url, required this.filename});

  factory Foto.fromJson(Map<String, dynamic> json) {
    return Foto(
      url: json['url'],
      filename: json['filename'],
    );
  }
}