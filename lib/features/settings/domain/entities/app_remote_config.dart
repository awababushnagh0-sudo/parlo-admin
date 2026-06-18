import 'package:equatable/equatable.dart';

/// Remote app configuration (the `config/app` document) read by the mobile app.
class AppRemoteConfig with EquatableMixin {
  final bool maintenanceMode;
  final int dailyGoalDefault;
  final String minAppVersion;

  const AppRemoteConfig({
    this.maintenanceMode = false,
    this.dailyGoalDefault = 10,
    this.minAppVersion = '',
  });

  static const empty = AppRemoteConfig();

  AppRemoteConfig copyWith({
    bool? maintenanceMode,
    int? dailyGoalDefault,
    String? minAppVersion,
  }) {
    return AppRemoteConfig(
      maintenanceMode: maintenanceMode ?? this.maintenanceMode,
      dailyGoalDefault: dailyGoalDefault ?? this.dailyGoalDefault,
      minAppVersion: minAppVersion ?? this.minAppVersion,
    );
  }

  @override
  List<Object?> get props => [maintenanceMode, dailyGoalDefault, minAppVersion];
}
