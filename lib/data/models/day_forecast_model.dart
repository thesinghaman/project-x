/// Model class for daily forecast
class DayForecastModel {
  final String date;
  final DateTime dateTime;
  final int maxTemp;
  final int minTemp;
  final double maxTempF;
  final double minTempF;
  final String conditionText;
  final int conditionCode;
  final double chanceOfRain;
  final double chanceOfSnow;
  final double totalPrecipitation;
  final double avgHumidity;
  final double maxWind;
  final int avgVisibility;
  final int uv;

  DayForecastModel({
    required this.date,
    required this.dateTime,
    required this.maxTemp,
    required this.minTemp,
    required this.maxTempF,
    required this.minTempF,
    required this.conditionText,
    required this.conditionCode,
    required this.chanceOfRain,
    required this.chanceOfSnow,
    required this.totalPrecipitation,
    required this.avgHumidity,
    required this.maxWind,
    required this.avgVisibility,
    required this.uv,
  });

  // Create model from API JSON response
  factory DayForecastModel.fromJson(Map<String, dynamic> json) {
    final day = json['day'];

    return DayForecastModel(
      date: json['date'],
      dateTime: DateTime.parse(json['date']),
      maxTemp: day['maxtemp_c'].round(),
      minTemp: day['mintemp_c'].round(),
      maxTempF: day['maxtemp_f'],
      minTempF: day['mintemp_f'],
      conditionText: day['condition']['text'],
      conditionCode: day['condition']['code'],
      chanceOfRain: day['daily_chance_of_rain'].toDouble(),
      chanceOfSnow: day['daily_chance_of_snow'].toDouble(),
      totalPrecipitation: day['totalprecip_mm'],
      avgHumidity: day['avghumidity'],
      maxWind: day['maxwind_kph'],
      avgVisibility: day['avgvis_km'].round(),
      uv: day['uv'].round(),
    );
  }

  // Convert model to JSON
  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'dateTime': dateTime.toIso8601String(),
      'maxTemp': maxTemp,
      'minTemp': minTemp,
      'maxTempF': maxTempF,
      'minTempF': minTempF,
      'conditionText': conditionText,
      'conditionCode': conditionCode,
      'chanceOfRain': chanceOfRain,
      'chanceOfSnow': chanceOfSnow,
      'totalPrecipitation': totalPrecipitation,
      'avgHumidity': avgHumidity,
      'maxWind': maxWind,
      'avgVisibility': avgVisibility,
      'uv': uv,
    };
  }

  // Get day name from date
  String getDayName() {
    final weekday = dateTime.weekday;

    switch (weekday) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
        return '';
    }
  }

  // Get short day name
  String getShortDayName() {
    final weekday = dateTime.weekday;

    switch (weekday) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return '';
    }
  }

  // Check if this is today
  bool isToday() {
    final now = DateTime.now();
    return dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day;
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
