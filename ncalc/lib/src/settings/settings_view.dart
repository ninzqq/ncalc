import 'package:flutter/material.dart';
import 'package:ncalc/src/constants.dart' as constants;
import 'settings_controller.dart';

/// Displays the various settings that can be customized by the user.
///
/// When a user changes a setting, the SettingsController is updated and
/// Widgets that listen to the SettingsController are rebuilt.
class SettingsView extends StatelessWidget {
  const SettingsView({super.key, required this.controller});

  static const routeName = '/settings';

  final SettingsController controller;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        title: Text(
          'Settings',
          style: TextStyle(color: theme.colorScheme.primaryFixed),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            // Glue the SettingsController to the theme selection DropdownButton.
            //
            // When a user selects a theme from the dropdown list, the
            // SettingsController is updated, which rebuilds the MaterialApp.
            child: DropdownButton<ThemeMode>(
              // Read the selected themeMode from the controller
              value: controller.themeMode,
              // Call the updateThemeMode method any time the user selects a theme.
              onChanged: controller.updateThemeMode,
              dropdownColor: theme.colorScheme.secondary,
              items: [
                DropdownMenuItem(
                  value: ThemeMode.dark,
                  child: Text(
                    'Dark Theme',
                    style: theme.textTheme.labelMedium,
                  ),
                ),
                DropdownMenuItem(
                  value: ThemeMode.system,
                  child: Text(
                    'System Theme',
                    style: theme.textTheme.labelMedium,
                  ),
                ),
                DropdownMenuItem(
                  value: ThemeMode.light,
                  child: Text(
                    'Light Theme',
                    style: TextStyle(color: theme.colorScheme.primaryFixed),
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(18),
            child: Text('Version ${constants.version}'),
          ),
        ],
      ),
    );
  }
}
