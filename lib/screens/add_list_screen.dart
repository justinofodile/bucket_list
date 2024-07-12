// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class AddBucketListScreen extends StatefulWidget {
  int newIndex;
  AddBucketListScreen({super.key, required this.newIndex});

  @override
  State<AddBucketListScreen> createState() => _AddBucketListScreenState();
}

class _AddBucketListScreenState extends State<AddBucketListScreen> {
  late TextEditingController nameText, costText, imageText, completedText;
  @override
  void initState() {
    super.initState();
    nameText = TextEditingController();
    costText = TextEditingController();
    imageText = TextEditingController();
    completedText = TextEditingController();
  }

  @override
  void dispose() {
    nameText.dispose();
    costText.dispose();
    imageText.dispose();
    completedText.dispose();
    super.dispose();
  }

  Future<void> addData() async {
    try {
      Map<String, dynamic> data = {
        "completed": false,
        "name": nameText.text,
        "cost": costText.text,
        "image": imageText.text
      };
      // ignore: unused_local_variable
      Response response = await Dio().patch(
        'https://bucketlist-b0a70-default-rtdb.firebaseio.com/bucketlist/${widget.newIndex}.json',
        data: data,
      );
      // ignore: use_build_context_synchronously
      Navigator.pop(context, 'refresh');
    } catch (e) {
      print('Error');
    }
  }

  var addDataFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add Bucket List'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(9.0),
          child: Form(
            key: addDataFormKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value.toString().length < 3) {
                        return "Value must be more than 3 characters";
                      }
                      /* if (value == null || value.isEmpty) {
                        return "Please enter a value";
                      } */
                      // return null;
                    },
                    controller: nameText,
                    decoration: const InputDecoration(
                      label: Text("Name"),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      /* if (value!.length < 3) {
                        return "Value must be more than 3 characters";
                      } */
                      if (value == null || value.isEmpty) {
                        return "Please enter a value";
                      }
                      // return null;
                    },
                    controller: costText,
                    decoration: const InputDecoration(
                      label: Text("Cost"),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      /* if (value!.length < 3) {
                        return "Value must be more than 3 characters";
                      } */
                      if (value == null || value.isEmpty) {
                        return "Please enter a value";
                      }
                      // return null;
                    },
                    controller: imageText,
                    decoration: const InputDecoration(
                      label: Text("Image"),
                    ),
                  ),
                  /* const SizedBox(height: 20),
                  TextField(
                    controller: completedText,
                    decoration: const InputDecoration(
                      label: Text("Completed"),
                    ),
                  ), */
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.lightBlue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0),
                            ),
                          ),
                          onPressed: () {
                            if (addDataFormKey.currentState!.validate()) {
                              addData();
                            }
                          },
                          child: const Text(
                            'Add Data',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
