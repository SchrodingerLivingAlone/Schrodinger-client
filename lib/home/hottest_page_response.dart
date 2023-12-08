class HottestPostResponse {
  final bool isSuccess;
  final String code;
  final String message;
  final dynamic result;

  HottestPostResponse({
    required this.isSuccess,
    required this.code,
    required this.message,
    required this.result
  });

  factory HottestPostResponse.fromJson(Map<String, dynamic> json) {
    return HottestPostResponse(
        isSuccess: json["isSuccess"],
        code: json["code"],
        message: json["message"],
        result: (json['result'])
    );
  }
}

class HottestPostResult{
  final String id;
  final String dong;
  final String neighborhoodPostCategory;
  final String title;
  final String content;
  final String imageUrl;
  final String createdAt;
  final String calculatedTime;
  final int view;
  final int likeCount;
  final int commentCount;

  HottestPostResult({
    required this.id,
    required this.dong,
    required this.neighborhoodPostCategory,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.createdAt,
    required this.calculatedTime,
    required this.view,
    required this.likeCount,
    required this.commentCount
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dong': dong,
      'neighborhoodPostCategory': neighborhoodPostCategory,
      'title': title,
      'content' : content,
      'imageUrl' : imageUrl,
      'createAt' : createdAt,
      'calculatedTime' : calculatedTime,
      'view' : view,
      'likeCount':likeCount,
      'commentCount':commentCount,
    };
  }
}

