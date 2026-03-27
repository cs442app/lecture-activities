import 'package:flutter/material.dart';

enum RecipeCategory { breakfast, mains, desserts, snacks }

extension RecipeCategoryX on RecipeCategory {
  String get label => switch (this) {
        RecipeCategory.breakfast => 'Breakfast',
        RecipeCategory.mains => 'Mains',
        RecipeCategory.desserts => 'Desserts',
        RecipeCategory.snacks => 'Snacks',
      };

  IconData get icon => switch (this) {
        RecipeCategory.breakfast => Icons.free_breakfast,
        RecipeCategory.mains => Icons.restaurant,
        RecipeCategory.desserts => Icons.cake,
        RecipeCategory.snacks => Icons.apple,
      };
}

class Ingredient {
  const Ingredient({
    required this.name,
    required this.amount,
    required this.unit,
  });

  final String name;
  final double amount;
  final String unit; // empty string for unitless amounts (e.g. "2 eggs")

  String displayFor(int servings, int defaultServings) {
    final scaled = amount * servings / defaultServings;
    final formatted = scaled == scaled.roundToDouble()
        ? scaled.toInt().toString()
        : scaled.toStringAsFixed(1);
    return unit.isEmpty ? '$formatted $name' : '$formatted $unit $name';
  }
}

class RecipeStep {
  const RecipeStep({required this.instruction, this.durationMinutes});

  final String instruction;
  final int? durationMinutes;
}

class Recipe {
  const Recipe({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.prepMinutes,
    required this.cookMinutes,
    required this.defaultServings,
    required this.rating,
    required this.reviewCount,
    required this.ingredients,
    required this.steps,
    required this.accentColor,
    this.isVegetarian = false,
    this.isGlutenFree = false,
  });

  final String id;
  final String title;
  final String description;
  final RecipeCategory category;
  final int prepMinutes;
  final int cookMinutes;
  final int defaultServings;
  final double rating;
  final int reviewCount;
  final List<Ingredient> ingredients;
  final List<RecipeStep> steps;
  final Color accentColor;
  final bool isVegetarian;
  final bool isGlutenFree;

  int get totalMinutes => prepMinutes + cookMinutes;
}
