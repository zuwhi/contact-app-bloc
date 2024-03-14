import 'package:bloc/bloc.dart';
import 'package:contact_app/models/contact.dart';
import 'package:contact_app/repositories/contact.repo.dart';

part 'contact_event.dart';
part 'contact_state.dart';

class ContactBloc extends Bloc<ContactEvent, ContactState> {
  ContactBloc() : super(ContactState([], ContactStatus.init)) {
    on<onGetContact>((event, emit) async {
      emit(ContactState([], ContactStatus.loading));
      final db = ContactRepository();
      final List<Contact> hasil = await db.getAllContact();
      emit(ContactState(hasil, ContactStatus.success));
    });

    on<OnAddContact>((event, emit) async {
      emit(ContactState([], ContactStatus.loading));
      final db = ContactRepository();
      final add = db.addContact(event.newContact);
      final List<Contact> hasil = await db.getAllContact();
      if (add == 0) {
        emit(ContactState([], ContactStatus.failed));
      } else {
        emit(ContactState(hasil, ContactStatus.success));
      }
    });
    on<OnUpdateContact>((event, emit) async {
      emit(ContactState([], ContactStatus.loading));
      final db = ContactRepository();
      final update = db.updateContact(event.updateContact);
      final List<Contact> hasil = await db.getAllContact();
      if (update == 0) {
        emit(ContactState([], ContactStatus.failed));
      } else {
        emit(ContactState(hasil, ContactStatus.success));
      }
    });
    on<OnDeleteContact>((event, emit) async {
      emit(ContactState([], ContactStatus.loading));
      final db = ContactRepository();
      final update = db.deleteContact(event.id);
      final List<Contact> hasil = await db.getAllContact();
      if (update == 0) {
        emit(ContactState([], ContactStatus.failed));
      } else {
        emit(ContactState(hasil, ContactStatus.success));
      }
    });
    on<OnSearchContact>((event, emit) async {
      emit(ContactState([], ContactStatus.loading));
      final db = ContactRepository();
      final List<Contact> hasil = await db.searchContact(event.key);
      if (hasil == 0) {
        emit(ContactState([], ContactStatus.failed));
      } else {
        emit(ContactState(hasil, ContactStatus.success));
      }
    });
    on<OnSortList>((event, emit) async {
      emit(ContactState([], ContactStatus.loading));
      final db = ContactRepository();
      final List<Contact> hasil = await db.sortlist();
      if (hasil == 0) {
        emit(ContactState([], ContactStatus.failed));
      } else {
        emit(ContactState(hasil, ContactStatus.success));
      }
    });
  }
}
