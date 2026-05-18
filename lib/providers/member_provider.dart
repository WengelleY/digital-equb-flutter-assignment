import 'package:flutter/foundation.dart';
import '../models/member.dart';
import '../services/api_service.dart';

enum LoadingState {
  idle,
  loading,
  success,
  error,
}

class MemberProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Member> _members = [];
  List<Member> _filteredMembers = [];
  LoadingState _loadingState = LoadingState.idle;
  String _errorMessage = '';
  String _searchQuery = '';
  String _filterStatus = 'All';
  String _currentGroupId = '';

  // Getters
  List<Member> get members => _filteredMembers;
  List<Member> get allMembers => _members;
  LoadingState get loadingState => _loadingState;
  String get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;
  String get filterStatus => _filterStatus;
  bool get isLoading =>
      _loadingState == LoadingState.loading;

  int get totalMembers => _members.length;
  double get totalMoney => _members.fold(
    0,
    (sum, m) => sum + m.contribution,
  );
  int get paidCount => _members
      .where((m) => m.status == 'Paid')
      .length;

  int get currentRound {
    if (_members.isEmpty) return 1;
    final maxRound = _members
        .map((m) => m.roundReceived)
        .reduce((a, b) => a > b ? a : b);
    return maxRound + 1;
  }

  Future<void> fetchMembers({
    required String groupId,
  }) async {
    if (_currentGroupId != groupId) {
      _members = [];
      _filteredMembers = [];
      _currentGroupId = groupId;
    }
    _setLoading();
    try {
      _members = await _apiService.getMembers(
        groupId,
      );
      _applyFilters();
      _loadingState = LoadingState.success;
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    }
  }

  // CREATE — groupId is baked into the member object
  Future<bool> addMember(Member member) async {
    _setLoading();
    try {
      final newMember = await _apiService
          .createMember(member);
      _members.add(newMember);
      _applyFilters();
      _loadingState = LoadingState.success;
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  // UPDATE
  Future<bool> updateMember(
    String id,
    Member member,
  ) async {
    _setLoading();
    try {
      final updated = await _apiService
          .updateMember(id, member);
      final index = _members.indexWhere(
        (m) => m.id == id,
      );
      if (index != -1) _members[index] = updated;
      _applyFilters();
      _loadingState = LoadingState.success;
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  Future<bool> markAsPaid(Member member) async {
    return updateMember(
      member.id!,
      member.copyWith(status: 'Paid'),
    );
  }

  // DELETE
  Future<bool> deleteMember(String id) async {
    _setLoading();
    try {
      await _apiService.deleteMember(id);
      _members.removeWhere((m) => m.id == id);
      _applyFilters();
      _loadingState = LoadingState.success;
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  void setFilter(String status) {
    _filterStatus = status;
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    List<Member> result = List.from(_members);
    if (_searchQuery.isNotEmpty) {
      result = result
          .where(
            (m) =>
                m.name.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ) ||
                m.phone.contains(_searchQuery),
          )
          .toList();
    }
    if (_filterStatus != 'All') {
      result = result
          .where((m) => m.status == _filterStatus)
          .toList();
    }
    _filteredMembers = result;
  }

  void _setLoading() {
    _loadingState = LoadingState.loading;
    _errorMessage = '';
    notifyListeners();
  }

  void _setError(String message) {
    _loadingState = LoadingState.error;
    _errorMessage = message;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = '';
    _loadingState = LoadingState.idle;
    notifyListeners();
  }
}
