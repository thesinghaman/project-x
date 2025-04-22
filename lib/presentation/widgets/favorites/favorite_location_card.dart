import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sundrift/app/themes/app_theme.dart';
import 'package:sundrift/core/constants/app_constants.dart';
import 'package:sundrift/core/storage/local_storage.dart';
import 'package:sundrift/data/models/favorite_location_model.dart';
import 'package:sundrift/data/models/current_weather_model.dart';
import 'package:flutter_animate/flutter_animate.dart';

class FavoriteLocationCard extends StatelessWidget {
  final FavoriteLocationModel location;
  final CurrentWeatherModel? weatherData;
  final VoidCallback onTap;
  final VoidCallback onRemove;
  final VoidCallback onRefresh;
  final bool isRefreshing;
  final int index;

  const FavoriteLocationCard({
    Key? key,
    required this.location,
    this.weatherData,
    required this.onTap,
    required this.onRemove,
    required this.onRefresh,
    this.isRefreshing = false,
    this.index = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LocalStorage localStorage = Get.find<LocalStorage>();

    // Get temperature unit preference
    final temperatureUnit = localStorage.getString(
      AppConstants.storageKeyTemperatureUnit,
      defaultValue: AppConstants.defaultTemperatureUnit,
    );

    // Get temperature based on unit
    final temp = weatherData != null
        ? (temperatureUnit == AppConstants.unitCelsius
            ? weatherData!.temperature
            : weatherData!.tempF?.round() ??
                ((weatherData!.temperature * 9 / 5) + 32).round())
        : null;

    return Animate(
      effects: [
        FadeEffect(
          duration: AppDimensions.animNormal,
          delay: Duration(milliseconds: index * 70),
        ),
        SlideEffect(
          duration: AppDimensions.animNormal,
          delay: Duration(milliseconds: index * 70),
          begin: const Offset(0, 0.1),
          end: const Offset(0, 0),
        ),
      ],
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Location header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Location name and country
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            location.name,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            location.country,
                            style: Theme.of(context).textTheme.bodySmall,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),

                    // Remove button
                    IconButton(
                      icon: const Icon(Iconsax.trash),
                      onPressed: onRemove,
                      tooltip: 'remove_from_favorites'.tr,
                      iconSize: 20,
                    ),
                  ],
                ),

                const Divider(),

                // Weather data or loading
                weatherData != null
                    ? _buildWeatherInfo(context, temp!)
                    : _buildLoadingOrError(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Build weather information
  Widget _buildWeatherInfo(BuildContext context, int temperature) {
    return Row(
      children: [
        // Weather icon
        SizedBox(
          width: 50,
          height: 50,
          child: _getWeatherIcon(context, weatherData!.conditionCode),
        ),

        const SizedBox(width: AppDimensions.sm),

        // Weather details
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                weatherData!.conditionText,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                '${weatherData!.humidity}% humidity · ${weatherData!.windSpeed.round()} km/h',
                style: Theme.of(context).textTheme.bodySmall,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),

        // Temperature
        Text(
          '$temperature°',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }

  // Build loading or error state
  Widget _buildLoadingOrError(BuildContext context) {
    return Center(
      child: isRefreshing
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Column(
              children: [
                const Icon(
                  Iconsax.danger,
                  color: Colors.amber,
                  size: 28,
                ),
                const SizedBox(height: AppDimensions.xs),
                Text(
                  'Unable to load weather data',
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
                TextButton(
                  onPressed: onRefresh,
                  child: Text('refresh'.tr),
                ),
              ],
            ),
    );
  }

  // Get weather icon based on condition code
  Widget _getWeatherIcon(BuildContext context, int conditionCode) {
    IconData iconData;

    if (conditionCode == 1000) {
      iconData = Iconsax.sun_1;
    } else if (conditionCode >= 1003 && conditionCode <= 1009) {
      iconData = Iconsax.cloud;
    } else if (conditionCode >= 1180 && conditionCode <= 1201) {
      iconData = Iconsax.cloud_drizzle;
    } else if (conditionCode >= 1273 && conditionCode <= 1282) {
      iconData = Iconsax.cloud_lightning;
    } else if (conditionCode >= 1210 && conditionCode <= 1225) {
      iconData = Iconsax.cloud_snow;
    } else {
      iconData = Iconsax.cloud_fog;
    }

    return Icon(
      iconData,
      color: _getWeatherIconColor(conditionCode),
      size: 32,
    );
  }

  // Get color for weather icon
  Color _getWeatherIconColor(int conditionCode) {
    if (conditionCode == 1000) {
      return Colors.orange;
    } else if (conditionCode >= 1003 && conditionCode <= 1009) {
      return Colors.blueGrey;
    } else if (conditionCode >= 1180 && conditionCode <= 1201) {
      return Colors.blue;
    } else if (conditionCode >= 1273 && conditionCode <= 1282) {
      return Colors.purple;
    } else if (conditionCode >= 1210 && conditionCode <= 1225) {
      return Colors.lightBlue;
    } else {
      return Colors.grey;
    }
  }
}
