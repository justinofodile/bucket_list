import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ViewBucketList extends StatefulWidget {
  String title;
  String image;
  int index;
  ViewBucketList(
      {super.key,
      required this.index,
      required this.title,
      required this.image});

  @override
  State<ViewBucketList> createState() => _ViewBucketListState();
}

class _ViewBucketListState extends State<ViewBucketList> {
  Future<void> deleteData() async {
    Navigator.pop(context);
    try {
      Response response = await Dio().delete(
          'https://bucketlist-b0a70-default-rtdb.firebaseio.com/bucketlist/${widget.index}.json');

      Navigator.pop(context, 'refresh');
    } catch (e) {
      print('Error');
    }
  }

  Future<void> markAsCompleted() async {
    try {
      Map<String, dynamic> data = {
        "completed": true,
      };
      Response response = await Dio().patch(
        'https://bucketlist-b0a70-default-rtdb.firebaseio.com/bucketlist/${widget.index}.json',
        data: data,
      );
      // ignore: use_build_context_synchronously
      Navigator.pop(context, 'refresh');
    } catch (e) {
      print('Error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton(onSelected: (value) {
            if (value == 1) {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Do you want to delete?'),
                    actions: [
                      InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel')),
                      InkWell(
                        onTap: deleteData,
                        child: const Text('Confirm'),
                      ),
                    ],
                  );
                },
              );
            } else if (value == 2) {
              markAsCompleted();
            }
          }, itemBuilder: (context) {
            return [
              const PopupMenuItem(value: 1, child: Text('Delete')),
              const PopupMenuItem(value: 2, child: Text('Mark as Read')),
            ];
          })
        ],
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          // Text(widget.index.toString()),
          Container(
            height: 300,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(widget.image),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
