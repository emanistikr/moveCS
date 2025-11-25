import 'package:flutter/material.dart';

class AppButtonDecoration {
    static final BoxDecoration elevatedButtonDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(50),
      color: Colors.white, //TODO: Cambiare colore se tema scuro
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          spreadRadius: 2,
          blurRadius: 7,
          offset: const Offset(0, 3),
        ),
      ],
    );
}

