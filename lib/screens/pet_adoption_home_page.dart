import 'package:flutter/material.dart';
import '../widgets/pet_card.dart';

class PetAdoptionHomePage extends StatelessWidget {
  const PetAdoptionHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Street to Sweet Home',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.orangeAccent,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),

          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search for pets...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
              ),
            ),
          ),

          const SizedBox(height: 15),

          // Scrollable Category Buttons
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                const SizedBox(width: 16),
                _buildCategoryButton("All", "all"),
                _buildCategoryButton("Dogs", "dog"),
                _buildCategoryButton("Cats", "cat"),
                _buildCategoryButton("Kittens", "kitten"),
                _buildCategoryButton("Puppies", "puppy"),
                _buildCategoryButton("Older Pets", "older"),
                const SizedBox(width: 16),
              ],
            ),
          ),

          const SizedBox(height: 15),

          // Pet Cards in a Scrollable Grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Two columns
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.8, // Controls item height
                ),
                itemCount: petList.length,
                itemBuilder: (context, index) {
                  final pet = petList[index];
                  return PetCard(
                    image: pet['image'] ?? '',      // Default empty string if null
                    title: pet['title'] ?? 'Unknown',
                    subtitle: pet['subtitle'] ?? 'Unknown',
                    age: pet['age'] ?? '0',         // Default age as '0' if null
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method for category buttons
  Widget _buildCategoryButton(String title, String filter) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: ElevatedButton(
        onPressed: () {
          // TODO: Implement category filtering logic
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orangeAccent,
          foregroundColor: Colors.white,
        ),
        child: Text(title),
      ),
    );
  }
}

// Dummy pet data
final List<Map<String, String>> petList = [
  {
    'image': 'assets/dog1.jpg',
    'title': 'A mother with puppies',
    'subtitle': 'Dehiwala',
    'age': '45',
  },
  {
    'image': 'assets/dog2.jpg',
    'title': 'Adorable Puppies',
    'subtitle': 'Dehiwala',
    'age': '30',
  },
  {
    'image': 'assets/cat1.jpg',
    'title': 'Twin Kittens',
    'subtitle': 'Dehiwala',
    'age': '55',
  },
  {
    'image': 'assets/cat2.jpg',
    'title': 'Middle-aged Cat',
    'subtitle': 'Dehiwala',
    'age': '48',
  },
  {
    'image': 'assets/dog3.jpg',
    'title': 'Fluffy Golden Retriever',
    'subtitle': 'Colombo',
    'age': '60',
  },
  {
    'image': 'assets/cat3.jpg',
    'title': 'Playful Kitten',
    'subtitle': 'Nugegoda',
    'age': '35',
  },
];
