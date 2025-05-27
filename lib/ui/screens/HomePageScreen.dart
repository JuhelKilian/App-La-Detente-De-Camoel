import 'package:android_detente_camoel/ui/screens/connexion/connexion.dart';
import 'package:flutter/material.dart';

// Connexion
import 'connexion/connexion.dart';

// QR Code
import 'qrCode/qrScanner.dart';

//
import 'home/page2.dart';
import 'home/page3.dart';
import 'chat/AccueilChat.dart';

class HomePageScreen extends StatefulWidget {
  final int initialIndex;
  const HomePageScreen({Key? key, this.initialIndex = 1}) : super(key: key);

  @override
  createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  // Page login ajoutée au début de la liste (index 0)
  final List<Widget> _children = <Widget>[
    const Connexion(),
    const QRScannerScreen(),
    const Page2(),
    Page3(),
    ChatPage(),
  ];

  final List<String> _titles = <String>[
    'Connexion', // Titre pour la page de login
    'Scan QR',
    'Nouvelle commande',
    'Status commandes',
    'Chat',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      // Affiche la navbar seulement si on n'est pas sur la page login et que l'index <= 2
      bottomNavigationBar: _currentIndex != 0 && _currentIndex <= 4
          ? BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              onTap: onTabTapped,
              // Décale l'index de -1 car la page login n'est pas dans la navbar
              currentIndex: _currentIndex - 1,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.qr_code),
                  label: 'Scan QR',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.add_shopping_cart),
                  label: 'Commander',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.list_alt),
                  label: 'Status',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.chat),
                  label: 'Chat',
                ),
              ],
            )
          : null,
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index + 1;
    });
  }

  PageRouteBuilder customPageRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }
}
