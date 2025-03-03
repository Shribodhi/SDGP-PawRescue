import 'package:flutter/material.dart';

class PetProfile {
  final String id;
  final String name;
  final String species;
  final String breed;
  final String age;
  final String imageUrl;

  PetProfile({
    required this.id,
    required this.name,
    required this.species,
    required this.breed,
    required this.age,
    required this.imageUrl,
  });
}

class PetProfilePage extends StatefulWidget {
  final PetProfile? pet;

  const PetProfilePage({Key? key, this.pet}) : super(key: key);

  @override
  _PetProfilePageState createState() => _PetProfilePageState();
}

class _PetProfilePageState extends State<PetProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _speciesController;
  late TextEditingController _breedController;
  late TextEditingController _ageController;
  String _imageUrl = '';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.pet?.name ?? '');
    _speciesController = TextEditingController(text: widget.pet?.species ?? '');
    _breedController = TextEditingController(text: widget.pet?.breed ?? '');
    _ageController = TextEditingController(text: widget.pet?.age ?? '');
    _imageUrl = widget.pet?.imageUrl ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _speciesController.dispose();
    _breedController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pet == null ? 'Create Pet Profile' : 'Edit Pet Profile'),
        backgroundColor: const Color(0xFF219EBC),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: GestureDetector(
                  onTap: () {
                    // TODO: Implement image picker
                    print('Image picker to be implemented');
                  },
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: _imageUrl.isNotEmpty ? NetworkImage(_imageUrl) : null,
                    child: _imageUrl.isEmpty
                        ? const Icon(Icons.add_a_photo, size: 40, color: Colors.white)
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Pet Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your pet\'s name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _speciesController,
                decoration: const InputDecoration(
                  labelText: 'Species',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your pet\'s species';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _breedController,
                decoration: const InputDecoration(
                  labelText: 'Breed',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your pet\'s breed';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _ageController,
                decoration: const InputDecoration(
                  labelText: 'Age',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your pet\'s age';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // TODO: Save pet profile
                      PetProfile newPet = PetProfile(
                        id: widget.pet?.id ?? DateTime.now().toString(),
                        name: _nameController.text,
                        species: _speciesController.text,
                        breed: _breedController.text,
                        age: _ageController.text,
                        imageUrl: _imageUrl,
                      );
                      Navigator.pop(context, newPet);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF219EBC),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    widget.pet == null ? 'Create Profile' : 'Update Profile',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

