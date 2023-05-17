class datamodel {
  String id;
  String content;
  String author;
  List<String> tags;
  String authorSlug;
  int length;
  String dateAdded;
  String dateModified;

  datamodel({
    required this.id,
    required this.content,
    required this.author,
    required this.tags,
    required this.authorSlug,
    required this.length,
    required this.dateAdded,
    required this.dateModified,
  });

  factory datamodel.fromJson(Map<String, dynamic> json) {
    return datamodel(
      id: json['_id'],
      content: json['content'],
      author: json['author'],
      tags: List<String>.from(json['tags']),
      authorSlug: json['authorSlug'],
      length: json['length'],
      dateAdded: json['dateAdded'],
      dateModified: json['dateModified'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'author': author,
      'tags': tags.join(","),
      'authorSlug': authorSlug,
      'length': length,
      'dateAdded': dateAdded,
      'dateModified': dateModified,
    };

  }
  static datamodel fromJsonfordatabase(Map<String, dynamic> json) {
    return datamodel(
      id: json['id'],
      content: json['content'],
      author: json['author'],
      tags: json['tags'].split(','),
      authorSlug: json['authorSlug'],
      length: json['length'],
      dateAdded: json['dateAdded'],
      dateModified: json['dateModified'],
    );
  }
}