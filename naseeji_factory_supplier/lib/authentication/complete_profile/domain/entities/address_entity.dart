import 'package:equatable/equatable.dart';

class AddressEntity extends Equatable {
  final String country;
  final String governorate;
  final String city;
  final String streetAddress;

  const AddressEntity({
    this.country = 'مصر',
    required this.governorate,
    required this.city,
    required this.streetAddress,
  });

  @override
  List<Object?> get props => [country, governorate, city, streetAddress];
}
