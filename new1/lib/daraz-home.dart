import 'package:flutter/material.dart';
import 'dart:ui'; 

void main() {
  runApp(const DarazHomeView());
}

class DarazHomeView extends StatefulWidget {
  const DarazHomeView({super.key});

  @override
  State<DarazHomeView> createState() => _DarazHomeViewState();
}

class _DarazHomeViewState extends State<DarazHomeView> {
  int _selectedIndex = 0; 


  final List<Widget> _screens = [
    const GridScreen(),
    const FavoritesScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daraz Home View',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Product Grid with Header'),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
        body: _screens[_selectedIndex], // Show the selected screen
        bottomNavigationBar: _buildCurvedNavigationBar(),
      ),
    );
  }

  Widget _buildCurvedNavigationBar() {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          color:
              Colors.black.withOpacity(1.0), // Background color with transparency
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_max_rounded),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite_outline_sharp),
                label: 'Favorites',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_circle_outlined),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GridScreen extends StatefulWidget {
  const GridScreen({super.key});

  @override
  _GridScreenState createState() => _GridScreenState();
}

class _GridScreenState extends State<GridScreen> {
  // Cart and favorites management
  List<Product> _cart = [];
  List<Product> _favorites = [];

  void _toggleFavorite(Product product) {
    setState(() {
      if (_favorites.contains(product)) {
        _favorites.remove(product);
      } else {
        _favorites.add(product);
      }
    });
  }

  void _toggleCart(Product product) {
    setState(() {
      if (_cart.contains(product)) {
        _cart.remove(product);
      } else {
        _cart.add(product);
      }
    });
  }

  void _navigateToProductDetail(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(
          product: product,
          isInCart: _cart.contains(product),
          isFavorite: _favorites.contains(product),
          onCartToggle: () => _toggleCart(product),
          onFavoriteToggle: () => _toggleFavorite(product),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Section
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome to the Shop',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Explore our collection of shoes and confectionery below.',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 7.0,
                childAspectRatio: 2 / 3,
              ),
              itemCount: products.length,
              itemBuilder: (BuildContext context, int index) {
                final product = products[index];
                return GestureDetector(
                  onTap: () => _navigateToProductDetail(product),
                  child: GridTileItem(
                    product: product,
                    isInCart: _cart.contains(product),
                    isFavorite: _favorites.contains(product),
                    onFavoriteToggle: () => _toggleFavorite(product),
                    onCartToggle: () => _toggleCart(product),
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

// Product model
class Product {
  final String title;
  final String imageUrl;
  final String price;
  final String description;

  Product({
    required this.title,
    required this.imageUrl,
    required this.price,
    required this.description,
  });
}

final List<Product> products = [
  Product(
      title: 'Running Shoes',
      imageUrl: 'assets/images/shoes1.jpg',
      price: '\$79.99',
      description: 'Comfortable running shoes with great support.'),
  Product(
      title: 'Casual Sneakers',
      imageUrl: 'assets/images/shoes2.jpg',
      price: '\$59.99',
      description: 'Stylish casual sneakers for everyday wear.'),
  Product(
      title: 'Chocolate Cake',
      imageUrl: 'assets/images/confectionery1.jpg',
      price: '\$14.99',
      description: 'Delicious chocolate cake perfect for any occasion.'),
  Product(
      title: 'Cupcakes',
      imageUrl: 'assets/images/confectionery2.jpg',
      price: '\$9.99',
      description: 'Delightful cupcakes in different flavors.'),
  Product(
      title: 'Sports Shoes',
      imageUrl: 'assets/images/shoes3.jpg',
      price: '\$99.99',
      description: 'High-performance sports shoes for athletes.'),
  Product(
      title: 'Designer Sneakers',
      imageUrl: 'assets/images/shoes4.jpg',
      price: '\$129.99',
      description: 'Luxury designer sneakers with a modern look.'),
  Product(
      title: 'Macarons',
      imageUrl: 'assets/images/confectionery3.jpg',
      price: '\$19.99',
      description: 'Assorted macarons in a variety of flavors.'),
  Product(
      title: 'Donuts',
      imageUrl: 'assets/images/confectionery4.jpg',
      price: '\$5.99',
      description: 'Fresh donuts, the perfect sweet snack.'),
];

class GridTileItem extends StatelessWidget {
  final Product product;
  final bool isInCart;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onCartToggle;

  const GridTileItem({
    super.key,
    required this.product,
    required this.isInCart,
    required this.isFavorite,
    required this.onFavoriteToggle,
    required this.onCartToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12.0),
                topRight: Radius.circular(12.0),
              ),
              child: Image.asset(
                product.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  product.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  product.price,
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.w500,
                    fontSize: 14.0,
                  ),
                  textAlign: TextAlign.center,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : null,
                      ),
                      onPressed: onFavoriteToggle,
                    ),
                    IconButton(
                      icon: Icon(
                        isInCart
                            ? Icons.remove_shopping_cart
                            : Icons.add_shopping_cart,
                      ),
                      onPressed: onCartToggle,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProductDetailScreen extends StatelessWidget {
  final Product product;
  final bool isInCart;
  final bool isFavorite;
  final VoidCallback onCartToggle;
  final VoidCallback onFavoriteToggle;

  const ProductDetailScreen({
    super.key,
    required this.product,
    required this.isInCart,
    required this.isFavorite,
    required this.onCartToggle,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.asset(product.imageUrl, fit: BoxFit.cover),
            const SizedBox(height: 16),
            Text(
              product.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              product.price,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              product.description,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : null,
                  ),
                  onPressed: onFavoriteToggle,
                ),
                IconButton(
                  icon: Icon(
                    isInCart
                        ? Icons.remove_shopping_cart
                        : Icons.add_shopping_cart,
                  ),
                  onPressed: onCartToggle,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Use the provider or state management to fetch favorites in real app
    final _favorites =
        products.where((product) => product.title == 'Running Shoes').toList();

    return ListView.builder(
      itemCount: _favorites.length,
      itemBuilder: (context, index) {
        final product = _favorites[index];
        return ListTile(
          leading: Image.asset(product.imageUrl),
          title: Text(product.title),
          subtitle: Text(product.price),
        );
      },
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.account_circle,
            size: 100,
            color: Colors.blue,
          ),
          const SizedBox(height: 20),
          const Text(
            'User Profile',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text('Name:Mubashir'),
          const Text('Email: Mubashir@example.com'),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Logged Out')),
              );
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
