import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextStyles {
  static final poppins = GoogleFonts.poppins();
  static final rubik = GoogleFonts.rubik();
  static final saira = GoogleFonts.saira();

  static final TextStyle poppins16greyDA6 = rubik.copyWith(
    fontSize: 26,
    fontWeight: FontWeight.bold,
    color: const Color.fromARGB(255, 1, 1, 22),
  );

  static final TextStyle poppins14greyDA6 = poppins.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: const Color.fromARGB(255, 1, 1, 22),
  );
  static final TextStyle poppins14lightgreyDA6 = poppins.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: const Color.fromARGB(255, 164, 164, 168),
  );

  static final TextStyle poppins16lightgreyDA6 = poppins.copyWith(
    fontSize: 25,
    fontWeight: FontWeight.w900,
    color: const Color.fromARGB(255, 20, 21, 34),
  );

  static final TextStyle poppins19white = poppins.copyWith(
    fontSize: 19,
    fontWeight: FontWeight.bold,
    color: const Color.fromARGB(255, 255, 255, 255),
  );

  static final TextStyle poppins12black = poppins.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: const Color.fromARGB(255, 1, 1, 22),
  );

    static final TextStyle poppins12white = poppins.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.bold,
    color: const Color.fromARGB(255, 255, 255, 255),
  );
}
