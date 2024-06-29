class Book {
  late int id;
  late String? isbn;
  late String title;
  late String cover;
  late String? publisher;
  late int publication;
  late String author;
  late String? rate;
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
    this.rate,
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
      'rate': rate,
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
    rate = map['rate'];
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
      rate: json['rate'],
      isPdf: json['is_pdf'],
      description: json['description'],
      url: json['url'],
    );
  }
}
