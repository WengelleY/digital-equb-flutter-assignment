class Member {
  final String? id;
  final String groupId;
  final String name;
  final String phone;
  final double contribution;
  final String status;
  final int roundReceived;

  Member({
    this.id,
    required this.groupId,
    required this.name,
    required this.phone,
    required this.contribution,
    this.status = 'Not Paid',
    this.roundReceived = 0,
  });

  factory Member.fromJson(
    Map<String, dynamic> json,
  ) {
    return Member(
      id: json['id']?.toString(),
      groupId: json['groupId']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      contribution:
          double.tryParse(
            json['contribution'].toString(),
          ) ??
          0.0,
      status:
          json['status']?.toString() ??
          'Not Paid',
      roundReceived:
          int.tryParse(
            json['roundReceived'].toString(),
          ) ??
          0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'groupId': groupId,
      'name': name,
      'phone': phone,
      'contribution': contribution,
      'status': status,
      'roundReceived': roundReceived,
    };
  }

  Member copyWith({
    String? id,
    String? groupId,
    String? name,
    String? phone,
    double? contribution,
    String? status,
    int? roundReceived,
  }) {
    return Member(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      contribution:
          contribution ?? this.contribution,
      status: status ?? this.status,
      roundReceived:
          roundReceived ?? this.roundReceived,
    );
  }
}
