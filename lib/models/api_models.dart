class User {
  final String id;
  final String name;
  final String email;
  final String? photo; // Foto bisa null

  User({required this.id, required this.name, required this.email, this.photo});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      photo: json['photo'],
    );
  }
}

class Category {
  final int id;
  final String name;

  Category({required this.id, required this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id_cate'], // Sesuaikan nama kolom di Laravel
      name: json['name'],
    );
  }
}

class Book {
  final String id; // BookParent ID (id_bp)
  final String title;
  final String author;
  final String genre; // Diambil dari relasi category->name
  final String? image;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.genre,
    this.image,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id_bp'].toString(),
      title: json['title'],
      author: json['writers'], // Di database kolomnya 'writers'
      genre: json['category'] != null ? json['category']['name'] : 'Umum',
      image: json['image'],
    );
  }
}