import 'package:flutter/material.dart';
import 'screens/profile_page.dart';
import 'screens/pets_page.dart';
import 'screens/shop_page.dart';
import 'screens/adopt_page.dart';
import 'screens/social_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeContent(),
    const PetsPage(),
    const ShopPage(),
    const AdoptPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PawRescue'),
        backgroundColor: const Color(0xFF219EBC),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.people),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SocialPage()),
              );
            },
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF023047),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pets),
            label: 'My Pets',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Shop',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Adopt',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF8ECAE6), Color(0xFF219EBC)],
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Hello, Pet Lover!',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'What would you like to do today?',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.pets,
                      size: 35,
                      color: Color(0xFF219EBC),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),

            const Text(
              'Quick Access',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),

            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: [
                _buildFeatureCard(
                  context,
                  'Track My Pets',
                  Icons.location_on,
                  Colors.orange,
                  () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PetsPage()));
                  },
                ),
                _buildFeatureCard(
                  context,
                  'Social Feed',
                  Icons.people,
                  Colors.blue,
                  () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SocialPage()));
                  },
                ),
                _buildFeatureCard(
                  context,
                  'Shop Products',
                  Icons.shopping_bag,
                  Colors.green,
                  () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ShopPage()));
                  },
                ),
                _buildFeatureCard(
                  context,
                  'Adopt a Pet',
                  Icons.favorite,
                  Colors.red,
                  () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AdoptPage()));
                  },
                ),
              ],
            ),

            const SizedBox(height: 25),

            const Text(
              'Recent Activity',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue[100],
                      child:
                          const Icon(Icons.notifications, color: Colors.blue),
                    ),
                    title: Text('Activity ${index + 1}'),
                    subtitle: Text('Details of activity ${index + 1}'),
                    trailing: const Text('Today'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(BuildContext context, String title, IconData icon,
      Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: color.withOpacity(0.2),
              child: Icon(icon, size: 35, color: color),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}





