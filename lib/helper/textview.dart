import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';



SizedBox addPadding(double height,double width,)=>SizedBox(height: height,width: width);

class SATextField2 extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final EdgeInsetsGeometry? contentPadding;
  final TextInputType? keyboardType;
  final int limit;
  final Widget? suffixIcon;
  final TextAlign? textAlign;
  final Widget? prefixIcon;
  final int? maxLines;
  final bool? readOnly;

  final void Function()? onTap;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(String)? onChanged;

  final Color? color;

  SATextField2(
      {super.key,
        required this.hintText,
        required this.controller,
        this.limit = 30,this.contentPadding,this.keyboardType,this.onChanged,
        this.inputFormatters,this.suffixIcon,this.prefixIcon,this.maxLines,
        this.textAlign,
        this.readOnly, this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextField(
        onTap: onTap,
        readOnly:
        readOnly??false,
        onChanged: onChanged,
        maxLines: maxLines??1,
        cursorColor: Colors.black,
        inputFormatters:inputFormatters?? [LengthLimitingTextInputFormatter(limit)],
        enabled: true,
        controller: controller,
        keyboardType: keyboardType,
        textCapitalization: TextCapitalization.sentences,
        textInputAction: TextInputAction.next,
        style: GoogleFonts.inter(
          color: Colors.black,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
        textAlign: textAlign??TextAlign.start,
        decoration: InputDecoration(
          contentPadding: contentPadding,
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: GoogleFonts.inter(
              color: Colors.black,
              fontSize: 13,
              fontWeight: FontWeight.w600),
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
        ),
      ),
    );
  }
}

class labelHeadingText extends StatelessWidget {
  final String title;
  final Color? color;
  final double? fontSize;
  final TextAlign? align;
  final FontWeight? fontWeight;
  labelHeadingText({super.key, required this.title, this.color, this.fontSize, this.align, this.fontWeight});

  @override
  Widget build(BuildContext context) {
    return  Text(title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: GoogleFonts.openSans(
            fontSize: fontSize, color: Theme.of(context).cardColor, fontWeight: fontWeight),
        textAlign: align);
  }
}


Text headingTextx({
  required title,
  Color? color,
  double? fontSize,
  TextAlign? align,
  FontWeight? fontWeight,
}) =>
    Text(title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: GoogleFonts.akatab(
            fontSize: fontSize, color: color, fontWeight: fontWeight),
        textAlign: align);

Widget headingText(
        {required title,
        Color? color,
        double? fontSize,
        TextAlign? align,
        FontWeight? fontWeight,
        int? maxLines}) =>
    Text(
      title,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: GoogleFonts.akatab(
          fontSize: fontSize, color: color, fontWeight: fontWeight),
    );

Text headingFullTextx({
  required title,
  Color? color,
  double? fontSize,
  TextAlign? align,
  FontWeight? fontWeight,
}) =>
    Text(title,
        style: GoogleFonts.akatab(
            fontSize: fontSize, color: color, fontWeight: fontWeight),
        textAlign: align);

Widget headingFullText({
  required title,
  Color? color,
  double? fontSize,
  TextAlign? align,
  int? maxLines,
  FontWeight? fontWeight,
}) =>
    Text(
        maxLines: maxLines,
        title,
        style: GoogleFonts.akatab(
            fontSize: fontSize, color: color, fontWeight: fontWeight),
        textAlign: align);

Text headingText1x(
        {required title,
        Color? color,
        double? fontSize,
        TextAlign? align,
        FontWeight? fontWeight}) =>
    Text(title,
        style: GoogleFonts.akatab(
            fontSize: fontSize, color: color, fontWeight: fontWeight),
        textAlign: align);

Widget headingText1(
        {required title,
        Color? color,
        double? fontSize,
        TextAlign? align,
        FontWeight? fontWeight}) =>
    Text(title,
        style: GoogleFonts.akatab(
            fontSize: fontSize, color: color, fontWeight: fontWeight),
        textAlign: align);

Text headingLongTextx(
        {required title,
        Color? color,
        double? fontSize,
        TextAlign? align,
        FontWeight? fontWeight}) =>
    Text(
      title,
      maxLines: 3,
      style: GoogleFonts.akatab(
          fontSize: fontSize, color: color, fontWeight: fontWeight),
      textAlign: align,
      overflow: TextOverflow.ellipsis,
    );

Widget headingLongText(
        {required title,
        Color? color,
        double? fontSize,
        TextAlign? align,
        FontWeight? fontWeight}) =>
    Text(
      title,
      maxLines: 4,
      style: GoogleFonts.akatab(
          fontSize: fontSize, color: color, fontWeight: fontWeight),
      textAlign: align,
      overflow: TextOverflow.ellipsis,
    );

Text headingShortTextx(
        {required title,
        Color? color,
        double? fontSize,
        TextAlign? align,
        FontWeight? fontWeight}) =>
    Text(
      title,
      maxLines: 2,
      style: GoogleFonts.akatab(
          fontSize: fontSize, color: color, fontWeight: fontWeight),
      textAlign: align,
      overflow: TextOverflow.ellipsis,
    );

Text headingShortText(
        {required title,
        Color? color,
        double? fontSize,
        TextAlign? align,
        FontWeight? fontWeight}) =>
    Text(
      title,
      maxLines: 2,
      style: GoogleFonts.akatab(
          fontSize: fontSize, color: color, fontWeight: fontWeight),
      textAlign: align,
      overflow: TextOverflow.ellipsis,
    );

Widget smallHeadingText(
        {required title,
        Color? color,
        double? fontSize,
        TextAlign? align,
        FontWeight? fontWeight,
        int? maxLines}) =>
    Text(
      title,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: GoogleFonts.akatab(
          fontSize: fontSize, color: color, fontWeight: fontWeight),
    );



class BoldHeadingText extends StatelessWidget {
  final String title;
  final double fontSize;
  final Color color;
  const BoldHeadingText({super.key,required this.title,required this.fontSize,
    required this.color});

  @override
  Widget build(BuildContext context) {
    return Text(title,style: TextStyle(
        fontSize: fontSize,color: color,fontWeight: FontWeight.w500),);
  }
}
exitConfirmation(BuildContext context){
  return AlertDialog(
    elevation: 0,
    backgroundColor: Colors.white,
    title:headingText(title: 'Exit?',fontSize: 15,color: Colors.black,fontWeight: FontWeight.w600),
    content:headingFullText(title: 'Are you sure you want to exit?',fontSize: 14,color: Colors.grey.shade700,),
    actions: <Widget>[
      TextButton(
        child: headingText(title: 'CANCEL',fontSize: 14.5,color: Colors.red,),
        onPressed: () =>Navigator.of(context).pop(),
      ),
      TextButton(
        child: headingText(title: 'OK',fontSize: 14.5,color: Colors.red,),
        onPressed: ()=>exit(0),
      ),
    ],
  );
}
