import 'dart:convert';
import 'dart:io';

import 'package:food_recipes_task/models/recipe_model.dart';
import 'package:food_recipes_task/services/session_service.dart';
import 'package:http/http.dart' as http;

const String baseUrl = "https://recipe.incube.id/api";

class RecipeService {
  final SessionService _sessionService = SessionService();

  // Fungsi untuk mengambil semua resep
  Future<List<RecipeModel>> getAllRecipe() async {
    final token = await _sessionService.getToken();

    if (token == null || token.isEmpty) {
      throw Exception("Tidak ada token. Harap login terlebih dahulu.");
    }

    final response = await http.get(
      Uri.parse('$baseUrl/recipes'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      try {
        final List data = jsonDecode(response.body)['data']['data'];
        return data.map((json) => RecipeModel.fromJson(json)).toList();
      } catch (e) {
        throw Exception("Error parsing data: $e");
      }
    } else {
      throw Exception('Gagal memuat data: ${response.reasonPhrase}');
    }
  }

  // Fungsi untuk mengambil data berdasarkan page
  Future<List<RecipeModel>> getRecipesByPage(int page) async {
    final token = await _sessionService.getToken();

    if (token == null || token.isEmpty) {
      throw Exception("Tidak ada token. Harap login terlebih dahulu.");
    }

    final response = await http.get(
      Uri.parse('$baseUrl/recipes?page=$page'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body)['data']['data'];
      return data.map((json) => RecipeModel.fromJson(json)).toList();
    } else {
      throw Exception('Gagal memuat data: ${response.reasonPhrase}');
    }
  }

  // Fungsi untuk mengambil detail resep berdasarkan ID
  Future<RecipeModel> getRecipeDetail(int id) async {
    final token = await _sessionService.getToken();

    if (token == null || token.isEmpty) {
      throw Exception("Tidak ada token. Harap login terlebih dahulu.");
    }

    final response = await http.get(
      Uri.parse('$baseUrl/recipes/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      try {
        final data = jsonDecode(response.body)['data'];
        if (data == null || data is! Map<String, dynamic>) {
          throw Exception("Data tidak valid atau kosong.");
        }
        return RecipeModel.fromJson(data);
      } catch (e) {
        throw Exception("Error parsing detail resep: $e");
      }
    } else if (response.statusCode == 404) {
      throw Exception("Resep dengan ID $id tidak ditemukan.");
    } else {
      throw Exception('Gagal memuat detail resep: ${response.reasonPhrase}');
    }
  }

  // Fungsi untuk menambah resep baru
  Future<Map<String, dynamic>> addRecipeWithImage({
    required String title,
    required String description,
    required String cookingMethod,
    required String ingredients,
    required File imageFile,
  }) async {
    final token = await _sessionService.getToken();

    if (token == null || token.isEmpty) {
      return {
        "status": false,
        "message": "Token tidak ditemukan. Harap login terlebih dahulu."
      };
    }

    try {
      var request =
          http.MultipartRequest('POST', Uri.parse('$baseUrl/recipes'));
      request.headers['Authorization'] = 'Bearer $token';
      request.fields['title'] = title;
      request.fields['description'] = description;
      request.fields['cooking_method'] = cookingMethod;
      request.fields['ingredients'] = ingredients;
      request.files
          .add(await http.MultipartFile.fromPath('photo', imageFile.path));

      final response = await request.send();

      if (response.statusCode == 201) {
        return {"status": true, "message": "Resep berhasil ditambahkan."};
      } else {
        final responseBody = await response.stream.bytesToString();
        final data = jsonDecode(responseBody);
        return {
          "status": false,
          "message": data['message'] ?? 'Gagal menambahkan resep.'
        };
      }
    } catch (e) {
      return {"status": false, "message": "Kesalahan: $e"};
    }
  }

  // Fungsi untuk menghapus resep berdasarkan ID
  // Fungsi untuk menghapus resep berdasarkan ID
  Future<void> deleteRecipe(int id) async {
    final token = await _sessionService.getToken();

    if (token == null || token.isEmpty) {
      throw Exception("Token tidak ditemukan. Harap login terlebih dahulu.");
    }

    final url = Uri.parse("$baseUrl/recipes/$id"); // Perbaiki URL
    print("Request DELETE: $url"); // Log URL untuk debugging

    try {
      final response = await http.delete(
        url,
        headers: {
          'Authorization': 'Bearer $token', // Tambahkan autentikasi
          'Content-Type': 'application/json',
        },
      );

      print("Response Status: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode != 200) {
        final errorBody = jsonDecode(response.body);
        throw Exception(
            "Gagal menghapus resep: ${errorBody['message'] ?? response.reasonPhrase}");
      }
    } catch (e) {
      print("Error deleting recipe: $e");
      throw Exception("Gagal menghapus resep: $e");
    }
  }
}
