import 'package:flutter/material.dart';
import 'theme.dart' as theme_mgr;

class ThemeToggleButton extends StatefulWidget {
  const ThemeToggleButton({Key? key});

  @override
  _ThemeToggleButtonState createState() => _ThemeToggleButtonState();
}

class _ThemeToggleButtonState extends State<ThemeToggleButton> {
  bool isDarkTheme = theme_mgr.AppColors.isDarkTheme;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.brightness_4),
      onPressed: () {
        setState(() {
          isDarkTheme = !isDarkTheme;
        });

        theme_mgr.AppColors.saveThemePreference(isDarkTheme).then((_) {
          theme_mgr.AppColors.loadThemeFromPrefs();
          final scaffoldMessenger = ScaffoldMessenger.of(context);
          scaffoldMessenger.showSnackBar(
            SnackBar(
              content: Text(isDarkTheme
                  ? 'Switched to Dark Theme'
                  : 'Switched to Light Theme'),
            ),
          );
        });
      },
    );
  }
}
