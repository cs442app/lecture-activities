import 'package:flutter/material.dart';

import 'data.dart';
import 'models.dart';
import 'recipe_detail_screen.dart';

/// A simple screen listing saved recipes. Provided — no TODOs here.
///
/// In a real app this would read from persistent storage; for this activity it
/// shows a hard-coded subset of the recipe list.
class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  static final _saved = kRecipes.where((r) =>
      const {'pancakes', 'carbonara', 'lava_cake'}.contains(r.id)).toList();

  @override
  Widget build(BuildContext context) {
    if (_saved.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.bookmark_outline, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No saved recipes yet.',
                style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: _saved.length,
      separatorBuilder: (context, _) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final recipe = _saved[index];
        return ListTile(
          leading: _RecipeSwatch(color: recipe.accentColor),
          title: Text(recipe.title),
          subtitle: Text(
            '${recipe.totalMinutes} min · ${recipe.category.label}',
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => RecipeDetailScreen(recipe: recipe),
            ),
          ),
        );
      },
    );
  }
}

class _RecipeSwatch extends StatelessWidget {
  const _RecipeSwatch({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
