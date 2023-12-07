class CommentResponse {
  final bool isSuccess;
  final String code;
  final String message;
  final dynamic result;

  CommentResponse({
    required this.isSuccess,
    required this.code,
    required this.message,
    required this.result
  });

  factory CommentResponse.fromJson(Map<String, dynamic> json) {
    return CommentResponse(
        isSuccess: json["isSuccess"],
        code: json["code"],
        message: json["message"],
        result: (json['result'])
    );
  }
}

class CommentResult{
  final String profile_image;
  final String nickname;
  final String comment;

  CommentResult({
    required this.profile_image,
    required this.nickname,
    required this.comment,
  });

  Map<String, dynamic> toJson() {
    return {
      'profile_image': profile_image,
      'nickname': nickname,
      'comment': comment,
    };
  }
}
