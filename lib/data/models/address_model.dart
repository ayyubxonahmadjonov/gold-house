import 'package:gold_house/data/models/city_model.dart';
import 'package:gold_house/data/models/region_model.dart';

class Address {
  final Region region;
  final City city;
  final String street;

  Address({
    required this.region,
    required this.city,
    required this.street,
  });
}
