import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/member.dart';

class ApiService {
  static const String baseUrl =
      'https://6a077cb5fa9b27c848fa1fa0.mockapi.io/api/v1';
  static const String endpoint = '/members';

  static String get membersUrl =>
      '$baseUrl$endpoint';

  // GET members filtered by groupId (filter in app, not URL)
  Future<List<Member>> getMembers(
    String groupId,
  ) async {
    final response = await http.get(
      Uri.parse(membersUrl),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(
        response.body,
      );
      final all = data
          .map((json) => Member.fromJson(json))
          .toList();
      return all
          .where((m) => m.groupId == groupId)
          .toList();
    } else if (response.statusCode == 404) {
      // MockAPI returns 404 when no records exist yet — treat as empty
      return [];
    } else {
      throw Exception(
        'Failed to load members: ${response.statusCode}',
      );
    }
  }

  // GET single member
  Future<Member> getMember(String id) async {
    final response = await http.get(
      Uri.parse('$membersUrl/$id'),
    );

    if (response.statusCode == 200) {
      return Member.fromJson(
        jsonDecode(response.body),
      );
    } else {
      throw Exception(
        'Failed to load member: ${response.statusCode}',
      );
    }
  }

  // POST create member (groupId is inside member.toJson())
  Future<Member> createMember(
    Member member,
  ) async {
    final response = await http.post(
      Uri.parse(membersUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(member.toJson()),
    );

    if (response.statusCode == 201) {
      return Member.fromJson(
        jsonDecode(response.body),
      );
    } else {
      throw Exception(
        'Failed to create member: ${response.statusCode}',
      );
    }
  }

  // PUT update member
  Future<Member> updateMember(
    String id,
    Member member,
  ) async {
    final response = await http.put(
      Uri.parse('$membersUrl/$id'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(member.toJson()),
    );

    if (response.statusCode == 200) {
      return Member.fromJson(
        jsonDecode(response.body),
      );
    } else {
      throw Exception(
        'Failed to update member: ${response.statusCode}',
      );
    }
  }

  // DELETE member
  Future<void> deleteMember(String id) async {
    final response = await http.delete(
      Uri.parse('$membersUrl/$id'),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to delete member: ${response.statusCode}',
      );
    }
  }
}
