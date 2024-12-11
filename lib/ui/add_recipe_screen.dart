import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:food_recipes_task/services/recipe_services.dart';

class AddRecipeScreen extends StatefulWidget {
  @override
  _AddRecipeScreenState createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _cookingMethodController = TextEditingController();
  final _ingredientsController = TextEditingController();

  File? _image;
  final ImagePicker _picker = ImagePicker();
  bool isLoading = false;

  // Warna dominan
  final Color primaryColor = Color(0xFF2A3663);
  final Color cardColor = Color(0xFF3C4A8E);
  final Color accentColor = Colors.white;

  // Fungsi untuk memilih gambar dari galeri
  Future<void> _pickImageFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }

  // Fungsi untuk mengambil gambar dengan kamera
  Future<void> _pickImageFromCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }

  Future<void> _submitRecipe() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_image == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Harap unggah gambar untuk resep.')),
        );
        return;
      }

      setState(() {
        isLoading = true;
      });

      final response = await RecipeService().addRecipeWithImage(
        title: _titleController.text,
        description: _descriptionController.text,
        cookingMethod: _cookingMethodController.text,
        ingredients: _ingredientsController.text,
        imageFile: _image!,
      );

      setState(() {
        isLoading = false;
      });

      if (response['status']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Resep berhasil ditambahkan!')),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menambahkan resep: ${response['message']}'),
          ),
        );
      }
    }
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: accentColor),
      hintStyle: TextStyle(color: Colors.white70),
      filled: true,
      fillColor: Color(0xFF4A539E),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide.none,
      ),
      errorStyle: TextStyle(color: Colors.redAccent),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text("Tambah Resep", style: TextStyle(color: accentColor)),
        iconTheme: IconThemeData(color: accentColor),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(accentColor),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Card(
                  color: cardColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  elevation: 8.0,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _titleController,
                            style: TextStyle(color: accentColor),
                            decoration: _inputDecoration('Judul Resep'),
                            validator: (value) => value == null || value.isEmpty
                                ? 'Judul tidak boleh kosong'
                                : null,
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            controller: _descriptionController,
                            style: TextStyle(color: accentColor),
                            decoration: _inputDecoration('Deskripsi'),
                            validator: (value) => value == null || value.isEmpty
                                ? 'Deskripsi tidak boleh kosong'
                                : null,
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            controller: _cookingMethodController,
                            style: TextStyle(color: accentColor),
                            decoration: _inputDecoration('Metode Memasak'),
                            validator: (value) => value == null || value.isEmpty
                                ? 'Metode tidak boleh kosong'
                                : null,
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            controller: _ingredientsController,
                            style: TextStyle(color: accentColor),
                            decoration: _inputDecoration('Bahan-bahan'),
                            validator: (value) => value == null || value.isEmpty
                                ? 'Bahan tidak boleh kosong'
                                : null,
                          ),
                          SizedBox(height: 16),
                          _image != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(12.0),
                                  child: Image.file(
                                    _image!,
                                    width: 200,
                                    height: 200,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Text('Belum ada gambar yang dipilih',
                                  style: TextStyle(color: accentColor)),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: _pickImageFromGallery,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF1C213A),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                ),
                                child: Text('Pilih dari Galeri',
                                    style: TextStyle(color: accentColor)),
                              ),
                              ElevatedButton(
                                onPressed: _pickImageFromCamera,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF1C213A),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                ),
                                child: Text('Ambil Foto',
                                    style: TextStyle(color: accentColor)),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _submitRecipe,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF1C213A),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              minimumSize: Size(double.infinity, 50),
                            ),
                            child: Text(
                              "Tambah Resep",
                              style: TextStyle(
                                color: accentColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
