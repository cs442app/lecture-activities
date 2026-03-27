import 'package:flutter/material.dart';
import 'models.dart';

const kRecipes = <Recipe>[
  Recipe(
    id: 'pancakes',
    title: 'Classic Buttermilk Pancakes',
    description:
        'Light, fluffy pancakes with a golden crust. A weekend breakfast staple that comes together in minutes.',
    category: RecipeCategory.breakfast,
    prepMinutes: 10,
    cookMinutes: 20,
    defaultServings: 4,
    rating: 4.8,
    reviewCount: 312,
    accentColor: Color(0xFFF4A843),
    isVegetarian: true,
    ingredients: [
      Ingredient(name: 'all-purpose flour', amount: 2, unit: 'cups'),
      Ingredient(name: 'buttermilk', amount: 2, unit: 'cups'),
      Ingredient(name: 'eggs', amount: 2, unit: ''),
      Ingredient(name: 'unsalted butter, melted', amount: 4, unit: 'tbsp'),
      Ingredient(name: 'sugar', amount: 2, unit: 'tbsp'),
      Ingredient(name: 'baking powder', amount: 2, unit: 'tsp'),
      Ingredient(name: 'baking soda', amount: 0.5, unit: 'tsp'),
      Ingredient(name: 'salt', amount: 0.5, unit: 'tsp'),
    ],
    steps: [
      RecipeStep(
          instruction:
              'Whisk together flour, sugar, baking powder, baking soda, and salt in a large bowl.'),
      RecipeStep(
          instruction:
              'In a separate bowl, whisk buttermilk, eggs, and melted butter together.'),
      RecipeStep(
          instruction:
              'Pour the wet ingredients into the dry ingredients and stir until just combined — a few lumps are fine. Do not overmix.',
          durationMinutes: 2),
      RecipeStep(
          instruction:
              'Heat a non-stick skillet or griddle over medium heat. Pour ¼ cup batter per pancake. Cook until bubbles form on the surface and edges look set, about 2–3 minutes.',
          durationMinutes: 3),
      RecipeStep(
          instruction:
              'Flip and cook the other side until golden brown, about 1–2 minutes. Serve immediately.',
          durationMinutes: 2),
    ],
  ),
  Recipe(
    id: 'avocado_toast',
    title: 'Smashed Avocado Toast',
    description:
        'Creamy avocado on toasted sourdough with a lemony kick. Ready in under 10 minutes and endlessly customizable.',
    category: RecipeCategory.breakfast,
    prepMinutes: 5,
    cookMinutes: 5,
    defaultServings: 2,
    rating: 4.5,
    reviewCount: 184,
    accentColor: Color(0xFF7CB67A),
    isVegetarian: true,
    isGlutenFree: false,
    ingredients: [
      Ingredient(name: 'thick sourdough slices', amount: 2, unit: ''),
      Ingredient(name: 'ripe avocados', amount: 2, unit: ''),
      Ingredient(name: 'lemon juice', amount: 1, unit: 'tbsp'),
      Ingredient(name: 'red pepper flakes', amount: 0.5, unit: 'tsp'),
      Ingredient(name: 'flaky sea salt', amount: 0.5, unit: 'tsp'),
      Ingredient(name: 'olive oil', amount: 1, unit: 'tbsp'),
    ],
    steps: [
      RecipeStep(
          instruction:
              'Toast the sourdough slices until golden and crisp.',
          durationMinutes: 3),
      RecipeStep(
          instruction:
              'Halve and pit the avocados. Scoop the flesh into a bowl and add lemon juice and a pinch of salt.'),
      RecipeStep(
          instruction:
              'Smash with a fork to your preferred texture — some prefer chunky, some smooth.'),
      RecipeStep(
          instruction:
              'Spread generously over the toast. Drizzle with olive oil, sprinkle with red pepper flakes and flaky salt.'),
    ],
  ),
  Recipe(
    id: 'carbonara',
    title: 'Spaghetti Carbonara',
    description:
        'A Roman classic made with eggs, Pecorino Romano, guanciale, and black pepper. Rich, silky, and no cream required.',
    category: RecipeCategory.mains,
    prepMinutes: 10,
    cookMinutes: 20,
    defaultServings: 4,
    rating: 4.9,
    reviewCount: 541,
    accentColor: Color(0xFFD4A96A),
    ingredients: [
      Ingredient(name: 'spaghetti', amount: 400, unit: 'g'),
      Ingredient(name: 'guanciale or pancetta', amount: 200, unit: 'g'),
      Ingredient(name: 'eggs', amount: 4, unit: ''),
      Ingredient(name: 'egg yolks', amount: 2, unit: ''),
      Ingredient(name: 'Pecorino Romano, finely grated', amount: 100, unit: 'g'),
      Ingredient(name: 'freshly ground black pepper', amount: 2, unit: 'tsp'),
      Ingredient(name: 'salt', amount: 1, unit: 'tsp'),
    ],
    steps: [
      RecipeStep(
          instruction:
              'Bring a large pot of salted water to a boil. Cook spaghetti until al dente according to package directions. Reserve 1 cup of pasta water before draining.',
          durationMinutes: 10),
      RecipeStep(
          instruction:
              'While pasta cooks, render guanciale in a large cold skillet over medium heat until crispy and the fat has rendered, about 8 minutes.',
          durationMinutes: 8),
      RecipeStep(
          instruction:
              'Whisk together eggs, yolks, most of the cheese, and a generous amount of black pepper in a bowl.'),
      RecipeStep(
          instruction:
              'Remove the skillet from heat. Add drained pasta and toss with the rendered fat.'),
      RecipeStep(
          instruction:
              'Off heat, pour the egg mixture over the pasta and toss rapidly, adding pasta water a splash at a time until a glossy, creamy sauce forms. Serve immediately with remaining cheese.'),
    ],
  ),
  Recipe(
    id: 'roast_chicken',
    title: 'Lemon Herb Roast Chicken',
    description:
        'A whole chicken roasted with lemon, garlic, and fresh herbs. Crispy skin, juicy meat, and effortless elegance.',
    category: RecipeCategory.mains,
    prepMinutes: 15,
    cookMinutes: 75,
    defaultServings: 4,
    rating: 4.7,
    reviewCount: 298,
    accentColor: Color(0xFFD17A3B),
    isGlutenFree: true,
    ingredients: [
      Ingredient(name: 'whole chicken', amount: 1.5, unit: 'kg'),
      Ingredient(name: 'lemon', amount: 1, unit: ''),
      Ingredient(name: 'garlic cloves', amount: 6, unit: ''),
      Ingredient(name: 'fresh thyme sprigs', amount: 4, unit: ''),
      Ingredient(name: 'fresh rosemary sprigs', amount: 2, unit: ''),
      Ingredient(name: 'olive oil', amount: 3, unit: 'tbsp'),
      Ingredient(name: 'salt', amount: 1.5, unit: 'tsp'),
      Ingredient(name: 'black pepper', amount: 1, unit: 'tsp'),
    ],
    steps: [
      RecipeStep(
          instruction:
              'Preheat oven to 220°C (425°F). Pat the chicken dry with paper towels — this is essential for crispy skin.'),
      RecipeStep(
          instruction:
              'Rub the outside and under the breast skin with olive oil, salt, and pepper. Stuff the cavity with the halved lemon, garlic cloves, and half the herbs.'),
      RecipeStep(
          instruction:
              'Place breast-side up in a roasting pan. Scatter remaining herbs around the bird.'),
      RecipeStep(
          instruction:
              'Roast for 20 minutes at high heat to crisp the skin, then reduce to 190°C (375°F) and roast for another 50–55 minutes until juices run clear.',
          durationMinutes: 75),
      RecipeStep(
          instruction:
              'Rest the chicken uncovered for 10 minutes before carving.',
          durationMinutes: 10),
    ],
  ),
  Recipe(
    id: 'stir_fry',
    title: 'Tofu & Vegetable Stir-Fry',
    description:
        'Crispy tofu and vibrant vegetables in a savory ginger-soy glaze. Ready in 25 minutes, naturally gluten-free with tamari.',
    category: RecipeCategory.mains,
    prepMinutes: 15,
    cookMinutes: 15,
    defaultServings: 2,
    rating: 4.4,
    reviewCount: 167,
    accentColor: Color(0xFF6BAF8A),
    isVegetarian: true,
    isGlutenFree: true,
    ingredients: [
      Ingredient(name: 'firm tofu, pressed', amount: 400, unit: 'g'),
      Ingredient(name: 'broccoli florets', amount: 200, unit: 'g'),
      Ingredient(name: 'red bell pepper, sliced', amount: 1, unit: ''),
      Ingredient(name: 'snap peas', amount: 100, unit: 'g'),
      Ingredient(name: 'tamari or soy sauce', amount: 3, unit: 'tbsp'),
      Ingredient(name: 'sesame oil', amount: 1, unit: 'tbsp'),
      Ingredient(name: 'fresh ginger, grated', amount: 1, unit: 'tbsp'),
      Ingredient(name: 'garlic cloves, minced', amount: 3, unit: ''),
      Ingredient(name: 'cornstarch', amount: 1, unit: 'tbsp'),
    ],
    steps: [
      RecipeStep(
          instruction:
              'Cut pressed tofu into 2 cm cubes. Toss with 1 tbsp tamari and the cornstarch until evenly coated.'),
      RecipeStep(
          instruction:
              'Heat 2 tbsp oil in a wok or large skillet over high heat. Fry tofu undisturbed for 3–4 minutes per side until golden and crispy. Remove and set aside.',
          durationMinutes: 8),
      RecipeStep(
          instruction:
              'In the same wok, stir-fry garlic and ginger for 30 seconds until fragrant. Add broccoli and pepper, stir-fry for 3–4 minutes.',
          durationMinutes: 4),
      RecipeStep(
          instruction:
              'Add snap peas and the remaining tamari and sesame oil. Toss for 1 minute.'),
      RecipeStep(
          instruction:
              'Return tofu to the wok, toss everything together, and serve immediately over steamed rice.'),
    ],
  ),
  Recipe(
    id: 'lava_cake',
    title: 'Chocolate Lava Cakes',
    description:
        'Individual molten chocolate cakes with a gooey, flowing center. Impressive and deceptively simple to make.',
    category: RecipeCategory.desserts,
    prepMinutes: 15,
    cookMinutes: 12,
    defaultServings: 4,
    rating: 4.9,
    reviewCount: 423,
    accentColor: Color(0xFF5C3D2E),
    isVegetarian: true,
    ingredients: [
      Ingredient(name: 'dark chocolate (70%), chopped', amount: 200, unit: 'g'),
      Ingredient(name: 'unsalted butter', amount: 100, unit: 'g'),
      Ingredient(name: 'eggs', amount: 4, unit: ''),
      Ingredient(name: 'egg yolks', amount: 4, unit: ''),
      Ingredient(name: 'caster sugar', amount: 100, unit: 'g'),
      Ingredient(name: 'all-purpose flour', amount: 40, unit: 'g'),
      Ingredient(name: 'cocoa powder, for dusting', amount: 2, unit: 'tsp'),
    ],
    steps: [
      RecipeStep(
          instruction:
              'Preheat oven to 200°C (400°F). Butter four 175ml ramekins and dust with cocoa powder. Tap out excess.'),
      RecipeStep(
          instruction:
              'Melt chocolate and butter together in a heatproof bowl over simmering water, stirring until smooth. Remove from heat.',
          durationMinutes: 5),
      RecipeStep(
          instruction:
              'Whisk eggs, yolks, and sugar together until thick and pale, about 3 minutes.',
          durationMinutes: 3),
      RecipeStep(
          instruction:
              'Fold the chocolate mixture into the egg mixture, then fold in the flour until just combined.'),
      RecipeStep(
          instruction:
              'Divide batter among ramekins. Bake for 10–12 minutes — the edges should be set but the center should wobble. Run a knife around the edge and invert onto plates immediately.',
          durationMinutes: 12),
    ],
  ),
  Recipe(
    id: 'banana_bread',
    title: 'Brown Butter Banana Bread',
    description:
        'Extra moist banana bread made with brown butter for a nutty, caramel depth. Best made with very ripe bananas.',
    category: RecipeCategory.desserts,
    prepMinutes: 15,
    cookMinutes: 65,
    defaultServings: 10,
    rating: 4.6,
    reviewCount: 289,
    accentColor: Color(0xFFB8873A),
    isVegetarian: true,
    ingredients: [
      Ingredient(name: 'very ripe bananas', amount: 3, unit: ''),
      Ingredient(name: 'unsalted butter', amount: 115, unit: 'g'),
      Ingredient(name: 'brown sugar', amount: 150, unit: 'g'),
      Ingredient(name: 'eggs', amount: 2, unit: ''),
      Ingredient(name: 'vanilla extract', amount: 1, unit: 'tsp'),
      Ingredient(name: 'all-purpose flour', amount: 190, unit: 'g'),
      Ingredient(name: 'baking soda', amount: 1, unit: 'tsp'),
      Ingredient(name: 'salt', amount: 0.5, unit: 'tsp'),
    ],
    steps: [
      RecipeStep(
          instruction:
              'Preheat oven to 175°C (350°F). Grease a 23×13 cm loaf pan.'),
      RecipeStep(
          instruction:
              'Brown the butter: melt in a light-colored pan over medium heat, swirling frequently until the foam subsides and the milk solids turn golden brown and smell nutty. Pour into a large bowl and cool slightly.',
          durationMinutes: 6),
      RecipeStep(
          instruction:
              'Mash bananas into the brown butter until mostly smooth. Whisk in sugar, eggs, and vanilla.'),
      RecipeStep(
          instruction:
              'Add flour, baking soda, and salt. Stir until just combined — do not overmix.'),
      RecipeStep(
          instruction:
              'Pour into the prepared pan and bake for 60–65 minutes until a skewer inserted in the center comes out with just a few moist crumbs.',
          durationMinutes: 65),
    ],
  ),
  Recipe(
    id: 'granola',
    title: 'Maple Pecan Granola',
    description:
        'Crispy, clumpy granola sweetened with maple syrup and loaded with pecans. Perfect over yogurt or eaten by the handful.',
    category: RecipeCategory.breakfast,
    prepMinutes: 10,
    cookMinutes: 35,
    defaultServings: 8,
    rating: 4.7,
    reviewCount: 211,
    accentColor: Color(0xFFC8956A),
    isVegetarian: true,
    isGlutenFree: true,
    ingredients: [
      Ingredient(name: 'rolled oats', amount: 300, unit: 'g'),
      Ingredient(name: 'pecans, roughly chopped', amount: 120, unit: 'g'),
      Ingredient(name: 'maple syrup', amount: 80, unit: 'ml'),
      Ingredient(name: 'coconut oil, melted', amount: 60, unit: 'ml'),
      Ingredient(name: 'brown sugar', amount: 2, unit: 'tbsp'),
      Ingredient(name: 'vanilla extract', amount: 1, unit: 'tsp'),
      Ingredient(name: 'cinnamon', amount: 1, unit: 'tsp'),
      Ingredient(name: 'salt', amount: 0.5, unit: 'tsp'),
    ],
    steps: [
      RecipeStep(
          instruction:
              'Preheat oven to 160°C (325°F). Line a large rimmed baking sheet with parchment.'),
      RecipeStep(
          instruction:
              'Combine oats and pecans in a large bowl. In a small bowl, whisk together maple syrup, coconut oil, brown sugar, vanilla, cinnamon, and salt.'),
      RecipeStep(
          instruction:
              'Pour the wet mixture over the oats and stir thoroughly until every oat is coated.'),
      RecipeStep(
          instruction:
              'Spread in an even layer on the prepared baking sheet. Press down firmly with a spatula — this encourages clumping. Do not stir during baking.',
          durationMinutes: 35),
      RecipeStep(
          instruction:
              'Bake for 30–35 minutes until deep golden. Cool completely on the pan before breaking into clusters. Stores in an airtight container for up to 2 weeks.'),
    ],
  ),
];
