import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'edit_profile_state.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  EditProfileCubit() : super(EditProfileInitial());

  void editProfile(String id, String? newName, File? image) async {
    emit(EditProfileLoading());
    try {
      String? imageUrl;
      if (image != null) {
        String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
        await Supabase.instance.client.storage
            .from('greener')
            .upload(fileName, image);
        imageUrl = Supabase.instance.client.storage
            .from('greener')
            .getPublicUrl(fileName);
      }
      await FirebaseFirestore.instance
          .collection('users')
          .doc(id)
          .update(imageUrl == null
              ? {
                  'name': newName,
                }
              : {
                  'name': newName,
                  'image': imageUrl,
                });
      emit(EditProfileSuccess(
        newImage: imageUrl,
        newName: newName,
      ));
    } catch (e) {
      emit(EditProfileError(e.toString()));
    }
  }
}
