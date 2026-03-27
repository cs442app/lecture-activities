// ignore_for_file: unused_import, unused_element, unnecessary_import
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'recipe_list_screen.dart';
import 'favorites_screen.dart';
import 'settings_screen.dart';

// Navigation destinations shared across navigation widgets.
const _labels = ['Browse', 'Saved', 'Settings'];
const _icons = [
  Icons.restaurant_menu_outlined,
  Icons.bookmark_outline,
  Icons.tune_outlined,
];
const _activeIcons = [
  Icons.restaurant_menu,
  Icons.bookmark,
  Icons.tune,
];

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selectedIndex = 0;

  static const _pages = <Widget>[
    RecipeListScreen(),
    FavoritesScreen(),
    SettingsScreen(),
  ];

  // ---------------------------------------------------------------------------
  // TODO (Ex 2.1 — Part A): Implement _buildBottomNav()
  //
  // Return either a CupertinoTabBar or a NavigationBar based on platform:
  //
  //   if (defaultTargetPlatform == TargetPlatform.iOS) {
  //     return CupertinoTabBar(
  //       currentIndex: _selectedIndex,
  //       onTap: (i) => setState(() => _selectedIndex = i),
  //       items: [ /* one BottomNavigationBarItem per destination */ ],
  //     );
  //   }
  //   // otherwise: return a Material NavigationBar (see baseline below)
  //
  // CupertinoTabBar uses BottomNavigationBarItem (not NavigationDestination).
  // Each item needs an `icon` and a `label`.
  //
  // After implementing, test by adding this line to main() then hot-reloading:
  //   debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
  // You should see the iOS-style tab bar style change.
  // ---------------------------------------------------------------------------
  Widget _buildBottomNav() {
    // Baseline — always Material. Replace with platform branch above.
    return NavigationBar(
      selectedIndex: _selectedIndex,
      onDestinationSelected: (i) => setState(() => _selectedIndex = i),
      destinations: [
        for (int i = 0; i < _labels.length; i++)
          NavigationDestination(
            icon: Icon(_icons[i]),
            selectedIcon: Icon(_activeIcons[i]),
            label: _labels[i],
          ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // TODO (Ex 2.1 — Part B): Implement _buildNavigationRail()
  //
  // Return a NavigationRail showing all three destinations.
  // Use NavigationRailDestination (not NavigationDestination).
  //
  //   NavigationRail(
  //     selectedIndex: _selectedIndex,
  //     onDestinationSelected: (i) => setState(() => _selectedIndex = i),
  //     labelType: NavigationRailLabelType.all,
  //     destinations: [ /* one NavigationRailDestination per destination */ ],
  //   )
  //
  // Each destination needs an `icon`, `selectedIcon`, and `label` (a Widget).
  // ---------------------------------------------------------------------------
  Widget _buildNavigationRail() {
    // Baseline — invisible placeholder. Replace with NavigationRail above.
    return const SizedBox.shrink();
  }

  // ---------------------------------------------------------------------------
  // TODO (Ex 2.1 — Part C): Make build() responsive + adaptive
  //
  // Wrap the returned Scaffold in a LayoutBuilder. Use constraints.maxWidth:
  //
  //   if (constraints.maxWidth >= 800):
  //     Return a Scaffold whose body is:
  //       Row([
  //         _buildNavigationRail(),
  //         const VerticalDivider(width: 1),
  //         Expanded(child: _pages[_selectedIndex]),
  //       ])
  //     Do NOT pass a bottomNavigationBar.
  //
  //   else (narrow screen):
  //     Return the Scaffold below as-is (body + bottomNavigationBar).
  //
  // On wide screens the NavigationRail replaces the bottom nav entirely.
  // Try resizing the browser window (when running on Chrome/web) to verify
  // the transition at 800 dp.
  // ---------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    // Baseline — narrow layout only. Wrap in LayoutBuilder per TODO above.
    return Scaffold(
      appBar: AppBar(
        title: Text(_labels[_selectedIndex]),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: _buildBottomNav(),
    );
  }
}
