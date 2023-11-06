import 'package:flutter/material.dart';

import 'helper/back4appHelper.dart';

class CreateTaskView {
  void createTask() {}
  void createTaskForm(
    BuildContext context,
    int id,
    TextEditingController _titleController,
    TextEditingController _descriptionController,
  ) {
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
        height: MediaQuery.of(context).size.height,
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
          bottom: MediaQuery.of(context).viewInsets.bottom + 200,
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
                color: Colors.black,
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
                backgroundColor: MaterialStateProperty.all(
                    Colors.deepPurpleAccent.withOpacity(.5)),
              ),
              onPressed: () async {
                if (id == null) {
                  print('add tasks');
                  //await addItem();
                }

                if (id != null) {
                  print('update tasks');
                  // await updateItem(id);
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
}
