class CommentModel {
  String dateTimeComment;
  String text;
  String name;
  String uId;
  String image;


  CommentModel({
    this.dateTimeComment,
    this.text,
    this.name,
    this.uId,
    this.image,

  });

  CommentModel.fromJson(Map<String, dynamic> json)
  {
    dateTimeComment = json['dateTimeComment'];
    text = json['text'];
    name = json['name'];
    uId = json['uId'];
    image = json['image'];

  }

  Map<String, dynamic> toMap() {
    return {
      'dateTimeComment': dateTimeComment,
      'text': text,
      'name': name,
      'uId': uId,
      'image': image,
    };
  }
}