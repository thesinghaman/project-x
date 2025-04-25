import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sundrift/app/routes/app_routes.dart';
import 'package:sundrift/app/themes/app_theme.dart';
import 'package:sundrift/core/constants/app_constants.dart';
import 'package:sundrift/core/constants/asset_paths.dart';
import 'package:sundrift/data/models/favorite_location_model.dart';
import 'package:sundrift/presentation/controllers/favorites_controller.dart';
import 'package:sundrift/presentation/widgets/common/custom_button.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  // Set of selected location IDs for multi-select mode
  final Set<String> _selectedLocationIds = <String>{};

  // Flag to track if we're in selection mode
  bool _isSelectionMode = false;

  @override
  Widget build(BuildContext context) {
    // Initialize controller
    final controller = Get.find<FavoritesController>();

    return Scaffold(
      appBar: _buildAppBar(context, controller),
      body: Obx(() {
        // Show loading state
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // Show error state if any
        if (controller.hasError.value) {
          return _buildErrorView(context, controller);
        }

        // Show empty state if no favorites
        if (controller.favoriteLocations.isEmpty) {
          return _buildEmptyState(context);
        }

        // Show list of favorites
        return _buildFavoritesList(context, controller);
      }),
    );
  }

  // Build app bar with different states for selection mode
  AppBar _buildAppBar(BuildContext context, FavoritesController controller) {
    if (_isSelectionMode) {
      // Selection mode app bar
      return AppBar(
        title: Text('${_selectedLocationIds.length} selected'),
        leading: IconButton(
          icon: const Icon(Iconsax.close_square),
          onPressed: () {
            setState(() {
              _isSelectionMode = false;
              _selectedLocationIds.clear();
            });
          },
          tooltip: 'cancel'.tr,
        ),
        actions: [
          // Delete selected locations
          IconButton(
            icon: const Icon(Iconsax.trash),
            onPressed: _selectedLocationIds.isNotEmpty
                ? () {
                    _deleteSelectedLocations(controller);
                  }
                : null,
            tooltip: 'delete'.tr,
          ),
          // Select all
          IconButton(
            icon: const Icon(Iconsax.tick_square),
            onPressed: () {
              setState(() {
                if (_selectedLocationIds.length ==
                    controller.favoriteLocations.length) {
                  // Deselect all if all are selected
                  _selectedLocationIds.clear();
                } else {
                  // Select all
                  _selectedLocationIds.clear();
                  _selectedLocationIds.addAll(
                    controller.favoriteLocations
                        .map((location) => location.locationId),
                  );
                }
              });
            },
            tooltip: _selectedLocationIds.length ==
                    controller.favoriteLocations.length
                ? 'deselect_all'.tr
                : 'select_all'.tr,
          ),
        ],
      );
    } else {
      // Normal app bar
      return AppBar(
        title: Text('favorites'.tr),
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.add),
            onPressed: () => Get.toNamed(AppRoutes.SEARCH),
            tooltip: 'add_to_favorites'.tr,
          ),
        ],
      );
    }
  }

  // Delete selected locations
  void _deleteSelectedLocations(FavoritesController controller) {
    // Show confirmation dialog
    Get.dialog(
      AlertDialog(
        title: Text('delete'.tr),
        content: Text(
            'Are you sure you want to delete ${_selectedLocationIds.length} '
            'location${_selectedLocationIds.length > 1 ? 's' : ''}?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('cancel'.tr),
          ),
          TextButton(
            onPressed: () {
              // Delete all selected locations
              for (var locationId in _selectedLocationIds) {
                controller.removeFavoriteLocation(locationId);
              }

              // Exit selection mode
              setState(() {
                _isSelectionMode = false;
                _selectedLocationIds.clear();
              });

              Get.back(); // Close dialog
            },
            child: Text('delete'.tr),
          ),
        ],
      ),
    );
  }

  // Build error view
  Widget _buildErrorView(BuildContext context, FavoritesController controller) {
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
            onPressed: controller.loadFavoriteLocations,
            icon: Iconsax.refresh,
          ),
        ],
      ),
    ).animate().fade(duration: AppDimensions.animNormal);
  }

  // Build empty state
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            AssetPaths.noFavorites,
            height: 150,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: AppDimensions.lg),
          Text(
            'no_favorites'.tr,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: AppDimensions.sm),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.xl),
            child: Text(
              'add_favorites'.tr,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: AppDimensions.lg),
          CustomButton(
            text: 'search_locations'.tr,
            onPressed: () => Get.toNamed(AppRoutes.SEARCH),
            icon: Iconsax.search_normal,
          ),
        ],
      ),
    ).animate().fade(duration: AppDimensions.animNormal);
  }

  // Build favorites list
  Widget _buildFavoritesList(
      BuildContext context, FavoritesController controller) {
    return RefreshIndicator(
      onRefresh: controller.refreshFavorites,
      child: ReorderableListView.builder(
        padding: const EdgeInsets.all(AppDimensions.md),
        itemCount: controller.favoriteLocations.length,
        onReorder: _isSelectionMode
            ? (int oldIndex, int newIndex) {}
            : (int oldIndex, int newIndex) {
                controller.reorderFavorites(oldIndex, newIndex);
              },
        itemBuilder: (context, index) {
          final location = controller.favoriteLocations[index];
          // We create the key from the location ID to ensure uniqueness
          final Key itemKey = Key(location.locationId);

          return _buildFavoriteItem(
            context,
            controller,
            location,
            index,
            key: itemKey,
          );
        },
      ),
    );
  }

  // Build favorite location item
  Widget _buildFavoriteItem(
    BuildContext context,
    FavoritesController controller,
    FavoriteLocationModel location,
    int index, {
    required Key key,
  }) {
    // Get weather data for this location
    final weatherData = controller.favoriteWeatherData[location.locationId];

    // Check if this location is selected
    final bool isSelected = _selectedLocationIds.contains(location.locationId);

    return Animate(
      key: key,
      effects: [
        FadeEffect(
          duration: AppDimensions.animNormal,
          delay: Duration(milliseconds: index * 50),
        ),
        SlideEffect(
          duration: AppDimensions.animNormal,
          delay: Duration(milliseconds: index * 50),
          begin: const Offset(0, 0.1),
          end: const Offset(0, 0),
        ),
      ],
      child: Slidable(
        key: key,
        enabled: !_isSelectionMode, // Disable sliding in selection mode
        endActionPane: ActionPane(
          extentRatio: 0.25,
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) =>
                  controller.removeFavoriteLocation(location.locationId),
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Iconsax.trash,
              label: 'delete'.tr,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(AppDimensions.radiusMd),
                bottomRight: Radius.circular(AppDimensions.radiusMd),
              ),
            ),
          ],
        ),
        startActionPane: ActionPane(
          extentRatio: 0.3,
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => controller.setAsCurrentLocation(location),
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              icon: Iconsax.location,
              label: 'Set Current',
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppDimensions.radiusMd),
                bottomLeft: Radius.circular(AppDimensions.radiusMd),
              ),
            ),
          ],
        ),
        child: Card(
          margin: const EdgeInsets.symmetric(vertical: AppDimensions.xs),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          ),
          child: InkWell(
            onTap: _isSelectionMode
                ? () {
                    // Toggle selection in selection mode
                    setState(() {
                      if (isSelected) {
                        _selectedLocationIds.remove(location.locationId);
                        // Exit selection mode if no items selected
                        if (_selectedLocationIds.isEmpty) {
                          _isSelectionMode = false;
                        }
                      } else {
                        _selectedLocationIds.add(location.locationId);
                      }
                    });
                  }
                : () {
                    // Navigate to weather details page
                    Get.toNamed(
                      AppRoutes.WEATHER_DETAILS,
                      arguments: {
                        'locationId': location.locationId,
                        'location': location,
                      },
                    );
                  },
            onLongPress: () {
              // Enter selection mode on long press
              if (!_isSelectionMode) {
                setState(() {
                  _isSelectionMode = true;
                  _selectedLocationIds.add(location.locationId);
                });
              }
            },
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            child: Container(
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                    : null,
                borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              ),
              padding: const EdgeInsets.all(AppDimensions.md),
              child: Row(
                children: [
                  // Checkbox in selection mode
                  if (_isSelectionMode) ...[
                    Checkbox(
                      value: isSelected,
                      onChanged: (value) {
                        setState(() {
                          if (value == true) {
                            _selectedLocationIds.add(location.locationId);
                          } else {
                            _selectedLocationIds.remove(location.locationId);
                            // Exit selection mode if no items selected
                            if (_selectedLocationIds.isEmpty) {
                              _isSelectionMode = false;
                            }
                          }
                        });
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(width: AppDimensions.xs),
                  ],

                  // Location icon and info
                  Expanded(
                    flex: 3,
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.1),
                            borderRadius:
                                BorderRadius.circular(AppDimensions.radiusSm),
                          ),
                          child: Icon(
                            Iconsax.location,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: AppDimensions.sm),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                location.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                location.country,
                                style: Theme.of(context).textTheme.bodySmall,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Weather data (if available)
                  Expanded(
                    flex: 2,
                    child: weatherData != null
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              // Weather icon
                              _getWeatherIcon(
                                  context, weatherData.conditionCode),
                              const SizedBox(width: AppDimensions.sm),
                              // Temperature
                              Text(
                                '${weatherData.temperature}°',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          )
                        : controller.isRefreshing.value
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : IconButton(
                                icon: const Icon(Iconsax.refresh),
                                onPressed: () => controller
                                    .fetchWeatherForLocation(location),
                                tooltip: 'refresh'.tr,
                              ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Get weather icon based on condition code
  Widget _getWeatherIcon(BuildContext context, int conditionCode) {
    IconData iconData;

    if (conditionCode == 1000) {
      iconData = Iconsax.sun_1;
    } else if (conditionCode >= 1003 && conditionCode <= 1009) {
      iconData = Iconsax.cloud;
    } else if (conditionCode >= 1180 && conditionCode <= 1201) {
      iconData = Iconsax.cloud_drizzle;
    } else if (conditionCode >= 1273 && conditionCode <= 1282) {
      iconData = Iconsax.cloud_lightning;
    } else if (conditionCode >= 1210 && conditionCode <= 1225) {
      iconData = Iconsax.cloud_snow;
    } else {
      iconData = Iconsax.cloud_fog;
    }

    return Icon(
      iconData,
      color: _getWeatherIconColor(conditionCode),
      size: 24,
    );
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
