import 'package:schrodinger_client/post/post_comment_response.dart';

class PostInfoResponse {
  final bool isSuccess;
  final String code;
  final String message;
  final dynamic result;

  PostInfoResponse({
    required this.isSuccess,
    required this.code,
    required this.message,
    required this.result
  });

  factory PostInfoResponse.fromJson(Map<String, dynamic> json) {
    return PostInfoResponse(
        isSuccess: json["isSuccess"],
        code: json["code"],
        message: json["message"],
        result: (json['result'])
    );
  }
}

class PostInfoResult{
  final int id;
  final String dong;
  final String neighborhoodPostCategory;
  final String profileImage;
  final String nickname;
  final String title;
  final String content;
  final String place;
  final List<String> imageUrls;
  final String createAt;
  final int view;
  final int likeCount;
  final int commentCount;
  final List<CommentResult> comments;
  final bool isScrapped;
  final bool isLiked;

  PostInfoResult({
    required this.id,
    required this.dong,
    required this.neighborhoodPostCategory,
    required this.profileImage,
    required this.nickname,
    required this.title,
    required this.content,
    required this.place,
    required this.imageUrls,
    required this.createAt,
    required this.view,
    required this.likeCount,
    required this.commentCount,
    required this.comments,
    required this.isLiked,
    required this.isScrapped,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dong': dong,
      'neighborhoodPostCategory': neighborhoodPostCategory,
      'profileImage': profileImage,
      'nickname' : nickname,
      'title': title,
      'content': content,
      'place' : place,
      'imageUrls': imageUrls,
      'createAt': createAt,
      'view': view,
      'likeCount': likeCount,
      'commentCount': commentCount,
      'comments' : comments,
      'isLiked' : isLiked,
      'isScrapped': isScrapped,
    };
  }
}
