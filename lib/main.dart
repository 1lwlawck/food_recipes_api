import 'package:flutter/material.dart';
import 'package:food_recipes_task/ui/add_recipe_screen.dart';
import 'package:food_recipes_task/ui/detail_screen.dart';
import 'package:food_recipes_task/ui/home_screen.dart';
import 'package:food_recipes_task/ui/login_screen.dart';
import 'package:food_recipes_task/ui/register_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/home': (context) => HomeScreen(),
        '/recipeDetail': (context) => RecipeDetailScreen(
              recipeId: ModalRoute.of(context)!.settings.arguments as int,
            ),
        '/addRecipe': (context) => AddRecipeScreen(),
      },
    );
  }
}
