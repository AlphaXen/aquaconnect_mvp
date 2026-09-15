class Member {
  const Member({
    required this.id,
    required this.orgId,
    required this.name,
    required this.isOwner,
    this.phone,
  });

  final String id;
  final String orgId;
  final String name;
  final bool isOwner;
  final String? phone;

  factory Member.fromJson(Map<String, dynamic> json) => Member(
        id: json['id'] as String,
        orgId: json['orgId'] as String,
        name: json['name'] as String,
        isOwner: json['isOwner'] as bool? ?? false,
        phone: json['phone'] as String?,
      );
}

class Organization {
  const Organization({required this.id, required this.name});

  final String id;
  final String name;

  factory Organization.fromJson(Map<String, dynamic> json) => Organization(
        id: json['id'] as String,
        name: json['name'] as String,
      );
}
