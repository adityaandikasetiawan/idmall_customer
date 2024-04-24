// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class PertanyaanPage extends StatefulWidget {
  const PertanyaanPage({super.key});

  @override
  _PertanyaanPageState createState() => _PertanyaanPageState();
}

class _PertanyaanPageState extends State<PertanyaanPage> {
  late List<FAQItem> _allFAQs;
  late List<FAQItem> _searchResults;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _allFAQs = _generateFAQs();
    _searchResults = _allFAQs;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _searchResults = _allFAQs.where((faq) {
        return faq.question.toLowerCase().contains(query) ||
            faq.answer.toLowerCase().contains(query);
      }).toList();
    });
  }

  List<FAQItem> _generateFAQs() {
    return [
      const FAQItem(
        question: 'Dimana saja jangkauan area IdPlay?',
        answer:
            'Layanan IdPlay saat ini tersedia di Jawa, Bali, Lombok, Kalimantan, Sulawesi. Untuk melihat detil area Anda, silahkan masuk ke kontak Cek Area pada halaman depan Website IdPlay.',
      ),
      const FAQItem(
        question:
            'Bagaimana jika wilayah rumah saya belum terjangkau jaringan IDPlay?',
        answer:
            'Anda tetap dapat menuliskan wilayah yang diinginkan, dengan cara klik “Not Found”, lalu masukan alamat lengkap dan nomor telepon yang dapat hubungi. Kami akan cek jaringan di wilayah yang Anda inginkan, dan menghubungi Anda jika telah tersedia.',
      ),
      const FAQItem(
        question: 'Bagaimana cara berlangganan IdPlay?',
        answer:
            'Pendaftaran layanan IdPlay dapat dilakukan dengan beberapa cara.\n• Daftar Online di website IdPlay.\n• Menghubungi Hotline di 08111520938\n• Melalui whatsapp representatif IdPlay di area Anda.',
      ),
      const FAQItem(
        question: 'Apakah ada biaya Instalasi jika ingin berlangganan?',
        answer:
            'Setiap pemasangan layanan IdPlay, pelanggan akan dikenakan biaya instalasi Rp.400.000,- (kecuali program promo, mendapatkan gratis instalasi).',
      ),
      const FAQItem(
        question: 'Kapan biaya Instalasi harus dibayarkan?',
        answer:
            'Biaya instalasi akan masuk ke dalam tagihan Anda pada bulan pertama.',
      ),
      const FAQItem(
        question: 'Dimana bisa mendapatkan informasi lengkap IdPlay?',
        answer:
            'Silahkan kunjungi website IdPlay untuk mendapatkan informasi lengkap.',
      ),
      const FAQItem(
        question: 'Apakah IdPlay?',
        answer:
            'IdPlay adalah layanan Internet Unlimited dengan kecepatan mulai dari 15 Mbps hingga 100 Mbps, yang ditujukan bagi pelanggan di segmen residensial/ perumahan. IDPlay juga melayani sektor bisnis, melalui Internet Dedicated dan Broadband Bisnis',
      ),
      const FAQItem(
        question: 'Apa perbedaan IdPlay Home dengan IdPlay Business?',
        answer:
            'IdPlay adalah layanan Internet Broadband yang ditujukan untuk kebutuhan Bisnis, dengan kecepatan hingga 500 Mbps',
      ),
      const FAQItem(
        question: 'Apa saja layanan IdPlay?',
        answer:
            'IdPlay memiliki beberapa layanan utama, yaitu :\nInternet Unlimited dengan kecepatan 15 hingga 100 Mbps',
      ),
      const FAQItem(
        question: 'Apa saja pilihan paket IdPlay?',
        answer:
            'Silahkan kunjungi halaman Paket & Harga untuk informasi selengkapnya.',
      ),
      const FAQItem(
        question: 'Apa kelebihan dari IdPlay?',
        answer:
            'Kecepatan Internet Unlimited hingga 200 Mbps dengan media Fiber Optic (100%).\nHarga paket sangat kompetitif.',
      ),
      const FAQItem(
        question: 'Apakah ada paket Bundling Internet & TV Kabel?',
        answer:
            'IDPlay terus berinovasi dalam meningkatkan kualitas dan variasi layanan. Saat ini kami sedang dalam pengembangan penyediaan channel dan konten berkualitas untuk keluarga Indonesia',
      ),
      const FAQItem(
        question: 'Harga & Paket IdPlay apakah sudah termasuk pajak?',
        answer:
            'Paket & Harga yang tertera pada brochure/ flyer IdPlay merupakan harga Nett (sudah termasuk PPN 10%)',
      ),
      const FAQItem(
        question:
            'Temukan jawaban untuk pertanyaan-pertanyaan yang sering diajukan oleh pelanggan lainnya.',
        answer:
            'Pendaftaran layanan IdPlay dapat dilakukan dengan beberapa cara.• Cakupan Area\n• Cara Berlangganan\n• Tentang IdPlay Home.',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pertanyaan',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Cari',
                hintText: 'Masukkan kata kunci',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                return _searchResults[index];
              },
            ),
          ),
        ],
      ),
    );
  }
}

class FAQItem extends StatelessWidget {
  final String question;
  final String answer;

  const FAQItem({
    super.key,
    required this.question,
    required this.answer,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        question,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(answer),
        ),
      ],
    );
  }
}
