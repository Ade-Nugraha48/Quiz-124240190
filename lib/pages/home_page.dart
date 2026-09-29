import 'package:flutter/material.dart';

import '../main.dart'; // Import untuk mengakses themeNotifier global
import '../models/item_model.dart';
import 'detail_page.dart';

class HomePage extends StatefulWidget {
  final String username;

  const HomePage({super.key, required this.username});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // State untuk pencarian, sorting, dan list item
  List<ItemModel> _displayItems = [];
  String _searchQuery = '';
  bool _isAscending = true;

  // State untuk menyimpan warna tema
  Color _themeColor = Colors.blue;

  @override
  void initState() {
    super.initState();
    // Inisialisasi daftar item saat halaman pertama kali dimuat
    _displayItems = List.from(dummyItems);
  }

  // Fungsi untuk memfilter list berdasarkan input pencarian
  void _runFilter(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _displayItems = List.from(dummyItems);
      } else {
        _displayItems = dummyItems
            .where(
              (car) => car.name.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
      }
      _applySort(); // Pastikan urutan tetap terjaga setelah difilter
    });
  }

  // Fungsi untuk membalikkan urutan sort (A-Z menjadi Z-A)
  void _toggleSort() {
    setState(() {
      _isAscending = !_isAscending;
      _applySort();
    });
  }

  // Fungsi internal untuk mengaplikasikan sorting pada list _displayItems
  void _applySort() {
    if (_isAscending) {
      _displayItems.sort((a, b) => a.name.compareTo(b.name));
    } else {
      _displayItems.sort((a, b) => b.name.compareTo(a.name));
    }
  }

  // Fungsi untuk toggle Favorite
  void _toggleFavorite(ItemModel car) {
    setState(() {
      car.isFavorite = !car.isFavorite;
    });

    // Tampilkan Snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          car.isFavorite
              ? '${car.name} ditambahkan ke Favorit!'
              : '${car.name} dihapus dari Favorit!',
        ),
        duration: const Duration(seconds: 1),
        backgroundColor: car.isFavorite ? Colors.pink : Colors.grey,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Halo, ${widget.username}'),
        backgroundColor: _themeColor, // Mengikuti state warna tema
        foregroundColor: Colors.white,
        actions: [
          // Tombol Dark Mode
          IconButton(
            icon: Icon(
              themeNotifier.value == ThemeMode.dark
                  ? Icons.dark_mode
                  : Icons.light_mode,
            ),
            onPressed: () {
              setState(() {
                // Toggle mode gelap/terang secara global
                themeNotifier.value = themeNotifier.value == ThemeMode.dark
                    ? ThemeMode.light
                    : ThemeMode.dark;
              });
            },
            tooltip: 'Toggle Dark Mode',
          ),
          // Tombol Sortir (Urut A - Z)
          IconButton(
            icon: Icon(_isAscending ? Icons.sort_by_alpha : Icons.sort),
            onPressed: _toggleSort,
            tooltip: 'Urutkan A-Z / Z-A',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Sapaan Pembuka Khusus (Centered dan Lebih Kecil)
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 8.0),
              child: Center(
                child: Text(
                  'Selamat Datang,\n${widget.username}! 👋',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20, // Font lebih kecil dari sebelumnya
                    fontWeight: FontWeight.bold,
                    color: _themeColor, // Mengikuti state warna tema
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Search Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                onChanged: (value) => _runFilter(value),
                decoration: InputDecoration(
                  hintText: 'Cari makanan impianmu...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                ),
              ),
            ),

            // Daftar List Mobil (Tanpa Expanded agar bisa ikut ke-scroll)
            _displayItems.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Center(
                      child: Text(
                        'Makanan tidak ditemukan',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ),
                  )
                : ListView.builder(
                    // Wajib tambahkan dua baris ini jika ListView berada di dalam SingleChildScrollView
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),

                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    itemCount: _displayItems.length,
                    itemBuilder: (context, index) {
                      final car = _displayItems[index];
                      return Card(
                        elevation: 3,
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(8),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              car.imageUrl,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.car_crash, size: 40),
                            ),
                          ),
                          title: Text(
                            car.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            'Kategori: ${car.category}\nAsal: ${car.origin}',
                          ),
                          // Tombol Favorite di samping ListTile
                          trailing: IconButton(
                            icon: Icon(
                              car.isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: car.isFavorite ? Colors.pink : Colors.grey,
                            ),
                            onPressed: () => _toggleFavorite(car),
                          ),
                          onTap: () {
                            // Pindah ke DetailPage, dan saat kembali (pop),
                            // perbarui state barangkali status favorit diubah di DetailPage
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailPage(car: car),
                              ),
                            ).then((value) {
                              setState(() {}); // Render ulang untuk mencerminkan status favorit terbaru
                            });
                          },
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }

  // Fungsi helper untuk merender tombol bulat pengubah warn
}
