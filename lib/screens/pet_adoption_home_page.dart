import 'package:flutter/material.dart';

class PetAdoptionHomePage extends StatelessWidget {
  const PetAdoptionHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Street to Sweet Home'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2, // Keeps two columns in each row
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: const [
            PetCard(
              image: 'assets/mother_puppies.jpg',
              title: 'A mother with puppies',
              subtitle: 'Dehiwala',
              age: '48 days',
            ),
            PetCard(
              image: 'assets/adorable_puppies.jpg',
              title: 'Adorable Puppies',
              subtitle: 'Dehiwala',
              age: '49 days',
            ),
            PetCard(
              image: 'assets/twin_kittens.jpg',
              title: 'Twin Kitten',
              subtitle: 'Dehiwala',
              age: '55 days',
            ),
            PetCard(
              image: 'assets/middle_aged_cat.jpg',
              title: 'Middle aged cat',
              subtitle: 'Dehiwala',
              age: '48 days',
            ),
            // New pet cards added below 👇
            PetCard(
              image: 'assets/golden_retriever.jpg',
              title: 'Golden Retriever',
              subtitle: 'Colombo',
              age: '60 days',
            ),
            PetCard(
              image: 'assets/siamese_cat.jpg',
              title: 'Siamese Kitten',
              subtitle: 'Galle',
              age: '45 days',
            ),
            PetCard(
              image: 'assets/husky_puppy.jpg',
              title: 'Husky Puppy',
              subtitle: 'Kandy',
              age: '50 days',
            ),
            PetCard(
              image: 'assets/persian_cat.jpg',
              title: 'Persian Cat',
              subtitle: 'Negombo',
              age: '70 days',
            ),
            PetCard(
              image: 'assets/labrador_puppy.jpg',
              title: 'Labrador Puppy',
              subtitle: 'Matara',
              age: '55 days',
            ),
          ],
        ),
      ),
    );
  }
}

class PetCard extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;
  final String age;

  const PetCard({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
    required this.age,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(image),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(subtitle, style: TextStyle(color: Colors.grey[600])),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$age old',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('See Details'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
