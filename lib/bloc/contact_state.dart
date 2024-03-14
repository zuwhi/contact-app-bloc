
part of 'contact_bloc.dart';
enum ContactStatus { init, loading, success, failed }

class ContactState {
  final List<Contact> contacts;
  final ContactStatus status;

  ContactState(
    this.contacts,
    this.status,
  );
}

// part of 'contact_bloc.dart';

// sealed class ContactState {}

// final class ContactInitial extends ContactState {}

// final class ContactLoading extends ContactState {}

// final class ContactFailure extends ContactState {
//   final String message;
//   ContactFailure(this.message);
// }

// final class ContactLoaded extends ContactState {
//   final List<Contact> contact;
//   ContactLoaded(this.contact);
// }
