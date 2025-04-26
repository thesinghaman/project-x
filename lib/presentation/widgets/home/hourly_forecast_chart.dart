import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sundrift/app/themes/app_theme.dart';
import 'package:sundrift/core/constants/app_constants.dart';
import 'package:sundrift/core/storage/local_storage.dart';
import 'package:sundrift/data/models/hour_forecast_model.dart';
import 'package:flutter_animate/flutter_animate.dart';

class HourlyForecastChart extends StatefulWidget {
  final List<HourForecastModel> hourlyForecasts;

  const HourlyForecastChart({
    Key? key,
    required this.hourlyForecasts,
  }) : super(key: key);

  @override
  State<HourlyForecastChart> createState() => _HourlyForecastChartState();
}

class _HourlyForecastChartState extends State<HourlyForecastChart> {
  late ScrollController _scrollController;
  int _currentHourIndex = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    // Find the current hour index
    for (int i = 0; i < widget.hourlyForecasts.length; i++) {
      if (widget.hourlyForecasts[i].isCurrentHour()) {
        _currentHourIndex = i;
        break;
      }
    }

    // Scroll to the current hour
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_currentHourIndex > 0 && _scrollController.hasClients) {
        _scrollController.animateTo(
          _calculateScrollOffset(_currentHourIndex),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // Calculate scroll offset to center current hour
  double _calculateScrollOffset(int index) {
    // Estimate width of each hour segment (adjust based on your design)
    final double hourWidth = 60.0;
    final double screenWidth = MediaQuery.of(context).size.width;

    // Calculate offset to center the current hour
    return (index * hourWidth) - (screenWidth / 2) + (hourWidth / 2);
  }

  @override
  Widget build(BuildContext context) {
    // Handle empty data case
    if (widget.hourlyForecasts.isEmpty) {
      return _buildEmptyState(context);
    }

    // Get localStorage for temperature unit preferences
    final localStorage = Get.find<LocalStorage>();
    final temperatureUnit = localStorage.getString(
      AppConstants.storageKeyTemperatureUnit,
      defaultValue: AppConstants.defaultTemperatureUnit,
    );

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // Section title outside the card, matching Daily Forecast style exactly
      Padding(
        padding: const EdgeInsets.only(bottom: AppDimensions.sm),
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
                Iconsax.chart_2,
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
                'hourly_forecast'.tr,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Will be overridden by shader
                    ),
              ),
            ),
            const Spacer(),
            // Temperature unit indicator - only if needed
          ],
        ),
      ),

      // Chart card
      Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Scrollable chart area
              Container(
                height: 180,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                ),
                child: SingleChildScrollView(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: SizedBox(
                    // Fixed width based on number of hours
                    width: widget.hourlyForecasts.length * 60.0,
                    child: Column(
                      children: [
                        // Temperature curve - main chart area
                        Expanded(
                          child: CustomPaint(
                            painter: HourlyChartCurvePainter(
                              forecasts: widget.hourlyForecasts,
                              temperatureUnit: temperatureUnit,
                              currentHourIndex: _currentHourIndex,
                              context: context,
                            ),
                            size: Size.infinite,
                          ),
                        ),

                        // Hour indicators
                        SizedBox(
                          height: 50,
                          child: Row(
                            children: List.generate(
                              widget.hourlyForecasts.length,
                              (index) => SizedBox(
                                width: 60.0,
                                child: _buildHourItem(
                                  context,
                                  widget.hourlyForecasts[index],
                                  index,
                                  temperatureUnit,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ]).animate().fadeIn(duration: const Duration(milliseconds: 300));
  }

  // Build individual hour indicator
  Widget _buildHourItem(
    BuildContext context,
    HourForecastModel forecast,
    int index,
    String temperatureUnit,
  ) {
    final bool isCurrentHour = forecast.isCurrentHour();

    // Format time
    final timeFormat = localStorage.getString(
      AppConstants.storageKeyTimeFormat,
      defaultValue: AppConstants.defaultTimeFormat,
    );

    final timeText = isCurrentHour
        ? 'Now'
        : timeFormat == AppConstants.unitTimeFormat24h
            ? forecast.getFormattedTime24h()
            : forecast.getFormattedTime12h();

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Icon(
          _getWeatherIcon(forecast.conditionCode),
          size: 18,
          color: isCurrentHour
              ? Theme.of(context).colorScheme.primary
              : _getWeatherIconColor(forecast.conditionCode),
        ),
        const SizedBox(height: 4),
        Text(
          timeText,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: isCurrentHour ? FontWeight.bold : FontWeight.normal,
                color: isCurrentHour
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // Build empty state widget
  Widget _buildEmptyState(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        boxShadow: AppShadows.small,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Iconsax.chart_fail,
              size: 40,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            ),
            const SizedBox(height: AppDimensions.sm),
            Text(
              'No hourly forecast available',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  // Get localStorage instance
  LocalStorage get localStorage => Get.find<LocalStorage>();

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

// Custom painter for the temperature curve
class HourlyChartCurvePainter extends CustomPainter {
  final List<HourForecastModel> forecasts;
  final String temperatureUnit;
  final int currentHourIndex;
  final BuildContext context;

  HourlyChartCurvePainter({
    required this.forecasts,
    required this.temperatureUnit,
    required this.currentHourIndex,
    required this.context,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (forecasts.isEmpty) return;

    final primaryColor = Theme.of(context).colorScheme.primary;
    final textColor = Theme.of(context).colorScheme.onSurface;

    final width = size.width;
    final height = size.height;

    // Calculate min and max temperature for scale
    double minTemp = double.infinity;
    double maxTemp = double.negativeInfinity;

    for (var forecast in forecasts) {
      final temp = temperatureUnit == AppConstants.unitCelsius
          ? forecast.temperature.toDouble()
          : forecast.tempF;

      if (temp < minTemp) minTemp = temp;
      if (temp > maxTemp) maxTemp = temp;
    }

    // Add padding to scale
    final paddedMin = minTemp - 2;
    final paddedMax = maxTemp + 2;
    final range = paddedMax - paddedMin;

    // Function to get Y coordinate from temperature
    double getY(double temp) {
      return height - ((temp - paddedMin) / range) * (height - 30) - 10;
    }

    // Create path for the line
    final path = Path();

    // Create path for the gradient fill
    final fillPath = Path();

    // Dots for each data point
    final dotRadius = 3.0;
    final highlightDotRadius = 5.0;
    final dotPaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill;

    final highlightDotPaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill;

    final highlightDotStrokePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Line styling
    final linePaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Gradient fill styling
    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          primaryColor.withOpacity(0.2),
          primaryColor.withOpacity(0.05),
          primaryColor.withOpacity(0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, width, height));

    // Draw temperature values
    final textStyle = TextStyle(
      color: textColor.withOpacity(0.7),
      fontSize: 10,
    );

    // Draw horizontal grid lines (subtle)
    final gridPaint = Paint()
      ..color = textColor.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    // Draw a few horizontal grid lines for reference
    final gridLineCount = 4;
    for (int i = 0; i < gridLineCount; i++) {
      final y = (height / (gridLineCount - 1)) * i;
      canvas.drawLine(
        Offset(0, y),
        Offset(width, y),
        gridPaint,
      );
    }

    // Calculate width per hour - fixed 60 points per hour
    final hourWidth = 60.0;

    // Draw each point on the line
    for (int i = 0; i < forecasts.length; i++) {
      final forecast = forecasts[i];
      final temp = temperatureUnit == AppConstants.unitCelsius
          ? forecast.temperature.toDouble()
          : forecast.tempF;

      // Calculate X position
      final x = i * hourWidth + (hourWidth / 2);
      final y = getY(temp);

      // Move to first point or line to subsequent points
      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, height); // Start at bottom
        fillPath.lineTo(x, y); // Line up to first point
      } else {
        // Use quadratic bezier curves for smoother lines between points
        if (i > 1) {
          final prevX = (i - 1) * hourWidth + (hourWidth / 2);
          final prevY = getY(temperatureUnit == AppConstants.unitCelsius
              ? forecasts[i - 1].temperature.toDouble()
              : forecasts[i - 1].tempF);

          final controlX = (prevX + x) / 2;

          path.quadraticBezierTo(controlX, prevY, x, y);
          fillPath.quadraticBezierTo(controlX, prevY, x, y);
        } else {
          path.lineTo(x, y);
          fillPath.lineTo(x, y);
        }
      }

      // Draw temperature values
      final textSpan = TextSpan(
        text: '${temp.round()}°',
        style: textStyle.copyWith(
          fontWeight:
              i == currentHourIndex ? FontWeight.bold : FontWeight.normal,
          color: i == currentHourIndex ? primaryColor : textStyle.color,
        ),
      );

      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );

      textPainter.layout(minWidth: 0, maxWidth: width);
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, y - 20),
      );

      // Draw dots for each data point
      if (i == currentHourIndex) {
        // Draw highlighted dot for current hour
        canvas.drawCircle(Offset(x, y), highlightDotRadius, highlightDotPaint);
        canvas.drawCircle(
            Offset(x, y), highlightDotRadius, highlightDotStrokePaint);
      } else {
        // Draw regular dots
        canvas.drawCircle(Offset(x, y), dotRadius, dotPaint);
      }
    }

    // Complete the fill path
    fillPath.lineTo(width, height);
    fillPath.close();

    // Draw the gradient fill
    canvas.drawPath(fillPath, fillPaint);

    // Draw the line on top
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
