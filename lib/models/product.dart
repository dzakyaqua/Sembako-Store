class Produk {
  final String id;
  final String nama;
  final int harga;
  final String deskripsi;
  final String gambar;

  Produk({
    required this.id,
    required this.nama,
    required this.harga,
    required this.deskripsi,
    required this.gambar,
  });

  factory Produk.fromFirestore(String id, Map<String, dynamic> data) {
    return Produk(
      id: id,
      nama: data['nama'] ?? '',
      harga: data['harga'] ?? 0,
      deskripsi: data['deskripsi'] ?? '',
      gambar: data['gambar'] ?? '',
    );
  }
}
