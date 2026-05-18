class EqubGroup {
  final String id;
  final String name;
  final double contributionAmount;
  final String interval;
  final int totalMembers;

  EqubGroup({
    required this.id,
    required this.name,
    required this.contributionAmount,
    required this.interval,
    required this.totalMembers,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'contributionAmount': contributionAmount,
    'interval': interval,
    'totalMembers': totalMembers,
  };

  factory EqubGroup.fromJson(
    Map<String, dynamic> json,
  ) => EqubGroup(
    id: json['id'] ?? '',
    name: json['name'] ?? '',
    contributionAmount:
        double.tryParse(
          json['contributionAmount'].toString(),
        ) ??
        0,
    interval: json['interval'] ?? 'Monthly',
    totalMembers:
        int.tryParse(
          json['totalMembers'].toString(),
        ) ??
        0,
  );
}
