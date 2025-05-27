
import 'package:flutter/material.dart';
import 'changerReservation.dart';
import 'changerTable.dart';
import 'package:android_detente_camoel/utils/QRFonctions.dart';
import 'package:android_detente_camoel/ui/screens/HomePageScreen.dart';

class QRResultat extends StatefulWidget {
  final Map<String, dynamic> content;

  const QRResultat({Key? key, required this.content}) : super(key: key);

  State<QRResultat> createState() => _QRResultatState();
}

class _QRResultatState extends State<QRResultat> {
  late Map<String, dynamic> currentContent;

  @override
  void initState() {
    super.initState();
    currentContent = Map<String, dynamic>.from(widget.content);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Réservation'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        elevation: 0,

      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              decoration: BoxDecoration(
                color: const Color(0xFFE7F8F0),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4.0),
                        decoration: const BoxDecoration(
                          color: Color(0xFF00B67A),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 24.0,
                        ),
                      ),
                      const SizedBox(width: 12.0),
                      const Text(
                        'Réservation confirmée',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12.0),
                  const Text(
                    'Voici les informations concernant ce client :',
                    style: TextStyle(fontSize: 14.0),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30.0),

            Container(
              width: double.infinity,
              constraints: const BoxConstraints(maxWidth: 330),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(fontSize: 14.0, color: Colors.black),
                      children: [
                        const TextSpan(text: 'Voici la réservation de '),
                        TextSpan(
                          text: '${currentContent['nombre_personnes']}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const TextSpan(text: ' :'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  Row(
                    children: [
                      const Text(
                        'Table numéro : ',
                        style: TextStyle(fontSize: 14.0),
                      ),
                      Text(
                        currentContent['table'],
                        style: const TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),


                  const SizedBox(height: 24.0),
                  Row(
                    children: [
                      const Text(
                        'Date : ',
                        style: TextStyle(fontSize: 14.0),
                      ),
                      Text(
                        currentContent['date'],
                        style: const TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12.0),
                  Row(
                    children: [
                      const Text(
                        'Heure : ',
                        style: TextStyle(fontSize: 14.0),
                      ),
                      Text(
                        currentContent['heure'],
                        style: const TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12.0),
                  ElevatedButton(
                    onPressed: () async {
                      final result = await Navigator.push<Map<String, dynamic>>(
                        context,
                        MaterialPageRoute(builder: (context) => changerReservation(idReservation: int.parse(currentContent['id_reservation']))),
                      );

                      if (result != null && result.containsKey('date') && result.containsKey('heure')) {
                        setState(() {
                          currentContent['date'] = result['date'];
                          currentContent['heure'] = result['heure'];
                        });
                      }
                    },
                    child: const Text('Reporter la réservation'),
                  ),

                  const SizedBox(height: 24.0),

                  const Text(
                    'Critères choisis en cas de table prise :',
                    style: TextStyle(fontSize: 14.0),
                  ),
                  const SizedBox(height: 12),

                  Text(
                    currentContent['commentaire'],
                    style: const TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,

                    ),
                  ),

                ],
              ),
            ),
            const Spacer(flex: 2),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () async {
                      final contenuTables = await recupererInfoTables();


                      final result = await Navigator.of(context).push<Map<String, dynamic>>(
                        MaterialPageRoute(
                          builder: (context) => ChangerTable(
                            content: contenuTables,
                            commentaires: currentContent['commentaire'],
                            idTable: currentContent['table'],
                            idReservation: currentContent['id_reservation'],
                          ),
                        ),
                      );

                      if (result != null) {
                        setState(() {
                          currentContent['table'] = result['newTable'].toString();
                        });
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      side: const BorderSide(color: Colors.blue),
                    ),
                    child: const Text('Changer de table'),
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const HomePageScreen(initialIndex: 2)),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      backgroundColor: Colors.blue,
                    ),
                    child: const Text(
                      'Prendre sa commande',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<List<dynamic>> recupererInfoTables() async {

    // Oral : On ajoute un flashlight en cas de manque de lisibilité sur une feuille
    List<dynamic> infoTables = await recupererTables();
    print(infoTables);
    return infoTables;

  }
}


