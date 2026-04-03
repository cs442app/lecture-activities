/// Provided shell — implement the TODOs marked with [Set 1] in this file.
library;

import 'package:flutter/material.dart';

import 'app_settings.dart';

/// Displays and edits the persisted user settings.
///
/// Loaded once in [initState]; saved to SharedPreferences when the user taps
/// "Save".
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key, required this.settings});

  final AppSettings settings;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _nameController = TextEditingController();
  int _dailyGoal = AppSettings.defaultDailyGoal;
  bool _saved = false;

  @override
  void initState() {
    super.initState();
    // ---- TODO 1.2a ---------------------------------------------------------
    // Pre-populate _nameController.text with the current displayName from
    // widget.settings, and set _dailyGoal to widget.settings.dailyGoal.
    // ------------------------------------------------------------------------
    // TODO 1.2a: pre-populate fields from widget.settings.
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    // ---- TODO 1.2b ---------------------------------------------------------
    // Persist the new values back to widget.settings:
    //   widget.settings.displayName = _nameController.text.trim();
    //   widget.settings.dailyGoal   = _dailyGoal;
    // Then set _saved = true via setState so the snack bar appears.
    // ------------------------------------------------------------------------
    // TODO 1.2b: persist values and show confirmation.
    setState(() => _saved = true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text('Profile',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Display name',
              hintText: 'Enter your name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 24),
          Text('Study goal',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text('Cards per day: $_dailyGoal'),
          Slider(
            value: _dailyGoal.toDouble(),
            min: 5,
            max: 50,
            divisions: 9,
            label: '$_dailyGoal',
            onChanged: (v) => setState(() => _dailyGoal = v.round()),
          ),
          const SizedBox(height: 32),
          FilledButton(
            onPressed: _save,
            child: const Text('Save'),
          ),
          if (_saved) ...[
            const SizedBox(height: 16),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle_outline, color: Colors.green),
                SizedBox(width: 8),
                Text('Settings saved.'),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
