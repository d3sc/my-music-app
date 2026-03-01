import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../domain/music.dart';
import '../../../core/storage/secure_storage.dart';

class MusicRepository {

  final String baseUrl = "http://192.168.0.109:8080/api/songs";

  Future<List<Music>> getAllMusic() async {
    final token = await SecureStorage.getToken();
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);

      return data.map((json) => Music.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load music");
    }
  }
}