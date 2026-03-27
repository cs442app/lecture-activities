// ignore_for_file: unused_import, unused_field, unused_element, prefer_final_fields, unnecessary_import
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'data.dart';
import 'models.dart';
import 'recipe_detail_screen.dart';

class RecipeListScreen extends StatefulWidget {
  const RecipeListScreen({super.key});

  @override
  State<RecipeListScreen> createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  // Sort options used by Ex 2.3.
  static const _sortOptions = ['Rating', 'Prep Time', 'Cook Time'];
  String _selectedSort = 'Rating';

  List<Recipe> get _sortedRecipes {
    final list = List<Recipe>.from(kRecipes);
    switch (_selectedSort) {
      case 'Prep Time':
        list.sort((a, b) => a.prepMinutes.compareTo(b.prepMinutes));
      case 'Cook Time':
        list.sort((a, b) => a.cookMinutes.compareTo(b.cookMinutes));
      default:
        list.sort((a, b) => b.rating.compareTo(a.rating));
    }
    return list;
  }

  // -------------------------------------------------------------------------
  // TODO (Ex 2.3 — Part A): Implement _showSortSheet()
  //
  // Open a platform-appropriate sort picker when the filter button is tapped:
  //
  //   iOS:
  //     showCupertinoModalPopup(
  //       context: context,
  //       builder: (_) => CupertinoActionSheet(
  //         title: const Text('Sort by'),
  //         actions: [
  //           for (final option in _sortOptions)
  //             CupertinoActionSheetAction(
  //               onPressed: () {
  //                 setState(() => _selectedSort = option);
  //                 Navigator.of(context).pop();
  //               },
  //               child: Text(option),
  //             ),
  //         ],
  //         cancelButton: CupertinoActionSheetAction(
  //           isDestructiveAction: true,
  //           onPressed: () => Navigator.of(context).pop(),
  //           child: const Text('Cancel'),
  //         ),
  //       ),
  //     );
  //
  //   Android / web:
  //     showModalBottomSheet(
  //       context: context,
  //       builder: (_) => Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           const ListTile(title: Text('Sort by', style: TextStyle(fontWeight: FontWeight.bold))),
  //           for (final option in _sortOptions)
  //             ListTile(
  //               title: Text(option),
  //               trailing: _selectedSort == option ? const Icon(Icons.check) : null,
  //               onTap: () {
  //                 setState(() => _selectedSort = option);
  //                 Navigator.of(context).pop();
  //               },
  //             ),
  //           const SizedBox(height: 16),
  //         ],
  //       ),
  //     );
  //
  //   Desktop (macOS, Windows, Linux):
  //     showDialog(
  //       context: context,
  //       builder: (_) => SimpleDialog(
  //         title: const Text('Sort by'),
  //         children: [
  //           for (final option in _sortOptions)
  //             SimpleDialogOption(
  //               onPressed: () {
  //                 setState(() => _selectedSort = option);
  //                 Navigator.of(context).pop();
  //               },
  //               child: Text(option),
  //             ),
  //         ],
  //       ),
  //     );
  //
  // Branch using defaultTargetPlatform:
  //   final isIOS = defaultTargetPlatform == TargetPlatform.iOS;
  //   final isDesktop = defaultTargetPlatform == TargetPlatform.macOS
  //       || defaultTargetPlatform == TargetPlatform.windows
  //       || defaultTargetPlatform == TargetPlatform.linux;
  // -------------------------------------------------------------------------
  void _showSortSheet() {
    // Baseline — does nothing. Replace with platform branch above.
  }

  @override
  Widget build(BuildContext context) {
    final recipes = _sortedRecipes;

    return Column(
      children: [
        // Filter / sort bar
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 8, 4),
          child: Row(
            children: [
              Text(
                '${recipes.length} recipes · sorted by $_selectedSort',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.sort),
                tooltip: 'Sort recipes',
                onPressed: _showSortSheet,
              ),
            ],
          ),
        ),
        Expanded(
          child: _RecipeGrid(recipes: recipes),
        ),
      ],
    );
  }
}

// =============================================================================

class _RecipeGrid extends StatelessWidget {
  const _RecipeGrid({required this.recipes});

  final List<Recipe> recipes;

  // ---------------------------------------------------------------------------
  // TODO (Ex 1.1): Make the recipe list responsive using LayoutBuilder.
  //
  // Wrap the ListView.builder below in a LayoutBuilder. Inside the builder:
  //
  //   1. Compute the column count:
  //        final columns = (constraints.maxWidth / 300).floor().clamp(1, 4);
  //
  //   2. If columns == 1, return the existing ListView.builder.
  //
  //   3. If columns >= 2, return a GridView.builder instead:
  //        GridView.builder(
  //          padding: const EdgeInsets.all(12),
  //          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //            crossAxisCount: columns,
  //            mainAxisSpacing: 12,
  //            crossAxisSpacing: 12,
  //            childAspectRatio: 0.78,
  //          ),
  //          itemCount: recipes.length,
  //          itemBuilder: (context, index) =>
  //              _RecipeCard(recipe: recipes[index]),
  //        )
  //
  // Run the app in Chrome and resize the browser window to see the layout
  // switch between 1, 2, and 3 columns as the window narrows and widens.
  // ---------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    // Baseline — single-column list only. Wrap in LayoutBuilder per TODO above.
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: recipes.length,
      itemBuilder: (context, index) => _RecipeCard(recipe: recipes[index]),
    );
  }
}

// =============================================================================

class _RecipeCard extends StatefulWidget {
  const _RecipeCard({required this.recipe});

  final Recipe recipe;

  @override
  State<_RecipeCard> createState() => _RecipeCardState();
}

class _RecipeCardState extends State<_RecipeCard> {
  // Used by Ex 2.3 Part B for hover state.
  bool _hovered = false;

  void _openDetail() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RecipeDetailScreen(recipe: widget.recipe),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final recipe = widget.recipe;
    final theme = Theme.of(context);

    // -------------------------------------------------------------------------
    // TODO (Ex 2.3 — Part B): Wrap the Card below in a MouseRegion.
    //
    // MouseRegion fires callbacks when the pointer enters/exits the widget,
    // enabling hover effects on desktop and web.
    //
    //   MouseRegion(
    //     cursor: SystemMouseCursors.click,
    //     onEnter: (_) => setState(() => _hovered = true),
    //     onExit:  (_) => setState(() => _hovered = false),
    //     child: Card( ... ),   // the Card widget below
    //   )
    //
    // Then use _hovered to animate the card's elevation:
    //   elevation: _hovered ? 8 : 2
    //
    // Resize the browser to a wide layout (so the grid shows ≥2 columns) and
    // hover over cards to observe the elevation change on desktop/web.
    // -------------------------------------------------------------------------

    // -------------------------------------------------------------------------
    // TODO (Ex 3.1 — Part A): Wrap the InkWell below in a Semantics widget.
    //
    //   Semantics(
    //     label: '${recipe.title}. '
    //            '${recipe.totalMinutes} minutes. '
    //            'Rated ${recipe.rating} out of 5.',
    //     hint: 'Double-tap to view recipe',
    //     button: true,
    //     child: InkWell( ... ),   // the InkWell below
    //   )
    //
    // This merges all the visual sub-elements (image, title, meta text) into a
    // single, clearly-labeled node that a screen reader can announce as one unit.
    // -------------------------------------------------------------------------
    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: _openDetail,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Recipe image placeholder
            // -----------------------------------------------------------------
            // TODO (Ex 3.1 — Part B): Wrap the _RecipeHero below in an
            // ExcludeSemantics widget so the decorative color block is not
            // announced separately by the screen reader.
            //
            //   ExcludeSemantics(child: _RecipeHero(recipe: recipe))
            //
            // The Semantics label on the outer card already describes the recipe,
            // so announcing the image placeholder again would be redundant noise.
            // -----------------------------------------------------------------
            _RecipeHero(recipe: recipe),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.title,
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 14, color: Colors.amber),
                      const SizedBox(width: 2),
                      Text(
                        recipe.rating.toStringAsFixed(1),
                        style: theme.textTheme.bodySmall,
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.schedule, size: 14),
                      const SizedBox(width: 2),
                      Text(
                        '${recipe.totalMinutes} min',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 4,
                    children: [
                      if (recipe.isVegetarian)
                        _Badge(label: 'Vegetarian', color: Colors.green),
                      if (recipe.isGlutenFree)
                        _Badge(label: 'GF', color: Colors.blue),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// Supporting widgets — provided, no TODOs.

class _RecipeHero extends StatelessWidget {
  const _RecipeHero({required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        color: recipe.accentColor,
        child: Center(
          child: Icon(
            recipe.category.icon,
            size: 56,
            color: Colors.white.withAlpha(200),
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withAlpha(30),
        border: Border.all(color: color.withAlpha(100)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          color: color.withAlpha(220),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
