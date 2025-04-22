import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sundrift/app/themes/app_theme.dart';
import 'package:sundrift/presentation/controllers/search_controller.dart'
    as app_search;
import 'package:sundrift/presentation/widgets/common/custom_button.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize controller
    final controller = Get.find<app_search.SearchController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('search_locations'.tr),
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left),
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(
        children: [
          // Search input
          Padding(
            padding: const EdgeInsets.all(AppDimensions.md),
            child: TextField(
              controller: controller.textController,
              decoration: InputDecoration(
                hintText: 'search_hint'.tr,
                prefixIcon: const Icon(Iconsax.search_normal),
                suffixIcon: IconButton(
                  icon: const Icon(Iconsax.close_circle),
                  onPressed: controller.clearSearchResults,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                ),
              ),
              onSubmitted: (query) => controller.searchLocations(query),
            ),
          ),

          // Results or recent searches
          Expanded(
            child: Obx(() {
              // Show loading indicator
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
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
                      ),
                      const SizedBox(height: AppDimensions.sm),
                      Text(
                        controller.errorMessage.value,
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppDimensions.md),
                      CustomButton(
                        text: 'retry'.tr,
                        onPressed: () => controller
                            .searchLocations(controller.searchQuery.value),
                        icon: Iconsax.refresh,
                      ),
                    ],
                  ),
                );
              }

              // Show search results if any
              if (controller.searchResults.isNotEmpty) {
                return _buildSearchResults(context, controller);
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
        return Card(
          margin: const EdgeInsets.only(bottom: AppDimensions.sm),
          child: ListTile(
            title: Text(result['name'] ?? ''),
            subtitle: Text(result['country'] ?? ''),
            trailing: const Icon(Iconsax.arrow_right_3),
            onTap: () => controller.selectLocation(result),
          ),
        );
      },
    );
  }

  // Build recent searches list
  Widget _buildRecentSearches(
      BuildContext context, app_search.SearchController controller) {
    if (controller.recentSearches.isEmpty) {
      return Center(
        child: Text(
          'no_recent_searches'.tr,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'recent_searches'.tr,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              TextButton(
                onPressed: controller.clearRecentSearches,
                child: Text('clear'.tr),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: controller.recentSearches.length,
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md),
            itemBuilder: (context, index) {
              final query = controller.recentSearches[index];
              return ListTile(
                leading: const Icon(Iconsax.clock),
                title: Text(query),
                onTap: () => controller.searchLocations(query),
              );
            },
          ),
        ),
      ],
    );
  }
}
