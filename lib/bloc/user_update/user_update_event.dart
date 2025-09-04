part of 'user_update_bloc.dart';


abstract class UserUpdateEvent {
  
}
class UserFullNameUpdateEvent extends UserUpdateEvent {
  String firstname;
  String lastname;
  String userid;
  UserFullNameUpdateEvent({required this.firstname, required this.lastname, required this.userid});
      
}
