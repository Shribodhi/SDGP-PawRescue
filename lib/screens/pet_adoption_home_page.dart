import 'package:flutter/material.dart';
import '../widgets/pet_card.dart';

class PetAdoptionHomePage extends StatefulWidget {
  const PetAdoptionHomePage({super.key});

  @override
  _PetAdoptionHomePageState createState() => _PetAdoptionHomePageState();
}

class _PetAdoptionHomePageState extends State<PetAdoptionHomePage> {
  final List<Map<String, String>> allPets = [
    {"image": "assets/mother_puppies.jpg", "title": "A mother with puppies", "subtitle": "Dehiwala", "age": "45", "category": "dog"},
    {"image": "assets/adorable_puppies.jpg", "title": "Adorable Puppies", "subtitle": "Dehiwala", "age": "30", "category": "dog"},
    {"image": "assets/twin_kittens.jpg", "title": "Twin Kitten", "subtitle": "Dehiwala", "age": "55", "category": "cat"},
    {"image": "assets/middle_aged_cat.jpg", "title": "Middle aged cat", "subtitle": "Dehiwala", "age": "48", "category": "cat"},
    {"image": "assets/young_puppy.jpg", "title": "Young Puppy", "subtitle": "Colombo", "age": "25", "category": "dog"},
    {"image": "assets/cute_kitten.jpg", "title": "Cute Kitten", "subtitle": "Negombo", "age": "40", "category": "cat"},
    {"image": "assets/playful_dog.jpg", "title": "Playful Dog", "subtitle": "Galle", "age": "60", "category": "dog"},
    {"image": "assets/stray_dog.jpg", "title": "Stray Dog", "subtitle": "Kandy", "age": "35", "category": "dog"},
  ];

  String selectedCategory = "all"; // Default category
  String searchQuery = "";

  List<Map<String, String>> get filteredPets {
    return allPets.where((pet) {
      final matchesCategory = selectedCategory == "all" || pet["category"] == selectedCategory;
      final matchesSearch = pet["title"]!.toLowerCase().contains(searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Street to Sweet Home"),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: "Search pets...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
            const SizedBox(height: 10),

            // Category Filter Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildCategoryButton("All", "all"),
                _buildCategoryButton("Dogs", "dog"),
                _buildCategoryButton("Cats", "cat"),
              ],
            ),
            const SizedBox(height: 10),

            // Pet Grid
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.75,
                ),
                itemCount: filteredPets.length,
                itemBuilder: (context, index) {
                  final pet = filteredPets[index];
                  return PetCard(
                    image: pet["image"]!,
                    title: pet["title"]!,
                    subtitle: pet["subtitle"]!,
                    age: pet["age"]!,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryButton(String text, String category) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            selectedCategory = category;
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: selectedCategory == category ? Colors.orange : Colors.grey[300],
          foregroundColor: selectedCategory == category ? Colors.white : Colors.black,
        ),
        child: Text(text),
      ),
    );
  }
}
