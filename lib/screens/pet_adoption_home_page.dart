import 'package:flutter/material.dart';
import '../widgets/pet_card.dart';

class PetAdoptionHomePage extends StatelessWidget {
  const PetAdoptionHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> petList = [
      {
        "image": "assets/mother_puppies.jpg",
        "title": "A mother with puppies",
        "subtitle": "Dehiwala",
        "age": "45",
      },
      {
        "image": "assets/adorable_puppies.jpg",
        "title": "Adorable Puppies",
        "subtitle": "Dehiwala",
        "age": "30",
      },
      {
        "image": "assets/twin_kittens.jpg",
        "title": "Twin Kitten",
        "subtitle": "Dehiwala",
        "age": "55",
      },
      {
        "image": "assets/middle_aged_cat.jpg",
        "title": "Middle aged cat",
        "subtitle": "Dehiwala",
        "age": "48",
      },
      // Add more pet entries here
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Street to Sweet Home"),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.8,
          ),
          itemCount: petList.length,
          itemBuilder: (context, index) {
            final pet = petList[index];
            return PetCard(
              image: pet["image"]!,
              title: pet["title"]!,
              subtitle: pet["subtitle"]!,
              age: pet["age"]!,
            );
          },
        ),
      ),
    );
  }
}
