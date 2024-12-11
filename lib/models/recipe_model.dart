import 'dart:convert';

// Fungsi untuk membuat objek RecipeModel dari JSON string
RecipeModel recipeModelFromJson(String str) =>
    RecipeModel.fromJson(json.decode(str));

// Fungsi untuk mengonversi objek RecipeModel ke JSON string
String recipeModelToJson(RecipeModel data) => json.encode(data.toJson());

class RecipeModel {
  final int id;
  final int userId;
  final String title;
  final String description;
  final String cookingMethod;
  final String ingredients;
  final String photoUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int likesCount;
  final int commentsCount;
  final User user;

  RecipeModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.cookingMethod,
    required this.ingredients,
    required this.photoUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.likesCount,
    required this.commentsCount,
    required this.user,
  });

  // Factory untuk membuat RecipeModel dari JSON
  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    return RecipeModel(
      id: json["id"] ?? 0, // Fallback jika id null
      userId: json["user_id"] ?? 0,
      title: json["title"] ?? "Untitled", // Default title jika null
      description: json["description"] ?? "No description provided.",
      cookingMethod: json["cooking_method"] ?? "No cooking method provided.",
      ingredients: json["ingredients"] ?? "No ingredients provided.",
      photoUrl: json["photo_url"] ?? "", // Fallback URL kosong
      createdAt: DateTime.tryParse(json["created_at"] ?? "") ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? "") ?? DateTime.now(),
      likesCount: json["likes_count"] ?? 0,
      commentsCount: json["comments_count"] ?? 0,
      user: User.fromJson(json["user"] ?? {}),
    );
  }

  // Konversi RecipeModel ke Map<String, dynamic>
  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "title": title,
        "description": description,
        "cooking_method": cookingMethod,
        "ingredients": ingredients,
        "photo_url": photoUrl,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "likes_count": likesCount,
        "comments_count": commentsCount,
        "user": user.toJson(),
      };
}

class User {
  final int id;
  final String name;
  final String email;
  final String? emailVerifiedAt; // Nullable
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory untuk membuat User dari JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["id"] ?? 0,
      name: json["name"] ?? "Unknown User", // Default nama jika null
      email: json["email"] ?? "No email provided.",
      emailVerifiedAt: json["email_verified_at"],
      createdAt: DateTime.tryParse(json["created_at"] ?? "") ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? "") ?? DateTime.now(),
    );
  }

  // Konversi User ke Map<String, dynamic>
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "email_verified_at": emailVerifiedAt,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
