import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sundrift/app/themes/app_theme.dart';
import 'package:sundrift/data/models/favorite_location_model.dart';
import 'package:sundrift/presentation/controllers/favorites_controller.dart';
import 'package:sundrift/presentation/widgets/favorites/favorite_location_card.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class FavoritesGrid extends StatelessWidget {
  final List<FavoriteLocationModel> favorites;
  final FavoritesController controller;

  const FavoritesGrid({
    Key? key,
    required this.favorites,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
      child: GridView.builder(
        padding: const EdgeInsets.all(AppDimensions.md),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.9,
          crossAxisSpacing: AppDimensions.md,
          mainAxisSpacing: AppDimensions.md,
        ),
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          final location = favorites[index];

          return AnimationConfiguration.staggeredGrid(
            position: index,
            duration: AppDimensions.animNormal,
            columnCount: 2,
            child: ScaleAnimation(
              child: FadeInAnimation(
                child: FavoriteLocationCard(
                  location: location,
                  weatherData:
                      controller.favoriteWeatherData[location.locationId],
                  onTap: () => controller.setAsCurrentLocation(location),
                  onRemove: () =>
                      controller.removeFavoriteLocation(location.locationId),
                  onRefresh: () => controller.fetchWeatherForLocation(location),
                  isRefreshing: controller.isRefreshing.value,
                  index: index,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
