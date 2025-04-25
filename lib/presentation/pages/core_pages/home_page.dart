import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sundrift/app/routes/app_routes.dart';
import 'package:sundrift/app/themes/app_theme.dart';
import 'package:sundrift/presentation/controllers/home_controller.dart';
import 'package:sundrift/presentation/widgets/common/custom_button.dart';
import 'package:sundrift/presentation/widgets/home/current_weather_card.dart';
import 'package:sundrift/presentation/widgets/home/hourly_forecast_slider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize controller
    final controller = Get.find<HomeController>();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Obx(() {
          // Show loading state
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          // Show error state if any
          if (controller.hasError.value) {
            return Center(
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
                  CustomButton(
                    text: 'retry'.tr,
                    onPressed: controller.fetchWeatherData,
                    icon: Iconsax.refresh,
                  ),
                ],
              ),
            );
          }

          // Show content
          return RefreshIndicator(
            onRefresh: controller.refreshWeatherData,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(AppDimensions.md),
              children: [
                // Location header
                _buildLocationHeader(context, controller),

                const SizedBox(height: AppDimensions.lg),

                // Current weather card
                CurrentWeatherCard(),

                const SizedBox(height: AppDimensions.lg),

                // Hourly forecast
                HourlyForecastSlider(),

                const SizedBox(height: AppDimensions.lg),

                // Placeholder for daily forecast
                _buildPlaceholderSection(
                  context,
                  'daily_forecast'.tr,
                  MediaQuery.of(context).size.height * 0.2,
                ),

                const SizedBox(height: AppDimensions.lg),

                // Placeholder for weather details
                _buildPlaceholderSection(
                  context,
                  'weather_details'.tr,
                  MediaQuery.of(context).size.height * 0.25,
                ),
              ],
            ),
          );
        }),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  // Build location header
  Widget _buildLocationHeader(BuildContext context, HomeController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Iconsax.location, size: 20),
                  const SizedBox(width: AppDimensions.xs),
                  Expanded(
                    child: Text(
                      controller.currentLocation.value,
                      style: Theme.of(context).textTheme.titleLarge,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              Text(
                'updated_at'.trParams({'time': controller.lastUpdated.value}),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onBackground
                          .withOpacity(0.7),
                    ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            IconButton(
              onPressed: () => Get.toNamed(AppRoutes.SEARCH),
              icon: const Icon(Iconsax.search_normal),
              tooltip: 'search'.tr,
            ),
            IconButton(
              onPressed: () => Get.toNamed(AppRoutes.SETTINGS),
              icon: const Icon(Iconsax.setting_2),
              tooltip: 'settings'.tr,
            ),
          ],
        ),
      ],
    );
  }

  // Build bottom navigation bar
  Widget _buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 0,
      onTap: (index) {
        // Handle navigation
        switch (index) {
          case 1:
            Get.toNamed(AppRoutes.SEARCH);
            break;
          case 2:
            Get.toNamed(AppRoutes.FAVORITES);
            break;
          case 3:
            Get.toNamed(AppRoutes.SETTINGS);
            break;
        }
      },
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Iconsax.home),
          label: 'home_title'.tr,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Iconsax.search_normal),
          label: 'search'.tr,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Iconsax.heart),
          label: 'favorites'.tr,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Iconsax.setting_2),
          label: 'settings'.tr,
        ),
      ],
    );
  }

  // Build placeholder section
  Widget _buildPlaceholderSection(
    BuildContext context,
    String title,
    double height,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: AppDimensions.sm),
        Container(
          width: double.infinity,
          height: height,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            boxShadow: AppShadows.small,
          ),
          child: Center(
            child: Text(
              'Coming Soon',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ),
      ],
    );
  }
}
