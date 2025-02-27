import 'package:flutter/material.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  final List<Map<String, dynamic>> _products = [
    {
      'name': 'Premium Dog Food',
      'category': 'Food',
      'price': 29.99,
      'rating': 4.7,
      'image': 'assets/images/dog_food.png',
    },
    {
      'name': 'Cat Collar with Bell',
      'category': 'Accessories',
      'price': 12.99,
      'rating': 4.5,
      'image': 'assets/images/cat_collar.png',
    },
    {
      'name': 'Interactive Pet Toy',
      'category': 'Toys',
      'price': 15.99,
      'rating': 4.8,
      'image': 'assets/images/pet_toy.png',
    },
    {
      'name': 'Pet Shampoo',
      'category': 'Grooming',
      'price': 9.99,
      'rating': 4.6,
      'image': 'assets/images/pet_shampoo.png',
    },
    {
      'name': 'Dog Leash',
      'category': 'Accessories',
      'price': 19.99,
      'rating': 4.9,
      'image': 'assets/images/dog_leash.png',
    },
    {
      'name': 'Cat Litter Box',
      'category': 'Essentials',
      'price': 24.99,
      'rating': 4.3,
      'image': 'assets/images/cat_litter.png',
    },
  ];

  String _selectedCategory = 'All';
  final List<String> _categories = [
    'All',
    'Food',
    'Toys',
    'Accessories',
    'Grooming',
    'Essentials'
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search bar
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(15),
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: const Icon(Icons.search),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 15),
                hintStyle: TextStyle(color: Colors.grey[500]),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Category filter
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    selected: _selectedCategory == _categories[index],
                    label: Text(_categories[index]),
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = _categories[index];
                      });
                    },
                    backgroundColor: Colors.grey[200],
                    selectedColor: const Color(0xFF219EBC),
                    checkmarkColor: Colors.white,
                    labelStyle: TextStyle(
                      color: _selectedCategory == _categories[index]
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 20),

          // Products grid
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: _products
                  .where((product) =>
                      _selectedCategory == 'All' ||
                      product['category'] == _selectedCategory)
                  .length,
              itemBuilder: (context, index) {
                final filteredProducts = _products
                    .where((product) =>
                        _selectedCategory == 'All' ||
                        product['category'] == _selectedCategory)
                    .toList();
                final product = filteredProducts[index];

                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product image
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(15),
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.pets,
                              size: 80,
                              color: Colors.grey[400],
                            ),
                          ),
                        ),
                      ),

                      // Product info
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product['name'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              product['category'],
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '\$${product['price']}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF023047),
                                    fontSize: 16,
                                  ),
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      size: 15,
                                      color: Colors.amber,
                                    ),
                                    const SizedBox(width: 2),
                                    Text(
                                      '${product['rating']}',
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
