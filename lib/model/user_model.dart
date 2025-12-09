class UserData {
  final String? id;
  final String? email;
  final bool? isHomeDataGiven;
  final String? role;
  final HomeData? homeData;
  final Profile? profile;

  UserData({
    this.id,
    this.email,
    this.isHomeDataGiven,
    this.role,
    this.homeData,
    this.profile,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'] as String?,
      email: json['email'] as String?,
      isHomeDataGiven: json['is_home_data_given'] is bool
          ? json['is_home_data_given'] as bool
          : json['is_home_data_given'] == 1, // handle int -> bool
      role: json['role'] as String?,
      homeData: json['home_data'] != null
          ? HomeData.fromJson(json['home_data'])
          : null,
      profile:
          json['profile'] != null ? Profile.fromJson(json['profile']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'is_home_data_given': isHomeDataGiven,
        'role': role,
        'home_data': homeData?.toJson(),
        'profile': profile?.toJson(),
      };
}

class HomeData {
  final String? homeRole;
  final String? homeAddress;
  final Home? home;

  HomeData({this.homeRole, this.homeAddress, this.home});
  factory HomeData.fromJson(Map<String, dynamic> json) {
    return HomeData(
      homeRole: json['home_role'] as String?,
      homeAddress: json['home_address'] as String?,
      home: json['home'] != null ? Home.fromJson(json['home']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'home_role': homeRole,
        'home_address': homeAddress,
        'home': home?.toJson(),
      };
}

class Home {
  final String? homeRoomId;

  Home({this.homeRoomId});

  factory Home.fromJson(Map<String, dynamic> json) {
    return Home(
      homeRoomId: json['home_room_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'home_room_id': homeRoomId,
      };
}

class Profile {
  final String? image;
  final String? lastName;
  final String? firstName;
  final String? address;
  final String? gender;
  final String? mobile;

  Profile({
    this.image,
    this.lastName,
    this.firstName,
    this.address,
    this.gender,
    this.mobile,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      image: json['image'] as String?,
      lastName: json['last_name'] as String?,
      firstName: json['first_name'] as String?,
      address: json['address'] as String?,
      gender: json['gender'] as String?,
      mobile: json['mobile'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'image': image,
        'last_name': lastName,
        'first_name': firstName,
        'address': address,
        'gender': gender,
        'mobile': mobile,
      };
}
