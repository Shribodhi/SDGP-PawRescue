import 'package:flutter/material.dart';
import '../services/tflite_service.dart';

class FoodRecommendationScreen extends StatefulWidget {
  final Map<String, dynamic> petPreferences;

  const FoodRecommendationScreen({
    Key? key,
    required this.petPreferences,
  }) : super(key: key);

  @override
  _FoodRecommendationScreenState createState() =>
      _FoodRecommendationScreenState();
}

class _FoodRecommendationScreenState extends State<FoodRecommendationScreen>
    with SingleTickerProviderStateMixin {
  final TFLiteService _tfliteService = TFLiteService();
  late AnimationController _animationController;
  bool _isLoading = false;
  double _recommendation = 0;

  // Sample food data - Replace with your actual food database
  final List<Map<String, dynamic>> _foodOptions = [
    {
      'name': 'Premium Dog Nutrition',
      'image':
          'https://example.com/dog-food-1.jpg', // Replace with actual image URL
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
    // Add more food options here
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
      // Convert preferences to input data for TFLite
      List<double> inputData =
          _convertPreferencesToInput(widget.petPreferences);

      // Get prediction from TFLite
      _recommendation = _tfliteService.predict(inputData)[0];

      // Show recommendation dialog after prediction
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
    // Convert preferences to the format expected by your TFLite model
    // This is just an example - modify according to your model's requirements
    return [
      preferences['petType'] == 'Dog' ? 1.0 : 0.0,
      preferences['healthCondition'] == 'Healthy' ? 1.0 : 0.0,
      preferences['petAge'] == 'Adult' ? 1.0 : 0.0,
      // Add more conversions based on your model's input requirements
    ];
  }

  void _showRecommendationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header with close button
                Stack(
                  children: [
                    Container(
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.pets,
                              color: Colors.white,
                              size: 40,
                            ),
                            const SizedBox(height: 8),
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

                // Food recommendation content
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Food image
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
                            image: NetworkImage(_foodOptions[0]['image']),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Food name and rating
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _foodOptions[0]['name'],
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 18,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  _foodOptions[0]['rating'].toString(),
                                  style: TextStyle(
                                    color: Colors.blue.shade700,
                                    fontWeight: FontWeight.bold,
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
                        _foodOptions[0]['price'],
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.blue.shade700,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Features chips
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: (_foodOptions[0]['features'] as List<String>)
                            .map((feature) => Chip(
                                  label: Text(
                                    feature,
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  backgroundColor: Colors.blue,
                                ))
                            .toList(),
                      ),
                      const SizedBox(height: 20),

                      // Benefits
                      const Text(
                        'Benefits',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...(_foodOptions[0]['benefits'] as List<String>)
                          .map((benefit) => Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.check_circle,
                                      color: Colors.green.shade400,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(benefit),
                                    ),
                                  ],
                                ),
                              ))
                          .toList(),
                      const SizedBox(height: 24),

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
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
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
                              onPressed: () {
                                // Handle buy now action
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
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
              ],
            ),
          ),
        );
      },
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
                    style: TextStyle(
                      color: Colors.blue.shade700,
                      fontSize: 16,
                    ),
                  ),
                ],
              )
            : const SizedBox(), // Empty when not loading as dialog will show
      ),
    );
  }
}
