import 'package:flutter/material.dart';
import 'shop_page.dart';
import 'travel_recommender.dart';
import 'pet_tracker_page.dart';

class HomePage extends StatelessWidget {
  final String userId;

  const HomePage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(height: 50),
          const Text(
            'PawRescue',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
          const SizedBox(height: 30),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(16.0),
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              children: [
                _buildClickableGridItem(context, 'Treatment History', 'assets/treatment.png'),
                _buildClickableGridItem(context, 'Animal Profiles', 'assets/animal_profiles.png'),
                _buildClickableGridItem(context, 'Medi-Center', 'assets/medi_center.png'),
                _buildClickableGridItem(context, 'Shop', 'assets/shop.png', onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ShopPage()),
                  );
                }),
                _buildClickableGridItem(context, 'Travel Recommender', 'assets/travel.png', onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TravelRecommenderPage()),
                  );
                }),
                _buildClickableGridItem(context, 'Pet Tracker', 'assets/pet_tracker.png', onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PetTrackerPage(userId: userId,)),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.black54,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildClickableGridItem(BuildContext context, String title, String imagePath, {Function()? onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap ?? () {
          // Add navigation or functionality for other grid items
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 5,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(imagePath, width: 50, height: 50),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}