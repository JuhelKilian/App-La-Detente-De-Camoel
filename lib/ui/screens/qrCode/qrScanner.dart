import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import '../../../utils/QRFonctions.dart'; // Utilisation des fonctions utilitaires pour QR
import './qrResultat.dart';
import './reservationPassee.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({Key? key}) : super(key: key);

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String? scannedText;
  bool isFlashOn = false;
  bool isError = false;
  String errorMessage = '';
  /*
  code modifié pour auutoriser sans téléphone à scanner un code "dsiqqsdsfsxsfdo"
  */

  bool _hasAutoValidated = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!_hasAutoValidated) {
        _hasAutoValidated = true;
        await _validateQRCode("dsiqqsdsfsxsfdo");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scanner QR Code'),
      ),
      body: Stack(
        children: [
          QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
          ),

          // Le carré vert (pour l'instant) au centre
          // Un jour peut être je le changerait en un beau truc
          Center(
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green, width: 3),
              ),
            ),
          ),

          if (isError)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Colors.redAccent,
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  errorMessage,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FloatingActionButton(
                backgroundColor: Colors.black.withOpacity(0.7),
                onPressed: _toggleFlash,
                child: Icon(
                  isFlashOn ? Icons.flash_on : Icons.flash_off,
                  color: Colors.yellow,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      controller.pauseCamera();

      setState(() {
        scannedText = scanData.code;
        scannedText = scanData.code;
      });

      await _validateQRCode(scannedText ?? "");
    });
  }

  Future<void> _validateQRCode(String qrCode) async {
    try {
      final Map<String, dynamic> data = await checkReservation(qrCode);

      if (data.isNotEmpty) {
        setState(() {
          isError = false;
        });
         // Si c.dart'est une réservation déjà validée :
        if (data.containsKey('DateFin') && data['DateFin'] != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ReservationPasseePage(content: data),
            ),
          );
        } else {
          // Sinon, on redirige vers la page de résultats avec les détails de la réservation
          validerQR(data);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QRResultat(content: data),
            ),
          );
        }
      } else {
        // Si le QR code n'est pas valide (réponse de l'api vide)
        setState(() {
          isError = true;
          errorMessage = 'QR Code invalide.';
        });
        controller?.resumeCamera(); // Oral : On remet la camera en cas d'erreur
      }
    } catch (e) {
      // Si une erreur se produit
      setState(() {
        isError = true;
        errorMessage = 'Erreur : $e';
      });
      controller?.resumeCamera();
    }
  }




  Future<void> _toggleFlash() async {

    // Oral : On ajoute un flashlight en cas de manque de lisibilité sur une feuille

    if (controller != null) {
      await controller?.toggleFlash();
      final flashStatus = await controller?.getFlashStatus() ?? false;
      setState(() {
        isFlashOn = flashStatus;
      });
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
