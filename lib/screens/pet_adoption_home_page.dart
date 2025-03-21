import 'package:flutter/material.dart';
import '../models/pet.dart';
import '../widgets/pet_card.dart';

class PetAdoptionHomePage extends StatelessWidget {
  const PetAdoptionHomePage({super.key});

  final List<Pet> pets = const [
    Pet(
      image: "assets/shih_tzu.jpg",
      name: "GiGi",
      breed: "Shih Tzu",
      location: "Sri Jayawardenepura Kotte",
      age: "2 years",
      sex: "Female",
    ),
    Pet(
      image: "assets/german_shepard.jpg",
      name: "Garry",
      breed: "German Shepard",
      location: "Ja-Ela",
      age: "4 years",
      sex: "Male",
    ),
    Pet(
      image: "assets/twin_kittens.jpg",
      name: "Twin Kittens",
      breed: "Siamese",
      location: "Galle",
      age: "55 days",
      sex: "Male/Female",
    ),
    Pet(
      image: "assets/labrador_puppy.jpg",
      name: "Labrador Puppy",
      breed: "Labrador Retriever",
      location: "Matara",
      age: "8 months",
      sex: "Male",
    ),
    Pet(
      image: "assets/persian_cat.jpg",
      name: "Persian Cat",
      breed: "Persian",
      location: "Kandy",
      age: "1 year",
      sex: "Male",
    ),
    Pet(
      image: "assets/golden_retriever.jpg",
      name: "Golden Retriever",
      breed: "Golden Retriever",
      location: "Colombo",
      age: "3 years",
      sex: "Female",
    ),
    Pet(
      image: "assets/siamese_cat.jpg",
      name: "Siamese Cat",
      breed: "Siamese",
      location: "Colombo",
      age: "2 years",
      sex: "Female",
    ),
    Pet(
      image: "assets/stray_dog.jpg",
      name: "Milo",
      breed: "Mixed",
      location: "Matale",
      age: "4 years",
      sex: "Male",
    ),
    Pet(
      image: "assets/husky_puppy.jpg",
      name: "Shadow",
      breed: "Husky",
      location: "Kaduwela",
      age: "2 years",
      sex: "Male",
    ),
    Pet(
      image: "assets/middle_aged_cat.jpg",
      name: "Smokey",
      breed: "Mixed",
      location: "Kalaniya",
      age: "1 years",
      sex: "Female",
    ),

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Street to Sweet Home'),
        backgroundColor: Colors.orange,
      ),
      body: ListView.builder(
        itemCount: pets.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: PetCard(pet: pets[index]),
          );
        },
      ),
    );
  }
}
