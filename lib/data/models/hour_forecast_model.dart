/// Model class for hourly forecast
class HourForecastModel {
  final String time;
  final DateTime dateTime;
  final int temperature;
  final double tempF;
  final String conditionText;
  final int conditionCode;
  final int humidity;
  final double windSpeed;
  final String windDirection;
  final int pressure;
  final double precipitation;
  final double chanceOfRain;
  final double chanceOfSnow;
  final int cloudCover;
  final int feelsLike;
  final double feelsLikeF;
  final int uv;

  HourForecastModel({
    required this.time,
    required this.dateTime,
    required this.temperature,
    required this.tempF,
    required this.conditionText,
    required this.conditionCode,
    required this.humidity,
    required this.windSpeed,
    required this.windDirection,
    required this.pressure,
    required this.precipitation,
    required this.chanceOfRain,
    required this.chanceOfSnow,
    required this.cloudCover,
    required this.feelsLike,
    required this.feelsLikeF,
    required this.uv,
  });

  // Create model from API JSON response
  factory HourForecastModel.fromJson(Map<String, dynamic> json) {
    return HourForecastModel(
      time: json['time'],
      dateTime: DateTime.parse(json['time']),
      temperature: json['temp_c'].round(),
      tempF: (json['temp_f'] as num).toDouble(),
      conditionText: json['condition']['text'],
      conditionCode: json['condition']['code'],
      humidity: json['humidity'],
      windSpeed: (json['wind_kph'] as num).toDouble(),
      windDirection: json['wind_dir'],
      pressure: json['pressure_mb'].round(),
      precipitation: (json['precip_mm'] as num).toDouble(),
      chanceOfRain: (json['chance_of_rain'] as num).toDouble(),
      chanceOfSnow: (json['chance_of_snow'] as num).toDouble(),
      cloudCover: json['cloud'],
      feelsLike: json['feelslike_c'].round(),
      feelsLikeF: (json['feelslike_f'] as num).toDouble(),
      uv: json['uv'].round(),
    );
  }

  // Convert model to JSON
  Map<String, dynamic> toJson() {
    return {
      'time': time,
      'dateTime': dateTime.toIso8601String(),
      'temperature': temperature,
      'tempF': tempF,
      'conditionText': conditionText,
      'conditionCode': conditionCode,
      'humidity': humidity,
      'windSpeed': windSpeed,
      'windDirection': windDirection,
      'pressure': pressure,
      'precipitation': precipitation,
      'chanceOfRain': chanceOfRain,
      'chanceOfSnow': chanceOfSnow,
      'cloudCover': cloudCover,
      'feelsLike': feelsLike,
      'feelsLikeF': feelsLikeF,
      'uv': uv,
    };
  }

  // Get formatted time (12-hour)
  String getFormattedTime12h() {
    return '${dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12}${dateTime.hour < 12 ? 'AM' : 'PM'}';
  }

  // Get formatted time (24-hour)
  String getFormattedTime24h() {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    return '$hour:00';
  }

  // Check if this is now (current hour)
  bool isCurrentHour() {
    final now = DateTime.now();
    return dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day &&
        dateTime.hour == now.hour;
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
}
