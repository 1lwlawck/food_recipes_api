import 'package:flutter/material.dart';
import 'package:food_recipes_task/models/recipe_model.dart';
import 'package:food_recipes_task/services/recipe_services.dart';

class RecipeDetailScreen extends StatefulWidget {
  final int recipeId;

  RecipeDetailScreen({required this.recipeId});

  @override
  _RecipeDetailScreenState createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  late Future<RecipeModel> recipeDetail;
  bool isLiked = false;

  final Color primaryColor = Color(0xFF2A3663);
  final Color cardColor = Color(0xFF3C4A8E);
  final Color accentColor = Colors.white;

  @override
  void initState() {
    super.initState();
    recipeDetail = RecipeService().getRecipeDetail(widget.recipeId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(
          'Recipe Detail',
          style: TextStyle(color: accentColor),
        ),
        iconTheme: IconThemeData(color: accentColor),
      ),
      body: FutureBuilder<RecipeModel>(
        future: recipeDetail,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(accentColor),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(color: Colors.redAccent),
              ),
            );
          } else if (snapshot.hasData) {
            RecipeModel recipe = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                color: cardColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                elevation: 8.0,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Gambar resep
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                          child: Image.network(
                            recipe.photoUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Icon(Icons.broken_image, color: accentColor),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Judul resep
                      Text(
                        recipe.title,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: accentColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Rating dan komentar
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.star,
                              color: Colors.yellow[600],
                            ),
                            onPressed: () {
                              setState(() {
                                isLiked = !isLiked;
                              });
                            },
                          ),
                          Text(
                            '${recipe.likesCount + (isLiked ? 1 : 0)} likes',
                            style: TextStyle(color: accentColor),
                          ),
                          const SizedBox(width: 16),
                          Icon(Icons.comment, color: Colors.white70),
                          SizedBox(width: 4),
                          Text(
                            '${recipe.commentsCount} comments',
                            style: TextStyle(color: accentColor),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Description
                      Text(
                        'Description:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: accentColor,
                        ),
                      ),
                      Text(
                        recipe.description,
                        style: TextStyle(color: accentColor),
                      ),
                      const SizedBox(height: 16),
                      // Ingredients
                      Text(
                        'Ingredients:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: accentColor,
                        ),
                      ),
                      Text(
                        recipe.ingredients,
                        style: TextStyle(color: accentColor),
                      ),
                      const SizedBox(height: 16),
                      // Cooking Method
                      Text(
                        'Cooking Method:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: accentColor,
                        ),
                      ),
                      Text(
                        recipe.cookingMethod,
                        style: TextStyle(color: accentColor),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Center(
              child: Text(
                'No data available.',
                style: TextStyle(color: accentColor),
              ),
            );
          }
        },
      ),
    );
  }
}
