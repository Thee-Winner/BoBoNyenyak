import 'package:flutter/material.dart';
import '../config/bobo_colors.dart';

/// Reusable Bottom Navigation Bar for BoboNyenyak supporting Dark & Light modes.
class BoboBottomNavbar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BoboBottomNavbar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = BoboColors.of(context);

    return Container(
      decoration: BoxDecoration(
        color: colors.bottomNavBg,
        border: Border(top: BorderSide(color: colors.border, width: 1)),
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        backgroundColor: colors.bottomNavBg,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: colors.isDark ? colors.accentYellow : const Color(0xFF1B2A4A),
        unselectedItemColor: colors.isDark ? Colors.white38 : const Color(0xFF8E99AF),
        selectedLabelStyle: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_rounded),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.insights_rounded),
            label: 'Trends',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_rounded),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
