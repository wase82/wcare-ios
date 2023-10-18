part of 'photo_picker_bloc.dart';

@immutable
abstract class PhotoPickerEvent {}

class PhotoPickerEventPhotoPicked extends PhotoPickerEvent {
  final XFile pickedPhoto;

  PhotoPickerEventPhotoPicked({required this.pickedPhoto});
}