import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import '../models/pet.dart';

class SubmissionPage extends StatefulWidget {
  final Pet pet;

  const SubmissionPage({super.key, required this.pet});

  @override
  State<SubmissionPage> createState() => _SubmissionPageState();
}

class _SubmissionPageState extends State<SubmissionPage> {
  final _formKey = GlobalKey<FormState>();
  bool previouslyOwnedPets = false;
  final TextEditingController reasonController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  String? petExperience;
  bool agreeToTerms = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F3F8),
      appBar: AppBar(
        title: const Text('Submission'),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Fill these forms for adoption ...',
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              const SizedBox(height: 16),

              // Pet Summary Card
              Card(
                elevation: 4,
                child: Row(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: AssetImage(widget.pet.image),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.pet.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            widget.pet.breed,
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              PetInfoChip(label: 'Age', value: widget.pet.age),
                              PetInfoChip(label: 'Sex', value: widget.pet.sex),
                              const PetInfoChip(label: 'Weight', value: '2.5 kg'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Owner's Details Section
              const OwnerDetails(),

              // Email Field
              const SizedBox(height: 24),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                  if (!emailRegex.hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),

              // Phone Number Field
              const SizedBox(height: 24),
              TextFormField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  if (value.length < 10) {
                    return 'Please enter a valid phone number';
                  }
                  return null;
                },
              ),

              // Previously Owned Pets Toggle Section
              const SizedBox(height: 24),
              const Text(
                'Have you previously owned pets?',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Row(
                children: [
                  ToggleButton(
                    label: 'Yes',
                    isSelected: previouslyOwnedPets,
                    onTap: () => setState(() => previouslyOwnedPets = true),
                  ),
                  const SizedBox(width: 8),
                  ToggleButton(
                    label: 'No',
                    isSelected: !previouslyOwnedPets,
                    onTap: () => setState(() => previouslyOwnedPets = false),
                  ),
                ],
              ),

              // Pet Experience Dropdown
              const SizedBox(height: 24),
              const Text(
                'If Owned, Years of Pet Ownership Experience',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: petExperience,
                items: ['No Experience','0-1 years', '1-3 years', '3-5 years', '5+ years']
                    .map((experience) => DropdownMenuItem(
                  value: experience,
                  child: Text(experience),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    petExperience = value;
                  });
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select your pet experience';
                  }
                  return null;
                },
              ),

              // Reason for Adoption Field
              const SizedBox(height: 24),
              const Text(
                'Why do you want to adopt?',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: reasonController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Describe your reason',
                ),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please describe your reason';
                  }
                  return null;
                },
              ),

              // Preferred Adoption Date
              const SizedBox(height: 24),
              const Text(
                'Preferred Adoption Date',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: dateController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Select a date',
                ),
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                    });
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a preferred adoption date';
                  }
                  return null;
                },
              ),

              // Agreement Checkbox
              const SizedBox(height: 24),
              Row(
                children: [
                  Checkbox(
                    value: agreeToTerms,
                    onChanged: (value) {
                      setState(() {
                        agreeToTerms = value!;
                      });
                    },
                  ),
                  const Text('I agree to the terms and conditions'),
                ],
              ),

              const SizedBox(height: 32),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    backgroundColor: Colors.orange,
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate() && agreeToTerms) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Thank you for your submission! You have applied to adopt ${widget.pet.name}. We will review your application and get back to you soon.',
                          ),
                        ),
                      );
                      Navigator.pop(context); // Navigate back after submission
                    } else if (!agreeToTerms) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please agree to the terms and conditions')),
                      );
                    }
                  },
                  child: const Text('Submit', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Pet Info Chip Widget
class PetInfoChip extends StatelessWidget {
  final String label;
  final String value;

  const PetInfoChip({required this.label, required this.value, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: TextStyle(color: Colors.grey[700], fontSize: 14)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}

// Toggle Button Widget
class ToggleButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const ToggleButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.orange.shade100 : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.orange : Colors.transparent,
            width: 2,
          ),
        ),
        child: Text(label, style: TextStyle(color: Colors.grey[800], fontWeight: FontWeight.bold)),
      ),
    );
  }
}

// Placeholder Owner Details Widget
class OwnerDetails extends StatelessWidget {
  const OwnerDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Rajitha Perera', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        SizedBox(height: 4),
        Row(
          children: [
            Icon(Icons.email, size: 16, color: Colors.grey),
            SizedBox(width: 8),
            Text('rajitha.perera@gmail.com', style: TextStyle(color: Colors.grey)),
            Spacer(),
            Icon(Icons.phone, size: 16, color: Colors.grey),
            SizedBox(width: 8),
            Text('+94 77 123 4567', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ],
    );
  }
}