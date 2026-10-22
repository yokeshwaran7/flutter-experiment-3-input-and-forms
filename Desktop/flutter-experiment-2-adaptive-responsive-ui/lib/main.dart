// ============================================================
// Experiment 2: Adaptive and Responsive UI Design
// Application : ShopEasy – E-Commerce Product Catalog
// Concepts    : LayoutBuilder, MediaQuery, GridView.builder,
//               Reusable Custom Widget (ProductCard),
//               MaterialApp, Scaffold, AppBar, Card, Row,
//               Column, Container, Expanded, Padding, SizedBox
// ============================================================

import 'package:flutter/material.dart';

// -------------------------------------------------------
// Entry Point
// -------------------------------------------------------
void main() {
  runApp(const MyApp());
}

// -------------------------------------------------------
// Root Application Widget – MaterialApp
// -------------------------------------------------------
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ShopEasy – E-Commerce Product Catalog',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1B5E20), // deep green
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const CatalogPage(),
    );
  }
}

// -------------------------------------------------------
// Product Data Model
// -------------------------------------------------------
class Product {
  final String name;
  final String category;
  final String price;
  final double rating;
  final IconData icon;
  final Color color;
  final Color iconColor;

  const Product({
    required this.name,
    required this.category,
    required this.price,
    required this.rating,
    required this.icon,
    required this.color,
    required this.iconColor,
  });
}

// -------------------------------------------------------
// Product Data – 8 Products
// -------------------------------------------------------
const List<Product> allProducts = [
  Product(
    name: 'Laptop',
    category: 'Electronics',
    price: '₹ 54,999',
    rating: 4.5,
    icon: Icons.laptop,
    color: Color(0xFFE3F2FD),
    iconColor: Color(0xFF1565C0),
  ),
  Product(
    name: 'Smartphone',
    category: 'Electronics',
    price: '₹ 29,999',
    rating: 4.7,
    icon: Icons.smartphone,
    color: Color(0xFFE8F5E9),
    iconColor: Color(0xFF2E7D32),
  ),
  Product(
    name: 'Headphones',
    category: 'Electronics',
    price: '₹ 4,499',
    rating: 4.3,
    icon: Icons.headphones,
    color: Color(0xFFF3E5F5),
    iconColor: Color(0xFF6A1B9A),
  ),
  Product(
    name: 'Smart Watch',
    category: 'Accessories',
    price: '₹ 9,999',
    rating: 4.6,
    icon: Icons.watch,
    color: Color(0xFFFFF8E1),
    iconColor: Color(0xFFF57F17),
  ),
  Product(
    name: 'Camera',
    category: 'Electronics',
    price: '₹ 39,999',
    rating: 4.4,
    icon: Icons.camera_alt,
    color: Color(0xFFFFEBEE),
    iconColor: Color(0xFFC62828),
  ),
  Product(
    name: 'Sneakers',
    category: 'Fashion',
    price: '₹ 3,999',
    rating: 4.2,
    icon: Icons.directions_run,
    color: Color(0xFFE0F7FA),
    iconColor: Color(0xFF00838F),
  ),
  Product(
    name: 'Backpack',
    category: 'Fashion',
    price: '₹ 2,499',
    rating: 4.1,
    icon: Icons.backpack,
    color: Color(0xFFFCE4EC),
    iconColor: Color(0xFFAD1457),
  ),
  Product(
    name: 'Tablet',
    category: 'Electronics',
    price: '₹ 24,999',
    rating: 4.5,
    icon: Icons.tablet,
    color: Color(0xFFE8EAF6),
    iconColor: Color(0xFF283593),
  ),
];

// Category list for filter chips
const List<String> categories = ['All', 'Electronics', 'Fashion', 'Accessories'];

// -------------------------------------------------------
// Main Catalog Page – StatefulWidget (for category filter)
// -------------------------------------------------------
class CatalogPage extends StatefulWidget {
  const CatalogPage({super.key});

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  String _selectedCategory = 'All';

  // Filter products based on selected category
  List<Product> get _filteredProducts {
    if (_selectedCategory == 'All') return allProducts;
    return allProducts.where((p) => p.category == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F8E9),

      // ── AppBar ──
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        title: Row(
          children: const [
            Icon(Icons.shopping_bag, color: Colors.white, size: 26),
            SizedBox(width: 8),
            Text(
              'ShopEasy',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
          const SizedBox(width: 4),
        ],
        elevation: 4,
      ),

      body: Column(
        children: [
          // ── Header Banner (Container + Row + Column) ──
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2E7D32), Color(0xFF43A047)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.science, color: Colors.white, size: 36),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'EXPERIMENT 2',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                        letterSpacing: 1.6,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Adaptive & Responsive UI',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Layout changes based on screen width',
                      style: TextStyle(
                        color: Colors.white60,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ── Search Field ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search products...',
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                prefixIcon: const Icon(Icons.search, color: Color(0xFF2E7D32)),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 1.5),
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // ── Category Filter Chips (Row) ──
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final cat = categories[index];
                final isSelected = cat == _selectedCategory;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(cat),
                    selected: isSelected,
                    onSelected: (_) => setState(() => _selectedCategory = cat),
                    selectedColor: const Color(0xFF2E7D32),
                    backgroundColor: Colors.white,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : const Color(0xFF2E7D32),
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                    side: const BorderSide(color: Color(0xFF2E7D32)),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 8),

          // ── Responsive Product Grid ──
          // Uses LayoutBuilder to read the available width and choose
          // the correct number of columns automatically.
          Expanded(
            // LayoutBuilder provides the constraints of the parent widget.
            // We use constraints.maxWidth to decide the grid column count.
            child: LayoutBuilder(
              builder: (context, constraints) {
                // ── RESPONSIVE COLUMN COUNT CALCULATION ──
                // Width < 600px  → 2 columns  (mobile phone)
                // Width 600–899px → 3 columns  (tablet portrait)
                // Width >= 900px  → 4 columns  (tablet landscape / desktop)
                final double screenWidth = constraints.maxWidth;
                int columnCount;
                if (screenWidth < 600) {
                  columnCount = 2; // Mobile
                } else if (screenWidth < 900) {
                  columnCount = 3; // Tablet
                } else {
                  columnCount = 4; // Desktop / wide tablet
                }

                // Responsive padding based on screen width
                final double gridPadding = screenWidth < 600 ? 10.0 : 16.0;

                // ── GridView.builder ──
                // Builds the product grid lazily with crossAxisCount
                // dynamically set from the responsive column count above.
                return GridView.builder(
                  padding: EdgeInsets.fromLTRB(
                    gridPadding, 0, gridPadding, gridPadding,
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columnCount, // responsive!
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.72,
                  ),
                  itemCount: _filteredProducts.length,
                  itemBuilder: (context, index) {
                    // ── ProductCard custom widget is used here ──
                    return ProductCard(product: _filteredProducts[index]);
                  },
                );
              },
            ),
          ),

          // ── Footer ──
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            color: const Color(0xFF2E7D32),
            child: const Text(
              'Flutter Lab Experiment 2  •  Adaptive & Responsive UI Design',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------
// Reusable Custom Widget – ProductCard
// Displays: product image (icon), name, category,
//           price, rating, and Add to Cart button.
// Used in GridView.builder above.
// -------------------------------------------------------
class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Product Image Area (gradient container + icon) ──
          Expanded(
            flex: 4,
            child: Container(
              decoration: BoxDecoration(
                color: product.color,
                gradient: LinearGradient(
                  colors: [product.color, Colors.white],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Center(
                child: Icon(
                  product.icon,
                  size: 56,
                  color: product.iconColor,
                ),
              ),
            ),
          ),

          // ── Product Details ──
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Color(0xFF1B5E20),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 2),

                  // Category Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: product.iconColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      product.category,
                      style: TextStyle(
                        fontSize: 10,
                        color: product.iconColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 4),

                  // Price
                  Text(
                    product.price,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E7D32),
                    ),
                  ),

                  const SizedBox(height: 3),

                  // Star Rating (Row)
                  Row(
                    children: [
                      const Icon(Icons.star, size: 13, color: Color(0xFFFFA000)),
                      const SizedBox(width: 2),
                      Text(
                        product.rating.toString(),
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF757575),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  // Add to Cart Button
                  SizedBox(
                    width: double.infinity,
                    height: 30,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${product.name} added to cart!'),
                            duration: const Duration(seconds: 1),
                            backgroundColor: const Color(0xFF2E7D32),
                          ),
                        );
                      },
                      icon: const Icon(Icons.add_shopping_cart, size: 13),
                      label: const Text(
                        'Add to Cart',
                        style: TextStyle(fontSize: 11),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E7D32),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
