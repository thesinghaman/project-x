import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sundrift/app/themes/app_theme.dart';
import 'package:sundrift/core/constants/app_constants.dart';
import 'package:sundrift/core/storage/local_storage.dart';
import 'package:sundrift/data/models/current_weather_model.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:math' as math;

class EnhancedWeatherDetails extends StatelessWidget {
  final CurrentWeatherModel currentWeather;

  const EnhancedWeatherDetails({
    Key? key,
    required this.currentWeather,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          _buildSectionTitle(context),

          const SizedBox(height: AppDimensions.md),

          // Main stats section with visual indicators
          _buildMainStatsSection(context),

          const SizedBox(height: AppDimensions.lg),

          // Wind compass visualization
          _buildWindCompassSection(context),

          const SizedBox(height: AppDimensions.lg),

          // Atmosphere section
          _buildAtmosphereSection(context),

          const SizedBox(height: AppDimensions.lg),

          // Sun & Moon section
          _buildSunMoonSection(context),
        ],
      ),
    );
  }

  // Build section title with animated gradient
  Widget _buildSectionTitle(BuildContext context) {
    return Row(
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
            Iconsax.chart_success,
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
            'weather_details'.tr,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Will be overridden by shader
                ),
          ),
        ),
      ],
    );
  }

  // Build main stats section with four visual indicators
  Widget _buildMainStatsSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.xs),
      child: Column(
        children: [
          // Temperature & Humidity row
          Row(
            children: [
              // Temperature stat with gauge
              Expanded(
                child: _buildVisualStatCard(
                  context: context,
                  title: 'temperature'.tr,
                  value: '${currentWeather.temperature}°',
                  subtitle: '${'feels_like'.tr}: ${currentWeather.feelsLike}°',
                  icon: Iconsax.warning_2,
                  iconColor: Colors.redAccent,
                  child: _buildTemperatureGauge(context),
                ),
              ),

              const SizedBox(width: AppDimensions.md),

              // Humidity stat with radial gauge
              Expanded(
                child: _buildVisualStatCard(
                  context: context,
                  title: 'humidity'.tr,
                  value: '${currentWeather.humidity}%',
                  subtitle: _getHumidityDescription(currentWeather.humidity),
                  icon: Iconsax.drop,
                  iconColor: Colors.blue,
                  child: _buildHumidityGauge(context),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppDimensions.md),

          // Pressure & UV Index row
          Row(
            children: [
              // Pressure stat with barometer
              Expanded(
                child: _buildVisualStatCard(
                  context: context,
                  title: 'pressure'.tr,
                  value: '${currentWeather.pressure} hPa',
                  subtitle: _getPressureDescription(currentWeather.pressure),
                  icon: Iconsax.weight,
                  iconColor: Colors.purple,
                  child: _buildPressureBarometer(context),
                ),
              ),

              const SizedBox(width: AppDimensions.md),

              // UV Index with circle gauge
              Expanded(
                child: _buildVisualStatCard(
                  context: context,
                  title: 'uv_index'.tr,
                  value: '${currentWeather.uv}',
                  subtitle: _getUVDescription(currentWeather.uv),
                  icon: Iconsax.sun_1,
                  iconColor: Colors.amber,
                  child: _buildUVIndexGauge(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Build wind compass section
  Widget _buildWindCompassSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppDimensions.xs),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.teal.shade400,
            Colors.teal.shade600,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        boxShadow: [
          BoxShadow(
            color: Colors.teal.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Padding(
            padding: const EdgeInsets.all(AppDimensions.md),
            child: Row(
              children: [
                Icon(
                  Iconsax.wind,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: AppDimensions.sm),
                Text(
                  'wind'.tr,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),

          // Wind speed and direction
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${currentWeather.windSpeed.round()} km/h',
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    Text(
                      _getBeaufortDescription(currentWeather.windSpeed),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withOpacity(0.8),
                          ),
                    ),
                  ],
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      currentWeather.windDirection,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      'wind_direction'.tr,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withOpacity(0.8),
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: AppDimensions.md),

          // Wind compass
          SizedBox(
            height: 180,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Compass background
                Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Colors.white.withOpacity(0.2),
                        Colors.white.withOpacity(0.05),
                      ],
                      stops: const [0.6, 1.0],
                    ),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                ),

                // Compass directions
                ...['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW']
                    .asMap()
                    .entries
                    .map((entry) {
                  final int index = entry.key;
                  final String direction = entry.value;
                  final double angle = index * math.pi / 4;
                  final double x = 80 * math.sin(angle);
                  final double y = -80 * math.cos(angle);

                  return Positioned(
                    left: 80 + x,
                    top: 90 + y,
                    child: Text(
                      direction,
                      style: TextStyle(
                        color: direction == 'N'
                            ? Colors.red
                            : Colors.white.withOpacity(0.8),
                        fontWeight: direction == 'N'
                            ? FontWeight.bold
                            : FontWeight.normal,
                        fontSize: direction == 'N' ? 16 : 12,
                      ),
                    ),
                  );
                }),

                // Wind direction arrow
                Transform.rotate(
                  angle: _getWindDirectionAngle(currentWeather.windDirection),
                  child: Container(
                    width: 120,
                    height: 8,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0.3),
                          Colors.white,
                          Colors.white,
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                    child: Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Center point
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppDimensions.md),

          // Wind gusts info
          Padding(
            padding: const EdgeInsets.all(AppDimensions.md),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Iconsax.flash,
                  color: Colors.amber,
                  size: 16,
                ),
                const SizedBox(width: AppDimensions.xs),
                Text(
                  'wind_gust'.tr +
                      ': ${(currentWeather.windSpeed * 1.5).round()} km/h',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: const Duration(milliseconds: 300));
  }

  // Build atmosphere section with visibility indicator
  Widget _buildAtmosphereSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppDimensions.xs),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blueGrey.shade400,
            Colors.blueGrey.shade700,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        boxShadow: [
          BoxShadow(
            color: Colors.blueGrey.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Padding(
            padding: const EdgeInsets.all(AppDimensions.md),
            child: Row(
              children: [
                Icon(
                  Iconsax.cloud,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: AppDimensions.sm),
                Text(
                  'Atmosphere',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),

          // Visibility info
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md),
            child: Row(
              children: [
                Icon(
                  Iconsax.eye,
                  color: Colors.white,
                  size: 16,
                ),
                const SizedBox(width: AppDimensions.xs),
                Text(
                  'visibility'.tr,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withOpacity(0.8),
                      ),
                ),
                const Spacer(),
                Text(
                  '${currentWeather.visibility} km',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppDimensions.sm),

          // Visibility visualization
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md),
            child: Container(
              height: 12,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  Container(
                    width: (currentWeather.visibility / 10) *
                        (MediaQuery.of(context).size.width -
                            56), // 56 is padding
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0.7),
                          Colors.white,
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppDimensions.xs),

          // Visibility scale
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '0 km',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white.withOpacity(0.7),
                      ),
                ),
                Text(
                  '5 km',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white.withOpacity(0.7),
                      ),
                ),
                Text(
                  '10+ km',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white.withOpacity(0.7),
                      ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppDimensions.md),

          // Weather condition
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md),
            child: Row(
              children: [
                Icon(
                  Iconsax.cloud_sunny,
                  color: Colors.white,
                  size: 16,
                ),
                const SizedBox(width: AppDimensions.xs),
                Text(
                  'Current condition',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withOpacity(0.8),
                      ),
                ),
                const Spacer(),
                Text(
                  currentWeather.conditionText,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppDimensions.md),

          // Cloud cover row - approximate based on condition
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md),
            child: Row(
              children: [
                Icon(
                  Iconsax.cloud,
                  color: Colors.white,
                  size: 16,
                ),
                const SizedBox(width: AppDimensions.xs),
                Text(
                  'Cloud cover',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withOpacity(0.8),
                      ),
                ),
                const Spacer(),
                Text(
                  _getApproximateCloudCover(currentWeather.conditionCode),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppDimensions.md),
        ],
      ),
    ).animate().fadeIn(
          duration: const Duration(milliseconds: 300),
          delay: const Duration(milliseconds: 150),
        );
  }

  // Build sun and moon section
  Widget _buildSunMoonSection(BuildContext context) {
    // These values would come from your API/model
    final String sunriseTime = "06:30";
    final String sunsetTime = "18:45";
    final String moonPhase = "Waxing Crescent";

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppDimensions.xs),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.indigo.shade400,
            Colors.deepPurple.shade700,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        boxShadow: [
          BoxShadow(
            color: Colors.indigo.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Padding(
            padding: const EdgeInsets.all(AppDimensions.md),
            child: Row(
              children: [
                Icon(
                  Iconsax.sun_1,
                  color: Colors.amber,
                  size: 20,
                ),
                const SizedBox(width: AppDimensions.sm),
                Text(
                  'Sun & Moon',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),

          // Sun path visualization
          SizedBox(
            height: 160,
            width: double.infinity,
            child: CustomPaint(
              painter: SunPathPainter(),
              child: Stack(
                children: [
                  // Sun position
                  Positioned(
                    left: MediaQuery.of(context).size.width * 0.5 - 40,
                    top: 40,
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.amber.withOpacity(0.6),
                            blurRadius: 15,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Sunrise time
                  Positioned(
                    left: 20,
                    bottom: 20,
                    child: Row(
                      children: [
                        Icon(
                          Iconsax.sun_1,
                          color: Colors.amber,
                          size: 16,
                        ),
                        const SizedBox(width: AppDimensions.xs),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'sunrise'.tr,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: Colors.white.withOpacity(0.8),
                                  ),
                            ),
                            Text(
                              sunriseTime, // From your API
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Sunset time
                  Positioned(
                    right: 20,
                    bottom: 20,
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'sunset'.tr,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: Colors.white.withOpacity(0.8),
                                  ),
                            ),
                            Text(
                              sunsetTime, // From your API
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(width: AppDimensions.xs),
                        Icon(
                          Iconsax.sun_1,
                          color: Colors.deepOrange,
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Moon information
          Padding(
            padding: const EdgeInsets.all(AppDimensions.md),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Moon phase
                Row(
                  children: [
                    // Moon phase icon
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.shade800,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: CustomPaint(
                          painter: MoonPhasePainter(),
                        ),
                      ),
                    ),

                    const SizedBox(width: AppDimensions.sm),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'moon_phase'.tr,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.white.withOpacity(0.8),
                                  ),
                        ),
                        Text(
                          moonPhase, // From your API
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
                    ),
                  ],
                ),

                // Day length
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Day Length',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white.withOpacity(0.8),
                          ),
                    ),
                    Text(
                      '12h 15m', // Calculate from sunrise/sunset
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(
          duration: const Duration(milliseconds: 300),
          delay: const Duration(milliseconds: 300),
        );
  }

  // Build visual stat card
  Widget _buildVisualStatCard({
    required BuildContext context,
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: iconColor.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: iconColor.withOpacity(0.1),
        ),
      ),
      padding: const EdgeInsets.all(AppDimensions.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
                ),
                child: Icon(
                  icon,
                  size: 14,
                  color: iconColor,
                ),
              ),
              const SizedBox(width: AppDimensions.xs),
              Text(
                title,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.xs,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
                ),
                child: Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: iconColor,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppDimensions.xs),

          // Value
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),

          const SizedBox(height: AppDimensions.sm),

          // Visual element
          SizedBox(
            height: 80,
            child: child,
          ),
        ],
      ),
    ).animate().fadeIn(duration: const Duration(milliseconds: 300));
  }

  // Build temperature gauge visualization
  Widget _buildTemperatureGauge(BuildContext context) {
    // Calculate temperature percentage
    final minTemp = -30.0; // Theoretical minimum
    final maxTemp = 50.0; // Theoretical maximum
    final range = maxTemp - minTemp;
    final percentage = (currentWeather.temperature - minTemp) / range;

    // Get temperature color
    final Color tempColor = _getTemperatureColor(currentWeather.temperature);

    return Stack(
      children: [
        // Temperature scale background
        Container(
          height: 12,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blue.shade700,
                Colors.blue.shade300,
                Colors.green.shade300,
                Colors.yellow.shade300,
                Colors.orange.shade300,
                Colors.red.shade300,
                Colors.red.shade700,
              ],
              stops: const [0.0, 0.2, 0.35, 0.5, 0.65, 0.8, 1.0],
            ),
            borderRadius: BorderRadius.circular(6),
          ),
        ),

        // Temperature marker
        Positioned(
          left: percentage *
              MediaQuery.of(context).size.width *
              0.38, // Account for card padding
          top: -5,
          child: Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: tempColor,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: tempColor.withOpacity(0.4),
                  blurRadius: 4,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Center(
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: tempColor,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ),

        // Temperature scale markings
        Positioned(
          top: 20,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '-20°',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text(
                '0°',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text(
                '20°',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text(
                '40°',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Build humidity gauge visualization
  Widget _buildHumidityGauge(BuildContext context) {
    final double percentage = currentWeather.humidity / 100;

    return Stack(
      alignment: Alignment.center,
      children: [
        // Circular background
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blue.withOpacity(0.1),
          ),
        ),

        // Humidity circle fill
        Container(
          width: 80,
          height: 80,
          child: CustomPaint(
            painter: CircularProgressPainter(
              percentage: percentage,
              color: Colors.blue,
              strokeWidth: 10,
            ),
          ),
        ),

        // Center text
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Iconsax.drop,
              color: Colors.blue,
              size: 16,
            ),
            Text(
              '${currentWeather.humidity}%',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
            ),
          ],
        ),
      ],
    );
  }

  // Build pressure barometer visualization
  Widget _buildPressureBarometer(BuildContext context) {
    // Average pressure ranges from 980 to 1040 hPa, calculate percentage
    final minPressure = 980.0;
    final maxPressure = 1040.0;
    final range = maxPressure - minPressure;
    final percentage = (currentWeather.pressure - minPressure) / range;

    return Stack(
      children: [
        // Barometer background
        Container(
          height: 80,
          decoration: BoxDecoration(
            color: Colors.purple.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          ),
        ),

        // Pressure gauge
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.amber.shade300,
                  Colors.green.shade400,
                  Colors.blue.shade400,
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(AppDimensions.radiusMd),
                bottomRight: Radius.circular(AppDimensions.radiusMd),
              ),
            ),
          ),
        ),

        // Pressure needle
        Positioned(
          bottom: 40 * 0.5,
          left: percentage *
              MediaQuery.of(context).size.width *
              0.38, // Account for card padding
          child: Container(
            width: 3,
            height: 40,
            color: Colors.purple,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  top: -10,
                  left: -9,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.purple,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.purple.withOpacity(0.4),
                          blurRadius: 4,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Pressure scale markings
        Positioned(
          top: 10,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '980',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text(
                '1010',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text(
                '1040',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Build UV index gauge visualization
  Widget _buildUVIndexGauge(BuildContext context) {
    // UV Index goes from 0 to 12+
    final double percentage = currentWeather.uv / 12;
    final Color uvColor = _getUVColor(currentWeather.uv);

    return Stack(
      alignment: Alignment.center,
      children: [
        // Circular background
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                uvColor.withOpacity(0.7),
                uvColor.withOpacity(0.1),
              ],
              stops: const [0.0, 1.0],
            ),
          ),
        ),

        // Rays emanating from center
        ...List.generate(8, (index) {
          final angle = index * math.pi / 4;
          return Transform.rotate(
            angle: angle,
            child: Container(
              height: 80,
              width: 2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    uvColor.withOpacity(0),
                    uvColor.withOpacity(percentage),
                  ],
                  begin: Alignment.center,
                  end: Alignment.topCenter,
                ),
              ),
            ),
          );
        }),

        // Center value
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: uvColor,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: uvColor.withOpacity(0.3),
                blurRadius: 4,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Center(
            child: Text(
              '${currentWeather.uv}',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: uvColor,
                  ),
            ),
          ),
        ),
      ],
    );
  }

  // Utility methods for weather information

  // Get UV index description
  String _getUVDescription(int uv) {
    if (uv <= 2) return 'Low';
    if (uv <= 5) return 'Moderate';
    if (uv <= 7) return 'High';
    if (uv <= 10) return 'Very High';
    return 'Extreme';
  }

  // Get UV index color
  Color _getUVColor(int uv) {
    if (uv <= 2) return Colors.green;
    if (uv <= 5) return Colors.yellow.shade800;
    if (uv <= 7) return Colors.orange;
    if (uv <= 10) return Colors.red;
    return Colors.purple;
  }

  // Get temperature color
  Color _getTemperatureColor(int temperature) {
    if (temperature < 0) return Colors.blue.shade700;
    if (temperature < 10) return Colors.blue.shade400;
    if (temperature < 20) return Colors.green;
    if (temperature < 25) return Colors.yellow.shade700;
    if (temperature < 30) return Colors.orange;
    return Colors.red;
  }

  // Get humidity level description
  String _getHumidityDescription(int humidity) {
    if (humidity < 30) return 'Dry';
    if (humidity < 50) return 'Comfortable';
    if (humidity < 70) return 'Moderate';
    return 'Humid';
  }

  // Get pressure description
  String _getPressureDescription(int pressure) {
    if (pressure < 1000) return 'Low';
    if (pressure > 1020) return 'High';
    return 'Normal';
  }

  // Get Beaufort scale description
  String _getBeaufortDescription(double windSpeed) {
    if (windSpeed < 1) return 'Calm';
    if (windSpeed < 6) return 'Light Air';
    if (windSpeed < 12) return 'Light Breeze';
    if (windSpeed < 20) return 'Gentle Breeze';
    if (windSpeed < 29) return 'Moderate Breeze';
    if (windSpeed < 39) return 'Fresh Breeze';
    if (windSpeed < 50) return 'Strong Breeze';
    if (windSpeed < 62) return 'Near Gale';
    if (windSpeed < 75) return 'Gale';
    if (windSpeed < 89) return 'Strong Gale';
    if (windSpeed < 103) return 'Storm';
    if (windSpeed < 118) return 'Violent Storm';
    return 'Hurricane';
  }

  // Get angle from wind direction string
  double _getWindDirectionAngle(String direction) {
    // Convert wind direction to angle in radians
    final Map<String, double> directions = {
      'N': 0,
      'NNE': 0.393,
      'NE': 0.785,
      'ENE': 1.178,
      'E': 1.571,
      'ESE': 1.963,
      'SE': 2.356,
      'SSE': 2.749,
      'S': 3.142,
      'SSW': 3.534,
      'SW': 3.927,
      'WSW': 4.320,
      'W': 4.712,
      'WNW': 5.105,
      'NW': 5.498,
      'NNW': 5.890,
    };

    return directions[direction] ?? 0;
  }

  // Get approximate cloud cover based on condition code
  String _getApproximateCloudCover(int conditionCode) {
    if (conditionCode == 1000) return '0-10%';
    if (conditionCode >= 1003 && conditionCode <= 1006) return '10-30%';
    if (conditionCode >= 1009 && conditionCode <= 1030) return '30-70%';
    if (conditionCode >= 1063 && conditionCode <= 1087) return '70-90%';
    if (conditionCode >= 1114 && conditionCode <= 1201) return '80-100%';
    if (conditionCode >= 1204 && conditionCode <= 1282) return '90-100%';
    return '50%';
  }
}

// Custom painter for circular progress (humidity gauge)
class CircularProgressPainter extends CustomPainter {
  final double percentage;
  final Color color;
  final double strokeWidth;

  CircularProgressPainter({
    required this.percentage,
    required this.color,
    this.strokeWidth = 10,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius =
        math.min(size.width, size.height) / 2 - strokeWidth / 2;

    // Draw background circle
    final Paint backgroundPaint = Paint()
      ..color = color.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Draw progress arc
    final Paint progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final double sweepAngle = 2 * math.pi * percentage;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2, // Start from top
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

// Custom painter for sun path visualization
class SunPathPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint pathPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final Paint dotPaint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    final double width = size.width;
    final double height = size.height;

    // Draw sun path arc
    final path = Path();
    path.moveTo(20, height - 20);
    path.quadraticBezierTo(
      width / 2,
      -height * 0.2,
      width - 20,
      height - 20,
    );

    canvas.drawPath(path, pathPaint);

    // Draw small dots along the path
    for (int i = 0; i <= 10; i++) {
      final double t = i / 10;
      final double x = (1 - t) * (1 - t) * 20 +
          2 * (1 - t) * t * (width / 2) +
          t * t * (width - 20);
      final double y = (1 - t) * (1 - t) * (height - 20) +
          2 * (1 - t) * t * (-height * 0.2) +
          t * t * (height - 20);

      if (i % 2 == 0 && i > 0 && i < 10) {
        // Skip first, last, and every other point
        canvas.drawCircle(Offset(x, y), 2, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

// Custom painter for moon phase visualization
class MoonPhasePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint moonPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final Paint shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.8)
      ..style = PaintingStyle.fill;

    final double width = size.width;
    final double height = size.height;
    final Offset center = Offset(width / 2, height / 2);
    final double radius = math.min(width, height) / 2;

    // Draw full moon
    canvas.drawCircle(center, radius, moonPaint);

    // For waxing crescent, cover part of the moon
    // This would be adjusted based on the actual moon phase
    final Path shadowPath = Path();
    shadowPath.addArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      math.pi,
    );
    shadowPath.arcTo(
      Rect.fromCircle(
        center: Offset(center.dx - radius * 0.3, center.dy),
        radius: radius * 1.3,
      ),
      math.pi / 2,
      -math.pi,
      false,
    );
    shadowPath.close();

    canvas.drawPath(shadowPath, shadowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
