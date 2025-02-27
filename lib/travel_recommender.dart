import 'package:flutter/material.dart';

class TravelRecommenderPage extends StatefulWidget {
  const TravelRecommenderPage({super.key});

  @override
  State<TravelRecommenderPage> createState() => _TravelRecommenderPageState();
}

class _TravelRecommenderPageState extends State<TravelRecommenderPage> {
  String _selectedCategory = 'All';
  final List<String> _categories = ['All', 'Jogging Areas', 'Pharmacies', 'Veterinarians'];
  
  // Mock data for nearby locations
  final List<Map<String, dynamic>> _locations = [
    {
      'name': 'Central Park',
      'type': 'Jogging Areas',
      'distance': '0.5 km',
      'rating': 4.8,
      'address': '123 Park Avenue, City',
      'image': 'assets/park.jpg',
    },
    {
      'name': 'PetMed Pharmacy',
      'type': 'Pharmacies',
      'distance': '1.2 km',
      'rating': 4.5,
      'address': '456 Health Street, City',
      'image': 'assets/pharmacy.jpg',
    },
    {
      'name': 'Dr. Paws Veterinary Clinic',
      'type': 'Veterinarians',
      'distance': '0.8 km',
      'rating': 4.9,
      'address': '789 Animal Care Road, City',
      'image': 'assets/vet.jpg',
    },
    {
      'name': 'Riverside Trail',
      'type': 'Jogging Areas',
      'distance': '1.5 km',
      'rating': 4.6,
      'address': '321 River Road, City',
      'image': 'assets/trail.jpg',
    },
    {
      'name': 'Pet Pharmacy Plus',
      'type': 'Pharmacies',
      'distance': '2.0 km',
      'rating': 4.3,
      'address': '654 Medicine Avenue, City',
      'image': 'assets/pharmacy2.jpg',
    },
    {
      'name': 'Happy Pets Veterinary Hospital',
      'type': 'Veterinarians',
      'distance': '1.7 km',
      'rating': 4.7,
      'address': '987 Pet Health Boulevard, City',
      'image': 'assets/vet2.jpg',
    },
  ];

  List<Map<String, dynamic>> get filteredLocations {
    if (_selectedCategory == 'All') {
      return _locations;
    } else {
      return _locations.where((location) => location['type'] == _selectedCategory).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Travel Recommender'),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        children: [
          // Map View (Placeholder)
          Container(
            height: 200,
            width: double.infinity,
            color: Colors.grey[300],
            child: Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.map, size: 50, color: Colors.grey),
                      const SizedBox(height: 8),
                      Text('Map View', style: TextStyle(color: Colors.grey[700])),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: FloatingActionButton(
                    mini: true,
                    backgroundColor: Colors.white,
                    onPressed: () {
                      // Get current location
                    },
                    child: const Icon(Icons.my_location, color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
          
          // Category Filter
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            color: Colors.white,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: _categories.map((category) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      selected: _selectedCategory == category,
                      label: Text(category),
                      onSelected: (selected) {
                        setState(() {
                          _selectedCategory = category;
                        });
                      },
                      selectedColor: Colors.orange[100],
                      checkmarkColor: Colors.orange,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          
          // List View
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredLocations.length,
              itemBuilder: (context, index) {
                final location = filteredLocations[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Location Image
                      Container(
                        height: 120,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                        ),
                        child: const Center(
                          child: Icon(Icons.image, size: 40, color: Colors.grey),
                        ),
                      ),
                      
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Location Name and Type
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    location['name'],
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getCategoryColor(location['type']),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    location['type'],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            
                            const SizedBox(height: 8),
                            
                            // Location Address
                            Row(
                              children: [
                                const Icon(Icons.location_on, size: 16, color: Colors.grey),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    location['address'],
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            
                            const SizedBox(height: 8),
                            
                            // Distance and Rating
                            Row(
                              children: [
                                const Icon(Icons.directions_walk, size: 16, color: Colors.grey),
                                const SizedBox(width: 4),
                                Text(
                                  location['distance'],
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                const Icon(Icons.star, size: 16, color: Colors.amber),
                                const SizedBox(width: 4),
                                Text(
                                  location['rating'].toString(),
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            
                            const SizedBox(height: 16),
                            
                            // Directions Button
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  // Navigate to directions
                                },
                                icon: const Icon(Icons.directions),
                                label: const Text('Directions'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Jogging Areas':
        return Colors.green;
      case 'Pharmacies':
        return Colors.blue;
      case 'Veterinarians':
        return Colors.purple;
      default:
        return Colors.orange;
    }
  }
}

