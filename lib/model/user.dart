class UserModel {
  String? userid;
  String profileImage;
  String profileName;
  String phoneNo;
  String email;
  String address;
  String dialCode;
  String isoCode;

  UserModel({
    required this.userid,
    required this.profileImage,
    required this.profileName,
    required this.phoneNo,
    required this.email,
    required this.address,
    required this.dialCode,
    required this.isoCode,
  });

  Map<String, dynamic> toJson() {
    return {
      "UID": userid,
      "ProfileImage": profileImage,
      "ProfileName": profileName,
      "PhoneNo": phoneNo,
      "Email": email,
      "Address": address,
      "DC": dialCode,
      "ISO": isoCode,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> data) {
    return UserModel(
      userid: data["UID"],
      profileImage: data["ProfileImage"],
      profileName: data["ProfileName"],
      phoneNo: data["PhoneNo"],
      email: data["Email"],
      address: data["Address"],
      dialCode: data["DC"],
      isoCode: data["ISO"],
    );
  }
}
