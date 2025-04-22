import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Service for tracking app lifecycle changes
class AppLifecycleService extends GetxService with WidgetsBindingObserver {
  // Reactive variables
  final Rx<AppLifecycleState> appState = AppLifecycleState.resumed.obs;
  final RxBool isInForeground = true.obs;
  final RxBool isFirstLaunch = true.obs;

  // Timestamp tracking
  final RxDouble lastResumedTimestamp = 0.0.obs;
  final RxDouble lastPausedTimestamp = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    // Register the observer
    WidgetsBinding.instance.addObserver(this);
    // Set initial timestamps
    lastResumedTimestamp.value =
        DateTime.now().millisecondsSinceEpoch.toDouble();
  }

  @override
  void onClose() {
    // Unregister the observer
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    // Update state
    appState.value = state;

    switch (state) {
      case AppLifecycleState.resumed:
        _onResumed();
        break;
      case AppLifecycleState.inactive:
        _onInactive();
        break;
      case AppLifecycleState.paused:
        _onPaused();
        break;
      case AppLifecycleState.detached:
        _onDetached();
        break;
      case AppLifecycleState.hidden:
        _onHidden();
        break;
    }
  }

  // Called when the app is visible and responding to user input
  void _onResumed() {
    isInForeground.value = true;
    isFirstLaunch.value = false;
    lastResumedTimestamp.value =
        DateTime.now().millisecondsSinceEpoch.toDouble();

    // Trigger app resume event that other services can listen to
    Get.find<EventBus>().fire(AppResumedEvent());
  }

  // Called when the app is not visible but still running
  void _onPaused() {
    isInForeground.value = false;
    lastPausedTimestamp.value =
        DateTime.now().millisecondsSinceEpoch.toDouble();

    // Trigger app pause event that other services can listen to
    Get.find<EventBus>().fire(AppPausedEvent());
  }

  // Called when the app is in an inactive state (transitioning between states)
  void _onInactive() {
    Get.find<EventBus>().fire(AppInactiveEvent());
  }

  // Called when the app is detached (being suspended or terminated)
  void _onDetached() {
    Get.find<EventBus>().fire(AppDetachedEvent());
  }

  // Called when the app is hidden
  void _onHidden() {
    Get.find<EventBus>().fire(AppHiddenEvent());
  }

  // Get time spent in app (milliseconds)
  double getTimeSpentInApp() {
    final now = DateTime.now().millisecondsSinceEpoch.toDouble();
    if (isInForeground.value) {
      return now - lastResumedTimestamp.value + _getPreviousTimeSpent();
    } else {
      return lastPausedTimestamp.value -
          lastResumedTimestamp.value +
          _getPreviousTimeSpent();
    }
  }

  // Get time spent in current session (milliseconds)
  double getSessionDuration() {
    final now = DateTime.now().millisecondsSinceEpoch.toDouble();
    if (isInForeground.value) {
      return now - lastResumedTimestamp.value;
    } else {
      return lastPausedTimestamp.value - lastResumedTimestamp.value;
    }
  }

  // Get previous time spent in app (to be implemented with local storage)
  double _getPreviousTimeSpent() {
    // This would be implemented with local storage to persist across app launches
    return 0.0;
  }
}

// Event bus for app lifecycle events
class EventBus {
  final _streamController = StreamController.broadcast();

  Stream<T> on<T>() {
    return _streamController.stream.where((event) => event is T).cast<T>();
  }

  void fire(event) {
    _streamController.add(event);
  }

  void dispose() {
    _streamController.close();
  }
}

// App lifecycle events
class AppLifecycleEvent {}

class AppResumedEvent extends AppLifecycleEvent {}

class AppPausedEvent extends AppLifecycleEvent {}

class AppInactiveEvent extends AppLifecycleEvent {}

class AppDetachedEvent extends AppLifecycleEvent {}

class AppHiddenEvent extends AppLifecycleEvent {}
