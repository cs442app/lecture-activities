// ignore_for_file: unused_import, unused_element
import 'package:flutter/material.dart';

import 'models.dart';

class RecipeDetailScreen extends StatefulWidget {
  const RecipeDetailScreen({super.key, required this.recipe});

  final Recipe recipe;

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  // Current serving count — adjusted by the slider in Ex 1.3 / 2.2.
  late int _servings;

  @override
  void initState() {
    super.initState();
    _servings = widget.recipe.defaultServings;
  }

  // ===========================================================================
  // Build
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    final recipe = widget.recipe;

    return Scaffold(
      // -----------------------------------------------------------------------
      // TODO (Ex 1.3 — Part C): Wrap this Scaffold's body in a SafeArea.
      //
      // Use SafeArea(top: false, child: ...) so the AppBar continues to extend
      // into the status bar notch area (the AppBar handles top padding itself),
      // but the bottom of the scroll content clears the home indicator.
      //
      // Verify by running on a device or simulator with a home indicator — the
      // last ingredient/step should not be hidden behind it.
      // -----------------------------------------------------------------------
      appBar: AppBar(
        title: Text(recipe.title),
        backgroundColor: recipe.accentColor,
        foregroundColor: Colors.white,
      ),
      body: _buildBody(recipe),
    );
  }

  // ---------------------------------------------------------------------------
  // TODO (Ex 1.2): Implement a two-pane layout for wide screens.
  //
  // Wrap this method's return value in a LayoutBuilder. Inside the builder:
  //
  //   if (constraints.maxWidth >= 720):
  //     return Row(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Expanded(flex: 2, child: _buildInfoPanel(recipe)),
  //         const VerticalDivider(width: 1),
  //         Expanded(flex: 3, child: _buildRecipePanel(recipe)),
  //       ],
  //     );
  //   else:
  //     return _buildNarrowLayout(recipe);  // existing single-column layout
  //
  // The left panel (flex: 2) shows the hero image, title, and meta information.
  // The right panel (flex: 3) shows the tabbed ingredients + steps view.
  //
  // Use MediaQuery.of(context).size.width instead of LayoutBuilder if you
  // prefer — both are appropriate here since RecipeDetailScreen fills the
  // screen. LayoutBuilder is slightly more reusable; MediaQuery is simpler.
  //
  // Widen the browser window past 720 dp to verify the side-by-side layout.
  // ---------------------------------------------------------------------------
  Widget _buildBody(Recipe recipe) {
    // Baseline — single-column layout always. Replace with LayoutBuilder above.
    return _buildNarrowLayout(recipe);
  }

  // Single-column layout (narrow screens and baseline).
  Widget _buildNarrowLayout(Recipe recipe) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _buildHeroImage(recipe)),
        SliverToBoxAdapter(child: _buildMetaRow(recipe)),
        SliverToBoxAdapter(child: _buildServingsControl(recipe)),
        SliverToBoxAdapter(
          child: _SectionHeader(title: 'Ingredients'),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, i) => _IngredientRow(
              ingredient: recipe.ingredients[i],
              servings: _servings,
              defaultServings: recipe.defaultServings,
            ),
            childCount: recipe.ingredients.length,
          ),
        ),
        SliverToBoxAdapter(
          child: _SectionHeader(title: 'Steps'),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, i) => _StepTile(
              stepNumber: i + 1,
              step: recipe.steps[i],
            ),
            childCount: recipe.steps.length,
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 32)),
      ],
    );
  }

  // Left pane: hero + meta info (used in two-pane layout, Ex 1.2).
  Widget _buildInfoPanel(Recipe recipe) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeroImage(recipe),
          _buildMetaRow(recipe),
          _buildServingsControl(recipe),
        ],
      ),
    );
  }

  // Right pane: tabbed ingredients + steps (used in two-pane layout, Ex 1.2).
  Widget _buildRecipePanel(Recipe recipe) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(tabs: [
            Tab(text: 'Ingredients'),
            Tab(text: 'Steps'),
          ]),
          Expanded(
            child: TabBarView(
              children: [
                ListView(
                  padding: const EdgeInsets.only(bottom: 32),
                  children: [
                    for (final ing in recipe.ingredients)
                      _IngredientRow(
                        ingredient: ing,
                        servings: _servings,
                        defaultServings: recipe.defaultServings,
                      ),
                  ],
                ),
                ListView(
                  padding: const EdgeInsets.only(bottom: 32),
                  children: [
                    for (int i = 0; i < recipe.steps.length; i++)
                      _StepTile(stepNumber: i + 1, step: recipe.steps[i]),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Hero image
  // ---------------------------------------------------------------------------

  // ---------------------------------------------------------------------------
  // TODO (Ex 1.3 — Part A): Replace the fixed-height SizedBox with AspectRatio.
  //
  // Currently the hero image container has a fixed height of 200 px. This
  // breaks on very small screens (overflow) and wastes space on large ones.
  //
  // Replace the SizedBox with:
  //   AspectRatio(
  //     aspectRatio: 16 / 9,
  //     child: Container(color: recipe.accentColor, child: Center(child: ...)),
  //   )
  //
  // On a phone in landscape, notice the image is now proportionally shorter.
  // On a wide browser window the image fills the panel width at the same ratio.
  // ---------------------------------------------------------------------------
  Widget _buildHeroImage(Recipe recipe) {
    // Baseline — fixed height. Replace with AspectRatio per TODO above.
    return SizedBox(
      height: 200,
      width: double.infinity,
      child: Container(
        color: recipe.accentColor,
        child: Center(
          child: Icon(
            recipe.category.icon,
            size: 72,
            color: Colors.white.withAlpha(200),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Meta row: rating, total time, category
  // ---------------------------------------------------------------------------
  Widget _buildMetaRow(Recipe recipe) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            recipe.title,
            style: theme.textTheme.headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.star, size: 16, color: Colors.amber),
              const SizedBox(width: 4),
              Text(
                '${recipe.rating} (${recipe.reviewCount} reviews)',
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.schedule, size: 16),
              const SizedBox(width: 4),
              Text(
                '${recipe.prepMinutes} min prep + ${recipe.cookMinutes} min cook',
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(recipe.category.icon, size: 16),
              const SizedBox(width: 4),
              Text(
                recipe.category.label,
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Servings control
  // ---------------------------------------------------------------------------

  // ---------------------------------------------------------------------------
  // TODO (Ex 2.2 — Part C): Replace the Slider below with Slider.adaptive.
  //
  //   Slider.adaptive(
  //     value: _servings.toDouble(),
  //     min: 1,
  //     max: 12,
  //     divisions: 11,
  //     label: '$_servings',
  //     onChanged: (v) => setState(() => _servings = v.round()),
  //   )
  //
  // This control is used in both the narrow layout and the wide info panel.
  // -------------------------------------------------------------------------
  Widget _buildServingsControl(Recipe recipe) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Servings: $_servings',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          // Baseline — non-adaptive Slider. Replace per TODO above.
          Slider(
            value: _servings.toDouble(),
            min: 1,
            max: 12,
            divisions: 11,
            label: '$_servings',
            onChanged: (v) => setState(() => _servings = v.round()),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// _SectionHeader — provided.

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  // ---------------------------------------------------------------------------
  // TODO (Ex 3.2 — Part C): Add Semantics(header: true) around the Text.
  //
  //   Semantics(
  //     header: true,
  //     child: Text(title, style: ...),
  //   )
  //
  // The `header: true` flag tells assistive technologies to treat this as a
  // section heading, allowing users to jump between sections by heading.
  // ---------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
      // Baseline — plain Text. Wrap in Semantics per TODO above.
      child: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .titleMedium
            ?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}

// =============================================================================
// _IngredientRow — provided skeleton; students add MergeSemantics in Ex 3.2.

class _IngredientRow extends StatelessWidget {
  const _IngredientRow({
    required this.ingredient,
    required this.servings,
    required this.defaultServings,
  });

  final Ingredient ingredient;
  final int servings;
  final int defaultServings;

  // ---------------------------------------------------------------------------
  // TODO (Ex 3.2 — Part A): Wrap the Row below in MergeSemantics.
  //
  //   MergeSemantics(child: Row( ... ))
  //
  // Without MergeSemantics, a screen reader announces each child separately:
  // "image" → "2 cups" → "all-purpose flour" — three focus stops per ingredient.
  // With MergeSemantics, the entire row becomes one node, announced as a unit.
  //
  // ---------------------------------------------------------------------------
  // TODO (Ex 3.2 — Part B): Wrap the leading Icon in ExcludeSemantics.
  //
  //   ExcludeSemantics(child: Icon(Icons.fiber_manual_record, ...))
  //
  // The bullet icon is decorative — it conveys no information. Excluding it
  // prevents the screen reader from announcing "image" before each ingredient.
  // ---------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final text = ingredient.displayFor(servings, defaultServings);
    // Baseline — unmerged row. Apply MergeSemantics + ExcludeSemantics per TODOs.
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        children: [
          Icon(
            Icons.fiber_manual_record,
            size: 8,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

// =============================================================================
// _StepTile — provided skeleton; students add Semantics label in Ex 3.2.

class _StepTile extends StatelessWidget {
  const _StepTile({required this.stepNumber, required this.step});

  final int stepNumber;
  final RecipeStep step;

  // ---------------------------------------------------------------------------
  // TODO (Ex 3.2 — Part D): Wrap the ListTile below in a Semantics widget.
  //
  //   Semantics(
  //     label: 'Step $stepNumber: ${step.instruction}',
  //     child: ListTile( ... ),
  //   )
  //
  // Without this, the screen reader announces the step number circle and the
  // instruction text as separate nodes. The explicit label unifies them into
  // one clear announcement.
  // ---------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 14,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        child: Text(
          '$stepNumber',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
      ),
      title: Text(step.instruction),
      subtitle: step.durationMinutes != null
          ? Text('~${step.durationMinutes} min')
          : null,
      isThreeLine: false,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }
}
