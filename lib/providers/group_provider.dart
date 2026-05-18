import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/equb_group.dart';

class GroupProvider with ChangeNotifier {
  List<EqubGroup> _groups = [];
  bool _loaded = false;

  List<EqubGroup> get groups => _groups;
  bool get loaded => _loaded;
  bool get hasGroups => _groups.isNotEmpty;

  Future<void> loadGroups() async {
    final prefs =
        await SharedPreferences.getInstance();
    final raw = prefs.getString('equb_groups');
    if (raw != null) {
      final List<dynamic> decoded = jsonDecode(
        raw,
      );
      _groups = decoded
          .map((e) => EqubGroup.fromJson(e))
          .toList();
    }
    _loaded = true;
    notifyListeners();
  }

  Future<void> _persist() async {
    final prefs =
        await SharedPreferences.getInstance();
    await prefs.setString(
      'equb_groups',
      jsonEncode(
        _groups.map((g) => g.toJson()).toList(),
      ),
    );
  }

  Future<void> addGroup(EqubGroup group) async {
    _groups.add(group);
    await _persist();
    notifyListeners();
  }

  Future<void> deleteGroup(String id) async {
    _groups.removeWhere((g) => g.id == id);
    await _persist();
    notifyListeners();
  }
}
