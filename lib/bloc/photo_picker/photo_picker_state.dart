part of 'photo_picker_bloc.dart';

@immutable
abstract class PhotoPickerState {}

class PhotoPickerNoPhoto extends PhotoPickerState {}

class PhotoPickerPhotoPicked extends PhotoPickerState {
  final XFile pickedPhoto;

  PhotoPickerPhotoPicked({required this.pickedPhoto});
}