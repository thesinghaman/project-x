import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sundrift/app/themes/app_theme.dart';
import 'package:sundrift/core/constants/app_constants.dart';
import 'package:sundrift/core/storage/local_storage.dart';
import 'package:sundrift/data/models/hour_forecast_model.dart';
import 'package:sundrift/presentation/controllers/home_controller.dart';
import 'package:flutter_animate/flutter_animate.dart';

class HourlyForecastSlider extends StatelessWidget {
  final LocalStorage _localStorage = Get.find<LocalStorage>();

  HourlyForecastSlider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title
        Text(
          'hourly_forecast'.tr,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),

        const SizedBox(height: AppDimensions.sm),

        // Hourly forecast list
        SizedBox(
          height: 120,
          child: Obx(() {
            final forecast = controller.forecast.value;

            if (forecast == null || forecast.hourlyForecasts.isEmpty) {
              return _buildPlaceholderList(context);
            }

            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: forecast.hourlyForecasts.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return _buildHourlyForecastItem(
                  context,
                  forecast.hourlyForecasts[index],
                  index,
                );
              },
            );
          }),
        ),
      ],
    );
  }

  // Build hourly forecast item
  Widget _buildHourlyForecastItem(
    BuildContext context,
    HourForecastModel forecast,
    int index,
  ) {
    // Get temperature unit preference
    final temperatureUnit = _localStorage.getString(
      AppConstants.storageKeyTemperatureUnit,
      defaultValue: AppConstants.defaultTemperatureUnit,
    );

    // Get time format preference (12h or 24h)
    final timeFormat = _localStorage.getString(
      AppConstants.storageKeyTimeFormat,
      defaultValue: AppConstants.defaultTimeFormat,
    );

    // Get temperature based on unit
    final temp = temperatureUnit == AppConstants.unitCelsius
        ? forecast.temperature
        : forecast.tempF.round();

    // Get formatted time based on preference
    final time = timeFormat == AppConstants.unitTimeFormat24h
        ? forecast.getFormattedTime24h()
        : forecast.getFormattedTime12h();

    // Determine if this is the current hour
    final isCurrentHour = forecast.isCurrentHour();

    // Create the animated item
    return Animate(
      effects: [
        FadeEffect(
          duration: AppDimensions.animNormal,
          delay: Duration(milliseconds: index * 50),
        ),
        SlideEffect(
          duration: AppDimensions.animNormal,
          delay: Duration(milliseconds: index * 50),
          begin: const Offset(0, 0.5),
          end: const Offset(0, 0),
        ),
      ],
      child: Container(
        margin: const EdgeInsets.only(right: AppDimensions.sm),
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.md,
          vertical: AppDimensions.sm,
        ),
        decoration: BoxDecoration(
          color: isCurrentHour
              ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          border: Border.all(
            color: isCurrentHour
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onBackground.withOpacity(0.1),
            width: isCurrentHour ? 2 : 1,
          ),
          boxShadow: isCurrentHour ? AppShadows.small : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Time
            Text(
              isCurrentHour ? 'Now' : time,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight:
                        isCurrentHour ? FontWeight.bold : FontWeight.normal,
                    color: isCurrentHour
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onBackground,
                  ),
            ),

            const SizedBox(height: AppDimensions.xs),

            // Weather icon
            Image.asset(
              forecast.getWeatherIcon(),
              width: 32,
              height: 32,
            ),

            const SizedBox(height: AppDimensions.xs),

            // Temperature
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$temp°',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isCurrentHour
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onBackground,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Build placeholder list while loading
  Widget _buildPlaceholderList(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 6,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return Container(
          width: 70,
          margin: const EdgeInsets.only(right: AppDimensions.sm),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            border: Border.all(
              color:
                  Theme.of(context).colorScheme.onBackground.withOpacity(0.1),
            ),
          ),
          child: Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        );
      },
    );
  }
}
