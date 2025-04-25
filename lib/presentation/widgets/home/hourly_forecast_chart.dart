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
  // Animation controller
  late AnimationController _animationController;
  late Animation<double> _animation;

  // For touch interaction
  int? _touchedIndex;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
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
    // Check for empty data early and return a placeholder
    if (widget.hourlyForecasts.isEmpty) {
      return _buildEmptyState(context);
    }

    final LocalStorage localStorage = Get.find<LocalStorage>();

    // Get temperature unit preference
    final temperatureUnit = localStorage.getString(
      AppConstants.storageKeyTemperatureUnit,
      defaultValue: AppConstants.defaultTemperatureUnit,
    );

    return Card(
      elevation: 4,
      shadowColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      ),
      child: Container(
        height: 250, // Fixed height to avoid layout issues
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.surface,
              Theme.of(context).colorScheme.surface.withOpacity(0.9),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and info row
            Padding(
              padding: const EdgeInsets.all(AppDimensions.md),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Title with icon
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Iconsax.clock,
                          size: 18,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'hourly_forecast'.tr,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                      ),
                    ],
                  ),

                  // Temperature unit display
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      temperatureUnit == AppConstants.unitCelsius ? '°C' : '°F',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                  ),
                ],
              ),
            ),

            // Main content
            Expanded(
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return _buildChartWithData(context, temperatureUnit);
                },
              ),
            ),
          ],
        ),
      ),
    ).animate().fade(
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeOutQuad,
        );
  }

  // Build empty state
  Widget _buildEmptyState(BuildContext context) {
    return SizedBox(
      height: 250,
      child: Card(
        elevation: 4,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Iconsax.chart_fail,
                size: 48,
                color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
              ),
              const SizedBox(height: AppDimensions.sm),
              Text(
                'No hourly data available',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onBackground
                          .withOpacity(0.7),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Build the main chart with interactive data display
  Widget _buildChartWithData(BuildContext context, String temperatureUnit) {
    if (widget.hourlyForecasts.isEmpty) {
      return _buildEmptyState(context);
    }

    // Find min/max temperature for chart scaling
    double minTemp = double.infinity;
    double maxTemp = double.negativeInfinity;

    for (var hourData in widget.hourlyForecasts) {
      final temp = temperatureUnit == AppConstants.unitCelsius
          ? hourData.temperature.toDouble()
          : hourData.tempF;

      if (temp < minTemp) minTemp = temp;
      if (temp > maxTemp) maxTemp = temp;
    }

    // Add padding to min/max
    minTemp = minTemp - 2;
    maxTemp = maxTemp + 2;

    return Stack(
      children: [
        // Temperature curve chart
        Positioned.fill(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 10,
              right: 10,
              bottom: 40,
              left: 10,
            ),
            child: _buildTempChart(context, temperatureUnit, minTemp, maxTemp),
          ),
        ),

        // Hours and weather icons row at bottom
        Positioned(
          left: 0,
          right: 0,
          bottom: 4,
          child: SizedBox(
            height: 40,
            child: _buildTimeIconsRow(context),
          ),
        ),

        // Vertical indicator line for touched position
        if (_touchedIndex != null &&
            _touchedIndex! < widget.hourlyForecasts.length)
          Positioned(
            top: 10,
            bottom: 40,
            left: 10 +
                (_touchedIndex! *
                    ((MediaQuery.of(context).size.width - 20) /
                        widget.hourlyForecasts.length)),
            child: Container(
              width: 1,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
            ),
          ),

        // Highlighted data for touched hour
        if (_touchedIndex != null &&
            _touchedIndex! < widget.hourlyForecasts.length)
          Positioned(
            top: 10,
            left: 0,
            right: 0,
            child: _buildHighlightedTemperature(context, temperatureUnit),
          ),
      ],
    );
  }

  // Build the temperature curve chart
  Widget _buildTempChart(BuildContext context, String temperatureUnit,
      double minTemp, double maxTemp) {
    // Safety check for empty data
    if (widget.hourlyForecasts.isEmpty) {
      return Container();
    }

    List<FlSpot> spots = [];

    // Create spots from forecast data
    for (int i = 0; i < widget.hourlyForecasts.length; i++) {
      final hour = widget.hourlyForecasts[i];
      final temp = temperatureUnit == AppConstants.unitCelsius
          ? hour.temperature.toDouble()
          : hour.tempF;

      spots.add(FlSpot(i.toDouble(), temp));
    }

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: (widget.hourlyForecasts.length - 1).toDouble(),
        minY: minTemp,
        maxY: maxTemp,
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            // tooltipBgColor: Colors.transparent,
            tooltipPadding: EdgeInsets.zero,
            tooltipMargin: 0,
            getTooltipItems: (_) => [],
          ),
          touchCallback:
              (FlTouchEvent event, LineTouchResponse? touchResponse) {
            setState(() {
              if (event is FlPanEndEvent ||
                  event is FlTapUpEvent ||
                  event is FlLongPressEnd) {
                _touchedIndex = null;
              } else if (touchResponse?.lineBarSpots != null &&
                  touchResponse!.lineBarSpots!.isNotEmpty) {
                _touchedIndex = touchResponse.lineBarSpots![0].x.toInt();
              }
            });
          },
        ),
        lineBarsData: [
          LineChartBarData(
            spots: spots
                .map((spot) => FlSpot(
                      spot.x,
                      minTemp + (spot.y - minTemp) * _animation.value,
                    ))
                .toList(),
            isCurved: true,
            curveSmoothness: 0.3,
            preventCurveOverShooting: true,
            color: Theme.of(context).colorScheme.primary,
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                if (_touchedIndex == index) {
                  return FlDotCirclePainter(
                    radius: 6,
                    color: Theme.of(context).colorScheme.primary,
                    strokeWidth: 2,
                    strokeColor: Colors.white,
                  );
                }
                return FlDotCirclePainter(
                  radius: 3.5,
                  color: Theme.of(context).colorScheme.primary,
                  strokeWidth: 1,
                  strokeColor: Colors.white,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Theme.of(context).colorScheme.primary.withOpacity(0.3),
                  Theme.of(context).colorScheme.primary.withOpacity(0.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Build time and icons row at bottom
  Widget _buildTimeIconsRow(BuildContext context) {
    // Safety check
    if (widget.hourlyForecasts.isEmpty) {
      return Container();
    }

    final double itemWidth =
        MediaQuery.of(context).size.width / widget.hourlyForecasts.length;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(widget.hourlyForecasts.length, (index) {
        final hour = widget.hourlyForecasts[index];
        final isCurrentHour = hour.isCurrentHour();
        final isHighlighted = index == _touchedIndex;

        // Get time to display
        final displayTime = isCurrentHour
            ? 'Now'
            : hour.dateTime.hour.toString().padLeft(2, '0');

        return SizedBox(
          width: itemWidth,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Weather icon
              Container(
                decoration: isHighlighted
                    ? BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.1),
                        shape: BoxShape.circle,
                      )
                    : null,
                padding: const EdgeInsets.all(2),
                child: Icon(
                  _getWeatherIcon(hour.conditionCode),
                  size: 16,
                  color: isHighlighted || isCurrentHour
                      ? Theme.of(context).colorScheme.primary
                      : _getWeatherIconColor(hour.conditionCode),
                ),
              ),
              const SizedBox(height: 4),
              // Time label
              Text(
                displayTime,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: isHighlighted || isCurrentHour
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onBackground,
                      fontWeight: isHighlighted || isCurrentHour
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }),
    );
  }

  // Build highlighted temperature/data display when a point is touched
  Widget _buildHighlightedTemperature(
      BuildContext context, String temperatureUnit) {
    if (_touchedIndex == null ||
        _touchedIndex! >= widget.hourlyForecasts.length) {
      return const SizedBox.shrink();
    }

    final hour = widget.hourlyForecasts[_touchedIndex!];
    final temp = temperatureUnit == AppConstants.unitCelsius
        ? hour.temperature
        : hour.tempF.round();

    final itemWidth =
        MediaQuery.of(context).size.width / widget.hourlyForecasts.length;
    final xPosition = 10 + (_touchedIndex! * itemWidth) + (itemWidth / 2);

    return Positioned(
      top: 10,
      left: xPosition - 40, // Center the tooltip
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Temperature
            Text.rich(
              TextSpan(
                text: '$temp°',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                children: [
                  TextSpan(
                    text:
                        temperatureUnit == AppConstants.unitCelsius ? 'C' : 'F',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                ],
              ),
            ),

            // Additional data
            if (widget.showPrecipitation &&
                (hour.chanceOfRain > 10 || hour.chanceOfSnow > 10))
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    hour.chanceOfRain > hour.chanceOfSnow
                        ? Iconsax.cloud_drizzle
                        : Iconsax.cloud_snow,
                    size: 14,
                    color: hour.chanceOfRain > hour.chanceOfSnow
                        ? Colors.blue
                        : Colors.lightBlue,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${hour.chanceOfRain > hour.chanceOfSnow ? hour.chanceOfRain.round() : hour.chanceOfSnow.round()}%',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: hour.chanceOfRain > hour.chanceOfSnow
                              ? Colors.blue
                              : Colors.lightBlue,
                        ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  // Get weather icon based on condition code
  IconData _getWeatherIcon(int conditionCode) {
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
