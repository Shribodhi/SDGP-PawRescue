import 'package:flutter/material.dart';
import '../services/tflite_service.dart';

class FoodRecommendationScreen extends StatefulWidget {
  final Map<String, dynamic> petPreferences;

  const FoodRecommendationScreen({Key? key, required this.petPreferences})
      : super(key: key);

  @override
  _FoodRecommendationScreenState createState() =>
      _FoodRecommendationScreenState();
}

class _FoodRecommendationScreenState extends State<FoodRecommendationScreen> {
  final TFLiteService _tfliteService = TFLiteService();
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  int _recommendedIndex = 0;

  // Sample food database - Replace with your actual food options
  final List<Map<String, dynamic>> _foodOptions = [
    {
      'name': 'Premium Dog Nutrition',
      'image':
          'https://images.unsplash.com/photo-1568640347023-a616a30bc3bd?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
      'description': 'High-quality protein-rich formula for active dogs',
      'features': ['High Protein', 'Grain Free', 'All Natural'],
      'rating': 4.8,
      'price': '\$49.99',
      'benefits': [
        'Supports muscle development',
        'Promotes healthy coat',
        'Improves digestion'
      ],
    },
    {
      'name': 'Balanced Cat Delight',
      'image':
          'https://images.unsplash.com/photo-1589924691995-400dc9ecc119?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
      'description': 'Perfect blend of nutrition for indoor cats',
      'features': ['Omega-3', 'Digestive Support', 'No Artificial Additives'],
      'rating': 4.6,
      'price': '\$39.99',
      'benefits': [
        'Boosts immunity',
        'Enhances fur softness',
        'Supports joint health'
      ],
    },
    {
      'name': 'Senior Pet Wellness',
      'image':
          'https://images.unsplash.com/photo-1601758124510-52d02ddb7cbd?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
      'description': 'Specially formulated for older pets with joint support',
      'features': ['Joint Support', 'Easy Digestion', 'Immune Boosting'],
      'rating': 4.7,
      'price': '\$54.99',
      'benefits': [
        'Reduces inflammation',
        'Supports aging joints',
        'Maintains energy levels'
      ],
    },
    {
      'name': 'Puppy Growth Formula',
      'image':
          'https://images.unsplash.com/photo-1591946614720-90a587da4a36?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
      'description': 'Nutrient-rich food for growing puppies',
      'features': ['DHA for Brain', 'Calcium Rich', 'Small Kibble Size'],
      'rating': 4.9,
      'price': '\$44.99',
      'benefits': [
        'Supports bone development',
        'Promotes healthy growth',
        'Enhances cognitive function'
      ],
    },
    {
      'name': 'Weight Management Formula',
      'image':
          'https://images.unsplash.com/photo-1623387641168-d9803ddd3f35?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
      'description':
          'Specially formulated to help overweight pets reach a healthy weight',
      'features': ['Low Calorie', 'High Fiber', 'Lean Protein'],
      'rating': 4.5,
      'price': '\$52.99',
      'benefits': [
        'Supports weight loss',
        'Maintains muscle mass',
        'Provides satiety'
      ],
    },
    {
      'name': 'Sensitive Stomach Formula',
      'image':
          'https://images.unsplash.com/photo-1548767797-d8c844163c4c?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
      'description': 'Gentle formula for pets with digestive sensitivities',
      'features': [
        'Limited Ingredients',
        'Easily Digestible',
        'Probiotic Support'
      ],
      'rating': 4.7,
      'price': '\$56.99',
      'benefits': [
        'Reduces digestive upset',
        'Improves nutrient absorption',
        'Supports gut health'
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadModelAndPredict();
  }

  Future<void> _loadModelAndPredict() async {
    setState(() => _isLoading = true);

    try {
      // Load the TFLite model
      await _tfliteService.loadModel();

      // Convert preferences to input data for the model
      List<double> inputData =
          _convertPreferencesToInput(widget.petPreferences);

      // Get prediction from the model
      List<double> prediction = _tfliteService.predict(inputData);

      // Determine the recommended food index based on the prediction
      _recommendedIndex = _tfliteService.getRecommendedFoodIndex(prediction);

      // Make sure the index is within bounds
      if (_recommendedIndex >= _foodOptions.length) {
        _recommendedIndex = 0;
      }
    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage =
            "Error loading model or making prediction: $e\nFalling back to default recommendation.";
      });
      print("Error in recommendation: $e");

      // Fall back to a simple recommendation method if AI fails
      _recommendedIndex = _getDefaultRecommendation(widget.petPreferences);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  List<double> _convertPreferencesToInput(Map<String, dynamic> preferences) {
    // Convert preferences to a format your TFLite model can understand
    // This is a simplified example - adjust based on your model's requirements
    List<double> inputData = [];

    // Pet Type (one-hot encoding)
    inputData.add(preferences['petType'] == 'Dog' ? 1.0 : 0.0);
    inputData.add(preferences['petType'] == 'Cat' ? 1.0 : 0.0);
    inputData.add(preferences['petType'] == 'Bird' ? 1.0 : 0.0);
    inputData.add(preferences['petType'] == 'Rabbit' ? 1.0 : 0.0);
    inputData.add(preferences['petType'] == 'Hamster' ? 1.0 : 0.0);

    // Health Condition (one-hot encoding)
    inputData.add(preferences['healthCondition'] == 'Healthy' ? 1.0 : 0.0);
    inputData.add(preferences['healthCondition'] == 'Overweight' ? 1.0 : 0.0);
    inputData.add(preferences['healthCondition'] == 'Underweight' ? 1.0 : 0.0);
    inputData
        .add(preferences['healthCondition'] == 'Sensitive Stomach' ? 1.0 : 0.0);
    inputData.add(preferences['healthCondition'] == 'Joint Issues' ? 1.0 : 0.0);

    // Pet Age (one-hot encoding)
    inputData.add(preferences['petAge'] == 'Puppy/Kitten' ? 1.0 : 0.0);
    inputData.add(preferences['petAge'] == 'Young' ? 1.0 : 0.0);
    inputData.add(preferences['petAge'] == 'Adult' ? 1.0 : 0.0);
    inputData.add(preferences['petAge'] == 'Senior' ? 1.0 : 0.0);

    // Weight Range (normalized)
    if (preferences['weightRange'] == 'Small (<10kg)') {
      inputData.add(0.0);
    } else if (preferences['weightRange'] == 'Medium (10-25kg)') {
      inputData.add(0.33);
    } else if (preferences['weightRange'] == 'Large (25-40kg)') {
      inputData.add(0.66);
    } else {
      inputData.add(1.0); // Extra Large
    }

    // Activity Level (normalized)
    if (preferences['activityLevel'] == 'Low') {
      inputData.add(0.0);
    } else if (preferences['activityLevel'] == 'Medium') {
      inputData.add(0.33);
    } else if (preferences['activityLevel'] == 'High') {
      inputData.add(0.66);
    } else {
      inputData.add(1.0); // Very Active
    }

    // Allergies (binary flags)
    List<String> allergies = preferences['allergies'];
    inputData.add(allergies.contains('Chicken') ? 1.0 : 0.0);
    inputData.add(allergies.contains('Beef') ? 1.0 : 0.0);
    inputData.add(allergies.contains('Grain') ? 1.0 : 0.0);
    inputData.add(allergies.contains('Dairy') ? 1.0 : 0.0);
    inputData.add(allergies.contains('Fish') ? 1.0 : 0.0);

    // Dietary Preferences (binary flags)
    List<String> dietaryPrefs = preferences['dietaryPreferences'];
    inputData.add(dietaryPrefs.contains('Grain-Free') ? 1.0 : 0.0);
    inputData.add(dietaryPrefs.contains('Organic') ? 1.0 : 0.0);
    inputData.add(dietaryPrefs.contains('Vegan') ? 1.0 : 0.0);
    inputData.add(dietaryPrefs.contains('Raw') ? 1.0 : 0.0);
    inputData.add(dietaryPrefs.contains('High-Protein') ? 1.0 : 0.0);

    // Toggle options
    inputData.add(preferences['includeTreats'] ? 1.0 : 0.0);
    inputData.add(preferences['budgetFriendly'] ? 1.0 : 0.0);

    // Portion Size (normalized)
    double portionSize = preferences['portionSize'];
    inputData.add((portionSize - 0.5) / 4.5); // Normalize between 0 and 1

    return inputData;
  }

  int _getDefaultRecommendation(Map<String, dynamic> preferences) {
    // This is a fallback method if the AI model fails
    // It uses simple rules to determine the best food option

    if (preferences['petType'] == 'Dog') {
      if (preferences['petAge'] == 'Puppy/Kitten') {
        return 3; // Puppy Growth Formula
      } else if (preferences['petAge'] == 'Senior') {
        return 2; // Senior Pet Wellness
      } else if (preferences['healthCondition'] == 'Overweight') {
        return 4; // Weight Management Formula
      } else if (preferences['healthCondition'] == 'Sensitive Stomach') {
        return 5; // Sensitive Stomach Formula
      } else {
        return 0; // Premium Dog Nutrition
      }
    } else if (preferences['petType'] == 'Cat') {
      return 1; // Balanced Cat Delight
    } else {
      // For other pet types, default to the first option
      return 0;
    }
  }

  @override
  void dispose() {
    _tfliteService.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Recommendation'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: _isLoading ? _buildLoadingState() : _buildRecommendationContent(),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: Colors.blue),
          const SizedBox(height: 20),
          Text(
            'Finding the perfect food for your pet...',
            style: TextStyle(
              color: Colors.blue.shade700,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationContent() {
    final recommendedFood = _foodOptions[_recommendedIndex];

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Error message if there was an error but we're showing a fallback recommendation
            if (_hasError)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.warning_amber_rounded,
                            color: Colors.orange.shade800),
                        const SizedBox(width: 8),
                        Text(
                          'AI Model Warning',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange.shade800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Using fallback recommendation method. The AI model encountered an issue.',
                      style: TextStyle(color: Colors.orange.shade800),
                    ),
                  ],
                ),
              ),

            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Icon(Icons.pets, color: Colors.white, size: 40),
                  const SizedBox(height: 10),
                  Text(
                    'Perfect Match Found!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Based on your ${widget.petPreferences['petType']}\'s needs',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Food image
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                recommendedFood['image'],
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    width: double.infinity,
                    color: Colors.grey.shade300,
                    child: Icon(
                      Icons.image_not_supported,
                      color: Colors.grey.shade700,
                      size: 50,
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // Food name and rating
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    recommendedFood['name'],
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        recommendedFood['rating'].toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.amber,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Price
            Text(
              recommendedFood['price'],
              style: TextStyle(
                fontSize: 20,
                color: Colors.blue.shade700,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            // Description
            Text(
              recommendedFood['description'],
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade700,
              ),
            ),

            const SizedBox(height: 20),

            // Features
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  (recommendedFood['features'] as List<String>).map((feature) {
                return Chip(
                  label: Text(
                    feature,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  backgroundColor: Colors.blue,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                );
              }).toList(),
            ),

            const SizedBox(height: 24),

            // Benefits
            const Text(
              'Benefits',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            ...List.generate(
              (recommendedFood['benefits'] as List<String>).length,
              (index) {
                final benefit =
                    (recommendedFood['benefits'] as List<String>)[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 22,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          benefit,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade800,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 30),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // Handle view details action
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.blue,
                      side: const BorderSide(color: Colors.blue),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text('View Details'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle buy now action
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text('Buy Now'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
