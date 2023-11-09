// ignore_for_file: use_build_context_synchronously

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:todo_flutter_app/model/Task.dart';

import 'helper/back4appHelper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const keyApplicationId = 'Add Application ID';
  const keyClientKey = 'ADD Client key';
  const keyParseServerUrl = 'https://parseapi.back4app.com';
  await Parse().initialize(keyApplicationId, keyParseServerUrl,
      clientKey: keyClientKey, debug: true);
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FinalView(),
    ),
  );
}

class FinalView extends StatefulWidget {
  const FinalView({Key? key}) : super(key: key);

  @override
  _FinalViewState createState() => _FinalViewState();
}

class _FinalViewState extends State<FinalView> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  List<Task> allData = [];
  List<Task> pendingTask = [];

  var appBarColor = const Color(0xFFe5666d);
  var appBackground = const Color(0xFFeefcfb);
  var textColor = const Color(0xFF062321);
  var cardColor = const Color(0xFFb9f3f0);
  var deleteIcon = const Color(0xFFc02129);
  var cardColorInv = const Color(0xFFDC464D);

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1));
    refreshData();
    if (allData.isEmpty) {
      setState(() {
        isLoading = true;
      });
    }
  }

  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: appBackground,
      appBar: _AppBar(),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            allData.isEmpty
                ? Expanded(
                    child: Center(
                      child: Image.asset(
                        'images/add_tasks.png',
                        width: size.width * 0.9,
                      ),
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: allData.length,
                        itemBuilder: (context, index) => GestureDetector(
                              onLongPress: () {
                                createTask(allData[index].todoId);
                              },
                              child: Slidable(
                                key: const ValueKey(0),
                                endActionPane: ActionPane(
                                  motion: const ScrollMotion(),
                                  extentRatio: 0.3,
                                  children: [
                                    SlidableAction(
                                      flex: 3,
                                      onPressed: (_) =>
                                          deleteItem(allData[index].todoId),
                                      foregroundColor: deleteIcon,
                                      backgroundColor: appBackground,
                                      icon: Icons.delete,
                                      label: 'Remove',
                                      autoClose: true,
                                    ),
                                  ],
                                ),
                                child: SizedBox(
                                  width: double.infinity,
                                  height: 90,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                updateStatus(index);
                                              },
                                              icon: Icon(
                                                allData[index].completed
                                                    ? Icons.check_box
                                                    : Icons
                                                        .check_box_outline_blank,
                                                color: appBarColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 5,
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          color: !allData[index].completed
                                              ? cardColor
                                              : cardColorInv,
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 5),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 12, left: 12),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Text(
                                                  allData[index].title,
                                                  style: TextStyle(
                                                      color: textColor,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 20,
                                                      decoration: allData[index]
                                                              .completed
                                                          ? TextDecoration
                                                              .lineThrough
                                                          : null),
                                                ),
                                                Text(
                                                  allData[index].description,
                                                  style: TextStyle(
                                                      color: textColor,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      decoration: allData[index]
                                                              .completed
                                                          ? TextDecoration
                                                              .lineThrough
                                                          : null),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )),
                  ),
          ],
        ),
      ),
      floatingActionButton: _buildFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void createTask(int? id) async {
    if (id != null) {
      // id != null -> update an existing item
      final existingJournal =
          allData.firstWhere((element) => element.todoId == id);
      _titleController.text = existingJournal.title;
      _descriptionController.text = existingJournal.description;
    }
    // id == null -> create new item
    showModalBottomSheet(
      context: context,
      elevation: 5,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
      ),
      builder: (_) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
          ),
        ),
        padding: EdgeInsets.only(
          top: 15,
          left: 15,
          right: 15,
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 70,
            ),
            Text(
              id == null ? 'Add New Task!' : 'Update The Task',
              style: const TextStyle(
                color: Color(0xFF062321),
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              "Tell me about Your Task:)",
              style: TextStyle(color: Colors.grey, fontSize: 25),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.title),
                hintText: 'Title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.description),
                hintText: 'Description',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9),
                  ),
                ),
                backgroundColor: MaterialStateProperty.all(appBarColor),
              ),
              onPressed: () async {
                if (id == null) {
                  await addItem();
                }

                if (id != null) {
                  await updateItem(id);
                }

                _titleController.text = '';
                _descriptionController.text = '';

                // ignore: use_build_context_synchronously
                Navigator.pop(context);
              },
              child: Text(id == null ? 'Create New' : 'Update'),
            )
          ],
        ),
      ),
    );
  }

  void refreshData() async {
    final data = await Back4AppHelper.getTasks();
    setState(() {
      allData = data;
      pendingTask = allToPendingTask(allData);
      isLoading = false;
    });
  }

  Future<void> _refresh() async {
    refreshData();
  }

  Future<void> addItem() async {
    await Back4AppHelper.createItem(
        _titleController.text, _descriptionController.text);
    refreshData();
  }

  /// Update Task Function
  Future<void> updateItem(int id) async {
    await Back4AppHelper.updateTask(
        id, _titleController.text, _descriptionController.text);
    refreshData();
  }

  Future<void> updateStatus(int index) async {
    setState(() {
      allData[index].completed = !allData[index].completed;
    });
    await Back4AppHelper.updateStatusInTask(
        allData[index].todoId,
        allData[index].title,
        allData[index].description,
        allData[index].completed);
    refreshData();
  }

  // ignore: non_constant_identifier_names
  AppBar _AppBar() {
    List<Task> selectedList =
        allData.where((element) => element.completed).toList();
    int len = selectedList.length;
    return AppBar(
      backgroundColor: appBarColor,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            child: Center(
              child: Text(
                "My Tasks",
                style: TextStyle(
                  foreground: Paint()
                    ..shader = const LinearGradient(
                      colors: [
                        Color(0xFFC2C3C1),
                        Color(0XFF7d7a7f),
                      ],
                    ).createShader(const Rect.fromLTWH(0.0, 20.0, 200.0, 70.0)),
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal,
                  fontSize: 30,
                ),
              ),
            ),
          ),
          GestureDetector(
            onLongPress: deleteItemAll,
            child: FloatingActionButton(
              onPressed: deleteItems,
              backgroundColor: appBarColor,
              foregroundColor: appBarColor,
              child: Text(
                "$len",
                style: TextStyle(
                    color: textColor,
                    fontSize: 25,
                    fontWeight: FontWeight.w300),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void deleteItem(int id) async {
    await Back4AppHelper.deleteTask(id);
    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.fixed,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: 'Success!',
        message: 'Successfully removed task',
        contentType: ContentType.success,
      ),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);

    refreshData();
  }

  void deleteItems() async {
    await Back4AppHelper.deleteTasks(true);
    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: 'Success!',
        message: 'Successfully removed COMPLETED tasks',
        messageFontSize: 15,
        contentType: ContentType.success,
      ),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);

    refreshData();
  }

  void deleteItemAll() async {
    await Back4AppHelper.deleteAllTasks();
    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: 'Success!',
        message: 'Removed All tasks',
        messageFontSize: 15,
        contentType: ContentType.success,
      ),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);

    refreshData();
  }

  List<Task> allToPendingTask(List<Task> allData) {
    return allData.where((element) => !element.completed).toList();
  }

  Widget _buildFAB() {
    return SizedBox(
      width: 90,
      child: FloatingActionButton(
        hoverColor: deleteIcon,
        hoverElevation: 20,
        shape: const CircleBorder(side: BorderSide.none),
        backgroundColor: appBarColor,
        child: const Icon(Icons.add),
        onPressed: () => createTask(null),
      ),
    );
  }
}
