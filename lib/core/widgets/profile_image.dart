import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import 'custom_network_image.dart';

class ProfileImage extends StatefulWidget {
  const ProfileImage({
    super.key,
    this.initialImageUrl,
    required this.onImageChanged,
  });

  final String? initialImageUrl;
  final void Function(XFile?) onImageChanged;

  @override
  State<ProfileImage> createState() => _ProfileImageState();
}

class _ProfileImageState extends State<ProfileImage> {
  XFile? _image;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final ImagePicker picker = ImagePicker();
        final XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);
        if (pickedImage != null) {
          setState(() {
            _image = pickedImage;
          });
          widget.onImageChanged(pickedImage);
        }
      },
      child: Padding(
        padding: EdgeInsets.all(10.0.r),
        child: Column(
          children: [
            SizedBox(height: 10.h),
            Stack(
              children: [
                CircleAvatar(
                  radius: 75.r,
                  backgroundImage: _image != null
                      ? FileImage(File(_image!.path))
                      : widget.initialImageUrl != null
                      ? CustomNetworkImage(image:widget.initialImageUrl!)as ImageProvider
                      : null,
                  backgroundColor: Colors.grey[300],
                  child: _image == null && widget.initialImageUrl == null
                      ? Icon(Icons.person, size: 75.r, color: Colors.grey[600])
                      : null,
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Icon(
                    Icons.edit,
                    size: 36.r,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}