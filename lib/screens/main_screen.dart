import 'package:bucketlist/screens/add_list_screen.dart';
import 'package:bucketlist/screens/view_bucket_list.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<dynamic> bucketListData = [];
  bool isLoading = false;
  bool isError = false;
  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      Response response = await Dio().get(
          'https://bucketlist-b0a70-default-rtdb.firebaseio.com/bucketlist.json');
      // ignore: avoid_print
      if (response.data is List) {
        bucketListData = response.data;
      } else {
        bucketListData = [];
      }
      isLoading = false;
      isError = false;
      setState(() {});
    } catch (e) {
      isLoading = false;
      isError = true;
      setState(() {});
      // ignore: use_build_context_synchronously
      /* showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Error Occured'),
            content: Text(e.toString()),
          );
        },
      ); */
    }
  }

  Widget errorCheckingWidget({required String errorText}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.warning),
          const SizedBox(
            height: 10,
          ),
          Text(errorText,
              style: const TextStyle(fontSize: 20, color: Colors.red)),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
            onPressed: getData,
            child: const Text('Try again'),
          ),
        ],
      ),
    );
  }

  Widget listBuilderWidget() {
    List<dynamic> filteredList = bucketListData
        .where((element) => !(element?['completed'] ?? false))
        .toList();
    return filteredList.isEmpty
        ? const Center(child: Text('No data on bucket list'))
        : ListView.builder(
            itemCount: bucketListData.length,
            itemBuilder: (BuildContext context, int index) {
              return (bucketListData[index] is Map &&
                      (!(bucketListData[index]?['completed'] ?? false)))
                  ? Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return ViewBucketList(
                                  index: index,
                                  title: bucketListData[index]['name'] ?? "",
                                  image: bucketListData[index]['image'] ?? "",
                                );
                              },
                            ),
                          ).then((value) {
                            if (value == 'refresh') {
                              getData();
                            }
                          });
                        },
                        title: Text(bucketListData[index]?['name'] ?? ""),
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                              bucketListData[index]?['image'] ?? ""),
                        ),
                        trailing: Text(
                            bucketListData[index]?['cost'].toString() ?? ""),
                      ),
                    )
                  : const SizedBox();
            },
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        shape: const CircleBorder(),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return AddBucketListScreen(
                  newIndex: bucketListData.length,
                );
              },
            ),
          ).then((value) {
            if (value == 'refresh') {
              getData();
            }
          });
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      appBar: AppBar(
        // centerTitle: true,
        title: const Text(
          'Bucket List',
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(onTap: getData, child: const Icon(Icons.refresh)),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          getData();
        },
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : isError
                ? errorCheckingWidget(errorText: 'Error Connecting....')
                : listBuilderWidget(),
      ),
    );
  }
}
