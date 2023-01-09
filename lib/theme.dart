import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const primaryColor = Color(0xff6C63FF);
const secondaryColor = Color.fromRGBO(143, 225, 215, 0.44);
const whiteColor = Color(0xffFBFAF5);
const textPrimaryColor = Color.fromRGBO(143, 225, 215, 0.44);

TextStyle textButtonStyle = GoogleFonts.poppins(
  fontSize: 16,
  fontWeight: FontWeight.w600,
  color: whiteColor,
);

TextStyle textButton2Style = GoogleFonts.poppins(
  fontSize: 16,
  fontWeight: FontWeight.w600,
  color: primaryColor,
);

TextStyle textTitleStyle = GoogleFonts.poppins(
  fontSize: 32,
  fontWeight: FontWeight.w600,
  color: textPrimaryColor,
);

TextStyle textTitle2Style = GoogleFonts.poppins(
  fontSize: 32,
  fontWeight: FontWeight.w600,
  color: whiteColor,
);

TextStyle textBodyStyle = GoogleFonts.poppins(
  fontSize: 16,
  color: textPrimaryColor,
);

TextStyle textBody2Style = GoogleFonts.poppins(
  fontSize: 16,
  color: whiteColor,
);

TextStyle textSecondaryStyle = GoogleFonts.poppins(
  fontSize: 12,
  color: secondaryColor,
);

TextStyle textPrimaryStyle = GoogleFonts.poppins(
  fontSize: 12,
  color: textPrimaryColor,
);
