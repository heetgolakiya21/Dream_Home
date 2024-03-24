class Search {
  String? tokenID;
  String? userID;
  String? post;
  String? country;
  String state;
  String city;
  String type;
  String numMin;
  String numMax;
  String strMin;
  String strMax;

  Search({
    this.tokenID,
    this.userID,
    this.post,
    this.country,
    this.state = "",
    this.city = "",
    this.type = "",
    this.numMin = "",
    this.numMax = "",
    this.strMin = "",
    this.strMax = "",
  });

  Map<String, dynamic> toJson() {
    return {
      "TokenID": tokenID,
      "UserID": userID,
      "Post": post,
      "Country": country,
      "State": state,
      "City": city,
      "Type": type,
      "NumMin": numMin,
      "NumMax": numMax,
      "StrMin": strMin,
      "StrMax": strMax,
    };
  }
}
