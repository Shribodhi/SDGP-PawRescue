import 'package:flutter/material.dart';
import '../widgets/pet_card.dart'; // Import the PetCard widget

class PetAdoptionHomePage extends StatelessWidget {
  const PetAdoptionHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Street to Sweet Home'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'All',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'See More >',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: const [
                PetCard(
                  image: 'assets/puppies.png',
                  title: 'Adorable Puppies',
                  subtitle: 'Autorine with puppies',
                  age: '49',
                ),
                SizedBox(height: 16),
                PetCard(
                  image: 'assets/kitten.png',
                  title: 'Twin Kitten',
                  subtitle: 'Middle aged cat',
                  age: '55',
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pets),
            label: 'Adoptions',
          ),
        ],
      ),
    );
  }
}