// ============================================================
// EXPERIMENT 3: Add Interactivity to App – Input and Forms
// Application: Product Search & Filter
//
// KEY CONCEPTS DEMONSTRATED:
// 1. Search Input Handling  - TextField/TextFormField with onChanged
// 2. Category Filtering     - DropdownButtonFormField with setState
// 3. Price Filtering        - Slider widget with setState
// 4. Form Validation        - Form widget with GlobalKey<FormState>
// 5. setState               - Updates UI on user interaction
// 6. ProductCard Widget     - Reusable custom StatelessWidget
// 7. Add to Cart            - SnackBar + cart count tracking
// ============================================================

import 'package:flutter/material.dart';

void main() {
  runApp(const ProductSearchApp());
}

// ============================================================
// ROOT APP WIDGET
// MaterialApp sets the theme (green/blue modern theme)
// ============================================================
class ProductSearchApp extends StatelessWidget {
  const ProductSearchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product Search & Filter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Modern green/teal color scheme
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00897B), // Teal 600
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
        // AppBar theme
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF00897B),
          foregroundColor: Colors.white,
          elevation: 4,
          centerTitle: true,
        ),
        // ElevatedButton theme
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00897B),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
        ),
        // Input decoration theme
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey.shade50,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF00897B), width: 2),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        cardTheme: CardThemeData(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          clipBehavior: Clip.antiAlias,
        ),
      ),
      home: const ProductHomePage(),
    );
  }
}

// ============================================================
// PRODUCT DATA MODEL
// Represents a single product with all required fields
// ============================================================
class Product {
  final String name;
  final String category;
  final double price;
  final double rating;
  final IconData icon;
  final Color iconColor;

  const Product({
    required this.name,
    required this.category,
    required this.price,
    required this.rating,
    required this.icon,
    required this.iconColor,
  });
}

// ============================================================
// PREDEFINED PRODUCT LIST (12 products)
// Categories: Electronics, Accessories, Fashion
// ============================================================
const List<Product> allProducts = [
  Product(
    name: 'Laptop',
    category: 'Electronics',
    price: 75000,
    rating: 4.5,
    icon: Icons.laptop,
    iconColor: Color(0xFF1565C0),
  ),
  Product(
    name: 'Smartphone',
    category: 'Electronics',
    price: 55000,
    rating: 4.7,
    icon: Icons.smartphone,
    iconColor: Color(0xFF6A1B9A),
  ),
  Product(
    name: 'Headphones',
    category: 'Electronics',
    price: 8000,
    rating: 4.3,
    icon: Icons.headphones,
    iconColor: Color(0xFF00838F),
  ),
  Product(
    name: 'Smart Watch',
    category: 'Electronics',
    price: 22000,
    rating: 4.4,
    icon: Icons.watch,
    iconColor: Color(0xFF2E7D32),
  ),
  Product(
    name: 'Camera',
    category: 'Electronics',
    price: 45000,
    rating: 4.6,
    icon: Icons.camera_alt,
    iconColor: Color(0xFFBF360C),
  ),
  Product(
    name: 'Tablet',
    category: 'Electronics',
    price: 35000,
    rating: 4.2,
    icon: Icons.tablet,
    iconColor: Color(0xFF00695C),
  ),
  Product(
    name: 'Sneakers',
    category: 'Fashion',
    price: 4500,
    rating: 4.1,
    icon: Icons.directions_run,
    iconColor: Color(0xFFE65100),
  ),
  Product(
    name: 'Backpack',
    category: 'Fashion',
    price: 2500,
    rating: 4.0,
    icon: Icons.backpack,
    iconColor: Color(0xFF4E342E),
  ),
  Product(
    name: 'Keyboard',
    category: 'Accessories',
    price: 3500,
    rating: 4.4,
    icon: Icons.keyboard,
    iconColor: Color(0xFF37474F),
  ),
  Product(
    name: 'Mouse',
    category: 'Accessories',
    price: 1500,
    rating: 4.2,
    icon: Icons.mouse,
    iconColor: Color(0xFF455A64),
  ),
  Product(
    name: 'USB Hub',
    category: 'Accessories',
    price: 2000,
    rating: 3.9,
    icon: Icons.usb,
    iconColor: Color(0xFF1B5E20),
  ),
  Product(
    name: 'Sunglasses',
    category: 'Fashion',
    price: 1800,
    rating: 4.0,
    icon: Icons.wb_sunny,
    iconColor: Color(0xFFF57F17),
  ),
];

// ============================================================
// MAIN PAGE - StatefulWidget
// Manages all state: search text, category, price, cart count
// setState is used to rebuild UI whenever filters change
// ============================================================
class ProductHomePage extends StatefulWidget {
  const ProductHomePage({super.key});

  @override
  State<ProductHomePage> createState() => _ProductHomePageState();
}

class _ProductHomePageState extends State<ProductHomePage> {
  // -------------------------------------------------------
  // Form Key for Form validation
  // -------------------------------------------------------
  final _formKey = GlobalKey<FormState>();

  // -------------------------------------------------------
  // Controllers and State Variables
  // -------------------------------------------------------

  // Search: TextEditingController links TextField to search logic
  final TextEditingController _searchController = TextEditingController();

  // Category dropdown: 'All' means no category filter applied
  String _selectedCategory = 'All';

  // Price Slider: max price filter (100000 is the absolute max)
  double _maxPrice = 100000;
  static const double _absoluteMaxPrice = 100000;

  // Cart count displayed in AppBar badge
  int _cartCount = 0;

  // Filtered list shown in the product grid
  List<Product> _filteredProducts = List.from(allProducts);

  // Category options for DropdownButtonFormField
  final List<String> _categories = [
    'All',
    'Electronics',
    'Accessories',
    'Fashion'
  ];

  @override
  void dispose() {
    // Always dispose controllers to free resources
    _searchController.dispose();
    super.dispose();
  }

  // ============================================================
  // SEARCH FUNCTIONALITY
  // Called from TextField's onChanged to filter products by name
  // Uses setState to rebuild the product list in real-time
  // ============================================================
  void _onSearchChanged(String query) {
    // setState triggers a UI rebuild with the new filtered list
    setState(() {
      _filteredProducts = _applyFilters(
        searchQuery: query,
        category: _selectedCategory,
        maxPrice: _maxPrice,
      );
    });
  }

  // ============================================================
  // CATEGORY FILTERING
  // Called when DropdownButtonFormField value changes
  // Filters products by their category field
  // ============================================================
  void _onCategoryChanged(String? category) {
    if (category == null) return;
    setState(() {
      _selectedCategory = category;
      _filteredProducts = _applyFilters(
        searchQuery: _searchController.text,
        category: category,
        maxPrice: _maxPrice,
      );
    });
  }

  // ============================================================
  // PRICE FILTERING
  // Called as Slider value changes (live update)
  // Filters products whose price <= selected maximum price
  // ============================================================
  void _onPriceChanged(double value) {
    setState(() {
      _maxPrice = value;
      _filteredProducts = _applyFilters(
        searchQuery: _searchController.text,
        category: _selectedCategory,
        maxPrice: value,
      );
    });
  }

  // ============================================================
  // CORE FILTER LOGIC
  // Combines search, category, and price filters together
  // Returns filtered list of products matching all conditions
  // ============================================================
  List<Product> _applyFilters({
    required String searchQuery,
    required String category,
    required double maxPrice,
  }) {
    return allProducts.where((product) {
      // Search filter: case-insensitive name match
      final matchesSearch =
          searchQuery.isEmpty ||
          product.name.toLowerCase().contains(searchQuery.toLowerCase());

      // Category filter: 'All' passes every product
      final matchesCategory =
          category == 'All' || product.category == category;

      // Price filter: product price must be <= selected max price
      final matchesPrice = product.price <= maxPrice;

      // Product passes only if ALL conditions are true
      return matchesSearch && matchesCategory && matchesPrice;
    }).toList();
  }

  // ============================================================
  // APPLY FILTERS BUTTON ACTION
  // Validates form, then applies all current filter values
  // ============================================================
  void _applyFiltersAction() {
    // Form validation: checks all TextFormField validators
    if (_formKey.currentState!.validate()) {
      setState(() {
        _filteredProducts = _applyFilters(
          searchQuery: _searchController.text,
          category: _selectedCategory,
          maxPrice: _maxPrice,
        );
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Filters applied!'),
          backgroundColor: const Color(0xFF00897B),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  // ============================================================
  // CLEAR FILTERS BUTTON ACTION
  // Resets all filter state to defaults and shows all products
  // ============================================================
  void _clearFilters() {
    setState(() {
      // Clear search text field
      _searchController.clear();
      // Reset category to 'All'
      _selectedCategory = 'All';
      // Reset price slider to maximum
      _maxPrice = _absoluteMaxPrice;
      // Show all products
      _filteredProducts = List.from(allProducts);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Filters cleared!'),
        backgroundColor: Colors.blueGrey,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // ============================================================
  // ADD TO CART
  // Increases cart count and shows a SnackBar notification
  // ============================================================
  void _addToCart(Product product) {
    setState(() {
      _cartCount++;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} added to cart'),
        backgroundColor: const Color(0xFF1565C0),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'VIEW',
          textColor: Colors.white,
          onPressed: () {},
        ),
      ),
    );
  }

  // ============================================================
  // BUILD METHOD
  // Assembles the complete UI structure:
  // AppBar -> Header -> Search -> Filters -> Product Grid
  // ============================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F8F6),
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section: "Find Your Product"
            _buildHeader(),

            // Search and Filter section (wrapped in Form)
            _buildSearchFilterSection(),

            // Results count indicator
            _buildResultsCount(),

            // Product list/grid section
            _buildProductGrid(),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // APP BAR with cart count badge
  // ============================================================
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text(
        'Product Search & Filter',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      actions: [
        // Cart icon with item count badge
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart, size: 28),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Cart has $_cartCount item(s)'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
              if (_cartCount > 0)
                Positioned(
                  top: 6,
                  right: 6,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '$_cartCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // HEADER BANNER
  // ============================================================
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF00897B), Color(0xFF0288D1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Find Your Product',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${allProducts.length} products available',
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SEARCH AND FILTER SECTION
  // Uses Form widget for validation
  // Contains: TextFormField (search), DropdownButtonFormField,
  //           Slider, Apply Filters button, Clear Filters button
  // ============================================================
  Widget _buildSearchFilterSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Form(
        // Form widget with GlobalKey for validation
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // -----------------------------------------------
            // SEARCH FIELD using TextFormField
            // onChanged: live filtering as user types
            // validator: no error for empty search (shows all)
            // -----------------------------------------------
            const Text(
              'Search Products',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Color(0xFF00695C),
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _searchController,
              // SEARCH INPUT HANDLING: updates filtered list on each keystroke
              onChanged: _onSearchChanged,
              decoration: const InputDecoration(
                hintText: 'Search by product name...',
                prefixIcon: Icon(Icons.search, color: Color(0xFF00897B)),
              ),
              // FORM VALIDATION: empty search is allowed (shows all products)
              validator: (value) {
                // No validation error for empty search field
                // An empty search simply shows all products
                return null;
              },
            ),

            const SizedBox(height: 20),

            // -----------------------------------------------
            // CATEGORY DROPDOWN using DropdownButtonFormField
            // CATEGORY FILTERING: changes _selectedCategory
            // -----------------------------------------------
            const Text(
              'Filter by Category',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Color(0xFF00695C),
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(
                prefixIcon:
                    Icon(Icons.category, color: Color(0xFF00897B)),
              ),
              // CATEGORY FILTERING: onChanged triggers _onCategoryChanged
              onChanged: _onCategoryChanged,
              items: _categories
                  .map((cat) => DropdownMenuItem(
                        value: cat,
                        child: Text(cat),
                      ))
                  .toList(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a category';
                }
                return null;
              },
            ),

            const SizedBox(height: 20),

            // -----------------------------------------------
            // PRICE SLIDER
            // PRICE FILTERING: _maxPrice controls max price
            // Slider updates _maxPrice and filters in real-time
            // -----------------------------------------------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Maximum Price',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Color(0xFF00695C),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00897B),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Rs.${_maxPrice.toInt()}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            // PRICE FILTERING: Slider from Rs.0 to Rs.1,00,000
            Slider(
              value: _maxPrice,
              min: 0,
              max: _absoluteMaxPrice,
              divisions: 20, // Steps of Rs.5000
              activeColor: const Color(0xFF00897B),
              inactiveColor: const Color(0xFFB2DFDB),
              // onChanged triggers price filter update
              onChanged: _onPriceChanged,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('Rs.0',
                    style: TextStyle(color: Colors.grey, fontSize: 12)),
                Text('Rs.1,00,000',
                    style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),

            const SizedBox(height: 20),

            // -----------------------------------------------
            // ACTION BUTTONS: Apply Filters + Clear Filters
            // -----------------------------------------------
            Row(
              children: [
                // APPLY FILTERS button: validates form & applies filters
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _applyFiltersAction,
                    icon: const Icon(Icons.filter_alt),
                    label: const Text('Apply Filters'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00897B),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // CLEAR FILTERS button: resets all filters
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _clearFilters,
                    icon: const Icon(Icons.clear_all),
                    label: const Text('Clear Filters'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // RESULTS COUNT INDICATOR
  // Shows how many products match the current filters
  // ============================================================
  Widget _buildResultsCount() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 20,
            decoration: BoxDecoration(
              color: const Color(0xFF00897B),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${_filteredProducts.length} product(s) found',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
              color: Color(0xFF00695C),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // PRODUCT GRID
  // Uses GridView.builder to display ProductCard widgets
  // shrinkWrap + NeverScrollableScrollPhysics since inside
  // SingleChildScrollView
  // ============================================================
  Widget _buildProductGrid() {
    if (_filteredProducts.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            children: [
              Icon(Icons.search_off, size: 60, color: Colors.grey.shade400),
              const SizedBox(height: 16),
              Text(
                'No products found',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Try adjusting your search or filters',
                style:
                    TextStyle(fontSize: 14, color: Colors.grey.shade500),
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.72,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: _filteredProducts.length,
        itemBuilder: (context, index) {
          final product = _filteredProducts[index];
          // =====================================================
          // PRODUCTCARD CUSTOM WIDGET
          // Reusable widget that receives product data & callback
          // =====================================================
          return ProductCard(
            product: product,
            onAddToCart: () => _addToCart(product),
          );
        },
      ),
    );
  }
}

// ============================================================
// PRODUCTCARD - Reusable Custom Widget (StatelessWidget)
//
// Displays:
//   - Product icon with colored background
//   - Product name
//   - Category badge
//   - Price in INR
//   - Star rating
//   - Add to Cart ElevatedButton
//
// Accepts:
//   - product: Product object with all display data
//   - onAddToCart: Callback function for cart action
// ============================================================
class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onAddToCart;

  const ProductCard({
    super.key,
    required this.product,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Icon with colored circular background
            Center(
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: product.iconColor.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  product.icon,
                  size: 34,
                  color: product.iconColor,
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Product Name
            Text(
              product.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Color(0xFF1A1A2E),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            // Category Badge
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFF00897B).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                product.category,
                style: const TextStyle(
                  fontSize: 10,
                  color: Color(0xFF00695C),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            // Price
            Text(
              'Rs.${product.price.toInt()}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1565C0),
              ),
            ),

            // Star Rating Row
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 14),
                const SizedBox(width: 4),
                Text(
                  product.rating.toString(),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),

            // Add to Cart Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onAddToCart,
                icon: const Icon(Icons.add_shopping_cart, size: 14),
                label: const Text(
                  'Add to Cart',
                  style: TextStyle(fontSize: 11),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00897B),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
