import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sundrift/app/themes/app_theme.dart';
import 'package:flutter_animate/flutter_animate.dart';

class WeatherStatsGrid extends StatelessWidget {
  final Map<String, WeatherStat> stats;

  const WeatherStatsGrid({
    Key? key,
    required this.stats,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final statItems = stats.entries.toList();

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppDimensions.sm,
        mainAxisSpacing: AppDimensions.sm,
        childAspectRatio: 1.5,
      ),
      itemCount: stats.length,
      itemBuilder: (context, index) {
        final entry = statItems[index];
        return _buildStatCard(
          context,
          entry.key,
          entry.value,
          index,
        );
      },
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String key,
    WeatherStat stat,
    int index,
  ) {
    return Animate(
      effects: [
        FadeEffect(
          duration: AppDimensions.animNormal,
          delay: Duration(milliseconds: 100 + index * 50),
        ),
        ScaleEffect(
          duration: AppDimensions.animNormal,
          delay: Duration(milliseconds: 100 + index * 50),
          begin: const Offset(0.95, 0.95),
          end: const Offset(1.0, 1.0),
        ),
      ],
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.md),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title and icon
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: stat.iconColor.withOpacity(0.1),
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusSm),
                    ),
                    child: Icon(
                      stat.icon,
                      size: 14,
                      color: stat.iconColor,
                    ),
                  ),
                  const SizedBox(width: AppDimensions.xs),
                  Text(
                    key.tr,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.7),
                        ),
                  ),
                ],
              ),

              const Spacer(),

              // Value
              Text(
                stat.value,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),

              // Description (if available)
              if (stat.description != null && stat.description!.isNotEmpty)
                Text(
                  stat.description!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.7),
                      ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class WeatherStat {
  final String value;
  final IconData icon;
  final Color iconColor;
  final String? description;

  WeatherStat({
    required this.value,
    required this.icon,
    this.iconColor = Colors.blue,
    this.description,
  });
}
