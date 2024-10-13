import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ncalc/src/calculator/calculator_basic_view.dart';
import 'settings/settings_controller.dart';
import 'settings/settings_view.dart';

/// The Widget that configures your application.
class NCalc extends StatelessWidget {
  const NCalc({
    super.key,
    required this.settingsController,
  });

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    // Glue the SettingsController to the MaterialApp.
    //
    // The ListenableBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.
    return ListenableBuilder(
      listenable: settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          // Providing a restorationScopeId allows the Navigator built by the
          // MaterialApp to restore the navigation stack when a user leaves and
          // returns to the app after it has been killed while running in the
          // background.
          restorationScopeId: 'calculator',

          // Provide the generated AppLocalizations to the MaterialApp. This
          // allows descendant Widgets to display the correct translations
          // depending on the user's locale.
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''), // English, no country code
          ],

          // Use AppLocalizations to configure the correct application title
          // depending on the user's locale.
          //
          // The appTitle is defined in .arb files found in the localization
          // directory.
          onGenerateTitle: (BuildContext context) =>
              AppLocalizations.of(context)!.appTitle,

          // Define a light and dark color theme. Then, read the user's
          // preferred ThemeMode (light, dark, or system default) from the
          // SettingsController to display the correct theme.
          theme: ThemeData(
            textTheme: const TextTheme(
              bodyMedium: TextStyle(color: Colors.black87),
            ),
            colorScheme: ColorScheme.fromSwatch().copyWith(
              primary: Colors.cyan.shade500,
              secondary: Colors.grey.shade300,
              surfaceBright: Colors.grey.shade200,
              primaryFixed: Colors.black,
            ),
          ),
          darkTheme: ThemeData(
            textTheme: const TextTheme(
              bodyMedium: TextStyle(color: Colors.white54),
            ),
            colorScheme: ColorScheme.fromSwatch().copyWith(
              primary: const Color.fromARGB(255, 20, 25, 46),
              secondary: const Color.fromARGB(255, 23, 60, 114),
              surfaceBright: const Color.fromARGB(255, 40, 78, 136),
              primaryFixed: Colors.white54, // text color
            ),
            //colorScheme: ColorScheme.fromSwatch().copyWith(
            //  primary: Colors.cyan.shade500,
            //  secondary: Colors.black87,
            //),
          ),
          themeMode: settingsController.themeMode,

          // Define a function to handle named routes in order to support
          // Flutter web url navigation and deep linking.
          onGenerateRoute: (RouteSettings routeSettings) {
            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (BuildContext context) {
                switch (routeSettings.name) {
                  case SettingsView.routeName:
                    return SettingsView(controller: settingsController);
                  case CalculatorBasicView.routeName:
                    return const CalculatorBasicView();
                  default:
                    return const CalculatorBasicView();
                }
              },
            );
          },
        );
      },
    );
  }
}
