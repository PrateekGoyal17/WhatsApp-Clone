import 'dart:io';
import 'package:enough_giphy_flutter/enough_giphy_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void showSnackBar(
  BuildContext context,
  String content,
) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
    ),
  );
}

Future<File?> pickImageFromGallery(BuildContext context) async {
  File? image;
  try {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      image = File(pickedImage.path);
    }
  } catch (e) {
    showSnackBar(context, e.toString());
  }
  return image;
}

Future<File?> pickVideoFromGallery(BuildContext context) async {
  File? video;
  try {
    final pickedVideo =
        await ImagePicker().pickVideo(source: ImageSource.gallery);

    if (pickedVideo != null) {
      video = File(pickedVideo.path);
    }
  } catch (e) {
    showSnackBar(context, e.toString());
  }
  return video;
}

Future<File?> pickFileFromGallery(BuildContext context) async {
  File? file;
  try {
    final pickedFile = await FilePicker.platform.pickFiles();
    
    if (pickedFile != null) {
      file = File(pickedFile.files.single.path!);
    }
  } catch (e) {
    showSnackBar(context, e.toString());
  }
  return file;
}

Future<GiphyGif?> pickGIF(BuildContext context) async {
  GiphyGif? gif;
  try {
    gif = await Giphy.getGif(
        context: context, apiKey: '2HoHKwZYNXgZOiEiPmpN0KcyyEcMuhr5');
  } catch (e) {
    showSnackBar(context, e.toString());
  }
  return gif;
}
