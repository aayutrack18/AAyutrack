class AppUser {
  final String uid;
  final String? name;
  final String? email;
  final String? phoneNumber;
  final String? photoUrl;
  final bool profileCompleted;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const AppUser({
    required this.uid,
    this.name,
    this.email,
    this.phoneNumber,
    this.photoUrl,
    this.profileCompleted = false,
    this.createdAt,
    this.updatedAt,
  });

  AppUser copyWith({
    String? uid,
    String? name,
    String? email,
    String? phoneNumber,
    String? photoUrl,
    bool? profileCompleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AppUser(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      photoUrl: photoUrl ?? this.photoUrl,
      profileCompleted: profileCompleted ?? this.profileCompleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}