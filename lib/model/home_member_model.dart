class HomeMemberModel {
  final String id;
  final String email;
  final Profile profile;
  final HomeData homeData;

  HomeMemberModel({
    required this.id,
    required this.email,
    required this.profile,
    required this.homeData,
  });

  factory HomeMemberModel.fromJson(Map<String, dynamic> json) {
    return HomeMemberModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      profile: Profile.fromJson(json['profile'] ?? {}),
      homeData: HomeData.fromJson(json['home_data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'profile': profile.toJson(),
        'home_data': homeData.toJson(),
      };
}

class Profile {
  final String? image;
  final String firstName;
  final String lastName;

  Profile({
    this.image,
    required this.firstName,
    required this.lastName,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      image: json['image'],
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'image': image,
        'first_name': firstName,
        'last_name': lastName,
      };
}

class HomeData {
  final String homeRole;

  HomeData({required this.homeRole});

  factory HomeData.fromJson(Map<String, dynamic> json) {
    return HomeData(
      homeRole: json['home_role'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'home_role': homeRole,
      };
}
