class UnboardingContent {
  String image;
  String image2; // Tambahkan properti untuk gambar kedua
  String description;

  UnboardingContent({
    required this.description,
    required this.image,
    required this.image2, // Tambahkan image2 ke dalam konstruktor
  });
}

List<UnboardingContent> contents = [
  UnboardingContent(
    description: 'Aplikasi yang Memberi Kemudahan Untuk Kamu',
    image: "images/about1.png",
    image2: "images/splash.png", // Tambahkan path gambar kedua
  ),
  UnboardingContent(
    description: 'Langganan Internet dan Lainnya Hanya Dalam Genggaman',
    image: "images/about2.png",
    image2: "images/splash.png", // Tambahkan path gambar kedua
  ),
  UnboardingContent(
    description: 'Satu Langkah Lagi dan Nikmati Segala Fiturnya',
    image: "images/about3.png",
    image2: "images/splash.png", // Tambahkan path gambar kedua
  ),
];
