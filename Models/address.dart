class Address {
  final int addressID;
  final String addressLine1;
  final String city;
  final String stateProvince;
  final String countryRegion;
  final String postalCode;

  Address({
    required this.addressID,
    required this.addressLine1,
    required this.city,
    required this.stateProvince,
    required this.countryRegion,
    required this.postalCode,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      addressID: json['addressID'],
      addressLine1: json['addressLine1'],
      city: json['city'],
      stateProvince: json['stateProvince'],
      countryRegion: json['countryRegion'],
      postalCode: json['postalCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'addressID': addressID,
      'addressLine1': addressLine1,
      'city': city,
      'stateProvince': stateProvince,
      'countryRegion': countryRegion,
      'postalCode': postalCode,
    };
  }
  
}
