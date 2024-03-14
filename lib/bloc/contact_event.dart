part of 'contact_bloc.dart';

sealed class ContactEvent {}

final class onGetContact extends ContactEvent {}

class OnAddContact extends ContactEvent {
  final Contact newContact;

  OnAddContact(this.newContact);
}

class OnUpdateContact extends ContactEvent {
  final Contact updateContact;

  OnUpdateContact(this.updateContact);
}

class OnDeleteContact extends ContactEvent {
  final int id;

  OnDeleteContact(this.id);
}
class OnSearchContact extends ContactEvent {
  final String key;

  OnSearchContact(this.key);
}
class OnSortList extends ContactEvent {
}
