

class VideosModel {
  VideosModel({
    required this.videosUrl,
    required this.avatarPath,
    required this.name,
    required this.title,
    required this.des,
    required this.isSubscribe,
  });
  String videosUrl;
  String avatarPath;
  String name;
  String title;
  String des;
  bool isSubscribe;
}