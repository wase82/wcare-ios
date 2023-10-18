part of 'services_bloc.dart';

@immutable
abstract class ServicesEvent {}

class ServicesEventCheckPermission extends ServicesEvent {}

class ServicesEventReqLocation extends ServicesEvent {

}
