import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class QrGeneratorScreen extends StatefulWidget {
  const QrGeneratorScreen({super.key});

  @override
  State<QrGeneratorScreen> createState() => _QrGeneratorScreenState();
}

class _QrGeneratorScreenState extends State<QrGeneratorScreen> {
  String? qrRawValue;
  final ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Color(0xFFF5F5F5),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Row untuk TextField dan IconButton
            Row(
              children: [
                // Expanded agar TextField menyesuaikan ukuran
                Expanded(
                  child: TextField(
                    style: const TextStyle(
                      color: Color(0xFF3E5E4E), // Warna teks input
                      fontSize: 16, // Ukuran font
                    ),
                    decoration: const InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 30),
                        filled: true,
                        fillColor: Color(0xFFFFFFFF),
                        hintText: "Enter your Link here",
                        hintStyle: TextStyle(
                          color: Colors.grey, // Warna hint text (abu-abu)
                        ),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xFF5B7769), width: 2.0))),
                    onSubmitted: (value) {
                      setState(() {
                        qrRawValue = value;
                      });
                    },
                  ),
                ),
                const SizedBox(
                    width: 10), // Jarak antara TextField dan IconButton
                // IconButton dengan latar belakang
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF5B7769),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.qr_code,
                      size: 35,
                    ),
                    color: Colors.white, // Warna ikon
                    onPressed: () {
                      if (qrRawValue != null && qrRawValue!.isNotEmpty) {
                        // Tambahkan fungsi scan QR code jika diperlukan
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('QR Code Icon pressed'),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Please enter a value to generate QR Code!'),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
            if (qrRawValue != null)
              Container(
                  decoration: BoxDecoration(
                    color: Colors.white, // Warna background
                    border: Border.all(
                      color: Color(0xFF5B7769),
                      width: 7.0,
                    ),
                    borderRadius: BorderRadius.circular(17), // Sudut border
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Screenshot(
                    controller: screenshotController,
                    child: PrettyQrView.data(data: qrRawValue!)
                )
              ),

            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white, // Background color,

                borderRadius: BorderRadius.circular(
                    15), // Bisa diubah ke BoxShape.rectangle kalau mau kotak
              ),
              child: IconButton(
                onPressed: () {
                  _shareQrCode();
                  if (qrRawValue != null && qrRawValue!.isNotEmpty) {
                    Share.share('Check out this QR code: $qrRawValue');
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:
                            Text('Please enter a value to generate QR Code!'),
                      ),
                    );
                  }
                },
                icon: const Icon(
                  
                  Icons.share,
                  color: Color((0xFF5B7769)),
                  size: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Future<void> _shareQrCode() async {
    // ambil screenshot dari QR
    final image = await screenshotController.capture();
    if (image != null) {
      // kalau berhasil ambil gambar, share menggunakan Share Plus
      await Share.shareXFiles([
        XFile.fromData(
          image,
          name: "qr_code.png", // nama file screenshot
          mimeType: "image/png", // format file
        ),
      ]);
    }
  }
}



// import 'package:flutter/material.dart';
// import 'package:pretty_qr_code/pretty_qr_code.dart';
// import 'package:share_plus/share_plus.dart';

// class QrGeneratorScreen extends StatefulWidget {
//   const QrGeneratorScreen({super.key});

//   @override
//   State<QrGeneratorScreen> createState() => _QrGeneratorScreenState();
// }

// class _QrGeneratorScreenState extends State<QrGeneratorScreen> {
//   String? qrRawValue;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F5F5),
//       appBar: AppBar(
//         // title: const Text('QR Code Generator'),
//         actions: [
//           IconButton(
//             onPressed: () {
//               // ngapus dan menggantikan
//               Navigator.pop(context);
//             },
//             icon: const Icon(Icons.close),
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 30),
//         child: Column(
//           mainAxisSize: MainAxisSize.max,
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
            // TextField(
            //   style: const TextStyle(
            //     color: Color(0xFF3E5E4E), // Warna teks input
            //     fontSize: 16, // Ukuran font
            //   ),
            //   decoration: const InputDecoration(
            //     contentPadding: const EdgeInsets.symmetric(horizontal: 30),
            //     filled: true,
            //       fillColor: Color(0xFFFFFFFF),
            //       hintText: "Enter your Link here",
            //       hintStyle: TextStyle(
            //         color: Colors.grey, // Warna hint text (abu-abu)
            //       ),
            //       enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF5B7769), width: 2.0))
            //       ),
            //   onSubmitted: (value) {
            //     setState(() {
            //       qrRawValue = value;
            //     });
            //   },
            // ),
//             if (qrRawValue != null) PrettyQrView.data(data: qrRawValue!),
//             IconButton(
//               onPressed: () {
//                 if (qrRawValue != null && qrRawValue!.isNotEmpty) {
//                   Share.share('Check out this QR code: $qrRawValue');
//                 } else {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                       content:
//                           Text('Please enter a value to generate QR Code!'),
//                     ),
//                   );
//                 }
//               },
//               icon: const Icon(Icons.share),
//             ),
        
//           ],
//         ),
        
//       ),
      
//     );
//   }
// }
