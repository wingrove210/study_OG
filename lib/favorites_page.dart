import 'package:flutter/material.dart';

class FavoritesPage extends StatelessWidget {
  final List<Map<String, dynamic>> favoriteItems;
  final Function(Map<String, dynamic>) onRemove;

  const FavoritesPage({Key? key, required this.favoriteItems, required this.onRemove}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorites"),
      ),
      body: favoriteItems.isEmpty
          ? const Center(child: Text("No items in favorites"))
          : ListView.builder(
              itemCount: favoriteItems.length,
              itemBuilder: (context, index) {
                final item = favoriteItems[index];
                return ListTile(
                  leading: Icon(item['image']),
                  title: Text(item['name']),
                  subtitle: Text(item['price']),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: () {
                      onRemove(item);
                    },
                  ),
                );
              },
            ),
    );
  }
}
