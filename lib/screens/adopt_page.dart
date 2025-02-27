import 'package:flutter/material.dart';

class AdoptPage extends StatefulWidget {
  const AdoptPage({super.key});

  @override
  State<AdoptPage> createState() => _AdoptPageState();
}

class _AdoptPageState extends State<AdoptPage> {
  final List<Map<String, dynamic>> _adoptablePets = [
    {
      'name': 'Charlie',
      'species': 'Dog',
      'breed': 'Labrador Retriever',
      'age': '2 years',
      'gender': 'Male',
      'location': '3.2 miles away',
      'description':
          'Charlie is a friendly and energetic Labrador who loves outdoor activities and playing with toys. He is good with children and other pets.',
      'image': 'assets/images/adopt_dog1.png',
    },
    {
      'name': 'Whiskers',
      'species': 'Cat',
      'breed': 'Persian',
      'age': '1.5 years',
      'gender': 'Female',
      'location': '1.8 miles away',
      'description':
          'Whiskers is a gentle and quiet Persian cat who enjoys lounging and cuddling. She is litter trained and well-behaved.',
      'image': 'assets/images/adopt_cat1.png',
    },
    {
      'name': 'Rocky',
      'species': 'Dog',
      'breed': 'German Shepherd',
      'age': '3 years',
      'gender': 'Male',
      'location': '5.7 miles away',
      'description':
          'Rocky is an intelligent and loyal German Shepherd. He is trained in basic commands and would make an excellent companion and guard dog.',
      'image': 'assets/images/adopt_dog2.png',
    },
    {
      'name': 'Mittens',
      'species': 'Cat',
      'breed': 'Domestic Shorthair',
      'age': '8 months',
      'gender': 'Female',
      'location': '2.3 miles away',
      'description':
          'Mittens is a playful and curious kitten who loves toys and climbing. She gets along well with other cats.',
      'image': 'assets/images/adopt_cat2.png',
    },
    {
      'name': 'Duke',
      'species': 'Dog',
      'breed': 'Boxer',
      'age': '4 years',
      'gender': 'Male',
      'location': '4.1 miles away',
      'description':
          'Duke is a strong and protective boxer who is also incredibly gentle with family members. He needs regular exercise and would be perfect for an active household.',
      'image': 'assets/images/adopt_dog3.png',
    },
  ];

  String _selectedFilter = 'All Pets';
  final List<String> _filters = [
    'All Pets',
    'Dogs',
    'Cats',
    'Nearby',
    'Recently Added'
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          const Text(
            'Find a New Friend',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Adopt a pet and give them a forever home',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 20),

          // Filter section
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _filters.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    selected: _selectedFilter == _filters[index],
                    label: Text(_filters[index]),
                    onSelected: (selected) {
                      setState(() {
                        _selectedFilter = _filters[index];
                      });
                    },
                    backgroundColor: Colors.grey[200],
                    selectedColor: const Color(0xFF219EBC),
                    labelStyle: TextStyle(
                      color: _selectedFilter == _filters[index]
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 20),

          // Adoptable pets list
          Expanded(
            child: ListView.builder(
              itemCount: _adoptablePets.length,
              itemBuilder: (context, index) {
                final pet = _adoptablePets[index];
                bool showItem = true;

                // Apply filters
                if (_selectedFilter == 'Dogs' && pet['species'] != 'Dog') {
                  showItem = false;
                } else if (_selectedFilter == 'Cats' &&
                    pet['species'] != 'Cat') {
                  showItem = false;
                }

                if (!showItem) {
                  return const SizedBox.shrink();
                }

                return GestureDetector(
                  onTap: () => _showPetDetails(context, pet),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Pet image
                        Container(
                          height: 180,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(15),
                            ),
                            color: Colors.grey[300],
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.pets,
                              size: 80,
                              color: Colors.white,
                            ),
                          ),
                        ),

                        // Pet information
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    pet['name'],
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF219EBC)
                                          .withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      pet['species'],
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF219EBC),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Text(
                                '${pet['breed']} • ${pet['age']} • ${pet['gender']}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    size: 16,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    pet['location'],
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () => _showPetDetails(context, pet),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF023047),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  minimumSize: const Size(double.infinity, 45),
                                ),
                                child: const Text(
                                  'Learn More',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showPetDetails(BuildContext context, Map<String, dynamic> pet) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Close button
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ),

            // Pet image
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.grey[300],
              ),
              child: const Center(
                child: Icon(
                  Icons.pets,
                  size: 80,
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Pet info header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pet['name'],
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${pet['breed']} • ${pet['age']} • ${pet['gender']}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF219EBC).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    pet['species'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF219EBC),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            // Location info
            Row(
              children: [
                const Icon(
                  Icons.location_on,
                  size: 20,
                  color: Colors.grey,
                ),
                const SizedBox(width: 5),
                Text(
                  pet['location'],
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Description
            const Text(
              'About',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              pet['description'],
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 30),

            // Shelter info
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.grey[300],
                    child: const Icon(Icons.home, color: Colors.grey),
                  ),
                  const SizedBox(width: 15),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Happy Paws Shelter',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Contact: (123) 456-7890',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      side: const BorderSide(color: Color(0xFF219EBC)),
                    ),
                    child: const Text(
                      'Contact',
                      style: TextStyle(color: Color(0xFF219EBC)),
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Adoption button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  // Show adoption request dialog
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Adoption request sent!'),
                      backgroundColor: Color(0xFF219EBC),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF023047),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Request to Adopt',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
