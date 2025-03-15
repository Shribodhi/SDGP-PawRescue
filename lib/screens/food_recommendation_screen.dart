import 'package:flutter/material.dart';
import '../services/tflite_service.dart';

class FoodRecommendationScreen extends StatefulWidget {
  final Map<String, dynamic> petPreferences;

  const FoodRecommendationScreen({super.key, required this.petPreferences});

  @override
  _FoodRecommendationScreenState createState() =>
      _FoodRecommendationScreenState();
}

class _FoodRecommendationScreenState extends State<FoodRecommendationScreen>
    with SingleTickerProviderStateMixin {
  final TFLiteService _tfliteService = TFLiteService();
  late AnimationController _animationController;
  bool _isLoading = false;
  int _recommendedIndex = 0;

  final List<Map<String, dynamic>> _foodOptions = [
    {
      'name': 'Premium Dog Nutrition',
      'image': 'https://example.com/dog-food-1.jpg',
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
      'image': 'https://example.com/cat-food-1.jpg',
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
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _tfliteService.loadModel();
    _getRecommendation();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _tfliteService.close();
    super.dispose();
  }

  Future<void> _getRecommendation() async {
    setState(() => _isLoading = true);

    try {
      List<double> inputData =
          _convertPreferencesToInput(widget.petPreferences);
      double recommendationScore = _tfliteService.predict(inputData)[0];

      _recommendedIndex = recommendationScore > 0.5 ? 0 : 1;

      _showRecommendationDialog();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error getting recommendation: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  List<double> _convertPreferencesToInput(Map<String, dynamic> preferences) {
    return [
      preferences['petType'] == 'Dog' ? 1.0 : 0.0,
      preferences['healthCondition'] == 'Healthy' ? 1.0 : 0.0,
      preferences['petAge'] == 'Adult' ? 1.0 : 0.0,
    ];
  }

  void _showRecommendationDialog() {
    final recommendedFood = _foodOptions[_recommendedIndex];

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    Container(
                      height: 120,
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.pets, color: Colors.white, size: 40),
                            SizedBox(height: 8),
                            Text(
                              'Perfect Match Found!',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      right: 8,
                      top: 8,
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    image: DecorationImage(
                      image: NetworkImage(recommendedFood['image']),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  recommendedFood['name'],
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  recommendedFood['price'],
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.blue.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: (recommendedFood['features'] as List<String>)
                      .map((feature) => Chip(
                            label: Text(feature,
                                style: TextStyle(color: Colors.white)),
                            backgroundColor: Colors.blue,
                          ))
                      .toList(),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Benefits',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: (recommendedFood['benefits'] as List<String>)
                      .map((benefit) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: [
                                Icon(Icons.check_circle,
                                    color: Colors.green.shade400, size: 20),
                                const SizedBox(width: 8),
                                Expanded(child: Text(benefit)),
                              ],
                            ),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {},
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
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pet Food Recommendation'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: _isLoading
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(color: Colors.blue),
                  const SizedBox(height: 16),
                  Text(
                    'Finding the perfect food for your pet...',
                    style: TextStyle(color: Colors.blue.shade700, fontSize: 16),
                  ),
                ],
              )
            : const SizedBox(),
      ),
    );
  }
}
