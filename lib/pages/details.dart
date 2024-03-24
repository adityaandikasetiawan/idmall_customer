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
  void initState() {
    super.initState();
    getNameUser();
  }

  Future<Null> getNameUser() async {
    WidgetsFlutterBinding.ensureInitialized();
    final SharedPreferences? prefs = await _prefs;

    setState(() {
      token = prefs?.getString('token');
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail'),
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
                  style: TextStyle(
                    fontSize: 20,
                  fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Rp. ' + widget.price.toString(),
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Deskripsi Produk:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  widget.description ?? '',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shadowColor: Colors.orange, // Ubah warna latar belakang tombol menjadi orange
                        backgroundColor: Colors.white, // Ubah warna font menjadi putih
                        side: BorderSide(color: Colors.orange), // Tambahkan garis tepi dengan warna yang sama
                      ),
                      onPressed: () {
                        // Tambahkan logika untuk memasukkan produk ke keranjang di sini
                        // Misalnya, Anda dapat menampilkan pesan atau mengirimkan produk ke keranjang belanja
                        if (token == null) {
                          print('belum login');
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Info'),
                              content: Text('Login terlebih dahulu.'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).push(MaterialPageRoute(builder: (builder)=> Login()));
                                  },
                                  child: Text('Sign In'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                    'Tutup',
                                    // style: TextStyle(
                                    //   color: Colors.white
                                    // ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }else {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Sukses'),
                              content: Text('Produk berhasil dimasukkan ke keranjang.'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Tutup'),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                      child: Text('Pesan Sekarang!'),
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
