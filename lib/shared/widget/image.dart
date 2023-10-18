import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wtoncare/bloc/photo_picker/photo_picker_bloc.dart';
import 'package:wtoncare/shared/util/color.dart';
import 'package:wtoncare/router/page_foto_detail.dart';
import 'package:wtoncare/shared/widget/alert.dart';

ImagePicker imagePicker = ImagePicker();

class ImageNetworkHolder extends StatelessWidget {
  final String url;

  const ImageNetworkHolder({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  HeroPhotoViewRouteWrapper(imageProvider: NetworkImage(url))),
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 4,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(5),
              topRight: Radius.circular(5),
            ),
            image:
                DecorationImage(image: NetworkImage(url), fit: BoxFit.cover)),
      ),
    );
  }
}

class ImageNetworkHolderRadius extends StatelessWidget {
  final String url;

  const ImageNetworkHolderRadius({Key? key, required this.url})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  HeroPhotoViewRouteWrapper(imageProvider: NetworkImage(url))),
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 5,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            image:
                DecorationImage(image: NetworkImage(url), fit: BoxFit.cover)),
      ),
    );
  }
}

class CardImage extends StatelessWidget {
  final PhotoPickerBloc photoPickerBloc;
  final TextStyle? textStyle;
  final String title;

  const CardImage(
      {Key? key,
      required this.photoPickerBloc,
      this.textStyle,
      this.title = "Foto Temuan"})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double iconSize = 20;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 5.0),
          child: Text(
            title,
            style: textStyle ??
                const TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey.withOpacity(0.5), // Warna abu
              width: 1.0, // Ketebalan 1
            ),
            borderRadius:
                BorderRadius.circular(10.0), // Radius untuk membuat ClipRRect
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(iconSize / 2),
            child: SizedBox(
              height: MediaQuery.of(context).size.height / 5,
              child: GestureDetector(
                onTap: () async {
                  try {
                    XFile? file = await showPicker(context);
                    if (file != null) {
                      photoPickerBloc
                          .add(PhotoPickerEventPhotoPicked(pickedPhoto: file));
                    }
                  } catch (e) {
                    showSnackBar(
                        context: context,
                        message: e.toString(),
                        messageType: MessageType.error);
                  }
                },
                child: BlocBuilder<PhotoPickerBloc, PhotoPickerState>(
                  bloc: photoPickerBloc,
                  builder: (context, state) {
                    if (state is PhotoPickerPhotoPicked) {
                      return Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.file(
                            File(state.pickedPhoto.path),
                            fit: BoxFit.fitWidth,
                          ),
                          Container(
                            color: cWhite.withOpacity(0.3),
                            child: const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.camera_alt,
                                      color: cSecondColor, size: 50),
                                  Text(
                                    'Ganti Foto',
                                    style: TextStyle(
                                      color: cSecondColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      );
                    }
                    return Container(
                      color: cWhite,
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.camera_alt,
                                color: cUnFocusColor, size: 50),
                            Text(
                              'Ambil Foto',
                              style: TextStyle(
                                color: cUnFocusColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

Future<XFile?> showPicker(BuildContext context) async {
  return await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Galeri'),
                  onTap: () async {
                    loadImage(ImageSource.gallery).then((value) {
                      Navigator.pop(context, value);
                    });
                  }),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text("Kamera"),
                onTap: () async {
                  loadImage(ImageSource.camera).then((value) {
                    Navigator.pop(context, value);
                  });
                },
              ),
            ],
          ),
        );
      });
}

Future<XFile?> loadImage(ImageSource imageSource) async {
  XFile? file =
      await imagePicker.pickImage(maxWidth: 1000, source: imageSource);
  if (file != null) {
    ImageCropper tes = ImageCropper();
    CroppedFile? croppedFile = await tes.cropImage(
        sourcePath: file.path,
        aspectRatio: const CropAspectRatio(ratioX: 7, ratioY: 5),
        compressQuality: 75,
        maxWidth: 800,
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.blue,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.ratio7x5,
              lockAspectRatio: true),
        ]);
    if (croppedFile != null) {
      XFile newFile = XFile(croppedFile.path);
      return newFile;
    }
    return null;
  }
  return null;
}
