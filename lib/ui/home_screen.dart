import 'package:flutter/material.dart';
import 'package:food_recipes_task/services/recipe_services.dart';
import 'package:food_recipes_task/models/recipe_model.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  RecipeService _recipeService = RecipeService();
  Future<void> _deleteRecipe(int id) async {
    try {
      await _recipeService.deleteRecipe(id);
      setState(() {
        recipes.removeWhere((recipe) => recipe.id == id);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Resep berhasil dihapus!")),
      );
    } catch (e) {
      print("Error deleting recipe: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal menghapus resep.")),
      );
    }
  }

  // Warna dominan dan tema
  final Color primaryColor = Color(0xFF2A3663);
  final Color cardColor = Color(0xFF3C4A8E);
  final Color accentColor = Colors.white;

  // Pagination variables
  int currentPage = 1;
  bool isLoading = false;
  bool hasMoreData = true;
  bool hasError = false;
  List<RecipeModel> recipes = [];

  @override
  void initState() {
    super.initState();
    _loadRecipes();
  }

  Future<void> _loadRecipes({bool isRefresh = false}) async {
    if (isLoading) return;

    if (isRefresh) {
      setState(() {
        currentPage = 1;
        recipes.clear();
        hasMoreData = true;
        hasError = false;
      });
    }

    setState(() {
      isLoading = true;
      hasError = false;
    });

    try {
      final newRecipes = await _recipeService.getRecipesByPage(currentPage);
      setState(() {
        if (isRefresh) recipes.clear();
        recipes.addAll(newRecipes);
        currentPage++;
        if (newRecipes.isEmpty) {
          hasMoreData = false;
        }
      });
    } catch (error) {
      setState(() {
        hasError = true;
      });
      print("Error loading recipes: $error");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(
          "Home - Halaman $currentPage",
          style: TextStyle(color: accentColor),
        ),
        iconTheme: IconThemeData(color: accentColor),
      ),
      body: RefreshIndicator(
        onRefresh: () => _loadRecipes(isRefresh: true),
        color: accentColor, // warna indikator refresh
        backgroundColor: cardColor,
        child: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (!isLoading &&
                hasMoreData &&
                scrollInfo.metrics.pixels ==
                    scrollInfo.metrics.maxScrollExtent) {
              _loadRecipes();
            }
            return false;
          },
          child: hasError
              ? _buildErrorWidget()
              : recipes.isEmpty && !isLoading
                  ? _buildEmptyDataWidget()
                  : Stack(
                      children: [
                        GridView.builder(
                          padding: const EdgeInsets.all(8.0),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            childAspectRatio: 0.75,
                          ),
                          itemCount: recipes.length,
                          itemBuilder: (context, index) {
                            final data = recipes[index];
                            return CustomCard(
                              id: data.id,
                              title: data.title,
                              img: data.photoUrl,
                              likes_count: data.likesCount,
                              comments_count: data.commentsCount,
                              onDelete: () => _deleteRecipe(data.id),
                              cardColor: cardColor,
                              accentColor: accentColor,
                            );
                          },
                        ),
                        if (isLoading) _buildLoadingOverlay(),
                      ],
                    ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF1C213A),
        onPressed: () {
          Navigator.pushNamed(context, '/addRecipe').then((value) {
            if (value == true) {
              _loadRecipes(isRefresh: true);
            }
          });
        },
        child: Icon(Icons.add, color: accentColor),
        tooltip: 'Tambah Resep',
      ),
    );
  }

  Widget _buildEmptyDataWidget() {
    return Center(
      child: Text(
        "Belum ada resep",
        style: TextStyle(color: accentColor, fontSize: 16),
      ),
    );
  }

  Widget _buildLoadingOverlay() {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(accentColor),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Gagal memuat data",
              style: TextStyle(fontSize: 16, color: Colors.redAccent)),
          SizedBox(height: 8),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF1C213A),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            onPressed: () => _loadRecipes(isRefresh: true),
            child: Text("Coba Lagi", style: TextStyle(color: accentColor)),
          ),
        ],
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  final String title;
  final String img;
  final int likes_count;
  final int comments_count;
  final int id;
  final VoidCallback onDelete;
  final Color cardColor;
  final Color accentColor;

  CustomCard({
    required this.id,
    required this.title,
    required this.img,
    required this.likes_count,
    required this.comments_count,
    required this.onDelete,
    required this.cardColor,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/recipeDetail', arguments: id);
          },
          child: SizedBox(
            height: constraints.maxWidth * 1.2,
            child: Card(
              color: cardColor,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: constraints.maxWidth * 0.6,
                    child: Image.network(
                      img,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Icon(Icons.broken_image, color: accentColor),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: accentColor,
                            ),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Likes
                              Row(
                                children: [
                                  Icon(Icons.star,
                                      color: Colors.yellow, size: 16),
                                  SizedBox(width: 4),
                                  Text("$likes_count",
                                      style: TextStyle(color: accentColor)),
                                ],
                              ),
                              // Comments
                              Row(
                                children: [
                                  Icon(Icons.comment,
                                      color: Colors.white70, size: 16),
                                  SizedBox(width: 4),
                                  Text("$comments_count",
                                      style: TextStyle(color: accentColor)),
                                ],
                              ),
                              // Tombol Hapus
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: onDelete,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
