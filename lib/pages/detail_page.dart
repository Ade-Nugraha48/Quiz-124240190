import 'package:flutter/material.dart';

import '../models/item_model.dart';

class DetailPage extends StatefulWidget {
  // Menerima objek ItemModel
  final ItemModel car;

  const DetailPage({super.key, required this.car});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  // Fungsi untuk toggle Favorite dari Detail Page
  void _toggleFavorite() {
    setState(() {
      widget.car.isFavorite = !widget.car.isFavorite;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.car.isFavorite
              ? '${widget.car.name} ditambahkan ke Favorit!'
              : '${widget.car.name} dihapus dari Favorit!',
        ),
        duration: const Duration(seconds: 1),
        backgroundColor: widget.car.isFavorite ? Colors.pink : Colors.grey,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.car.name), // Menampilkan Brand + Nama
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          // Tombol Favorite di AppBar Detail Page
          IconButton(
            icon: Icon(
              widget.car.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: widget.car.isFavorite ? Colors.pinkAccent : Colors.white,
            ),
            onPressed: _toggleFavorite,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Menampilkan gambar full width
            Image.network(
              widget.car.imageUrl,
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const SizedBox(
                height: 250,
                child: Center(child: Icon(Icons.image_not_supported, size: 50)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.car.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      // Ikon favorit di samping judul juga (opsional untuk mempertegas UI)
                      Icon(
                        widget.car.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: widget.car.isFavorite
                            ? Colors.pink
                            : Colors.grey,
                        size: 28,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const SizedBox(height: 16),
                  Text(
                    'Asal: ${widget.car.origin}',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  Text(
                    'Kategori: ${widget.car.category}',
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  Text(
                    'Bahan Utama: ${widget.car.mainIngredient}',
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  Text(
                    'Rasa: ${widget.car.flavor}',
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  Text(
                    'Level Pedas:: ${widget.car.spicyLevel}',
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  Text(
                    'Waktu Layan: ${widget.car.servingTime}',
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const Divider(height: 32, thickness: 1),
                  const Text(
                    'Deskripsi',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.car.description,
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // Floating Action Button sebagai alternatif Favorite
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleFavorite,
        backgroundColor: widget.car.isFavorite ? Colors.pink : Colors.white,
        child: Icon(
          widget.car.isFavorite ? Icons.favorite : Icons.favorite_border,
          color: widget.car.isFavorite ? Colors.white : Colors.pink,
        ),
      ),
    );
  }
}
