import 'package:flutter/material.dart';
import '../../config/widget_decoration/widget_styles.dart';
import '../../controller/app_localization.dart';
import '../../controller/auth_controller.dart';

class ProfiloPage extends StatefulWidget {
  const ProfiloPage({super.key});

  @override
  State<ProfiloPage> createState() => _ProfiloPageState();
}

class _ProfiloPageState extends State<ProfiloPage> {
  AuthController controller = AuthController();
  String nomeUtente = "Utente";
  String urlImmagine =
      'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=500&q=80'; //Todo: prendere dal profilo utente

  Future<void> signOut() async {
    await AuthController().signOut();
  }

  @override
  void initState() {
    super.initState();
    recuperaDati();
  }

  Future<void> recuperaDati() async {
    // Ora puoi usare await correttamente
    String? verify = await controller.getUserName(await controller.getUid());

    setState(() {
      nomeUtente = verify ?? "Utente"; // Aggiorna la variabile e rifà il build
    });
    setState(() {}); // Aggiorna lo stato per riflettere il cambiamento
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        children: [
          // Parte superiore con colore adattato al tema
          Container(
            padding: const EdgeInsets.only(
              top: 50,
              bottom: 25,
              left: 20,
              right: 20,
            ),

            width: double.infinity,
            decoration: WidgetStyles.cardDecoration(context),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context), // Torna al main
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Theme.of(context).colorScheme.primary,
                        size: 22,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        AppLocalizations.of(
                              context,
                            )?.translate('profilo_text') ??
                            "My profile",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                  ],
                ),
                const SizedBox(height: 40),

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
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.primary.withAlpha(180),
                        child: const Icon(
                          Icons.edit_outlined,
                          size: 20,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Text(
                  "${AppLocalizations.of(context)?.translate('Hi') ?? 'Hi'}, $nomeUtente",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSecondary,
                    fontFamily: 'OpenSans',
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () {
                  signOut();
                },
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Theme.of(
                        context,
                      ).colorScheme.onPrimaryContainer.withAlpha(40),
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    Icons.logout,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  controller.deleteAccount();
                },
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Theme.of(
                        context,
                      ).colorScheme.onPrimaryContainer.withAlpha(40),
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    Icons.delete,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
