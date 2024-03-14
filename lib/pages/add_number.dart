// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'package:contact_app/models/contact.dart';
import 'package:contact_app/pages/detail_contact.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddNumberPage extends StatefulWidget {
  const AddNumberPage({Key? key}) : super(key: key);

  @override
  State<AddNumberPage> createState() => _AddNumberPageState();
}

class _AddNumberPageState extends State<AddNumberPage> {
  TextEditingController _inputController = TextEditingController();
  late Contact numberContact;

  List<Contact> listContact = [];
  void insertText(String myText) {
    setState(() {
      _inputController.text = _inputController.text + myText;
    });
  }

  void deleteOne() {
    setState(() {
      String currentValue = _inputController.text;
      if (currentValue.isNotEmpty) {
        _inputController.text =
            currentValue.substring(0, currentValue.length - 1);
      }
    });
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add number",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        actions: const [],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: TextFormField(
                  controller: _inputController,
                  initialValue: null,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                        onPressed: () {
                          deleteOne();
                        },
                        icon: Icon(Icons.arrow_back_ios_new_rounded)),
                    filled: true,
                    fillColor: Colors.white,
                    labelText: "Input Number",
                    hintText: "Search",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly // Filter hanya digit
                  ],
                  keyboardType: TextInputType.number,
                  onChanged: (value) {},
                ),
              ),
              const SizedBox(
                height: 50.0,
              ),
              GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 1.0,
                  crossAxisCount: 3,
                  mainAxisSpacing: 6,
                  crossAxisSpacing: 6,
                ),
                itemCount: 12,
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  if (index == 10) {
                    return Container(
                        width: double.infinity,
                        child: Center(
                            child: MaterialButton(
                          height: 100,
                          onPressed: () {
                            insertText('0');
                          },
                          color: Colors.white,
                          textColor: Colors.black,
                          child: Text(
                            '0',
                            style: TextStyle(
                              fontSize: 30.0,
                            ),
                          ),
                          padding: EdgeInsets.all(16),
                          shape: const CircleBorder(),
                        )));
                  } else if (index == 9) {
                    return SizedBox.shrink();
                  } else if (index == 11) {
                    return Container(
                        width: double.infinity,
                        child: Center(
                            child: MaterialButton(
                          height: 100,
                          onPressed: () {
                            deleteOne();
                          },
                          textColor: Colors.black,
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 8.0,
                              ),
                              Icon(Icons.arrow_back_ios_new_rounded),
                              Text(
                                '=',
                                style: TextStyle(
                                    fontSize: 30.0,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          padding: EdgeInsets.all(16),
                          shape: const CircleBorder(),
                        )));
                  }
                  return Container(
                      child: Center(
                          child: MaterialButton(
                    height: 100,
                    onPressed: () {
                      insertText("${index + 1}");
                    },
                    color: Colors.white,
                    textColor: Colors.black,
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        fontSize: 30.0,
                      ),
                    ),
                    padding: EdgeInsets.all(16),
                    shape: const CircleBorder(),
                  )));
                },
              ),
              const SizedBox(
                height: 60.0,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                width: MediaQuery.of(context).size.width,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: Colors.black, width: 0.8)),
                  ),
                  onPressed: () {
                    numberContact = Contact(
                        nama: '',
                        number: _inputController.text,
                        foto: '',
                        kategori: 'teman');
                    print(numberContact.number);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailContactPage(
                              contact: numberContact, status: 'add'),
                        ));
                  },
                  child: const Text(
                    "Tambah Nomor",
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
