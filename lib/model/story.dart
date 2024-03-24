class Story {
  final String uid;
  final List<String> caption;
  final List<String> storyImage;
  final String profileImage;
  final String profileName;

  Story({
    required this.uid,
    required this.caption,
    required this.storyImage,
    required this.profileImage,
    required this.profileName,
  });

  Map<String, dynamic> toJson() {
    return {
      "UID": uid,
      "Caption": caption,
      "StoryImage": storyImage,
      "ProfileImage": profileImage,
      "ProfileName": profileName,
    };
  }
}
