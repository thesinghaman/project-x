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
    required double latitude,
    required double longitude,
    DateTime? dateAdded,
  })  :
        // Ensure latitude and longitude are always stored as doubles
        this.latitude =
            latitude is int ? (latitude as int).toDouble() : latitude,
        this.longitude =
            longitude is int ? (longitude as int).toDouble() : longitude,
        this.dateAdded = dateAdded ?? DateTime.now();

  // Create model from JSON
  factory FavoriteLocationModel.fromJson(Map<String, dynamic> json) {
    // Convert latitude and longitude to double if they're integers
    final double lat = json['latitude'] is int
        ? (json['latitude'] as int).toDouble()
        : json['latitude'].toDouble();

    final double lon = json['longitude'] is int
        ? (json['longitude'] as int).toDouble()
        : json['longitude'].toDouble();

    return FavoriteLocationModel(
      locationId: json['locationId'],
      name: json['name'],
      country: json['country'],
      latitude: lat,
      longitude: lon,
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

  // Create a FavoriteLocationModel from a search result
  static FavoriteLocationModel fromSearchResult(
      Map<String, dynamic> searchResult) {
    // Create a unique ID from the location name and country
    String locationId = '${searchResult["name"]}_${searchResult["country"]}';

    // Convert coordinates to double if they're integers
    double lat = 0.0;
    double lon = 0.0;

    if (searchResult["lat"] != null) {
      lat = searchResult["lat"] is int
          ? (searchResult["lat"] as int).toDouble()
          : double.parse(searchResult["lat"].toString());
    }

    if (searchResult["lon"] != null) {
      lon = searchResult["lon"] is int
          ? (searchResult["lon"] as int).toDouble()
          : double.parse(searchResult["lon"].toString());
    }

    return FavoriteLocationModel(
      locationId: locationId,
      name: searchResult["name"],
      country: searchResult["country"],
      latitude: lat,
      longitude: lon,
    );
  }
}
