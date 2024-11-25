import 'package:flutter/material.dart';
import 'product_details.dart';
import 'cart_page.dart';
import 'favorites_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellowAccent),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'JEWELRY SHOP'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Map<String, dynamic>> products = [
    {"name": "Diamond Ring", "price": "\$1000", "image": Icons.diamond},
    {"name": "Gold Necklace", "price": "\$1500", "image": Icons.auto_awesome},
    {"name": "Silver Bracelet", "price": "\$500", "image": Icons.watch},
  ];

  final List<Map<String, dynamic>> cartItems = [];
  final List<Map<String, dynamic>> favoriteItems = [];

  void _openProductDetails(Map<String, dynamic> product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetails(
          product: product,
          isFavorite: favoriteItems.contains(product),
          onFavoriteToggle: _toggleFavorite,
        ),
      ),
    );
  }

  void _addToCart(Map<String, dynamic> product) {
    setState(() {
      cartItems.add(product);
    });
  }

  void _removeFromCart(Map<String, dynamic> product) {
    setState(() {
      cartItems.remove(product);
    });
  }

  void _toggleFavorite(Map<String, dynamic> product) {
    setState(() {
      if (favoriteItems.contains(product)) {
        favoriteItems.remove(product);
      } else {
        favoriteItems.add(product);
      }
    });
  }

  void _openCart() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CartPage(
          cartItems: cartItems,
          onRemove: _removeFromCart,
        ),
      ),
    );
  }

  void _openFavorites() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FavoritesPage(
          favoriteItems: favoriteItems,
          onRemove: _toggleFavorite,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: _openCart,
              ),
              Positioned(
                right: 4,
                top: 4,
                child: CircleAvatar(
                  radius: 10,
                  backgroundColor: Colors.red,
                  child: Text(
                    '${cartItems.length}',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.favorite),
                onPressed: _openFavorites,
              ),
              Positioned(
                right: 4,
                top: 4,
                child: CircleAvatar(
                  radius: 10,
                  backgroundColor: Colors.red,
                  child: Text(
                    '${favoriteItems.length}',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('img/iPhone 13 mini - 13.png'), // Используем локальный файл
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Wrap(
              spacing: 16,
              runSpacing: 16,
              children: products.map((product) {
                final isFavorite = favoriteItems.contains(product);
                return GestureDetector(
                  onTap: () => _openProductDetails(product),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 2 - 24,
                    child: Card(
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              product['image'],
                              size: 50,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              product['name'],
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              product['price'],
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            IconButton(
                              icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
                              color: isFavorite ? Colors.red : null,
                              onPressed: () => _toggleFavorite(product),
                            ),
                            ElevatedButton(
                              onPressed: () => _addToCart(product),
                              child: const Text("Add to Cart"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
