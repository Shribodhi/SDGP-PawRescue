import 'package:flutter/material.dart';
import '../models/pet.dart';
import '../widgets/pet_card.dart';

class PetAdoptionHomePage extends StatefulWidget {
  const PetAdoptionHomePage({super.key});

  @override
  _PetAdoptionHomePageState createState() => _PetAdoptionHomePageState();
}

class _PetAdoptionHomePageState extends State<PetAdoptionHomePage> {
  String selectedFilter = "All";

  final List<Pet> allPets = [
    const Pet(
      image: "assets/shih_tzu.jpg",
      name: "GiGi",
      breed: "Shih Tzu",
      location: "Pitakotte",
      age: "2 years",
      sex: "Female",
    ),
    const Pet(
      image: "assets/german_shepard.jpg",
      name: "Garry",
      breed: "German Shepard",
      location: "Ja-Ela",
      age: "4 years",
      sex: "Male",
    ),
    const Pet(
      image: "assets/twin_kittens.jpg",
      name: "Luna [F] & Leo [M] Twins",
      breed: "Siamese",
      location: "Galle",
      age: "55 days",
      sex: "Female/Male",
    ),
    const Pet(
      image: "assets/labrador_puppy.jpg",
      name: "Max",
      breed: "Labrador Retriever",
      location: "Matara",
      age: "8 months",
      sex: "Male",
    ),
    const Pet(
      image: "assets/persian_cat.jpg",
      name: "Oscar",
      breed: "Persian",
      location: "Kandy",
      age: "1 year",
      sex: "Male",
    ),
    const Pet(
      image: "assets/golden_retriever.jpg",
      name: "Peach",
      breed: "Golden Retriever",
      location: "Colombo",
      age: "3 years",
      sex: "Female",
    ),
    const Pet(
      image: "assets/siamese_cat.jpg",
      name: "Suki",
      breed: "Siamese",
      location: "Colombo",
      age: "2 years",
      sex: "Female",
    ),
    const Pet(
      image: "assets/stray_dog.jpg",
      name: "Milo",
      breed: "Mixed",
      location: "Matale",
      age: "4 years",
      sex: "Male",
    ),
    const Pet(
      image: "assets/husky_puppy.jpg",
      name: "Shadow",
      breed: "Husky",
      location: "Kaduwela",
      age: "2 years",
      sex: "Male",
    ),
    const Pet(
      image: "assets/middle_aged_cat.jpg",
      name: "Smokey",
      breed: "Mixed",
      location: "Kalaniya",
      age: "1 years",
      sex: "Female",
    ),
  ];

  List<Pet> getFilteredPets() {
    if (selectedFilter == "All") {
      return allPets;
    } else if (selectedFilter == "Dogs") {
      return allPets.where((pet) => [
        "shih_tzu.jpg",
        "labrador_puppy.jpg",
        "german_shepard.jpg",
        "golden_retriever.jpg",
        "stray_dog.jpg",
        "husky_puppy.jpg",
      ].contains(pet.image.split('/').last)).toList();
    } else {
      return allPets.where((pet) => [
        "twin_kittens.jpg",
        "persian_cat.jpg",
        "siamese_cat.jpg",
        "middle_aged_cat.jpg",
      ].contains(pet.image.split('/').last)).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Pet> filteredPets = getFilteredPets();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Street to Sweet Home'),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: selectedFilter,
              onChanged: (String? newValue) {
                setState(() {
                  selectedFilter = newValue!;
                });
              },
              items: ["All", "Dogs", "Cats"]
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredPets.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: PetCard(pet: filteredPets[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
