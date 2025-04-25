import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sundrift/app/themes/app_theme.dart';
import 'package:sundrift/core/constants/app_constants.dart';
import 'package:sundrift/core/storage/local_storage.dart';
import 'package:sundrift/data/models/day_forecast_model.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ui';

class DailyForecastWidget extends StatefulWidget {
  final List<DayForecastModel> dailyForecasts;

  const DailyForecastWidget({
    Key? key,
    required this.dailyForecasts,
  }) : super(key: key);

  @override
  State<DailyForecastWidget> createState() => _DailyForecastWidgetState();
}

class _DailyForecastWidgetState extends State<DailyForecastWidget>
    with SingleTickerProviderStateMixin {
  // Animation controller for chart
  late AnimationController _animationController;
  late Animation<double> _animation;
  int? _hoveredIndex;

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title with icon and shimmer effect
        Container(
          margin: const EdgeInsets.symmetric(vertical: AppDimensions.sm),
          child: Row(
            children: [
              ShaderMask(
                shaderCallback: (bounds) {
                  return LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.secondary,
                      Theme.of(context).colorScheme.primary,
                    ],
                    stops: const [0.0, 0.5, 1.0],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    tileMode: TileMode.mirror,
                  ).createShader(bounds);
                },
                child: Icon(
                  Iconsax.calendar,
                  color: Colors.white,
                  size: 24,
                )
                    .animate(
                      onPlay: (controller) => controller.repeat(reverse: true),
                    )
                    .scale(
                      duration: const Duration(seconds: 2),
                      begin: const Offset(1, 1),
                      end: const Offset(1.1, 1.1),
                      curve: Curves.easeInOut,
                    ),
              ),
              const SizedBox(width: AppDimensions.sm),
              ShaderMask(
                shaderCallback: (bounds) {
                  return LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.secondary,
                      Theme.of(context).colorScheme.primary,
                    ],
                    stops: const [0.0, 0.5, 1.0],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    tileMode: TileMode.mirror,
                  ).createShader(bounds);
                },
                child: Text(
                  'daily_forecast'.tr,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // Will be overridden by shader
                      ),
                ),
              ),
            ],
          ),
        ),

        // Visual temperature chart for 7 days
        Container(
          height: 160,
          margin: const EdgeInsets.only(bottom: AppDimensions.md),
          child: _buildTemperatureChart(context),
        ),

        // Daily forecast cards
        Column(
          children: List.generate(
            widget.dailyForecasts.length,
            (index) {
              final day = widget.dailyForecasts[index];
              final isToday = day.isToday();

              // Create delay for staggered animation
              final delay = Duration(milliseconds: 100 * index);

              return Padding(
                padding: const EdgeInsets.only(bottom: AppDimensions.sm),
                child: _buildForecastCard(context, day, isToday, index, delay),
              );
            },
          ),
        ),
      ],
    ).animate().fadeIn(
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeOutQuad,
        );
  }

  // Build temperature chart
  Widget _buildTemperatureChart(BuildContext context) {
    final LocalStorage localStorage = Get.find<LocalStorage>();
    final temperatureUnit = localStorage.getString(
      AppConstants.storageKeyTemperatureUnit,
      defaultValue: AppConstants.defaultTemperatureUnit,
    );

    // Find min/max temperatures
    double minTemp = double.infinity;
    double maxTemp = double.negativeInfinity;

    for (var day in widget.dailyForecasts) {
      final dayMin = temperatureUnit == AppConstants.unitCelsius
          ? day.minTemp.toDouble()
          : day.minTempF;
      final dayMax = temperatureUnit == AppConstants.unitCelsius
          ? day.maxTemp.toDouble()
          : day.maxTempF;

      if (dayMin < minTemp) minTemp = dayMin;
      if (dayMax > maxTemp) maxTemp = dayMax;
    }

    // Add padding to range
    minTemp = minTemp - 2;
    maxTemp = maxTemp + 2;
    final range = maxTemp - minTemp;

    return Card(
      elevation: 8,
      shadowColor: Theme.of(context).colorScheme.primary.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).colorScheme.surface.withOpacity(0.85),
                  Theme.of(context).colorScheme.surface.withOpacity(0.95),
                ],
              ),
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              border: Border.all(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                width: 1,
              ),
            ),
            padding: const EdgeInsets.all(AppDimensions.md),
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return CustomPaint(
                  painter: _TemperatureChartPainter(
                    days: widget.dailyForecasts,
                    minTemp: minTemp,
                    maxTemp: maxTemp,
                    temperatureUnit: temperatureUnit,
                    progress: _animation.value,
                    primaryColor: Theme.of(context).colorScheme.primary,
                    secondaryColor: Theme.of(context).colorScheme.secondary,
                    textColor: Theme.of(context).colorScheme.onSurface,
                    gridColor: Theme.of(context).dividerColor.withOpacity(0.3),
                    hoveredIndex: _hoveredIndex,
                  ),
                  child: MouseRegion(
                    onHover: (event) {
                      final RenderBox box =
                          context.findRenderObject() as RenderBox;
                      final position = box.globalToLocal(event.position);
                      final width = box.size.width;

                      // Calculate day index
                      final dayWidth = width / widget.dailyForecasts.length;
                      int index = (position.dx / dayWidth).floor();

                      if (index >= 0 && index < widget.dailyForecasts.length) {
                        if (_hoveredIndex != index) {
                          setState(() {
                            _hoveredIndex = index;
                          });
                        }
                      }
                    },
                    onExit: (event) {
                      setState(() {
                        _hoveredIndex = null;
                      });
                    },
                    child: GestureDetector(
                      onTapUp: (details) {
                        final RenderBox box =
                            context.findRenderObject() as RenderBox;
                        final position =
                            box.globalToLocal(details.globalPosition);
                        final width = box.size.width;

                        // Calculate day index
                        final dayWidth = width / widget.dailyForecasts.length;
                        int index = (position.dx / dayWidth).floor();

                        if (index >= 0 &&
                            index < widget.dailyForecasts.length) {
                          _showDayDetailsBottomSheet(
                              context, widget.dailyForecasts[index]);
                        }
                      },
                      child: Container(
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  // Build forecast card for each day
  Widget _buildForecastCard(
    BuildContext context,
    DayForecastModel day,
    bool isToday,
    int index,
    Duration delay,
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

    // Calculate temp percentage for progress indicator
    double highest = -double.infinity;
    double lowest = double.infinity;

    for (var forecast in widget.dailyForecasts) {
      double max = temperatureUnit == AppConstants.unitCelsius
          ? forecast.maxTemp.toDouble()
          : forecast.maxTempF;
      double min = temperatureUnit == AppConstants.unitCelsius
          ? forecast.minTemp.toDouble()
          : forecast.minTempF;

      if (max > highest) highest = max;
      if (min < lowest) lowest = min;
    }

    final range = highest - lowest;
    final lowPercent = range > 0 ? (minTemp - lowest) / range : 0.3;
    final highPercent = range > 0 ? (maxTemp - lowest) / range : 0.7;

    return Card(
      elevation: isToday ? 8 : 4,
      shadowColor: Theme.of(context)
          .colorScheme
          .primary
          .withOpacity(isToday ? 0.3 : 0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      ),
      child: InkWell(
        onTap: () => _showDayDetailsBottomSheet(context, day),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        splashColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        highlightColor: Theme.of(context).colorScheme.primary.withOpacity(0.05),
        child: Ink(
          decoration: BoxDecoration(
            gradient: isToday
                ? LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      Theme.of(context).colorScheme.surface,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            border: isToday
                ? Border.all(
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.5),
                    width: 1,
                  )
                : null,
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.md),
            child: Column(
              children: [
                // Top Row: Day name, date, and temperature
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Day name and date
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              if (isToday)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    'Today',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ),
                              if (isToday) const SizedBox(width: 8),
                              Text(
                                isToday ? day.getDayName() : day.getDayName(),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: isToday
                                          ? FontWeight.bold
                                          : FontWeight.w600,
                                      color: isToday
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
                                          : null,
                                    ),
                              ),
                            ],
                          ),
                          if (!isToday)
                            Text(
                              day.date,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.color
                                        ?.withOpacity(0.7),
                                  ),
                            ),
                        ],
                      ),
                    ),

                    // Temperature with high/low
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '$maxTemp°',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.red.shade700,
                              ),
                        ),
                        Text(
                          '$minTemp°',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Colors.blue.shade700,
                                  ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: AppDimensions.md),

                // Middle section with weather icon and condition
                Row(
                  children: [
                    // Weather icon in colored container
                    Container(
                      padding: const EdgeInsets.all(AppDimensions.sm),
                      decoration: BoxDecoration(
                        color: _getConditionColor(day.conditionCode)
                            .withOpacity(0.1),
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radiusMd),
                      ),
                      child: Icon(
                        _getIconForConditionCode(day.conditionCode),
                        size: 32,
                        color: _getConditionColor(day.conditionCode),
                      ),
                    ),
                    const SizedBox(width: AppDimensions.md),

                    // Weather condition text
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            day.conditionText,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),

                          // Precipitation forecast if available
                          if (day.chanceOfRain > 0 || day.chanceOfSnow > 0)
                            Row(
                              children: [
                                Icon(
                                  day.chanceOfRain > day.chanceOfSnow
                                      ? Iconsax.cloud_drizzle
                                      : Iconsax.cloud_snow,
                                  size: 14,
                                  color: day.chanceOfRain > day.chanceOfSnow
                                      ? Colors.blue
                                      : Colors.lightBlue,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${(day.chanceOfRain > day.chanceOfSnow ? day.chanceOfRain : day.chanceOfSnow).round()}%',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color:
                                            day.chanceOfRain > day.chanceOfSnow
                                                ? Colors.blue
                                                : Colors.lightBlue,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppDimensions.md),

                // Bottom section with temperature range
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '$minTemp°',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.blue.shade700,
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                        Text(
                          '$maxTemp°',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.red.shade700,
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Custom temperature range slider
                    AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(2),
                          child: Container(
                            height: 6,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              color: Colors.grey.shade200,
                            ),
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                final width = constraints.maxWidth;
                                final lowPos =
                                    lowPercent * width * _animation.value;
                                final highPos =
                                    highPercent * width * _animation.value;

                                return Stack(
                                  children: [
                                    // Cold to hot gradient
                                    Container(
                                      width: width,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.blue.shade200,
                                            Colors.blue.shade100,
                                            Colors.grey.shade100,
                                            Colors.orange.shade100,
                                            Colors.red.shade100,
                                          ],
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                        ),
                                      ),
                                    ),

                                    // Today's temperature range
                                    Positioned(
                                      left: lowPos,
                                      child: Container(
                                        width: highPos - lowPos,
                                        height: 6,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.blue.shade600,
                                              Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              Colors.red.shade600,
                                            ],
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary
                                                  .withOpacity(0.4),
                                              blurRadius: 4,
                                              offset: const Offset(0, 1),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    // Low temperature indicator
                                    Positioned(
                                      left: lowPos - 4,
                                      top: -2,
                                      child: Container(
                                        width: 10,
                                        height: 10,
                                        decoration: BoxDecoration(
                                          color: Colors.blue.shade600,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 1,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.2),
                                              blurRadius: 2,
                                              offset: const Offset(0, 1),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    // High temperature indicator
                                    Positioned(
                                      left: highPos - 4,
                                      top: -2,
                                      child: Container(
                                        width: 10,
                                        height: 10,
                                        decoration: BoxDecoration(
                                          color: Colors.red.shade600,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 1,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.2),
                                              blurRadius: 2,
                                              offset: const Offset(0, 1),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),

                    // Extra weather details row
                    const SizedBox(height: AppDimensions.sm),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildMiniInfoItem(
                          context,
                          Iconsax.wind,
                          '${day.maxWind.round()} km/h',
                          Colors.teal,
                        ),
                        _buildMiniInfoItem(
                          context,
                          Iconsax.drop,
                          '${day.avgHumidity.round()}%',
                          Colors.blue,
                        ),
                        _buildMiniInfoItem(
                          context,
                          Iconsax.sun_1,
                          'UV ${day.uv}',
                          Colors.orange,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    )
        .animate(delay: delay)
        .fadeIn(
          duration: const Duration(milliseconds: 500),
        )
        .slideY(
          begin: 0.1,
          end: 0,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOutQuad,
        );
  }

  // Build mini info item for the forecast card
  Widget _buildMiniInfoItem(
    BuildContext context,
    IconData icon,
    String value,
    Color color,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          size: 14,
          color: color.withOpacity(0.8),
        ),
        const SizedBox(width: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
      ],
    );
  }

  // Show day details bottom sheet
  void _showDayDetailsBottomSheet(BuildContext context, DayForecastModel day) {
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

    final isToday = day.isToday();

    Get.bottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppDimensions.radiusLg),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle and day title
            Center(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    isToday ? 'Today' : '${day.getDayName()}, ${day.date}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                ],
              ),
            ),

            // Divider
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.lg,
                vertical: AppDimensions.md,
              ),
              child: Divider(
                color: Theme.of(context).dividerColor,
              ),
            ),

            // Main weather display
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.lg),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Weather condition
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            _getIconForConditionCode(day.conditionCode),
                            size: 24,
                            color: _getConditionColor(day.conditionCode),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            day.conditionText,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (day.chanceOfRain > 0)
                        Row(
                          children: [
                            Icon(
                              Iconsax.cloud_drizzle,
                              size: 16,
                              color: Colors.blue,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'chance_of_rain'.tr +
                                  ': ${day.chanceOfRain.round()}%',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      if (day.chanceOfSnow > 0)
                        Row(
                          children: [
                            Icon(
                              Iconsax.cloud_snow,
                              size: 16,
                              color: Colors.lightBlue,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'chance_of_snow'.tr +
                                  ': ${day.chanceOfSnow.round()}%',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                    ],
                  ),

                  // Temperature display
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '$maxTemp°',
                        style:
                            Theme.of(context).textTheme.headlineLarge?.copyWith(
                                  color: Colors.red.shade700,
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      Text(
                        '$minTemp°',
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: Colors.blue.shade700,
                                ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Detailed stats
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.lg),
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: AppDimensions.md,
                  crossAxisSpacing: AppDimensions.md,
                  childAspectRatio: 2.0,
                  children: [
                    _buildDetailCard(
                      context,
                      Iconsax.wind,
                      'wind'.tr,
                      '${day.maxWind.round()} km/h',
                      Colors.teal,
                    ),
                    _buildDetailCard(
                      context,
                      Iconsax.drop,
                      'humidity'.tr,
                      '${day.avgHumidity.round()}%',
                      Colors.blue,
                    ),
                    _buildDetailCard(
                      context,
                      Iconsax.cloud_drizzle,
                      'precipitation'.tr,
                      '${day.totalPrecipitation} mm',
                      Colors.indigo,
                    ),
                    _buildDetailCard(
                      context,
                      Iconsax.sun_1,
                      'uv_index'.tr,
                      '${day.uv}',
                      Colors.orange,
                    ),
                    _buildDetailCard(
                      context,
                      Iconsax.eye,
                      'visibility'.tr,
                      '${day.avgVisibility} km',
                      Colors.purple,
                    ),
                    _buildDetailCard(
                      context,
                      Iconsax.cloud,
                      'cloud_cover'.tr,
                      '${day.cloudCover}%',
                      Colors.blueGrey,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build detail card for the bottom sheet
  Widget _buildDetailCard(
    BuildContext context,
    IconData icon,
    String title,
    String value,
    Color color,
  ) {
    return Card(
      elevation: 2,
      shadowColor: color.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.sm),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
              ),
              child: Icon(
                icon,
                size: 20,
                color: color,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.color
                              ?.withOpacity(0.7),
                        ),
                  ),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().scale(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutBack,
        );
  }

  // Get weather icon based on condition code
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

  // Get color for weather condition
  Color _getConditionColor(int conditionCode) {
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

// Custom painter for temperature chart
class _TemperatureChartPainter extends CustomPainter {
  final List<DayForecastModel> days;
  final double minTemp;
  final double maxTemp;
  final String temperatureUnit;
  final double progress;
  final Color primaryColor;
  final Color secondaryColor;
  final Color textColor;
  final Color gridColor;
  final int? hoveredIndex;

  _TemperatureChartPainter({
    required this.days,
    required this.minTemp,
    required this.maxTemp,
    required this.temperatureUnit,
    required this.progress,
    required this.primaryColor,
    required this.secondaryColor,
    required this.textColor,
    required this.gridColor,
    this.hoveredIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;
    final dayWidth = width / days.length;

    // Text painters
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    // Day names
    for (int i = 0; i < days.length; i++) {
      final day = days[i];
      final isToday = day.isToday();
      final isHovered = hoveredIndex == i;

      // Center point for this day
      final centerX = dayWidth * i + dayWidth / 2;

      // Draw day label
      textPainter.text = TextSpan(
        text: isToday ? 'Today' : day.getShortDayName(),
        style: TextStyle(
          fontSize: 12,
          fontWeight:
              isToday || isHovered ? FontWeight.bold : FontWeight.normal,
          color:
              isToday || isHovered ? primaryColor : textColor.withOpacity(0.7),
        ),
      );

      textPainter.layout();
      textPainter.paint(
          canvas,
          Offset(centerX - textPainter.width / 2,
              height - textPainter.height - 5));

      // Draw grid lines
      if (i > 0) {
        final paint = Paint()
          ..color = gridColor
          ..strokeWidth = 1.0
          ..style = PaintingStyle.stroke;

        final path = Path();
        path.moveTo(i * dayWidth, 0);
        path.lineTo(i * dayWidth, height - 25); // Stop above the day names

        canvas.drawPath(path, paint);
      }
    }

    // Temperature range
    final tempRange = maxTemp - minTemp;

    // Draw horizontal grid lines and temperature labels
    for (int temp = minTemp.round(); temp <= maxTemp.round(); temp += 5) {
      if (temp % 5 == 0) {
        final y = height - 30 - ((temp - minTemp) / tempRange) * (height - 50);

        final paint = Paint()
          ..color = gridColor
          ..strokeWidth = 0.5;

        canvas.drawLine(
          Offset(0, y),
          Offset(width, y),
          paint,
        );

        // Temperature label
        textPainter.text = TextSpan(
          text: '$temp°',
          style: TextStyle(
            fontSize: 10,
            color: textColor.withOpacity(0.6),
          ),
        );

        textPainter.layout();
        textPainter.paint(canvas, Offset(5, y - textPainter.height / 2));
      }
    }

    // Draw max temperature line
    final maxPoints = <Offset>[];
    final minPoints = <Offset>[];

    for (int i = 0; i < days.length; i++) {
      final day = days[i];

      // Get max and min temps
      final maxT =
          temperatureUnit == 'celsius' ? day.maxTemp.toDouble() : day.maxTempF;

      final minT =
          temperatureUnit == 'celsius' ? day.minTemp.toDouble() : day.minTempF;

      // Calculate y positions (inverted y-axis)
      final maxY = height - 30 - ((maxT - minTemp) / tempRange) * (height - 50);
      final minY = height - 30 - ((minT - minTemp) / tempRange) * (height - 50);

      // X position at center of day column
      final x = dayWidth * i + dayWidth / 2;

      // Collect points for lines
      maxPoints.add(Offset(x, maxY));
      minPoints.add(Offset(x, minY));
    }

    // Draw area between min and max
    final areaPath = Path();
    areaPath.moveTo(maxPoints.first.dx, maxPoints.first.dy);

    for (int i = 0; i < maxPoints.length; i++) {
      final point = Offset(
        maxPoints[i].dx,
        maxPoints[i].dy + (1 - progress) * (height - maxPoints[i].dy),
      );

      if (i == 0) {
        areaPath.moveTo(point.dx, point.dy);
      } else {
        // Use quadratic bezier for smoother curve
        final prevPoint = Offset(
          maxPoints[i - 1].dx,
          maxPoints[i - 1].dy + (1 - progress) * (height - maxPoints[i - 1].dy),
        );

        final controlX = (prevPoint.dx + point.dx) / 2;
        areaPath.quadraticBezierTo(
          controlX,
          prevPoint.dy,
          point.dx,
          point.dy,
        );
      }
    }

    // Continue with min temperature line in reverse
    for (int i = minPoints.length - 1; i >= 0; i--) {
      final point = Offset(
        minPoints[i].dx,
        minPoints[i].dy + (1 - progress) * (height - minPoints[i].dy),
      );

      if (i == minPoints.length - 1) {
        areaPath.lineTo(point.dx, point.dy);
      } else {
        // Use quadratic bezier for smoother curve
        final prevPoint = Offset(
          minPoints[i + 1].dx,
          minPoints[i + 1].dy + (1 - progress) * (height - minPoints[i + 1].dy),
        );

        final controlX = (prevPoint.dx + point.dx) / 2;
        areaPath.quadraticBezierTo(
          controlX,
          prevPoint.dy,
          point.dx,
          point.dy,
        );
      }
    }

    areaPath.close();

    // Fill the area with gradient
    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        primaryColor.withOpacity(0.5),
        secondaryColor.withOpacity(0.2),
      ],
    ).createShader(Rect.fromLTWH(0, 0, width, height));

    final areaPaint = Paint()
      ..shader = gradient
      ..style = PaintingStyle.fill;

    canvas.drawPath(areaPath, areaPaint);

    // Draw max temperature line
    final maxPath = Path();
    for (int i = 0; i < maxPoints.length; i++) {
      final point = Offset(
        maxPoints[i].dx,
        maxPoints[i].dy + (1 - progress) * (height - maxPoints[i].dy),
      );

      if (i == 0) {
        maxPath.moveTo(point.dx, point.dy);
      } else {
        // Use quadratic bezier for smoother curve
        final prevPoint = Offset(
          maxPoints[i - 1].dx,
          maxPoints[i - 1].dy + (1 - progress) * (height - maxPoints[i - 1].dy),
        );

        final controlX = (prevPoint.dx + point.dx) / 2;
        maxPath.quadraticBezierTo(
          controlX,
          prevPoint.dy,
          point.dx,
          point.dy,
        );
      }
    }

    final maxLinePaint = Paint()
      ..color = Colors.red.shade600
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(maxPath, maxLinePaint);

    // Draw min temperature line
    final minPath = Path();
    for (int i = 0; i < minPoints.length; i++) {
      final point = Offset(
        minPoints[i].dx,
        minPoints[i].dy + (1 - progress) * (height - minPoints[i].dy),
      );

      if (i == 0) {
        minPath.moveTo(point.dx, point.dy);
      } else {
        // Use quadratic bezier for smoother curve
        final prevPoint = Offset(
          minPoints[i - 1].dx,
          minPoints[i - 1].dy + (1 - progress) * (height - minPoints[i - 1].dy),
        );

        final controlX = (prevPoint.dx + point.dx) / 2;
        minPath.quadraticBezierTo(
          controlX,
          prevPoint.dy,
          point.dx,
          point.dy,
        );
      }
    }

    final minLinePaint = Paint()
      ..color = Colors.blue.shade600
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(minPath, minLinePaint);

    // Draw points and temperature values
    for (int i = 0; i < days.length; i++) {
      final day = days[i];
      final isToday = day.isToday();
      final isHovered = hoveredIndex == i;

      // Get temps
      final maxT =
          temperatureUnit == 'celsius' ? day.maxTemp.toDouble() : day.maxTempF;

      final minT =
          temperatureUnit == 'celsius' ? day.minTemp.toDouble() : day.minTempF;

      // Animated positions
      final maxY = height - 30 - ((maxT - minTemp) / tempRange) * (height - 50);
      final minY = height - 30 - ((minT - minTemp) / tempRange) * (height - 50);

      final maxPoint = Offset(
        dayWidth * i + dayWidth / 2,
        maxY + (1 - progress) * (height - maxY),
      );

      final minPoint = Offset(
        dayWidth * i + dayWidth / 2,
        minY + (1 - progress) * (height - minY),
      );

      // Draw max temperature point
      canvas.drawCircle(
        maxPoint,
        isToday || isHovered ? 4.0 : 3.0,
        Paint()
          ..color = Colors.red.shade600
          ..style = PaintingStyle.fill,
      );

      // Draw min temperature point
      canvas.drawCircle(
        minPoint,
        isToday || isHovered ? 4.0 : 3.0,
        Paint()
          ..color = Colors.blue.shade600
          ..style = PaintingStyle.fill,
      );

      // Draw temperature labels if hovered or today
      if (isHovered || isToday) {
        // Max temp label
        textPainter.text = TextSpan(
          text: '${maxT.round()}°',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Colors.red.shade700,
          ),
        );

        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(
            maxPoint.dx - textPainter.width / 2,
            maxPoint.dy - textPainter.height - 5,
          ),
        );

        // Min temp label
        textPainter.text = TextSpan(
          text: '${minT.round()}°',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Colors.blue.shade700,
          ),
        );

        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(
            minPoint.dx - textPainter.width / 2,
            minPoint.dy + 5,
          ),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _TemperatureChartPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.hoveredIndex != hoveredIndex;
  }
}
