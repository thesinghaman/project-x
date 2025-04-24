// Complete lib/presentation/widgets/home/hourly_forecast_chart.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sundrift/app/themes/app_theme.dart';
import 'package:sundrift/core/constants/app_constants.dart';
import 'package:sundrift/core/storage/local_storage.dart';
import 'package:sundrift/data/models/hour_forecast_model.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fl_chart/fl_chart.dart';

class HourlyForecastChart extends StatelessWidget {
  final List<HourForecastModel> hourlyForecasts;
  final bool showPrecipitation;

  const HourlyForecastChart({
    Key? key,
    required this.hourlyForecasts,
    this.showPrecipitation = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LocalStorage localStorage = Get.find<LocalStorage>();

    // Get temperature unit preference
    final temperatureUnit = localStorage.getString(
      AppConstants.storageKeyTemperatureUnit,
      defaultValue: AppConstants.defaultTemperatureUnit,
    );

    // Get time format preference
    final timeFormat = localStorage.getString(
      AppConstants.storageKeyTimeFormat,
      defaultValue: AppConstants.defaultTimeFormat,
    );

    // Return an animated chart card
    return Animate(
      effects: [
        FadeEffect(duration: AppDimensions.animNormal),
        SlideEffect(
          duration: AppDimensions.animNormal,
          begin: const Offset(0, 0.1),
          end: const Offset(0, 0),
        ),
      ],
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                'hourly_forecast'.tr,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),

              const SizedBox(height: AppDimensions.md),

              // Chart
              SizedBox(
                height: 200,
                child: _buildChart(context, temperatureUnit, timeFormat),
              ),

              // Legend
              Padding(
                padding: const EdgeInsets.only(top: AppDimensions.md),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildLegendItem(
                      context,
                      'Temperature',
                      Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: AppDimensions.md),
                    if (showPrecipitation)
                      _buildLegendItem(
                        context,
                        'precipitation'.tr,
                        Colors.blue.shade400,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChart(
      BuildContext context, String temperatureUnit, String timeFormat) {
    // Return placeholder or loading indicator if no data
    if (hourlyForecasts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Iconsax.chart_1,
              size: 32,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
            ),
            const SizedBox(height: AppDimensions.sm),
            Text(
              'loading'.tr,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      );
    }

    // Prepare data for the chart
    double minY = double.infinity;
    double maxY = double.negativeInfinity;
    List<FlSpot> temperatureSpots = [];
    List<FlSpot> precipitationSpots = [];

    // Find min/max temperature
    for (int i = 0; i < hourlyForecasts.length; i++) {
      final forecast = hourlyForecasts[i];
      final double temp = temperatureUnit == AppConstants.unitCelsius
          ? forecast.temperature.toDouble()
          : forecast.tempF;

      if (temp < minY) minY = temp;
      if (temp > maxY) maxY = temp;
    }

    // Calculate base line for precipitation (at the bottom of the chart)
    final tempRange = maxY - minY;
    final precipBase = minY - (tempRange * 0.1); // Slightly below the min temp

    // Find max precipitation for scaling
    double maxPrecip = 0.0;
    for (var forecast in hourlyForecasts) {
      if (forecast.precipitation > maxPrecip) {
        maxPrecip = forecast.precipitation;
      }
    }

    // Calculate precipitation scaling factor
    // We want max precipitation to reach about 15% of the chart height
    final double precipScale =
        maxPrecip > 0 ? (tempRange * 0.15) / maxPrecip : 1.0;

    // Process hourly forecasts
    for (int i = 0; i < hourlyForecasts.length; i++) {
      final forecast = hourlyForecasts[i];

      // Temperature spot
      final double temp = temperatureUnit == AppConstants.unitCelsius
          ? forecast.temperature.toDouble()
          : forecast.tempF;
      temperatureSpots.add(FlSpot(i.toDouble(), temp));

      // Precipitation spot (if showing)
      if (showPrecipitation) {
        final double scaledPrecip =
            precipBase + (forecast.precipitation * precipScale);
        precipitationSpots.add(FlSpot(i.toDouble(), scaledPrecip));
      }
    }

    // Adjust min/max to add padding
    minY =
        minY - (tempRange * 0.15); // More padding at bottom for precipitation
    maxY = maxY + (tempRange * 0.1); // Some padding at top

    // Create the LineChartData
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 5,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Theme.of(context).dividerColor.withOpacity(0.2),
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                // Show time for every 3 hours to avoid crowding
                if (value.toInt() % 3 != 0 && value != 0) {
                  return const SizedBox.shrink();
                }

                if (value.toInt() >= hourlyForecasts.length) {
                  return const SizedBox.shrink();
                }

                final forecast = hourlyForecasts[value.toInt()];
                final time = timeFormat == AppConstants.unitTimeFormat24h
                    ? forecast.getFormattedTime24h()
                    : forecast.getFormattedTime12h();

                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    time,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                );
              },
            ),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                // Only show titles for temperature values, not precipitation
                if (value < precipBase + (tempRange * 0.05)) {
                  return const SizedBox.shrink();
                }

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Text(
                    value.toInt().toString(),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: (hourlyForecasts.length - 1).toDouble(),
        minY: minY,
        maxY: maxY,
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            tooltipRoundedRadius: 8,
            tooltipPadding: const EdgeInsets.all(8),
            tooltipBorder: BorderSide(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
            ),
            getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
              return touchedBarSpots.map((barSpot) {
                if (barSpot.barIndex == 0) {
                  // Temperature line
                  final index = barSpot.x.toInt();
                  if (index >= hourlyForecasts.length) return null;

                  final forecast = hourlyForecasts[index];

                  return LineTooltipItem(
                    '${barSpot.y.toInt()}°',
                    TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                    children: [
                      TextSpan(
                        text: '\n${forecast.conditionText}',
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodySmall?.color,
                          fontWeight: FontWeight.normal,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  );
                } else {
                  // Precipitation line
                  final index = barSpot.x.toInt();
                  if (index >= hourlyForecasts.length) return null;

                  final forecast = hourlyForecasts[index];
                  if (forecast.precipitation <= 0) return null;

                  return LineTooltipItem(
                    '${forecast.precipitation.toStringAsFixed(1)} mm',
                    TextStyle(
                      color: Colors.blue.shade400,
                      fontWeight: FontWeight.normal,
                      fontSize: 12,
                    ),
                  );
                }
              }).toList();
            },
          ),
        ),
        lineBarsData: [
          // Temperature line
          LineChartBarData(
            spots: temperatureSpots,
            isCurved: true,
            color: Theme.of(context).colorScheme.primary,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 2,
                  color: Theme.of(context).colorScheme.primary,
                  strokeWidth: 1,
                  strokeColor: Colors.white,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            ),
          ),

          // Precipitation line
          if (showPrecipitation)
            LineChartBarData(
              spots: precipitationSpots,
              isCurved: true,
              color: Colors.blue.shade400,
              barWidth: 1,
              isStrokeCapRound: true,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: Colors.blue.withOpacity(0.05),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(BuildContext context, String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
