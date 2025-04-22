/// Model class for a favorite location
class FavoriteLocationModel {
  final String locationId;
  final String name;
  final String country;
  final double latitude;
  final double longitude;
  final DateTime dateAdded;

  FavoriteLocationModel({
    required this.locationId,
    required this.name,
    required this.country,
    required this.latitude,
    required this.longitude,
    DateTime? dateAdded,
  }) : this.dateAdded = dateAdded ?? DateTime.now();

  // Create model from JSON
  factory FavoriteLocationModel.fromJson(Map<String, dynamic> json) {
    return FavoriteLocationModel(
      locationId: json['locationId'],
      name: json['name'],
      country: json['country'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      dateAdded: json['dateAdded'] != null
          ? DateTime.parse(json['dateAdded'])
          : DateTime.now(),
    );
  }

  // Convert model to JSON
  Map<String, dynamic> toJson() {
    return {
      'locationId': locationId,
      'name': name,
      'country': country,
      'latitude': latitude,
      'longitude': longitude,
      'dateAdded': dateAdded.toIso8601String(),
    };
  }

  // Get formatted location string
  String getFormattedLocation() {
    return '$name, $country';
  }
}
