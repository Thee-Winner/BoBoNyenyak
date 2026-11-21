import 'package:flutter/material.dart';

/// Reusable Bottom Navigation Bar for BoboNyenyak.
///
/// Provides consistent dark theme navigation across screens:
/// - 0: Home
/// - 1: History
/// - 2: Trends
/// - 3: Settings
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
    const bgDark = Color(0xFF0F1528);
    const borderColor = Color(0xFF1E2846);
    const accentYellow = Color(0xFFFBBF24);

    return Container(
      decoration: const BoxDecoration(
        color: bgDark,
        border: Border(top: BorderSide(color: borderColor, width: 1)),
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        backgroundColor: bgDark,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: accentYellow,
        unselectedItemColor: Colors.white38,
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
