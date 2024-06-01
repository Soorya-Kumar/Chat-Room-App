import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends StatefulWidget {
  const ImagePickerWidget({super.key, required this.passingSelectedImage});

  final void Function(File pickedImage) passingSelectedImage;

  @override
  State<ImagePickerWidget> createState() {
    return _ImagePickerWidget();
  }
}

class _ImagePickerWidget extends State<ImagePickerWidget> {
  
  var _isImagePicked = false;
  File? _pickedImageFile;

  void _pickImage() async {
    print('Pick Image');
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 150,
    );

    if (pickedImage != null) {
      setState(() {
        {
          _pickedImageFile = File(pickedImage.path);
          _isImagePicked = true;
        }
      });

      widget.passingSelectedImage(_pickedImageFile!);
    } 
    
    else {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(child: Text('CREATE A PROFILE',style: TextStyle(color: Color.fromARGB(255, 255, 252, 252))),),
        CircleAvatar(
          radius: 50,
          backgroundImage: _isImagePicked
              ? FileImage(_pickedImageFile!)
              : Image.asset('assets/images/photo.png').image,
          backgroundColor: Colors.white10,
        ),
        TextButton.icon(
            onPressed: _pickImage,
            icon: const Icon(Icons.add_a_photo_outlined),
            label: const Text('Add Image', style: TextStyle(color: Color.fromARGB(255, 255, 252, 252)),)),
      ],
    );
  }
}
