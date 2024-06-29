class Book {
  late int id;
  late String? isbn;
  late String title;
  late String cover;
  late String? publisher;
  late int publication;
  late String author;
  late bool isPdf;
  late String? description;
  late List<String>? url;

  Book({
    required this.id,
    this.isbn,
    required this.title,
    required this.cover,
    this.publisher,
    required this.publication,
    required this.author,
    required this.isPdf,
    this.description,
    this.url,
  });

  Map<String, dynamic> toMap() {
    final result = {
      'id': id,
      'isbn': isbn,
      'title': title,
      'cover': cover,
      'publisher': publisher,
      'publication': publication,
      'author': author,
      'is_pdf': isPdf,
      'description': description,
      'url': url,
    };

    result.removeWhere((key, value) => value == null);
    return result;
  }

  Book.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    isbn = map['isbn'];
    title = map['title'];
    cover = map['cover'];
    publisher = map['publisher'];
    publication = map['publication'];
    author = map['author'];
    isPdf = map['is_pdf'];
    description = map['description'];
    url = map['url'];
  }

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      isbn: json['isbn'],
      title: json['title'],
      cover: json['cover'],
      publisher: json['publisher'],
      publication: json['publication'],
      author: json['author'],
      isPdf: json['is_pdf'],
      description: json['description'],
      url: json['url'],
    );
  }
}
