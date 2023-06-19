import 'package:flutter/material.dart';
import 'colors.dart';

class ThemeToggleButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.brightness_4),
      onPressed: () {
        bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
        AppColors.saveThemePreference(!isDarkTheme).then((_) {
          final scaffoldMessenger = ScaffoldMessenger.of(context);
          scaffoldMessenger.showSnackBar(SnackBar(
            content: Text(isDarkTheme
                ? 'Switched to Light Theme'
                : 'Switched to Dark Theme'),
          ));
        });
      },
    );
  }
}
