import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_scanner/ui/component/bottom_navbar.dart';
import 'package:qr_scanner/ui/qr_generator_screen.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
   int _selectedIndex = 0; // Indeks tombol yang sedang dipilih

   // dasar untuk navigasi via navigation bar
  final List<Widget> _widgetOptions = [
    const QrScannerScreen(),
    const QrGeneratorScreen(),
  ];

// function untuk aksi pada bottom navbar
  void _onItemTapped(int index) {
    setState(() {
      // menyatakan bahwa inisial action adalah untk menampilkan objek yang
      // berada pada index ke 0
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _selectedIndex == 0 ? Stack(
        children: [
          // Kamera Scanner
          MobileScanner(
            controller: MobileScannerController(
              // cuma bekerja sekali (sekali detect), klo mau scan lagi harus back dulu
              detectionSpeed: DetectionSpeed.noDuplicates,
              // buat nangkep gambar qrnya
              returnImage: true,
            ),
            onDetect: (capture) {
              // bakal nyimpen hsilnya di variabel barcode
              final List<Barcode> barcodes = capture.barcodes;
              // menyimpan image sebesar 8bit (membatasi size file img)
              final Uint8List? image = capture.image;

              // jika berhasil mendeteksi
              if (image != null) {
                showDialog(
                  context: context,
                  builder: (context) {
                     // pop-up notification
                    return AlertDialog(
                      title:
                      // barcode.rawValue = nampilin angka di barcode, nilai asli nya (bisa link, angka)
                          Text(barcodes.first.rawValue ?? "QR Code Invalid!"),
                      // MemoryImage = untuk ngecompres imageny
                      content: Image(image: MemoryImage(image)),
                    );
                  },
                );
              }
            },
          ),

          // Overlay menggunakan CustomPaint
          CustomPaint(
            size: Size.infinite,
            painter: ScannerOverlayPainter(),
          ),

          // Teks di atas scanner
          const Padding(
            padding: EdgeInsets.only(top: 120),
            child: Align(
              alignment: Alignment.topCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Scan QR Code",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 33,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Place the QR code inside the \nclear area to scan it",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.34,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Tombol kontrol di bagian bawah
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: 315,
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)),
                 child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildButton(context, 0, "Scan Code", "/scanner"),
                    _buildButton(context, 1, "Make QR", "/generator"),
                  ],
                ),
              ),
            ),
          ),

           // Close Button
          Positioned(
            top: 40,
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          )
        ],
      ) : _widgetOptions[_selectedIndex],
      // bottomNavigationBar: 
      //     Padding(
      //       padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
      //       child: BottomNavbar(selectedIndex: _selectedIndex, onItemTapped: _onItemTapped),
      //     ),
      
    );
  }

  Widget _buildButton(BuildContext context, int index, String text, String route) {
  final bool isSelected = _selectedIndex == index;

  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      elevation: 0, // Menghilangkan shadow
      backgroundColor: isSelected ? const Color(0xFF5B7769) : Colors.white,
      foregroundColor: isSelected ? Colors.white : const Color(0xFF5B7769),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    onPressed: () {
      setState(() {
        _selectedIndex = index; // Perbarui indeks tombol yang dipilih
      });
      Navigator.pushNamed(context, route);
    },
    child: Text(
      text,
      style: const TextStyle(fontSize: 14),
    ),
  );
}
}

// CustomPainter untuk membuat overlay hijau dengan lubang transparan di tengah
class ScannerOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFF5B7769).withOpacity(0.8);

    // Gambar overlay hijau penuh
    canvas.drawRect(Offset.zero & size, paint);

    // Gambar lubang transparan di tengah (ukuran 250x250 dengan sudut membulat)
    final holePath = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(size.width / 2, size.height / 2),
            width: 272,
            height: 272,
          ),
          const Radius.circular(16),
        ),
      )
      ..fillType = PathFillType.evenOdd; // Membuat "lubang" di dalam overlay

    // Terapkan efek transparan di tengah dengan BlendMode.clear
    canvas.drawPath(holePath, Paint()..blendMode = BlendMode.clear);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


