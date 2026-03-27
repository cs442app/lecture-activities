// ignore_for_file: unused_import, unnecessary_import
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Dietary preference settings. Students add .adaptive controls in Ex 2.2.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _vegetarianOnly = false;
  bool _glutenFreeOnly = false;
  double _defaultServings = 2;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            'Dietary Preferences',
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        // -----------------------------------------------------------------------
        // TODO (Ex 2.2 — Part A): Replace the two Switch widgets below with
        // Switch.adaptive().
        //
        // Switch.adaptive has the same constructor parameters as Switch:
        //   Switch.adaptive(
        //     value: _vegetarianOnly,
        //     onChanged: (v) => setState(() => _vegetarianOnly = v),
        //   )
        //
        // On iOS/macOS it renders as a CupertinoSwitch; on other platforms it
        // renders as the standard Material Switch. The call site is identical.
        //
        // To see the difference:
        //   1. Run in Chrome and observe the Material appearance.
        //   2. Add `debugDefaultTargetPlatformOverride = TargetPlatform.iOS;`
        //      in main() and hot-reload. Notice the Cupertino appearance.
        //   3. Remove the override before continuing.
        // -----------------------------------------------------------------------
        SwitchListTile(
          title: const Text('Vegetarian only'),
          subtitle: const Text('Hide recipes that contain meat or fish'),
          value: _vegetarianOnly,
          onChanged: (v) => setState(() => _vegetarianOnly = v),
        ),
        SwitchListTile(
          title: const Text('Gluten-free only'),
          subtitle: const Text('Hide recipes that contain gluten'),
          value: _glutenFreeOnly,
          onChanged: (v) => setState(() => _glutenFreeOnly = v),
        ),

        const Divider(height: 32),

        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: Text(
            'Default Serving Size',
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            '${_defaultServings.round()} servings',
            style: theme.textTheme.bodyLarge,
          ),
        ),

        // -----------------------------------------------------------------------
        // TODO (Ex 2.2 — Part B): Replace the Slider below with Slider.adaptive().
        //
        // Slider.adaptive has the same API:
        //   Slider.adaptive(
        //     value: _defaultServings,
        //     min: 1,
        //     max: 12,
        //     divisions: 11,
        //     label: '${_defaultServings.round()}',
        //     onChanged: (v) => setState(() => _defaultServings = v),
        //   )
        //
        // On iOS/macOS it renders as a CupertinoSlider; on other platforms it
        // renders as the standard Material Slider.
        // -----------------------------------------------------------------------
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Slider(
            value: _defaultServings,
            min: 1,
            max: 12,
            divisions: 11,
            label: '${_defaultServings.round()}',
            onChanged: (v) => setState(() => _defaultServings = v),
          ),
        ),

        const SizedBox(height: 16),
      ],
    );
  }
}
