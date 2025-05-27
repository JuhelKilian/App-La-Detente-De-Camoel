import 'package:flutter/material.dart';
import '../../../utils/QRFonctions.dart'; // Utilisation des fonctions utilitaires pour QR

class changerReservation extends StatefulWidget {
  final int idReservation;
  const changerReservation({super.key, required this.idReservation});

  @override
  State<changerReservation> createState() => _ChangerReservationState();
}

class _ChangerReservationState extends State<changerReservation> {
  DateTime selectedDateTime = DateTime.now();
  late int idReservation;

  @override
  void initState() {
    super.initState();
    idReservation = widget.idReservation;
  }

  void _valider() async {
    final String dateStr =
        '${selectedDateTime.year}-${selectedDateTime.month.toString().padLeft(2, '0')}-${selectedDateTime.day.toString().padLeft(2, '0')}';
    final String heureStr =
        '${selectedDateTime.hour.toString().padLeft(2, '0')}:${selectedDateTime.minute.toString().padLeft(2, '0')}';

    final result = await reporterReservation(idReservation, dateStr, heureStr);

    if (result.containsKey('error')) {
      // Gérer l'erreur (afficher un message par exemple)
      print('Erreur: ${result['error']}');
    } else {
      Navigator.of(context).pop({
        'date': dateStr,
        'heure': heureStr,
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reporter la réservation'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
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
                children: const [
                  Text(
                    'Sélectionnez une nouvelle date et heure pour cette réservation.',
                    style: TextStyle(fontSize: 14.0),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30.0),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(12),
              child: SizedBox(
                height: 200,
                child: CalendarDatePicker(
                  initialDate: selectedDateTime,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                  onDateChanged: (newDate) {
                    setState(() {
                      selectedDateTime = DateTime(
                        newDate.year,
                        newDate.month,
                        newDate.day,
                        selectedDateTime.hour,
                        selectedDateTime.minute,
                      );
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text(
                  'Heure : ',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TimePickerSpinner(
                    initialTime: TimeOfDay(
                      hour: selectedDateTime.hour,
                      minute: selectedDateTime.minute < 30 ? 0 : 30,
                    )
                    ,
                    onTimeChange: (time) {
                      setState(() {
                        selectedDateTime = DateTime(
                          selectedDateTime.year,
                          selectedDateTime.month,
                          selectedDateTime.day,
                          time.hour,
                          time.minute,
                        );
                      });
                    },
                  ),
                ),
              ],
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Annule et ferme la page
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      side: const BorderSide(color: Colors.grey),
                    ),
                    child: const Text(
                      'Annuler',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _valider,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                    ),
                    child: const Text(
                      'Valider',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ],
            )

          ],
        ),
      ),
    );
  }
}

// Spinner pour choisir l'heure (remplace CupertinoDatePicker dans structure Material)
class TimePickerSpinner extends StatelessWidget {
  final TimeOfDay initialTime;
  final void Function(TimeOfDay) onTimeChange;

  const TimePickerSpinner({
    Key? key,
    required this.initialTime,
    required this.onTimeChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButton<TimeOfDay>(
      isExpanded: true,
      value: initialTime,
      onChanged: (newTime) {
        if (newTime != null) {
          onTimeChange(newTime);
        }
      },
      items: List.generate(24 * 2, (index) {
        final hour = index ~/ 2;
        final minute = (index % 2) * 30;
        final time = TimeOfDay(hour: hour, minute: minute);
        final label =
            '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
        return DropdownMenuItem(
          value: time,
          child: Text(label),
        );
      }),
    );
  }
}
