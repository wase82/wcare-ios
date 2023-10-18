import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

part 'photo_picker_event.dart';

part 'photo_picker_state.dart';

class PhotoPickerBloc extends Bloc<PhotoPickerEvent, PhotoPickerState> {
  PhotoPickerBloc() : super(PhotoPickerNoPhoto()) {
    on<PhotoPickerEvent>((event, emit) {
      if (event is PhotoPickerEventPhotoPicked) {
        emit(PhotoPickerPhotoPicked(pickedPhoto: event.pickedPhoto));
      }
    });
  }
}
