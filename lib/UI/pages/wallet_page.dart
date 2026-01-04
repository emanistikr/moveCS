import 'package:flutter/material.dart';
import '../../../controller/app_localization.dart';
import '../../config/widget_decoration/widget_styles.dart';

class WalletPage extends StatelessWidget {
  final VoidCallback? onBack; // Aggiungi questo callback

  const WalletPage({super.key, this.onBack});

  // Colori estratti dall'immagine
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,

      body: Column(
        children: [
          _buildCustomHeader(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)?.translate('myTickets') ??
                        "My Tickets",
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Biglietto Grande (Attivo)
                  _buildActiveTicketCard(context),

                  const SizedBox(height: 30),
                  Text(
                    AppLocalizations.of(context)?.translate('buyNew') ??
                        "Buy New",
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Riga Acquisti (90 min / 03 ore)
                  Row(
                    children: [
                      Expanded(
                        child: _buildPurchaseCard(
                          mainText: "90",
                          subText: "min",
                          price: "1,80 €",
                          context: context,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: _buildPurchaseCard(
                          mainText: "03",
                          subText: "ore",
                          price: "4,40 €",
                          context: context,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  // Pulsante Titoli Scaduti
                  _buildExpiredTicketsButton(context),

                  // Spazio extra in fondo per scorrimento comodo
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 50, bottom: 25, left: 20, right: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [WidgetStyles.shadowDownStyle(context)],
      ),
      child: Column(
        children: [
          Row(
            children: [
              InkWell(
                onTap: onBack,
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Theme.of(context).colorScheme.primary,
                  size: 22,
                ),
              ),
              Expanded(
                child: Text(
                  AppLocalizations.of(context)?.translate('myBalance') ??
                      "My balance",
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
          const SizedBox(height: 15),
          // Saldo Gigante
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 14.0),
                child: Text(
                  "€",
                  style: TextStyle(
                    fontFamily: 'OpenSans',
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 5),
              Text(
                "00,00",
                style: TextStyle(
                  fontFamily: 'OpenSans',
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 52,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(width: 10),
              Padding(
                padding: const EdgeInsets.only(top: 22),
                child: Icon(
                  Icons.add_circle,
                  color: Theme.of(context).colorScheme.primary,
                  size: 28,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActiveTicketCard(BuildContext context) {
    return ClipPath(
      clipper: TicketClipper(holeRadius: 15, holePositionRatio: 0.70),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(
              context,
            ).colorScheme.onPrimaryContainer.withAlpha(40),
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "24 Nov 2025",
                        style: Theme.of(context).textTheme.labelMedium!
                            .copyWith(
                              color: Theme.of(
                                context,
                              ).colorScheme.onPrimaryContainer,
                            ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.onPrimaryContainer.withAlpha(60),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          "90 ${AppLocalizations.of(context)?.translate('min') ?? 'min'}",
                          style: Theme.of(context).textTheme.labelSmall!
                              .copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onPrimaryContainer,
                              ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15, left: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(
                                context,
                              )?.translate('activation') ??
                              'Attivazione',
                          style: Theme.of(context).textTheme.labelMedium!
                              .copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onPrimaryContainer,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          AppLocalizations.of(
                                context,
                              )?.translate('expiration') ??
                              'expiration',
                          style: Theme.of(context).textTheme.labelMedium!
                              .copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onPrimaryContainer,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Divider(height: 1, color: Colors.grey[400]),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.qr_code_rounded,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    size: 30,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    AppLocalizations.of(context)?.translate('clickToShow') ??
                        'Click to show',
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPurchaseCard({
    required String mainText,
    required String subText,
    required String price,
    required BuildContext context,
  }) {
    return ClipPath(
      clipper: TicketClipper(holeRadius: 10, holePositionRatio: 0.5),
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(
              context,
            ).colorScheme.onPrimaryContainer.withAlpha(40),
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    mainText,
                    style: TextStyle(
                      fontFamily: 'OpenSans',
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      fontSize: 48,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    subText,
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Divider(height: 1, color: Colors.grey[400]),
            ),
            Expanded(
              child: Center(
                child: Text(
                  price,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpiredTicketsButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.onPrimaryContainer.withAlpha(40),
          width: 2,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            AppLocalizations.of(context)?.translate('expiredTickets') ??
                "Expired Tickets",
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Icon(Icons.keyboard_double_arrow_right, color: Colors.grey[400]),
        ],
      ),
    );
  }
}

class TicketClipper extends CustomClipper<Path> {
  final double holeRadius;
  final double holePositionRatio;
  final double borderRadius;

  TicketClipper({
    this.holeRadius = 10,
    this.holePositionRatio = 0.7,
    this.borderRadius = 16,
  });

  @override
  Path getClip(Size size) {
    final path = Path();
    final holeY = size.height * holePositionRatio;

    path.moveTo(0, borderRadius);

    path.lineTo(0, holeY - holeRadius);
    path.arcToPoint(
      Offset(0, holeY + holeRadius),
      radius: Radius.circular(holeRadius),
      clockwise: true,
    );
    path.lineTo(0, size.height - borderRadius);
    path.quadraticBezierTo(0, size.height, borderRadius, size.height);

    path.lineTo(size.width - borderRadius, size.height);
    path.quadraticBezierTo(
      size.width,
      size.height,
      size.width,
      size.height - borderRadius,
    );

    path.lineTo(size.width, holeY + holeRadius);
    path.arcToPoint(
      Offset(size.width, holeY - holeRadius),
      radius: Radius.circular(holeRadius),
      clockwise: true,
    );
    path.lineTo(size.width, borderRadius);
    path.quadraticBezierTo(size.width, 0, size.width - borderRadius, 0);

    path.lineTo(borderRadius, 0);
    path.quadraticBezierTo(0, 0, 0, borderRadius);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(TicketClipper oldClipper) => true;
}
