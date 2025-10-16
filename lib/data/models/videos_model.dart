class VideosModel {
  final int id;
  final String video;
  final String uploaded_at;

  VideosModel({
    required this.id,
    required this.video,
    required this.uploaded_at,
  });
  factory VideosModel.fromJson(Map<String, dynamic> json){
    return VideosModel(
      id: json['id'],
      video: json['video'],
      uploaded_at: json['uploaded_at'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'video': video,
      'uploaded_at': uploaded_at,
    };
  }
}