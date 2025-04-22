/// Model class for current weather data
class CurrentWeatherModel {
  final int temperature;
  final int feelsLike;
  final String conditionText;
  final int conditionCode;
  final int humidity;
  final double windSpeed;
  final String windDirection;
  final int pressure;
  final double precipitation;
  final int uv;
  final double visibility;
  final double? tempF; // Optional Fahrenheit temperature

  CurrentWeatherModel({
    required this.temperature,
    required this.feelsLike,
    required this.conditionText,
    required this.conditionCode,
    required this.humidity,
    required this.windSpeed,
    required this.windDirection,
    required this.pressure,
    required this.precipitation,
    required this.uv,
    required this.visibility,
    this.tempF,
  });

  // Create model from API JSON response
  factory CurrentWeatherModel.fromJson(Map<String, dynamic> json) {
    final current = json['current'];

    return CurrentWeatherModel(
      temperature: current['temp_c'].round(),
      tempF: current['temp_f'],
      feelsLike: current['feelslike_c'].round(),
      conditionText: current['condition']['text'],
      conditionCode: current['condition']['code'],
      humidity: current['humidity'],
      windSpeed: current['wind_kph'],
      windDirection: current['wind_dir'],
      pressure: current['pressure_mb'].round(),
      precipitation: current['precip_mm'],
      uv: current['uv'].round(),
      visibility: current['vis_km'],
    );
  }

  // Convert model to JSON
  Map<String, dynamic> toJson() {
    return {
      'temperature': temperature,
      'feelsLike': feelsLike,
      'conditionText': conditionText,
      'conditionCode': conditionCode,
      'humidity': humidity,
      'windSpeed': windSpeed,
      'windDirection': windDirection,
      'pressure': pressure,
      'precipitation': precipitation,
      'uv': uv,
      'visibility': visibility,
      'tempF': tempF,
    };
  }

  // Get weather icon based on condition code
  String getWeatherIcon() {
    // This would return the path to the appropriate weather icon
    // based on the condition code
    if (conditionCode == 1000) {
      return 'assets/icons/weather/clear_sky.png'; // Sunny
    } else if (conditionCode >= 1003 && conditionCode <= 1009) {
      return 'assets/icons/weather/few_clouds.png'; // Cloudy
    } else if (conditionCode >= 1180 && conditionCode <= 1201) {
      return 'assets/icons/weather/rain.png'; // Rain
    } else if (conditionCode >= 1273 && conditionCode <= 1282) {
      return 'assets/icons/weather/thunderstorm.png'; // Thunderstorm
    } else if (conditionCode >= 1210 && conditionCode <= 1225) {
      return 'assets/icons/weather/snow.png'; // Snow
    } else {
      return 'assets/icons/weather/few_clouds.png'; // Default
    }
  }

  // Get weather animation based on condition code
  String getWeatherAnimation() {
    // This would return the path to the appropriate Lottie animation
    // based on the condition code
    if (conditionCode == 1000) {
      return 'assets/animations/lottie/sun_animation.json';
    } else if (conditionCode >= 1003 && conditionCode <= 1009) {
      return 'assets/animations/lottie/cloud_animation.json';
    } else if (conditionCode >= 1180 && conditionCode <= 1201) {
      return 'assets/animations/lottie/rain_animation.json';
    } else if (conditionCode >= 1273 && conditionCode <= 1282) {
      return 'assets/animations/lottie/thunder_animation.json';
    } else if (conditionCode >= 1210 && conditionCode <= 1225) {
      return 'assets/animations/lottie/snow_animation.json';
    } else {
      return 'assets/animations/lottie/cloud_animation.json';
    }
  }

  // Get background gradient based on condition code
  List<double> getWeatherGradient() {
    // This would return gradient colors based on the condition
    // For now, it will return [hue1, hue2] values for HSL colors
    if (conditionCode == 1000) {
      return [210, 220]; // Sunny blue gradient
    } else if (conditionCode >= 1003 && conditionCode <= 1009) {
      return [210, 200]; // Cloudy blue gradient
    } else if (conditionCode >= 1180 && conditionCode <= 1201) {
      return [200, 190]; // Rainy gradient
    } else if (conditionCode >= 1273 && conditionCode <= 1282) {
      return [250, 240]; // Thunderstorm gradient
    } else if (conditionCode >= 1210 && conditionCode <= 1225) {
      return [220, 210]; // Snowy gradient
    } else {
      return [210, 200]; // Default gradient
    }
  }
}
