// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'package:contact_app/bloc/contact_bloc.dart';
import 'package:contact_app/database/utility.dart';
import 'package:contact_app/models/contact.dart';
import 'package:contact_app/pages/add_number.dart';
import 'package:contact_app/pages/detail_contact.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListContactPage extends StatefulWidget {
  const ListContactPage({Key? key}) : super(key: key);

  @override
  State<ListContactPage> createState() => _ListContactPageState();
}

class _ListContactPageState extends State<ListContactPage> {
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    refreshList();
  }

  void refreshList() async {
    context.read<ContactBloc>().add(onGetContact());
  }

  void searchContact() async {
    String key = searchController.text.trim();
    if (key.isEmpty) {
      context.read<ContactBloc>().add(onGetContact());
    } else {
      context.read<ContactBloc>().add(OnSearchContact(key));
    }
  }

  Color stringToColor(String colorString) {
    if (colorString == '') {
      return Colors.black;
    }
    return Color(int.parse(colorString, radix: 16));
  }

  bool setSortList = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Contact App",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        actions: [
          Container(
              padding: const EdgeInsets.only(right: 10),
              child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddNumberPage()),
                    );
                  },
                  icon: const Icon(Icons.add)))
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 6.0,
                  horizontal: 12.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(12.0),
                  ),
                  border: Border.all(
                    width: 1.0,
                    color: Colors.grey[400]!,
                  ),
                ),
                child: Builder(builder: (context) {
                  return Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(3.0),
                        child: Icon(Icons.search),
                      ),
                      Expanded(
                        child: TextFormField(
                          initialValue: null,
                          controller: searchController,
                          decoration: const InputDecoration.collapsed(
                            filled: true,
                            fillColor: Colors.transparent,
                            hintText: "Search",
                            hoverColor: Colors.transparent,
                          ),
                          onChanged: (value) {
                            searchContact();
                          },
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            setSortList = !setSortList;
                          });

                          if (setSortList == true) {
                            context.read<ContactBloc>().add(OnSortList());
                          } else {
                            context.read<ContactBloc>().add(onGetContact());
                          }
                        },
                        child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: (setSortList == true)
                                ? const Icon(
                                    Icons.sort_by_alpha,
                                    size: 20.0,
                                  )
                                : const Icon(
                                    Icons.sort,
                                    size: 20.0,
                                  )),
                      ),
                    ],
                  );
                }),
              ),
              const SizedBox(
                height: 13.0,
              ),
              BlocBuilder<ContactBloc, ContactState>(builder: (context, state) {
                if (state.status == ContactStatus.init) return const Text('0');
                if (state.status == ContactStatus.loading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                List<Contact> listContacts = state.contacts;
                return ListView.builder(
                  itemCount: listContacts.length,
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      color: stringToColor(listContacts[index].warna ?? '')
                          .withOpacity(0.1),
                      elevation: 0,
                      child: ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailContactPage(
                                      contact: listContacts[index],
                                      status: 'edit'),
                                ));
                          },
                          leading: listContacts[index].foto != '' &&
                                  listContacts[index].foto != null
                              ? CircleAvatar(
                                  backgroundImage: MemoryImage(
                                      Utility.dataFromBase64String(
                                          listContacts[index].foto ?? "")))
                              : const CircleAvatar(
                                  backgroundImage:
                                      AssetImage('assets/img/profil.jpg')),
                          title: Text(
                            listContacts[index].nama,
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          subtitle: Text(
                            listContacts[index].number,
                            style: const TextStyle(
                                fontSize: 13.0, fontWeight: FontWeight.w500),
                          ),
                          trailing: IconButton(
                              onPressed: () {
                                // dbHelper.deleteContact(
                                //     listContacts[index].id ?? 0);
                                // refreshList();
                                context.read<ContactBloc>().add(OnDeleteContact(
                                    listContacts[index].id ?? 0));
                              },
                              icon: Icon(
                                Icons.delete,
                                color: stringToColor(
                                        listContacts[index].warna ?? '')
                                    .withOpacity(1),
                              ))),
                    );
                  },
                );
              })
            ],
          ),
        ),
      ),
    );
  }
}



// import 'package:contact_app/database/database_helper.dart';
// import 'package:contact_app/database/utility.dart';
// import 'package:contact_app/models/contact.dart';
// import 'package:contact_app/pages/add_number.dart';
// import 'package:contact_app/pages/detail_contact.dart';
// import 'package:flutter/material.dart';

// class ListContactPage extends StatefulWidget {
//   const ListContactPage({Key? key}) : super(key: key);

//   @override
//   State<ListContactPage> createState() => _ListContactPageState();
// }

// class _ListContactPageState extends State<ListContactPage> {
//   List<Contact> listContact = [];
//   TextEditingController searchController = TextEditingController();

//   final dbHelper = DatabaseHelper();

//   @override
//   void initState() {
//     super.initState();
//     refreshList();
//   }

//   void refreshList() async {
//     final contact = await dbHelper.getAllContact();
//     setState(() {
//       listContact = contact;
//     });
//   }

//   void searchContact() async {
//     String key = searchController.text.trim();
//     List<Contact> contact = [];
//     if (key.isEmpty) {
//       contact = await dbHelper.getAllContact();
//     } else {
//       contact = await dbHelper.searchContact(key);
//       print('cek');
//     }
//     setState(() {
//       listContact = contact;
//     });
//   }

//   Color stringToColor(String colorString) {
//     if (colorString == '') {
//       return Colors.white;
//     }
//     return Color(int.parse(colorString, radix: 16));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "Contact App",
//           style: TextStyle(fontWeight: FontWeight.w600),
//         ),
//         centerTitle: true,
//         actions: [
//           Container(
//               padding: EdgeInsets.only(right: 10),
//               child: IconButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => const AddNumberPage()),
//                     );
//                   },
//                   icon: Icon(Icons.add)))
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Container(
//           padding: const EdgeInsets.all(15.0),
//           child: Column(
//             children: [
//               Container(
//                 padding: const EdgeInsets.symmetric(
//                   vertical: 6.0,
//                   horizontal: 12.0,
//                 ),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: const BorderRadius.all(
//                     Radius.circular(12.0),
//                   ),
//                   border: Border.all(
//                     width: 1.0,
//                     color: Colors.grey[400]!,
//                   ),
//                 ),
//                 child: Row(
//                   children: [
//                     const Padding(
//                       padding: EdgeInsets.all(3.0),
//                       child: Icon(Icons.search),
//                     ),
//                     Expanded(
//                       child: TextFormField(
//                         initialValue: null,
//                         controller: searchController,
//                         decoration: const InputDecoration.collapsed(
//                           filled: true,
//                           fillColor: Colors.transparent,
//                           hintText: "Search",
//                           hoverColor: Colors.transparent,
//                         ),
//                         onChanged: (value) {
//                           searchContact();
//                         },
//                       ),
//                     ),
//                     InkWell(
//                       onTap: () {},
//                       child: const Padding(
//                         padding: EdgeInsets.all(3.0),
//                         child: Icon(
//                           Icons.sort,
//                           size: 20.0,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(
//                 height: 13.0,
//               ),
//               ListView.builder(
//                 itemCount: listContact.length,
//                 shrinkWrap: true,
//                 physics: const ScrollPhysics(),
//                 itemBuilder: (BuildContext context, int index) {
//                   return Card(
//                     margin: EdgeInsets.only(bottom: 10),
//                     color: stringToColor(listContact[index].warna ?? '')
//                         .withOpacity(0.1),
//                     elevation: 0,
//                     child: ListTile(
//                         onTap: () {
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => DetailContactPage(
//                                     contact: listContact[index],
//                                     status: 'edit'),
//                               ));
//                         },
//                         leading: CircleAvatar(
//                             backgroundImage: MemoryImage(
//                                 Utility.dataFromBase64String(
//                                     listContact[index].foto ?? ""))),
//                         title: Text(
//                           '${listContact[index].nama}',
//                           style: TextStyle(
//                             fontSize: 16.0,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.black87,
//                           ),
//                         ),
//                         subtitle: Text(
//                           '${listContact[index].number}',
//                           style: TextStyle(
//                               fontSize: 13.0, fontWeight: FontWeight.w500),
//                         ),
//                         trailing: IconButton(
//                             onPressed: () {
//                               dbHelper
//                                   .deleteContact(listContact[index].id ?? 0);
//                               refreshList();
//                             },
//                             icon: Icon(
//                               Icons.delete,
//                               color:
//                                   stringToColor(listContact[index].warna ?? '')
//                                       .withOpacity(1),
//                             ))),
//                   );
//                 },
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
