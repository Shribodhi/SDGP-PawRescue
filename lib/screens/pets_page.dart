import 'package:flutter/material.dart';

class PetsPage extends StatefulWidget {
  const PetsPage({super.key});

  @override
  State<PetsPage> createState() => _PetsPageState();
}

class _PetsPageState extends State<PetsPage> {
  final List<Map<String, dynamic>> _pets = [
    {
      'name': 'Max',
      'species': 'Dog',
      'breed': 'Golden Retriever',
      'age': '3 years',
      'image': 'assets/images/dog1.png',
      'lastLocation': 'Home',
      'isTracking': true,
    },
    {
      'name': 'Luna',
      'species': 'Cat',
      'breed': 'Siamese',
      'age': '2 years',
      'image': 'assets/images/cat1.png',
      'lastLocation': 'Backyard',
      'isTracking': false,
    },
    {
      'name': 'Buddy',
      'species': 'Dog',
      'breed': 'Beagle',
      'age': '4 years',
      'image': 'assets/images/dog2.png',
      'lastLocation': 'Park',
      'isTracking': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'My Pets',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),

          // Tracker section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF8ECAE6).withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: const Color(0xFF8ECAE6)),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.location_on,
                  size: 40,
                  color: Color(0xFF219EBC),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Pet Tracker',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'Track your pets in real-time',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _openPetTracker(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF023047),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                  ),
                  child: const Text('Track Now'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Pet list
          const Text(
            'Your Pets',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),

          Expanded(
            child: ListView.builder(
              itemCount: _pets.length,
              itemBuilder: (context, index) {
                final pet = _pets[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 35,
                          backgroundColor: Colors.grey[200],
                          child: const Icon(Icons.pets,
                              size: 40, color: Colors.grey),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                pet['name'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text('${pet['breed']} • ${pet['age']}'),
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    size: 16,
                                    color: pet['isTracking']
                                        ? Colors.green
                                        : Colors.grey,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Last seen: ${pet['lastLocation']}',
                                    style: TextStyle(
                                      color: pet['isTracking']
                                          ? Colors.green
                                          : Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: pet['isTracking'],
                          activeColor: const Color(0xFF219EBC),
                          onChanged: (value) {
                            setState(() {
                              _pets[index]['isTracking'] = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Add new pet button
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Add New Pet'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  backgroundColor: const Color(0xFF023047),
                ),
                onPressed: () {
                  // Add new pet logic
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openPetTracker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Pet Tracker',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Center(
                    child: Text(
                      'Map View\n(Map integration would go here)',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 2,
                itemBuilder: (context, index) {
                  final pet = _pets[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: pet['isTracking']
                          ? Colors.green[100]
                          : Colors.grey[300],
                      child: Icon(
                        Icons.pets,
                        color: pet['isTracking'] ? Colors.green : Colors.grey,
                      ),
                    ),
                    title: Text(pet['name']),
                    subtitle: Text(pet['lastLocation']),
                    trailing: Switch(
                      value: pet['isTracking'],
                      activeColor: const Color(0xFF219EBC),
                      onChanged: (value) {
                        setState(() {
                          _pets[index]['isTracking'] = value;
                          Navigator.pop(context);
                          _openPetTracker(context);
                        });
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
