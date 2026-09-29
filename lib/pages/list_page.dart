import 'package:flutter/material.dart';
import '../models/item_model.dart';
import 'login_page.dart';
import 'detail_page.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  List<ItemModel> _displayItems = [];
  String _searchQuery = '';
  bool _isAscending = true;

  @override
  void initState() {
    super.initState();
    _displayItems = List.from(dummyItems);
  }

  void _runFilter(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _displayItems = List.from(dummyItems);
      } else {
        _displayItems = dummyItems
            .where((item) => item.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
      _applySort();
    });
  }

  void _toggleSort() {
    setState(() {
      _isAscending = !_isAscending;
      _applySort();
    });
  }

  void _applySort() {
    if (_isAscending) {
      _displayItems.sort((a, b) => a.name.compareTo(b.name));
    } else {
      _displayItems.sort((a, b) => b.name.compareTo(a.name));
    }
  }

  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // 🟢 [EDIT DI SINI: Ubah Title AppBar sesuai tema kuis]
        title: const Text('Daftar Produk', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            // 🟢 [EDIT DI SINI: Ubah Icon Sort jika diperlukan]
            icon: Icon(_isAscending ? Icons.sort_by_alpha : Icons.sort),
            onPressed: _toggleSort,
            tooltip: 'Sortir A-Z',
          ),
          IconButton(
            // 🟢 [EDIT DI SINI: Ubah Icon Logout jika diperlukan]
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) => _runFilter(value),
              decoration: InputDecoration(
                hintText: 'Cari sesuatu...',
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
          Expanded(
            child: _displayItems.isEmpty
                // COMBAT-READY EMPTY STATE: Muncul jika hasil filter tidak ada
                ? const Center(
                    child: Text(
                      'Data tidak ditemukan',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    // 🟢 [EDIT DI SINI: Ubah jumlah kolom Grid (crossAxisCount) jika diminta kuis]
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: _displayItems.length,
                    itemBuilder: (context, index) {
                      final item = _displayItems[index];
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailPage(car: item),
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Image.network(
                                  item.imageUrl,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  // COMBAT-READY IMAGE FALLBACK: Jika URL mati / tidak ada internet
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Center(child: Icon(Icons.broken_image, size: 50, color: Colors.grey)),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Rp ${item.origin}',
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.primary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
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