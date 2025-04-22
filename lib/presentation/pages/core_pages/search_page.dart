import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sundrift/app/themes/app_theme.dart';
import 'package:sundrift/core/constants/app_constants.dart';
import 'package:sundrift/core/constants/asset_paths.dart';
import 'package:sundrift/presentation/controllers/search_controller.dart'
    as app_search;
import 'package:sundrift/presentation/widgets/common/custom_button.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize controller
    final controller = Get.find<app_search.SearchController>();

    // Auto focus the search field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.searchFocusNode.requestFocus();
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('search_locations'.tr),
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left),
          onPressed: () => Get.back(),
        ),
        actions: [
          // Clear all button for recent searches
          Obx(() => controller.recentSearches.isNotEmpty &&
                  !controller.hasSearched.value
              ? IconButton(
                  icon: const Icon(Iconsax.trash),
                  onPressed: controller.clearRecentSearches,
                  tooltip: 'clear'.tr,
                )
              : const SizedBox.shrink()),
        ],
      ),
      body: Column(
        children: [
          // Search input
          Padding(
            padding: const EdgeInsets.all(AppDimensions.md),
            child: Obx(() {
              return TextField(
                controller: controller.textController,
                focusNode: controller.searchFocusNode,
                decoration: InputDecoration(
                  hintText: 'search_hint'.tr,
                  prefixIcon: const Icon(Iconsax.search_normal),
                  suffixIcon: controller.showClearButton.value
                      ? IconButton(
                          icon: const Icon(Iconsax.close_circle),
                          onPressed: controller.clearSearchResults,
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                  ),
                ),
                onSubmitted: (query) => controller.searchLocations(query),
                textInputAction: TextInputAction.search,
              ).animate().fadeIn(duration: AppDimensions.animFast);
            }),
          ),

          // Results or recent searches
          Expanded(
            child: Obx(() {
              // Show loading indicator
              if (controller.isLoading.value) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: AppDimensions.md),
                      Text(
                        'loading'.tr,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                );
              }

              // Show error message
              if (controller.hasError.value) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Iconsax.danger,
                        size: 48,
                        color: Theme.of(context).colorScheme.error,
                      ).animate().scale(duration: AppDimensions.animNormal),
                      const SizedBox(height: AppDimensions.sm),
                      Text(
                        controller.errorMessage.value,
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ).animate().fade(duration: AppDimensions.animNormal),
                      const SizedBox(height: AppDimensions.md),
                      CustomButton(
                        text: 'retry'.tr,
                        onPressed: () => controller
                            .searchLocations(controller.searchQuery.value),
                        icon: Iconsax.refresh,
                      ).animate().fade(
                            duration: AppDimensions.animNormal,
                            delay: const Duration(milliseconds: 200),
                          ),
                    ],
                  ),
                );
              }

              // Show search results if any
              if (controller.searchResults.isNotEmpty) {
                return _buildSearchResults(context, controller);
              }

              // Show empty search results if searched but no results
              if (controller.hasSearched.value &&
                  controller.searchResults.isEmpty) {
                return _buildEmptySearchResults(context);
              }

              // Show recent searches
              return _buildRecentSearches(context, controller);
            }),
          ),
        ],
      ),
    );
  }

  // Build search results list
  Widget _buildSearchResults(
      BuildContext context, app_search.SearchController controller) {
    return ListView.builder(
      itemCount: controller.searchResults.length,
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md),
      itemBuilder: (context, index) {
        final result = controller.searchResults[index];

        // Animate items with staggered delay based on index
        return Animate(
          effects: [
            FadeEffect(
              duration: AppDimensions.animNormal,
              delay: Duration(milliseconds: 30 * index),
            ),
            SlideEffect(
              duration: AppDimensions.animNormal,
              delay: Duration(milliseconds: 30 * index),
              begin: const Offset(0, 0.1),
              end: const Offset(0, 0),
            ),
          ],
          child: Card(
            margin: const EdgeInsets.only(bottom: AppDimensions.sm),
            elevation: 2,
            child: ListTile(
              title: Text(
                result['name'] ?? '',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              subtitle: Text(
                '${result['region'] ?? ''}, ${result['country'] ?? ''}',
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                ),
                child: Icon(
                  Iconsax.location,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Favorite toggle button
                  Obx(() {
                    bool isFavorite = controller.isLocationFavorite(result);
                    return IconButton(
                      icon: Icon(
                        isFavorite ? Iconsax.heart5 : Iconsax.heart,
                        color: isFavorite
                            ? Theme.of(context).colorScheme.error
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      onPressed: () => isFavorite
                          ? controller.removeFromFavorites(result)
                          : controller.addToFavorites(result),
                      tooltip: isFavorite
                          ? 'remove_from_favorites'.tr
                          : 'add_to_favorites'.tr,
                    );
                  }),
                  const Icon(Iconsax.arrow_right_3),
                ],
              ),
              onTap: () => controller.selectLocation(result),
            ),
          ),
        );
      },
    );
  }

  // Build empty search results
  Widget _buildEmptySearchResults(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            AssetPaths.noResults,
            height: 120,
            fit: BoxFit.contain,
          ).animate().scale(duration: AppDimensions.animNormal),
          const SizedBox(height: AppDimensions.md),
          Text(
            'no_results'.tr,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ).animate().fade(duration: AppDimensions.animNormal),
          const SizedBox(height: AppDimensions.sm),
          Text(
            'try_again'.tr,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ).animate().fade(
                duration: AppDimensions.animNormal,
                delay: const Duration(milliseconds: 200),
              ),
        ],
      ),
    );
  }

  // Build recent searches list
  Widget _buildRecentSearches(
      BuildContext context, app_search.SearchController controller) {
    if (controller.recentSearches.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Iconsax.clock,
              size: 48,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
            ).animate().scale(duration: AppDimensions.animNormal),
            const SizedBox(height: AppDimensions.md),
            Text(
              'no_recent_searches'.tr,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ).animate().fade(duration: AppDimensions.animNormal),
            const SizedBox(height: AppDimensions.sm),
            Text(
              'search_hint'.tr,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ).animate().fade(
                  duration: AppDimensions.animNormal,
                  delay: const Duration(milliseconds: 200),
                ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.md,
            vertical: AppDimensions.sm,
          ),
          child: Text(
            'recent_searches'.tr,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ).animate().fade(duration: AppDimensions.animFast),
        Expanded(
          child: ListView.builder(
            itemCount: controller.recentSearches.length,
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md),
            itemBuilder: (context, index) {
              final query = controller.recentSearches[index];

              // Animate items with staggered delay based on index
              return Animate(
                effects: [
                  FadeEffect(
                    duration: AppDimensions.animNormal,
                    delay: Duration(milliseconds: 50 * index),
                  ),
                  SlideEffect(
                    duration: AppDimensions.animNormal,
                    delay: Duration(milliseconds: 50 * index),
                    begin: const Offset(0, 0.1),
                    end: const Offset(0, 0),
                  ),
                ],
                child: ListTile(
                  leading: const Icon(Iconsax.clock),
                  title: Text(query),
                  trailing: IconButton(
                    icon: const Icon(Iconsax.close_circle),
                    onPressed: () {
                      // Remove just this entry from recent searches
                      final List<String> searches =
                          controller.recentSearches.toList();
                      searches.removeWhere((element) => element == query);
                      controller.recentSearches.value = searches;
                      controller.localStorage.setObject(
                        AppConstants.storageKeyRecentSearches,
                        searches,
                      );
                    },
                  ),
                  onTap: () => controller.searchLocations(query),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
