import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greener/core/constants/kcolors.dart';

class CustomTextSnackBar{
   CustomTextSnackBar({
    required this.message,
    this.isError = true,
  }){
     Get.snackbar("",'',
         backgroundColor:isError?Colors.redAccent: baseColor,
         colorText: whitenColor,
         messageText: Text(message,style: const TextStyle(color: Colors.white),),
         borderRadius: 0,
         margin: const EdgeInsets.all(0),
         snackPosition: SnackPosition.BOTTOM);
  }

  final String message;
  final bool isError;


}