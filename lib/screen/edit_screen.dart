import 'dart:io';
import 'dart:typed_data';
import '../database/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:sql_lite/Package/Utils.dart';
import 'package:sql_lite/models/picture.dart';
import '../bloc/image_picker/image_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sql_lite/Package/Text_Button.dart';
import 'package:sql_lite/Package/TextFormField.dart';
import 'package:sql_lite/Package/PackageConstants.dart';
import 'package:sql_lite/bloc/image_picker/image_bloc.dart';
import 'package:sql_lite/bloc/image_picker/image_state.dart';

class EditPictureScreen extends StatelessWidget
    with text_with_button, utils, formField {
  final int id;
  EditPictureScreen({super.key, required this.id});

  pickImage(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
                onTap: () =>
                    context.read<ImageBloc>()..add(PickImageFromCameraEvent()),
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
                onTap: () =>
                    context.read<ImageBloc>()..add(PickImageFromGalleryEvent()),
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
    });
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
                  BlocBuilder<ImageBloc, ImageState>(
                    builder: (context, state) {
                      return Container(
                        height: 125,
                        width: 125,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(100)),
                        child: state is ImagePickedState
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Image.file(
                                  state.imageString,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Container(),
                      );
                    },
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: InkWell(
                      onTap: () {
                        pickImage(context);
                      },
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
                  final state = context.read<ImageBloc>().state;
                  if (state is ImagePickedState) {
                    context.read<ImageBloc>().add(UpdateImageEvent(
                        id: id,
                        title: state.title,
                        imageBytes: await state.imageString.readAsBytes()));
                  }
                  Navigator.pop(context);
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
