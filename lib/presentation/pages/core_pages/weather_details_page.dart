import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sundrift/app/themes/app_theme.dart';
import 'package:sundrift/core/constants/app_constants.dart';
import 'package:sundrift/core/storage/local_storage.dart';
import 'package:sundrift/data/models/favorite_location_model.dart';
import 'package:sundrift/data/models/current_weather_model.dart';
import 'package:sundrift/data/models/forecast_model.dart';
import 'package:sundrift/presentation/controllers/weather_details_controller.dart';
import 'package:sundrift/presentation/widgets/common/weather_stats_grid.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';

// Import our new widgets
import 'package:sundrift/presentation/widgets/home/hourly_forecast_chart.dart';
import 'package:sundrift/presentation/widgets/home/daily_forecast_widget.dart';

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
        // Make sure the error view app bar is opaque
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
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
                  HourlyForecastChart(
                    hourlyForecasts: forecast.hourlyForecasts,
                  ),

                const SizedBox(height: AppDimensions.lg),

// Daily forecast
                if (forecast != null && forecast.dailyForecasts.isNotEmpty)
                  DailyForecastWidget(
                    dailyForecasts: forecast.dailyForecasts,
                  ),

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
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radiusMd),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
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
                          backgroundColor:
                              Theme.of(context).colorScheme.surface,
                          foregroundColor:
                              Theme.of(context).colorScheme.primary,
                          side: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                            width: 2,
                          ),
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
      // Make the collapsed app bar use primary color and be completely opaque
      backgroundColor: Theme.of(context).colorScheme.surface,
      foregroundColor: Colors.white,
      // Ensure the app bar is completely opaque when collapsed
      scrolledUnderElevation: 0,
      elevation: 0,
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
        // Don't show title in the collapsed app bar to avoid duplicate title
        titlePadding: EdgeInsets.zero,
        // Center the title text
        centerTitle: true,
        // Make the title empty because we want a custom title in the AppBar
        title: const SizedBox.shrink(),
        // Prevent the title from fading in when collapsing
        collapseMode: CollapseMode.pin,
      ),
      // Set a title for the collapsed app bar
      title: Text(
        location.name,
        style: const TextStyle(color: Colors.white),
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
}
