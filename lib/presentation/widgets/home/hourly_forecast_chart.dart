import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sundrift/app/themes/app_theme.dart';
import 'package:sundrift/core/constants/app_constants.dart';
import 'package:sundrift/core/storage/local_storage.dart';
import 'package:sundrift/data/models/hour_forecast_model.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fl_chart/fl_chart.dart';

class HourlyForecastChart extends StatefulWidget {
  final List<HourForecastModel> hourlyForecasts;
  final bool showPrecipitation;

  const HourlyForecastChart({
    Key? key,
    required this.hourlyForecasts,
    this.showPrecipitation = true,
  }) : super(key: key);

  @override
  State<HourlyForecastChart> createState() => _HourlyForecastChartState();
}

class _HourlyForecastChartState extends State<HourlyForecastChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  // Touch position for tooltip
  int? touchedIndex;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutCubic,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

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
    return Card(
      elevation: 4,
      shadowColor: Theme.of(context).colorScheme.primary.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      ),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).colorScheme.surface,
                  Theme.of(context).colorScheme.surface.withBlue(
                        (Theme.of(context).colorScheme.surface.blue + 15)
                            .clamp(0, 255),
                      ),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color:
                      Theme.of(context).colorScheme.primary.withOpacity(0.05),
                  blurRadius: 10,
                  spreadRadius: 0,
                ),
              ],
            ),
            padding: const EdgeInsets.all(AppDimensions.md),
            child: child,
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title with animated icon
            Row(
              children: [
                Icon(
                  Iconsax.clock,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                )
                    .animate(
                      onPlay: (controller) => controller.repeat(),
                    )
                    .rotate(
                      duration: const Duration(seconds: 10),
                      curve: Curves.linear,
                    ),
                const SizedBox(width: AppDimensions.sm),
                Text(
                  'hourly_forecast'.tr,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ],
            ),

            // Divider
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppDimensions.sm),
              child: Divider(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                thickness: 1,
              ),
            ),

            // Chart
            SizedBox(
              height: 220,
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
                  if (widget.showPrecipitation)
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
    )
        .animate()
        .fadeIn(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        )
        .slideY(
          begin: 0.2,
          end: 0,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeOutQuad,
        );
  }

  Widget _buildChart(
      BuildContext context, String temperatureUnit, String timeFormat) {
    // Return placeholder or loading indicator if no data
    if (widget.hourlyForecasts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Iconsax.chart_1,
              size: 32,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
            ).animate().scale(
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.elasticOut,
                ),
            const SizedBox(height: AppDimensions.sm),
            Text(
              'loading'.tr,
              style: Theme.of(context).textTheme.bodyMedium,
            ).animate().fadeIn(
                  duration: const Duration(milliseconds: 400),
                  delay: const Duration(milliseconds: 300),
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
    for (int i = 0; i < widget.hourlyForecasts.length; i++) {
      final forecast = widget.hourlyForecasts[i];
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
    for (var forecast in widget.hourlyForecasts) {
      if (forecast.precipitation > maxPrecip) {
        maxPrecip = forecast.precipitation;
      }
    }

    // Calculate precipitation scaling factor
    // We want max precipitation to reach about 15% of the chart height
    final double precipScale =
        maxPrecip > 0 ? (tempRange * 0.15) / maxPrecip : 1.0;

    // Process hourly forecasts
    for (int i = 0; i < widget.hourlyForecasts.length; i++) {
      final forecast = widget.hourlyForecasts[i];

      // Temperature spot
      final double temp = temperatureUnit == AppConstants.unitCelsius
          ? forecast.temperature.toDouble()
          : forecast.tempF;
      temperatureSpots.add(FlSpot(i.toDouble(), temp));

      // Precipitation spot (if showing)
      if (widget.showPrecipitation) {
        final double scaledPrecip =
            precipBase + (forecast.precipitation * precipScale);
        precipitationSpots.add(FlSpot(i.toDouble(), scaledPrecip));
      }
    }

    // Adjust min/max to add padding
    minY =
        minY - (tempRange * 0.15); // More padding at bottom for precipitation
    maxY = maxY + (tempRange * 0.1); // Some padding at top

    // Create animated line
    final animatedTemperatureSpots = List.generate(
      temperatureSpots.length,
      (index) => FlSpot(
        temperatureSpots[index].x,
        minY + (temperatureSpots[index].y - minY) * _animation.value,
      ),
    );

    // Create the LineChartData
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 5,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Theme.of(context).dividerColor.withOpacity(0.1),
              strokeWidth: 1,
              dashArray: [5, 5],
            );
          },
        ),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                // Show time for every 2 hours to avoid crowding
                if (value.toInt() % 2 != 0 && value != 0) {
                  return const SizedBox.shrink();
                }

                if (value.toInt() >= widget.hourlyForecasts.length) {
                  return const SizedBox.shrink();
                }

                final forecast = widget.hourlyForecasts[value.toInt()];
                final time = timeFormat == AppConstants.unitTimeFormat24h
                    ? forecast.getFormattedTime24h()
                    : forecast.getFormattedTime12h();

                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getIconForConditionCode(forecast.conditionCode),
                        size: 16,
                        color:
                            _getColorForConditionCode(forecast.conditionCode),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        time,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontWeight: forecast.isCurrentHour()
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: forecast.isCurrentHour()
                                  ? Theme.of(context).colorScheme.primary
                                  : null,
                            ),
                      ),
                    ],
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
              reservedSize: 35,
              getTitlesWidget: (value, meta) {
                // Only show titles for temperature values, not precipitation
                if (value < precipBase + (tempRange * 0.05)) {
                  return const SizedBox.shrink();
                }

                return Container(
                  padding: const EdgeInsets.only(right: 8),
                  decoration: value == touchedIndex
                      ? BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        )
                      : null,
                  child: Text(
                    value.toInt().toString() + '°',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight:
                              value == touchedIndex ? FontWeight.bold : null,
                          color: value == touchedIndex
                              ? Theme.of(context).colorScheme.primary
                              : null,
                        ),
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: (widget.hourlyForecasts.length - 1).toDouble(),
        minY: minY,
        maxY: maxY,
        lineTouchData: LineTouchData(
          enabled: true,
          touchCallback: (FlTouchEvent event, LineTouchResponse? response) {
            if (response == null || response.lineBarSpots == null) {
              setState(() {
                touchedIndex = null;
              });
              return;
            }
            if (event is FlTapUpEvent) {
              final spot = response.lineBarSpots![0];
              setState(() {
                touchedIndex = spot.y.toInt();
              });
            }
          },
          touchTooltipData: LineTouchTooltipData(
            tooltipRoundedRadius: 8,
            tooltipPadding: const EdgeInsets.all(8),
            // tooltipBgColor: Theme.of(context).colorScheme.surface,
            tooltipBorder: BorderSide(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
            ),
            tooltipMargin: 8,
            getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
              return touchedBarSpots.map((barSpot) {
                if (barSpot.barIndex == 0) {
                  // Temperature line
                  final index = barSpot.x.toInt();
                  if (index >= widget.hourlyForecasts.length) return null;

                  final forecast = widget.hourlyForecasts[index];

                  return LineTooltipItem(
                    '${barSpot.y.toInt()}°',
                    TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
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
                      if (forecast.chanceOfRain > 0)
                        TextSpan(
                          text: '\n💧 ${forecast.chanceOfRain.round()}%',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.normal,
                            fontSize: 12,
                          ),
                        ),
                    ],
                  );
                } else {
                  // Precipitation line
                  final index = barSpot.x.toInt();
                  if (index >= widget.hourlyForecasts.length) return null;

                  final forecast = widget.hourlyForecasts[index];
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
            spots: animatedTemperatureSpots,
            isCurved: true,
            curveSmoothness: 0.3,
            color: Theme.of(context).colorScheme.primary,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                Color dotColor = Theme.of(context).colorScheme.primary;
                double radius = 3;

                // Check if this is the current hour
                final isCurrentHour = index < widget.hourlyForecasts.length &&
                    widget.hourlyForecasts[index].isCurrentHour();

                if (isCurrentHour) {
                  radius = 5;
                  dotColor = Theme.of(context).colorScheme.secondary;
                }

                return FlDotCirclePainter(
                  radius: radius,
                  color: dotColor,
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary.withOpacity(0.3),
                  Theme.of(context).colorScheme.primary.withOpacity(0.0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            shadow: const Shadow(
              blurRadius: 8,
              color: Colors.black12,
              offset: Offset(0, 3),
            ),
          ),

          // Precipitation line
          if (widget.showPrecipitation)
            LineChartBarData(
              spots: precipitationSpots,
              isCurved: true,
              curveSmoothness: 0.3,
              color: Colors.blue.shade400,
              barWidth: 1,
              isStrokeCapRound: true,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    Colors.blue.withOpacity(0.1),
                    Colors.blue.withOpacity(0.0),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
        ],
      ),
    );
  }

  IconData _getIconForConditionCode(int conditionCode) {
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

  Color _getColorForConditionCode(int conditionCode) {
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

  Widget _buildLegendItem(BuildContext context, String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.5),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.normal,
              ),
        ),
      ],
    );
  }
}
