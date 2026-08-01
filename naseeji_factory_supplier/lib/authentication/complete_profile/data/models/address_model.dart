class AddressModel {
  final String country;
  final String governorate;
  final String city;
  final String streetAddress;

  const AddressModel({
    this.country = 'مصر',
    required this.governorate,
    required this.city,
    required this.streetAddress,
  });

  Map<String, dynamic> toJson() => {
        'country': country,
        'governorate': governorate,
        'city': city,
        'streetAddress': streetAddress,
      };

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      country: json['country'] as String? ?? 'مصر',
      governorate: json['governorate'] as String? ?? '',
      city: json['city'] as String? ?? '',
      streetAddress: json['streetAddress'] as String? ?? '',
    );
  }
}
