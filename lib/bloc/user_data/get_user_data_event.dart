part of 'get_user_data_bloc.dart';


abstract class GetUserDataEvent {}
class GetUserAllDataEvent extends GetUserDataEvent {
  final String id;

  GetUserAllDataEvent({required this.id});
}
