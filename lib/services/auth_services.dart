import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:food_recipes_task/models/response_model.dart';
import 'package:food_recipes_task/services/session_service.dart';

const String baseUrl = "https://recipe.incube.id/api";

class AuthService {
  final SessionService _sessionService = SessionService();

  // Fungsi untuk registrasi
  Future<Map<String, dynamic>> register(
      String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        body: {'name': name, 'email': email, 'password': password},
      );

      if (response.statusCode == 201) {
        // Respons sukses, simpan token dan data pengguna
        ResponseModel res = ResponseModel.fromJson(jsonDecode(response.body));
        await _sessionService.saveToken(res.data?["token"] ?? "");
        await _sessionService.saveUser(
          res.data?["user"]?["id"]?.toString() ?? "",
          res.data?["user"]?["name"] ?? "",
          res.data?["user"]?["email"] ?? "",
        );
        return {"status": true, "message": res.message};
      } else if (response.statusCode == 422) {
        // Respons error dari server (misalnya validasi gagal)
        ResponseModel res = ResponseModel.fromJson(jsonDecode(response.body));
        Map<String, dynamic> err = res.errors as Map<String, dynamic>? ?? {};
        return {"status": false, "message": res.message, "error": err};
      } else {
        throw Exception("Failed register: ${response.body}");
      }
    } catch (e) {
      return {
        "status": false,
        "message": "Terjadi kesalahan saat registrasi: $e"
      };
    }
  }

  // Fungsi untuk login
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        body: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        // Respons sukses, simpan token dan data pengguna
        ResponseModel res = ResponseModel.fromJson(jsonDecode(response.body));
        if (res.data != null) {
          await _sessionService.saveToken(res.data["token"]);
          await _sessionService.saveUser(
            res.data["user"]["id"].toString(),
            res.data["user"]["name"],
            res.data["user"]["email"],
          );
          return {"status": true, "message": res.message};
        } else {
          return {
            "status": false,
            "message": "Token atau data pengguna tidak ditemukan."
          };
        }
      } else if (response.statusCode == 401) {
        // Jika login gagal karena kredensial salah
        ResponseModel res = ResponseModel.fromJson(jsonDecode(response.body));
        return {"status": false, "message": res.message};
      } else {
        throw Exception("Failed login: ${response.body}");
      }
    } catch (e) {
      return {"status": false, "message": "Terjadi kesalahan saat login: $e"};
    }
  }
}
