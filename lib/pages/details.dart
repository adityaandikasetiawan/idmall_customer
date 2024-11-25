import 'package:flutter/material.dart';
import 'package:idmall/pages/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailPage extends StatefulWidget {
  final String title;
  final String price;
  final String imagePath;
  final String? description;

  const DetailPage({
    super.key,
    required this.title,
    required this.price,
    required this.imagePath,
    this.description,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  String? token;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    super.initState();
    getNameUser();
  }

  Future<Null> getNameUser() async {
    WidgetsFlutterBinding.ensureInitialized();
    final SharedPreferences prefs = await _prefs;

    setState(() {
      token = prefs.getString('token');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            widget.imagePath,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Rp. ${widget.price}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Deskripsi Produk: \n 1. Internet cepat \n 2. Jangkauan internet lebih luas \n',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.description ?? '',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shadowColor: Colors
                            .orange, // Ubah warna latar belakang tombol menjadi orange
                        backgroundColor:
                            Colors.white, // Ubah warna font menjadi putih
                        side: const BorderSide(
                            color: Colors
                                .orange), // Tambahkan garis tepi dengan warna yang sama
                      ),
                      onPressed: () {
                        // Tambahkan logika untuk memasukkan produk ke keranjang di sini
                        // Misalnya, Anda dapat menampilkan pesan atau mengirimkan produk ke keranjang belanja
                        if (token == null) {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Info'),
                              content: const Text('Login terlebih dahulu.'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (builder) =>
                                                const Login()));
                                  },
                                  child: const Text('Sign In'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text(
                                    'Tutup',
                                    // style: TextStyle(
                                    //   color: Colors.white
                                    // ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Sukses'),
                              content: const Text(
                                  'Produk berhasil dimasukkan ke keranjang.'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Tutup'),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                      child: const Text('Pesan Sekarang!'),
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
