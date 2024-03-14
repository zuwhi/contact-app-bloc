import 'package:contact_app/bloc/contact_bloc.dart';
import 'package:contact_app/database/database_helper.dart';
import 'package:contact_app/database/utility.dart';
import 'package:contact_app/pages/list_contact.dart';
import 'package:flutter/material.dart';

import 'package:contact_app/models/contact.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class DetailContactPage extends StatefulWidget {
  final contact;
  final status;
  const DetailContactPage({Key? key, required this.contact, this.status})
      : super(key: key);

  @override
  State<DetailContactPage> createState() => _DetailContactPageState();
}

class _DetailContactPageState extends State<DetailContactPage> {
  String? _selectImage;
  String? kategori;
  final ImagePicker picker = ImagePicker();
  String? setColor;

  Future getImage() async {
    ImagePicker().pickImage(source: ImageSource.gallery).then((imgFile) async {
      String imgString = Utility.base64String(await imgFile!.readAsBytes());
      setState(() {
        _selectImage = imgString;
      });
    });
  }

  void refreshList() async {
    setState(() {});
  }

  final dbHelper = DatabaseHelper();

  colorToString(Color color) {
    setState(() {
      setColor = color.value.toRadixString(16);
    });
    print(setColor);
  }

  Color stringToColor(String colorString) {
    if (colorString == '') {
      return Colors.black;
    }
    return Color(int.parse(colorString, radix: 16));
  }

  String namaText = '';

  void updateNamaText(String value) {
    setState(() {
      namaText = value;
    });
  }

  void _showColorPickerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pick a Color'),
          content: SingleChildScrollView(
            child: BlockPicker(
              pickerColor: stringToColor(setColor ?? ''),
              onColorChanged: (Color color) {
                colorToString(color);
              },
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  late TextEditingController namaController;
  late TextEditingController numberContoller;

  @override
  void initState() {
    super.initState();
    namaController = TextEditingController(text: widget.contact.nama);
    numberContoller = TextEditingController(text: widget.contact.number);

    if (widget.contact != null) {
      setColor = widget.contact.warna;
    }
  }

  @override
  Widget build(BuildContext context) {
    final detail = widget.contact;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: stringToColor(setColor ?? '').withOpacity(0.8),
        title: const Text(
          "Detail Contact ",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        actions: [
          widget.status == 'edit'
              ? IconButton(
                  onPressed: () {
                    final contact = Contact(
                        id: widget.contact.id,
                        nama: namaController.text,
                        number: numberContoller.text,
                        foto: _selectImage ?? detail.foto,
                        kategori: kategori ?? detail.kategori,
                        warna: setColor ?? detail.warna);
                    context.read<ContactBloc>().add(OnUpdateContact(contact));

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ListContactPage()));
                  },
                  icon: Icon(Icons.checklist_rounded))
              : const SizedBox.shrink()
        ],
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
                width: double.infinity,
                height: 300,
                decoration: BoxDecoration(
                  color: stringToColor(setColor ?? '').withOpacity(0.8),
                )),
            Container(
              margin: EdgeInsets.only(top: 195),
              width: double.infinity,
              height: 500,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(33),
                      topRight: Radius.circular(33))),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Column(
                children: [
                  const SizedBox(
                    height: 30.0,
                  ),
                  Center(
                    child: GestureDetector(
                        onTap: () {
                          getImage();
                        },
                        child: Stack(
                          children: [
                            detail.foto != '' && detail.foto != null ||
                                    _selectImage != null
                                ? CircleAvatar(
                                    radius: 45.0,
                                    backgroundImage: MemoryImage(
                                      Utility.dataFromBase64String(
                                          _selectImage ?? detail.foto),
                                    ),
                                  )
                                : const CircleAvatar(
                                    radius: 45.0,
                                    backgroundImage:
                                        AssetImage('assets/img/profil.jpg')),
                            const Positioned(
                                bottom: 0,
                                right: 0,
                                child: CircleAvatar(
                                    maxRadius: 13,
                                    child: Icon(
                                      Icons.edit,
                                      size: 15,
                                      color: Colors.black38,
                                    )))
                          ],
                        )),
                  ),
                  const SizedBox(
                    height: 40.0,
                  ),
                  Container(
                    margin: const EdgeInsets.only(),
                    child: TextFormField(
                      controller: namaController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        labelText: "Nama Contact",
                        hintText: "masukkan nama",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onChanged: (value) {},
                    ),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
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
                      ),
                    ),
                    child: Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.phone),
                        ),
                        Expanded(
                          child: TextFormField(
                            initialValue: null,
                            controller: numberContoller,
                            decoration: const InputDecoration.collapsed(
                              filled: true,
                              fillColor: Colors.transparent,
                              hintText: "",
                              hoverColor: Colors.transparent,
                            ),
                            onFieldSubmitted: (value) {},
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  DropdownButtonFormField<String>(
                    icon: const Icon(Icons.keyboard_arrow_down_rounded),
                    iconSize: 20,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: 0.8,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          width: 1,
                        ),
                      ),
                    ),
                    value: kategori ?? detail.kategori,
                    onChanged: (value) {
                      print(kategori);
                      setState(() {
                        kategori = value.toString();
                      });
                      print(kategori);
                    },
                    items: <String>['teman', 'Suadara', 'perusahaan', 'pacar']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(
                    height: 20.0,
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                              15,
                            )),
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            textStyle: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold)),
                        onPressed: () {
                          _showColorPickerDialog();
                        },
                        child: Text('Pilih Warna')),
                  ),
                  // BlockPicker(
                  //   pickerColor: Colors.red,
                  //   onColorChanged: (Color color) {
                  //     colorToString(color);
                  //   },
                  // ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  widget.status == 'add'
                      ? Container(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide(
                                      color: Colors.black, width: 0.8)),
                            ),
                            onPressed: () {
                              final contact = Contact(
                                  nama: namaController.text,
                                  number: numberContoller.text,
                                  foto: _selectImage,
                                  kategori: kategori ?? 'teman',
                                  warna: setColor);
                              context
                                  .read<ContactBloc>()
                                  .add(OnAddContact(contact));
                              // Navigator.popUntil(context, (route) => route.isFirst);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ListContactPage()));
                            },
                            child: const Text(
                              "Save",
                              style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        )
                      : SizedBox.shrink()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// import 'package:contact_app/database/database_helper.dart';
// import 'package:contact_app/database/utility.dart';
// import 'package:contact_app/pages/list_contact.dart';
// import 'package:flutter/material.dart';

// import 'package:contact_app/models/contact.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:flutter_colorpicker/flutter_colorpicker.dart';

// class DetailContactPage extends StatefulWidget {
//   final contact;
//   final status;
//   const DetailContactPage({Key? key, required this.contact, this.status})
//       : super(key: key);

//   @override
//   State<DetailContactPage> createState() => _DetailContactPageState();
// }

// class _DetailContactPageState extends State<DetailContactPage> {
//   String? _selectImage;
//   String kategori = '';
//   final ImagePicker picker = ImagePicker();
//   String? setColor;

//   Future getImage() async {
//     ImagePicker().pickImage(source: ImageSource.gallery).then((imgFile) async {
//       String imgString = Utility.base64String(await imgFile!.readAsBytes());
//       setState(() {
//         _selectImage = imgString;
//       });
//     });
//   }

//   void refreshList() async {
//     setState(() {});
//   }

//   final dbHelper = DatabaseHelper();

//   colorToString(Color color) {
//     setState(() {
//       setColor = color.value.toRadixString(16);
//     });
//     print(setColor);
//   }

//   String namaText = '';

//   void updateNamaText(String value) {
//     setState(() {
//       namaText = value;
//     });
//   }

//   Color _selectedColor = Colors.red;
//   void _showColorPickerDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Pick a Color'),
//           content: SingleChildScrollView(
//             child: BlockPicker(
//               pickerColor: _selectedColor,
//               onColorChanged: (Color color) {
//                 setState(() {
//                   _selectedColor = color;
//                 });
//                 // Jika Anda ingin melakukan sesuatu dengan nilai warna, letakkan kode di sini
//                 colorToString(color);
//               },
//             ),
//           ),
//           actions: <Widget>[
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text('Close'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   late TextEditingController namaController;
//   late TextEditingController numberContoller;

//   @override
//   void initState() {
//     super.initState();
//     namaController = TextEditingController(text: widget.contact.nama);
//     numberContoller = TextEditingController(text: widget.contact.number);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final detail = widget.contact;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "Detail Contact ",
//           style: TextStyle(fontWeight: FontWeight.w600),
//         ),
//         centerTitle: true,
//         actions: [
//           widget.status == 'edit'
//               ? IconButton(
//                   onPressed: () {
//                     final contact = Contact(
//                         id: widget.contact.id,
//                         nama: namaController.text,
//                         number: numberContoller.text,
//                         foto: _selectImage ?? detail.foto,
//                         kategori: kategori,
//                         warna: setColor);
//                     dbHelper.updateContact(contact);

//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => ListContactPage()));
//                   },
//                   icon: Icon(Icons.checklist_rounded))
//               : SizedBox.shrink()
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 50),
//           child: Column(
//             children: [
//               Center(
//                 child: GestureDetector(
//                   onTap: () {
//                     getImage();
//                   },
//                   child: CircleAvatar(
//                     radius: 45.0,
//                     backgroundImage: MemoryImage(
//                       Utility.dataFromBase64String(_selectImage ?? detail.foto),
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(
//                 height: 20.0,
//               ),
//               Container(
//                 margin: const EdgeInsets.only(),
//                 child: TextFormField(
//                   controller: namaController,
//                   decoration: InputDecoration(
//                     filled: true,
//                     fillColor: Colors.white,
//                     labelText: "Nama Contact",
//                     hintText: "Search",
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                   onChanged: (value) {
//                     // a
//                   },
//                 ),
//               ),
//               const SizedBox(
//                 height: 15.0,
//               ),
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
//                   ),
//                 ),
//                 child: Row(
//                   children: [
//                     const Padding(
//                       padding: EdgeInsets.all(8.0),
//                       child: Icon(Icons.phone),
//                     ),
//                     Expanded(
//                       child: TextFormField(
//                         initialValue: null,
//                         controller: numberContoller,
//                         decoration: const InputDecoration.collapsed(
//                           filled: true,
//                           fillColor: Colors.transparent,
//                           hintText: "",
//                           hoverColor: Colors.transparent,
//                         ),
//                         onFieldSubmitted: (value) {},
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(
//                 height: 15.0,
//               ),
//               DropdownButtonFormField(
//                 icon: const Icon(Icons.keyboard_arrow_down_rounded),
//                 iconSize: 20,
//                 decoration: InputDecoration(
//                   fillColor: Colors.white,
//                   filled: true,
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                     borderSide: const BorderSide(
//                       color: Colors.black,
//                       width: 0.8,
//                     ),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                     borderSide: const BorderSide(
//                       width: 1,
//                     ),
//                   ),
//                 ),
//                 value: widget.contact.kategori,
//                 onChanged: (value) {
//                   kategori = value.toString();
//                   print(kategori);
//                 },
//                 items: <String>['teman', 'Suadara', 'perusahaan', 'pacar']
//                     .map<DropdownMenuItem<String>>((String value) {
//                   return DropdownMenuItem<String>(
//                     value: value,
//                     child: Text(
//                       value,
//                     ),
//                   );
//                 }).toList(),
//               ),
//               const SizedBox(
//                 height: 20.0,
//               ),
//               Align(
//                 alignment: Alignment.bottomRight,
//                 child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(
//                           15,
//                         )),
//                         padding:
//                             EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//                         textStyle: TextStyle(
//                             fontSize: 15, fontWeight: FontWeight.bold)),
//                     onPressed: () {
//                       _showColorPickerDialog();
//                     },
//                     child: Text('Pilih Warna')),
//               ),
//               // BlockPicker(
//               //   pickerColor: Colors.red,
//               //   onColorChanged: (Color color) {
//               //     colorToString(color);
//               //   },
//               // ),
//               const SizedBox(
//                 height: 20.0,
//               ),
//               widget.status == 'add'
//                   ? Container(
//                       width: MediaQuery.of(context).size.width,
//                       height: 50,
//                       child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.white,
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10),
//                               side:
//                                   BorderSide(color: Colors.black, width: 0.8)),
//                         ),
//                         onPressed: () {
//                           print(numberContoller.text);
//                           print(kategori);
//                           final contact = Contact(
//                               nama: namaController.text,
//                               number: numberContoller.text,
//                               foto: _selectImage,
//                               kategori: kategori,
//                               warna: setColor);
//                           dbHelper.addContact(contact);
//                           // Navigator.popUntil(context, (route) => route.isFirst);
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => ListContactPage()));
//                         },
//                         child: const Text(
//                           "Save",
//                           style: TextStyle(
//                             fontSize: 20.0,
//                             color: Colors.black,
//                           ),
//                         ),
//                       ),
//                     )
//                   : SizedBox.shrink()
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
