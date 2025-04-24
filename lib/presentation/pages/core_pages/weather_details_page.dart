import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sundrift/app/themes/app_theme.dart';
import 'package:sundrift/core/constants/app_constants.dart';
import 'package:sundrift/core/storage/local_storage.dart';
import 'package:sundrift/data/models/day_forecast_model.dart';
import 'package:sundrift/data/models/favorite_location_model.dart';
import 'package:sundrift/data/models/current_weather_model.dart';
import 'package:sundrift/data/models/forecast_model.dart';
import 'package:sundrift/presentation/controllers/weather_details_controller.dart';
import 'package:sundrift/presentation/widgets/common/weather_stats_grid.dart';
import 'package:sundrift/presentation/widgets/home/hourly_forecast_chart.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';

class WeatherDetailsPage extends StatelessWidget {
  const WeatherDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get arguments
    final arguments = Get.arguments as Map<String, dynamic>;
    final location = arguments['location'] as FavoriteLocationModel;

    // Initialize controller
    final controller = Get.find<WeatherDetailsController>();

    // Load data for this location
    controller.loadLocationData(location);

    return Scaffold(
      body: Obx(() {
        // Show loading state
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // Show error state if any
        if (controller.hasError.value) {
          return _buildErrorView(context, controller);
        }

        // Show content
        return _buildWeatherDetailsContent(context, controller, location);
      }),
    );
  }

  // Build error view
  Widget _buildErrorView(
      BuildContext context, WeatherDetailsController controller) {
    return Scaffold(
      appBar: AppBar(
        title: Text('weather_details'.tr),
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left),
          onPressed: () => Get.back(),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Iconsax.danger,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: AppDimensions.md),
            Text(
              'error_occurred'.tr,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppDimensions.sm),
            Text(
              controller.errorMessage.value,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.lg),
            ElevatedButton.icon(
              onPressed: controller.refreshData,
              icon: const Icon(Iconsax.refresh),
              label: Text('retry'.tr),
            ),
          ],
        ),
      ),
    );
  }

  // Build weather details content
  Widget _buildWeatherDetailsContent(
    BuildContext context,
    WeatherDetailsController controller,
    FavoriteLocationModel location,
  ) {
    final currentWeather = controller.currentWeather.value;
    final forecast = controller.forecast.value;

    if (currentWeather == null) {
      return _buildErrorView(context, controller);
    }

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // App bar
        _buildSliverAppBar(context, controller, location, currentWeather),

        // Content
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Weather stats grid
                Animate(
                  effects: const [
                    FadeEffect(duration: AppDimensions.animNormal),
                    SlideEffect(
                      duration: AppDimensions.animNormal,
                      begin: Offset(0, 0.2),
                      end: Offset(0, 0),
                    ),
                  ],
                  child: WeatherStatsGrid(
                    stats: {
                      'humidity': WeatherStat(
                        value: '${currentWeather.humidity}%',
                        icon: Iconsax.drop,
                        iconColor: Colors.blue,
                      ),
                      'wind': WeatherStat(
                        value: '${currentWeather.windSpeed.round()} km/h',
                        icon: Iconsax.wind,
                        iconColor: Colors.teal,
                        description: currentWeather.windDirection,
                      ),
                      'pressure': WeatherStat(
                        value: '${currentWeather.pressure} hPa',
                        icon: Iconsax.weight,
                        iconColor: Colors.purple,
                      ),
                      'uv_index': WeatherStat(
                        value: '${currentWeather.uv}',
                        icon: Iconsax.sun_1,
                        iconColor: Colors.orange,
                      ),
                    },
                  ),
                ),

                const SizedBox(height: AppDimensions.lg),

                // Hourly forecast if available
                if (forecast != null && forecast.hourlyForecasts.isNotEmpty)
                  Animate(
                    effects: const [
                      FadeEffect(
                        duration: AppDimensions.animNormal,
                        delay: Duration(milliseconds: 100),
                      ),
                      SlideEffect(
                        duration: AppDimensions.animNormal,
                        delay: Duration(milliseconds: 100),
                        begin: Offset(0, 0.2),
                        end: Offset(0, 0),
                      ),
                    ],
                    child: HourlyForecastChart(
                      hourlyForecasts: forecast.hourlyForecasts,
                    ),
                  ),

                const SizedBox(height: AppDimensions.lg),

                // Daily forecast
                if (forecast != null && forecast.dailyForecasts.isNotEmpty)
                  _buildDailyForecast(context, forecast),

                const SizedBox(height: AppDimensions.xxl),

                // Set as current location button
                Animate(
                  effects: const [
                    FadeEffect(
                      duration: AppDimensions.animNormal,
                      delay: Duration(milliseconds: 300),
                    ),
                  ],
                  child: Center(
                    child: OutlinedButton.icon(
                      onPressed: () =>
                          controller.setAsCurrentLocation(location),
                      icon: const Icon(Iconsax.location),
                      label: Text('Set as Current Location'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.lg,
                          vertical: AppDimensions.md,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: AppDimensions.lg),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Build sliver app bar with weather info
  Widget _buildSliverAppBar(
    BuildContext context,
    WeatherDetailsController controller,
    FavoriteLocationModel location,
    CurrentWeatherModel currentWeather,
  ) {
    final LocalStorage localStorage = Get.find<LocalStorage>();

    // Get temperature unit preference
    final temperatureUnit = localStorage.getString(
      AppConstants.storageKeyTemperatureUnit,
      defaultValue: AppConstants.defaultTemperatureUnit,
    );

    // Get temperature based on unit
    final temp = temperatureUnit == AppConstants.unitCelsius
        ? currentWeather.temperature
        : currentWeather.tempF?.round() ??
            ((currentWeather.temperature * 9 / 5) + 32).round();

    // Temperature unit symbol
    final unitSymbol =
        temperatureUnit == AppConstants.unitCelsius ? '°C' : '°F';

    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      stretch: true,
      leading: IconButton(
        icon: const Icon(Iconsax.arrow_left),
        onPressed: () => Get.back(),
      ),
      actions: [
        IconButton(
          icon: const Icon(Iconsax.refresh),
          onPressed: controller.refreshData,
          tooltip: 'refresh'.tr,
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Gradient background based on weather
            Container(
              decoration: BoxDecoration(
                gradient: _getWeatherGradient(currentWeather.conditionCode),
              ),
            ),

            // Weather animation overlay
            Opacity(
              opacity: 0.4,
              child: Lottie.asset(
                currentWeather.getWeatherAnimation(),
                fit: BoxFit.cover,
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(AppDimensions.lg),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Location name
                  Text(
                    '${location.name}, ${location.country}',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),

                  const SizedBox(height: AppDimensions.sm),

                  // Weather condition
                  Text(
                    currentWeather.conditionText,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white.withOpacity(0.9),
                        ),
                  ),

                  const SizedBox(height: AppDimensions.lg),

                  // Temperature
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$temp',
                        style:
                            Theme.of(context).textTheme.displayLarge?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  height: 0.9,
                                ),
                      ),
                      Text(
                        unitSymbol,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),

                  // Feels like
                  Text(
                    '${'feels_like'.tr}: ${currentWeather.feelsLike}$unitSymbol',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withOpacity(0.9),
                        ),
                  ),

                  const SizedBox(height: AppDimensions.sm),

                  // Last updated
                  Text(
                    'Updated ${controller.lastUpdated.value}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white.withOpacity(0.7),
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build daily forecast section
  Widget _buildDailyForecast(BuildContext context, ForecastModel forecast) {
    return Animate(
      effects: const [
        FadeEffect(
          duration: AppDimensions.animNormal,
          delay: Duration(milliseconds: 200),
        ),
        SlideEffect(
          duration: AppDimensions.animNormal,
          delay: Duration(milliseconds: 200),
          begin: Offset(0, 0.2),
          end: Offset(0, 0),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            'daily_forecast'.tr,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),

          const SizedBox(height: AppDimensions.sm),

          // Daily forecast list
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: forecast.dailyForecasts.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final day = forecast.dailyForecasts[index];
                final isToday = day.isToday();

                return _buildDailyForecastItem(context, day, isToday, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  // Build daily forecast item
  Widget _buildDailyForecastItem(
    BuildContext context,
    DayForecastModel day,
    bool isToday,
    int index,
  ) {
    final LocalStorage localStorage = Get.find<LocalStorage>();

    // Get temperature unit preference
    final temperatureUnit = localStorage.getString(
      AppConstants.storageKeyTemperatureUnit,
      defaultValue: AppConstants.defaultTemperatureUnit,
    );

    // Get temperature based on unit
    final maxTemp = temperatureUnit == AppConstants.unitCelsius
        ? day.maxTemp
        : day.maxTempF.round();

    final minTemp = temperatureUnit == AppConstants.unitCelsius
        ? day.minTemp
        : day.minTempF.round();

    return Animate(
      effects: [
        FadeEffect(
          duration: AppDimensions.animNormal,
          delay: Duration(milliseconds: index * 50),
        ),
      ],
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.md,
          vertical: AppDimensions.xs,
        ),
        tileColor: isToday
            ? Theme.of(context).colorScheme.primary.withOpacity(0.05)
            : null,
        title: Text(
          isToday ? 'Today' : day.getDayName(),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: isToday ? FontWeight.bold : null,
              ),
        ),
        subtitle: Row(
          children: [
            Icon(
              _getWeatherIconData(day.conditionCode),
              size: 16,
              color: _getWeatherIconColor(day.conditionCode),
            ),
            const SizedBox(width: 4),
            Text(
              day.conditionText,
              style: Theme.of(context).textTheme.bodySmall,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Precipitation chance
            if (day.chanceOfRain > 0 || day.chanceOfSnow > 0)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    day.chanceOfRain > day.chanceOfSnow
                        ? Iconsax.cloud_drizzle
                        : Iconsax.cloud_snow,
                    size: 16,
                    color: Colors.blue,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${(day.chanceOfRain > day.chanceOfSnow ? day.chanceOfRain : day.chanceOfSnow).round()}%',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(width: 8),
                ],
              ),

            // Temperature
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$minTemp°',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.blue.shade700,
                      ),
                ),
                Text(
                  ' / ',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  '$maxTemp°',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.red.shade700,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Get weather gradient based on condition code
  LinearGradient _getWeatherGradient(int conditionCode) {
    if (conditionCode == 1000) {
      return AppGradients.sunnyGradient;
    } else if (conditionCode >= 1003 && conditionCode <= 1009) {
      return AppGradients.cloudyGradient;
    } else if (conditionCode >= 1180 && conditionCode <= 1201) {
      return AppGradients.rainyGradient;
    } else if (conditionCode >= 1273 && conditionCode <= 1282) {
      return AppGradients.stormyGradient;
    } else if (conditionCode >= 1210 && conditionCode <= 1225) {
      return AppGradients.snowyGradient;
    } else {
      return AppGradients.foggyGradient;
    }
  }

  // Get weather icon data
  IconData _getWeatherIconData(int conditionCode) {
    if (conditionCode == 1000) {
      return Iconsax.sun_1;
    } else if (conditionCode >= 1003 && conditionCode <= 1009) {
      return Iconsax.cloud;
    } else if (conditionCode >= 1180 && conditionCode <= 1201) {
      return Iconsax.cloud_drizzle;
    } else if (conditionCode >= 1273 && conditionCode <= 1282) {
      return Iconsax.cloud_lightning;
    } else if (conditionCode >= 1210 && conditionCode <= 1225) {
      return Iconsax.cloud_snow;
    } else {
      return Iconsax.cloud_fog;
    }
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
