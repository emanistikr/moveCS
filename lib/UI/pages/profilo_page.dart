import 'package:flutter/material.dart';
import '../../config/widget_decoration/widget_styles.dart';

class ProfiloPage extends StatefulWidget {
  const ProfiloPage({super.key});

  @override
  State<ProfiloPage> createState() => _ProfiloPageState();
}

class _ProfiloPageState extends State<ProfiloPage> {
  String nomeUtente = "Enrico Pasquale Pratticò"; //Todo: prendere dal profilo utente
  String urlImmagine = 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=500&q=80'; //Todo: prendere dal profilo utente
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          // Parte superiore con colore adattato al tema
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 60, bottom: 40),
            decoration: WidgetStyles.cardDecoration(context),
            child: Column(
              children: [
                Text(
                  'Il mio profilo', //TODO: localizzare
                  style: TextStyle(
                      color: Theme.of(context).secondaryHeaderColor, // Colore testo adattato al tema
                      fontSize: 22,
                      fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(height: 20),

                // Immagine Profilo con tasto edit
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: NetworkImage(urlImmagine),
                    ),
                    GestureDetector(
                      onTap: () {
                        // TODO: funzione modifica immagine profilo
                        print("Tasto edit premuto");
                      },
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: Theme.of(context).highlightColor,
                        child: const Icon(Icons.edit, size: 18, color: Colors.black),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Text(
                  nomeUtente,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}