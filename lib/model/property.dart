class Property {
  String? userID;
  String? propertyID;
  String paymentID;
  String? verificationStatus;
  String reason;
  String? post;
  String? mainType;
  String? type;
  String? country;
  String? state;
  String? city;
  String? address;
  String? fullAddress;
  String bedroom;
  String bathroom;
  String balcony;
  String totalFloor;
  String yourFloor;
  String furnishing;
  String carpetArea;
  String carpetAreaUnit;
  String superArea;
  String superAreaUnit;
  String roadWidth;
  String noAllowCon;
  String openSides;
  String boundaryWall;
  String plotArea;
  String plotAreaUnit;
  String plotLength;
  String plotBreadth;
  String pantryCafeteria;
  String washroom;
  String cornerShop;
  String roadFacing;
  String priceInString;
  String expectedPrice;
  String priceRentNegotiable;
  String bookingToken;
  String? mainStatus;
  String? subStatus;
  String? rentInString;
  String monthRent;
  String securityAmt;
  String maintenanceCharge;
  List<dynamic>? images;
  String description;

  Property({
    this.verificationStatus,
    this.reason = "",
    this.propertyID,
    this.userID,
    this.paymentID = "",
    this.description = "",
    this.post,
    this.mainType,
    this.type,
    this.country,
    this.state,
    this.city,
    this.address,
    this.fullAddress,
    this.bedroom = "",
    this.bathroom = "",
    this.balcony = "-1",
    this.totalFloor = "",
    this.yourFloor = "",
    this.furnishing = "",
    this.carpetArea = "",
    this.carpetAreaUnit = "",
    this.superArea = "",
    this.superAreaUnit = "",
    this.roadWidth = "",
    this.noAllowCon = "",
    this.openSides = "",
    this.boundaryWall = "",
    this.plotArea = "",
    this.plotAreaUnit = "",
    this.plotLength = "",
    this.plotBreadth = "",
    this.pantryCafeteria = "",
    this.washroom = "",
    this.cornerShop = "",
    this.roadFacing = "",
    this.priceInString = "",
    this.expectedPrice = "",
    this.priceRentNegotiable = "",
    this.bookingToken = "",
    this.mainStatus,
    this.subStatus = "",
    this.monthRent = "",
    this.rentInString = "",
    this.securityAmt = "",
    this.maintenanceCharge = "",
    this.images,
  });

  Map<String, dynamic> toJson() {
    return {
      "PropertyID": propertyID,
      "UserID": userID,
      "PaymentID": paymentID,
      "VerificationStatus": verificationStatus,
      "Reason": reason,
      "Description": description,
      "Images": images,
      "Post": post,
      "MainType": mainType,
      "Type": type,
      "Country": country,
      "State": state,
      "City": city,
      "Address": address,
      "FullAddress": fullAddress,
      "BedRoom": bedroom,
      "BathRoom": bathroom,
      "Balcony": balcony,
      "TotalFloor": totalFloor,
      "YourFloor": yourFloor,
      "Furnishing": furnishing,
      "CarpetArea": carpetArea,
      "CarpetAreaUnit": carpetAreaUnit,
      "SuperArea": superArea,
      "SuperAreaUnit": superAreaUnit,
      "RoadWidth": roadWidth,
      "NoAllowConstruction": noAllowCon,
      "OpenSides": openSides,
      "BoundaryWall": boundaryWall,
      "PlotArea": plotArea,
      "PlotAreaUnit": plotAreaUnit,
      "PlotLength": plotLength,
      "PlotBreadth": plotBreadth,
      "PantryCafeteria": pantryCafeteria,
      "Washroom": washroom,
      "CornerShop": cornerShop,
      "RoadFacing": roadFacing,
      "PriceInString": priceInString,
      "ExpectedPrice": expectedPrice,
      "PriceRentNegotiable": priceRentNegotiable,
      "BookingToken": bookingToken,
      "SubStatus": subStatus,
      "MainStatus": mainStatus,
      "MonthRent": monthRent,
      "RentInString": rentInString,
      "SecurityAmt": securityAmt,
      "MaintenanceCharge": maintenanceCharge,
    };
  }

  factory Property.fromJson(Map<String, dynamic> data) {
    return Property(
      propertyID: data["PropertyID"],
      userID: data["UserID"],
      paymentID: data["PaymentID"],
      description: data["Description"],
      images: data["Images"],
      post: data["Post"],
      mainType: data["MainType"],
      type: data["Type"],
      country: data["Country"],
      state: data["State"],
      city: data["City"],
      address: data["Address"],
      fullAddress: data["FullAddress"],
      bedroom: data["BedRoom"],
      bathroom: data["BathRoom"],
      balcony: data["Balcony"],
      totalFloor: data["TotalFloor"],
      yourFloor: data["YourFloor"],
      furnishing: data["Furnishing"],
      carpetArea: data["CarpetArea"],
      carpetAreaUnit: data["CarpetAreaUnit"],
      superArea: data["SuperArea"],
      superAreaUnit: data["SuperAreaUnit"],
      roadWidth: data["RoadWidth"],
      noAllowCon: data["NoAllowConstruction"],
      openSides: data["OpenSides"],
      boundaryWall: data["BoundaryWall"],
      plotArea: data["PlotArea"],
      plotAreaUnit: data["PlotAreaUnit"],
      plotLength: data["PlotLength"],
      plotBreadth: data["PlotBreadth"],
      pantryCafeteria: data["PantryCafeteria"],
      washroom: data["Washroom"],
      cornerShop: data["CornerShop"],
      roadFacing: data["RoadFacing"],
      priceInString: data["PriceInString"],
      expectedPrice: data["ExpectedPrice"],
      priceRentNegotiable: data["PriceRentNegotiable"],
      bookingToken: data["BookingToken"],
      mainStatus: data["MainStatus"],
      subStatus: data["SubStatus"],
      monthRent: data["MonthRent"],
      rentInString: data["RentInString"],
      securityAmt: data["SecurityAmt"],
      maintenanceCharge: data["MaintenanceCharge"],
    );
  }
}
