import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'product_details.dart';
import 'cart_page.dart';
import 'favorites_page.dart';
import 'login_page.dart';
import 'registration_page.dart';

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
  List<Map<String, dynamic>> products = [];
  final List<Map<String, dynamic>> cartItems = [];
  final List<Map<String, dynamic>> favoriteItems = [];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    const String apiUrl = 'http://10.0.2.2:8000/products/';
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> fetchedProducts = json.decode(response.body);
        setState(() {
          products = fetchedProducts.cast<Map<String, dynamic>>();
        });
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      print('Error loading products: $e');
    }
  }

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

  void _openLoginPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  void _openRegistrationPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegistrationPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
appBar: AppBar(
  backgroundColor: Theme.of(context).colorScheme.inversePrimary,
  title: Text(widget.title),
  actions: [
    Row(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: _openCart,
            ),
            if (cartItems.isNotEmpty)
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
            if (favoriteItems.isNotEmpty)
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
        TextButton(
          onPressed: _openLoginPage,
          child: const Text("Login", style: TextStyle(color: Colors.white)),
        ),
        TextButton(
          onPressed: _openRegistrationPage,
          child: const Text("Register", style: TextStyle(color: Colors.white)),
        ),
      ],
    ),
  ],
),
      body: SingleChildScrollView(
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
                            Icons.diamond, // Поставьте реальную иконку, если доступно
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
                            product['price'].toString(), // Преобразование в строку
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          IconButton(
                            icon: Icon(isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border),
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
    );
  }
}
