import 'package:sundrift/data/models/hour_forecast_model.dart';
import 'package:sundrift/data/models/day_forecast_model.dart';

/// Model class for weather forecasts
class ForecastModel {
  final List<DayForecastModel> dailyForecasts;
  final List<HourForecastModel> hourlyForecasts;

  ForecastModel({
    required this.dailyForecasts,
    required this.hourlyForecasts,
  });

  // Create model from API JSON response
  factory ForecastModel.fromJson(Map<String, dynamic> json) {
    final forecastDays = json['forecast']['forecastday'] as List;

    // Extract daily forecasts
    final dailyForecasts =
        forecastDays.map((day) => DayForecastModel.fromJson(day)).toList();

    // Extract hourly forecasts for the next 24 hours
    final List<HourForecastModel> hourlyForecasts = [];

    // Typically, we'd extract the next 24 hours across today and tomorrow
    for (var i = 0; i < Math.min(2, forecastDays.length); i++) {
      final hours = forecastDays[i]['hour'] as List;

      if (i == 0) {
        // For today, include only hours from current time onwards
        final now = DateTime.now();
        final currentHour = now.hour;

        for (var j = currentHour; j < hours.length; j++) {
          hourlyForecasts.add(HourForecastModel.fromJson(hours[j]));
        }
      } else {
        // For tomorrow, include hours until we have 24 in total
        for (var j = 0; j < hours.length && hourlyForecasts.length < 24; j++) {
          hourlyForecasts.add(HourForecastModel.fromJson(hours[j]));
        }
      }
    }

    return ForecastModel(
      dailyForecasts: dailyForecasts,
      hourlyForecasts: hourlyForecasts,
    );
  }

  // Convert model to JSON
  Map<String, dynamic> toJson() {
    return {
      'dailyForecasts': dailyForecasts.map((day) => day.toJson()).toList(),
      'hourlyForecasts': hourlyForecasts.map((hour) => hour.toJson()).toList(),
    };
  }
}

// Import Math for min function
class Math {
  static int min(int a, int b) {
    return a < b ? a : b;
  }
}
