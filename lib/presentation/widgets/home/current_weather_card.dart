import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sundrift/app/themes/app_theme.dart';
import 'package:sundrift/core/constants/app_constants.dart';
import 'package:sundrift/core/storage/local_storage.dart';
import 'package:sundrift/presentation/controllers/home_controller.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CurrentWeatherCard extends StatelessWidget {
  final LocalStorage _localStorage = Get.find<LocalStorage>();

  CurrentWeatherCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    // Get temperature unit preference
    final temperatureUnit = _localStorage.getString(
      AppConstants.storageKeyTemperatureUnit,
      defaultValue: AppConstants.defaultTemperatureUnit,
    );

    // Weather card background
    return Obx(() {
      final currentWeather = controller.currentWeather.value;

      if (currentWeather == null) {
        return _buildPlaceholderCard(context);
      }

      // Get temperature based on unit
      final temp = temperatureUnit == AppConstants.unitCelsius
          ? currentWeather.temperature
          : currentWeather.tempF?.round() ??
              (currentWeather.temperature * 9 / 5 + 32).round();

      final feelsLike = temperatureUnit == AppConstants.unitCelsius
          ? currentWeather.feelsLike
          : (currentWeather.feelsLike * 9 / 5 + 32).round();

      // Temperature unit symbol
      final unitSymbol =
          temperatureUnit == AppConstants.unitCelsius ? '°C' : '°F';

      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: AppGradients.sunnyGradient,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          boxShadow: AppShadows.medium,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          child: Stack(
            children: [
              // Weather animation as background
              Positioned.fill(
                child: Opacity(
                  opacity: 0.5,
                  child: Lottie.asset(
                    currentWeather.getWeatherAnimation(),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // Content
              Padding(
                padding: const EdgeInsets.all(AppDimensions.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Weather condition
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            currentWeather.conditionText,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        Lottie.asset(
                          currentWeather.getWeatherAnimation(),
                          width: 60,
                          height: 60,
                        ),
                      ],
                    ),

                    const SizedBox(height: AppDimensions.md),

                    // Temperature
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$temp',
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge
                              ?.copyWith(
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
                      '${'feels_like'.tr}: $feelsLike$unitSymbol',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withOpacity(0.9),
                          ),
                    ),

                    const SizedBox(height: AppDimensions.lg),

                    // Weather details
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildWeatherDetailItem(
                          context,
                          Iconsax.drop3,
                          '${'humidity'.tr}',
                          '${currentWeather.humidity}%',
                        ),
                        _buildWeatherDetailItem(
                          context,
                          Iconsax.wind,
                          '${'wind'.tr}',
                          '${currentWeather.windSpeed.round()} km/h',
                        ),
                        _buildWeatherDetailItem(
                          context,
                          Iconsax.eye,
                          '${'uv_index'.tr}',
                          '${currentWeather.uv}',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ).animate().fade(duration: AppDimensions.animNormal);
    });
  }

  // Build weather detail item
  Widget _buildWeatherDetailItem(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Column(
      children: [
        Icon(
          icon,
          color: Colors.white,
          size: 20,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white.withOpacity(0.8),
              ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }

  // Build placeholder card while loading
  Widget _buildPlaceholderCard(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 220,
      decoration: BoxDecoration(
        gradient: AppGradients.sunnyGradient,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        boxShadow: AppShadows.medium,
      ),
      child: Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      ),
    );
  }
}
