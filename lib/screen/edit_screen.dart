import 'dart:io';
import 'dart:typed_data';
import '../database/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:sql_lite/Package/Utils.dart';
import 'package:sql_lite/models/picture.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sql_lite/Package/Text_Button.dart';
import 'package:sql_lite/Package/TextFormField.dart';
import 'package:sql_lite/Package/PackageConstants.dart';

class EditPictureScreen extends StatefulWidget with text_with_button, utils {
  EditPictureScreen({super.key, required this.pid});
  final int pid;

  @override
  State<EditPictureScreen> createState() => _EditPictureScreenState();
}

class _EditPictureScreenState extends State<EditPictureScreen>
    with text_with_button, formField, utils {
  final ImagePicker picker = ImagePicker();
  File? imagePath;

  pickImage() {
    showBottomSheets(Container(
      height: 400,
      width: double.infinity,
      color: Colors.white,
      child: Container(
        height: 400,
        width: double.infinity,
        color: Colors.white,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
              onTap: pickImageFromCamera,
              child: SizedBox(
                height: 100,
                width: 100,
                child: Icon(
                  Icons.camera,
                  size: 50,
                ),
              ),
            ),
            InkWell(
              onTap: pickImageFromGallery,
              child: SizedBox(
                height: 100,
                width: 100,
                child: Icon(
                  Icons.image,
                  size: 50,
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }

  pickImageFromGallery() async {
    Navigator.pop(context);
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (image != null) {
        imagePath = File(image.path);
        addImage(image);
      }
    });
  }

  pickImageFromCamera() async {
    Navigator.pop(context);
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (photo != null) {
        imagePath = File(photo.path);
        addImage(photo);
      }
    });
  }

  Picture? picture;
  addImage(XFile photo) async {
    final Uint8List imageBytes = await photo.readAsBytes();

    // Now, create a Picture object and save it to the database

    setState(() {
      picture = Picture(
          id: DateTime.now().microsecond,
          title: controller.text,
          picture: imageBytes);
    });

    // Save the picture using DBHelper
  }

  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CP(
        h: 16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 50),
            Align(
              alignment: Alignment.center,
              child: Stack(
                children: [
                  Container(
                    height: 125,
                    width: 125,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(100)),
                    child: imagePath != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.file(
                              imagePath!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Container(),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: InkWell(
                      onTap: pickImage,
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.red,
                        child: Icon(Icons.add, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 50),
            textFormField(
                context: context,
                funValidate: (val) => Validator.fieldRequired(val),
                isborder: true,
                controller: controller),
            SizedBox(height: 50),
            simpleButton(
                onTap: () async {
                  await DBHelper.instance
                      .update(widget.pid, picture!)
                      .then((val) => {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Image saved!")))
                          });
                },
                title: text(
                    text: "Save Image", fontSize: 18, textColor: Colors.white),
                backgroundColor: Colors.green)
          ],
        ),
      ),
    );
  }
}
