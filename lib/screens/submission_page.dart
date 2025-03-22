import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../widgets/owner_details.dart';
import '../models/pet.dart';
import '../widgets/pet_info_chip.dart';
import '../widgets/toggle_button.dart';
import '../widgets/submission_splash_screen.dart';

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
    final ownerDetails = {
      "GiGi": {"name": "Darshani Priyanthi", "email": "darshani.priyanthi@email.com", "phone": "+94 77 556 0317"},
      "Garry": {"name": "Samantha Deniyegedara", "email": "samantha.deniyegedara@email.com", "phone": "+94 77 016 3343"},
      "Luna [F] & Leo [M] Twins": {"name": "Amila Perera", "email": "amila.perera@email.com", "phone": "+94 77 123 4567"},
      "Max": {"name": "Chamara Silva", "email": "chamara.silva@email.com", "phone": "+94 77 234 5678"},
      "Oscar": {"name": "Nadeesha Kumari", "email": "nadeesha.kumari@email.com", "phone": "+94 77 345 6789"},
      "Peach": {"name": "Pradeep Fernando", "email": "pradeep.fernando@email.com", "phone": "+94 77 456 7890"},
      "Suki": {"name": "Dilani Wijesinghe", "email": "dilani.wijesinghe@email.com", "phone": "+94 77 567 8901"},
      "Milo": {"name": "Sampath Rajapaksha", "email": "sampath.rajapaksha@email.com", "phone": "+94 77 678 9012"},
      "Shadow": {"name": "Tharindu Jayasinghe", "email": "tharindu.jayasinghe@email.com", "phone": "+94 77 789 0123"},
      "Smokey": {"name": "Ishara Lakshani", "email": "ishara.lakshani@email.com", "phone": "+94 77 890 1234"}
    };

    final details = ownerDetails[widget.pet.name] ?? {"name": "Default Name", "email": "default@example.com", "phone": "+1 000 000 0000"};

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
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            widget.pet.breed,
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 8),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                PetInfoChip(label: 'Age', value: widget.pet.age),
                                PetInfoChip(label: 'Sex', value: widget.pet.sex),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              OwnerDetails(
                name: details["name"]!,
                email: details["email"]!,
                phone: details["phone"]!,
              ),
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>
                        const SubmissionSplashScreen(loadingDuration: 3)),
                      );

                      // Show the snackbar after returning to home page
                      Future.delayed(const Duration(seconds: 5), () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Thank you for your submission! You have applied to adopt ${widget.pet.name}. We will review your application and get back to you soon.',
                            ),
                          ),
                        );
                      });
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