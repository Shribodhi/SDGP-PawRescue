import 'package:flutter/material.dart';

class ShopPart extends StatefulWidget {
  const ShopPart({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ShopPartState createState() => _ShopPartState();
}

class _ShopPartState extends State<ShopPart> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const PetAdoptionPage(),
    const PetFoodPage(),
    const PetMedicinePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pet Shop')),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.pets), label: 'Adoption'),
          BottomNavigationBarItem(icon: Icon(Icons.fastfood), label: 'Food'),
          BottomNavigationBarItem(
              icon: Icon(Icons.local_hospital), label: 'Medicine'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.orange,
        onTap: _onItemTapped,
      ),
    );
  }
}

class PetAdoptionPage extends StatelessWidget {
  const PetAdoptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Column(
            children: [
              Expanded(
                child: Image.asset('assets/pet${index + 1}.jpg',
                    fit: BoxFit.cover),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Pet ${index + 1}',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        );
      },
    );
  }
}

class PetFoodPage extends StatelessWidget {
  const PetFoodPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
        child: Text('Pet Food Section', style: TextStyle(fontSize: 20)));
  }
}

class PetMedicinePage extends StatelessWidget {
  const PetMedicinePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
        child: Text('Pet Medicine Section', style: TextStyle(fontSize: 20)));
  }
}
