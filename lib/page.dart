// import 'package:flutter/material.dart';

// import 'model/Task.dart';

// class TaskListView {
//   Widget method(
//     List<Task> allData,
//   ) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//       //  TopSideTitles(allData: allData),
//         allData.isEmpty
//             ?// const Expanded(child: EmptyListState())
//             : Expanded(
//                 child: ListView.builder(
//                   physics: const BouncingScrollPhysics(),
//                   itemCount: allData.length,
//                   itemBuilder: (context, index) => Slidable(
//                     key: const ValueKey(0),
//                     endActionPane: ActionPane(
//                       motion: const ScrollMotion(),
//                       extentRatio: 0.3,
//                       children: [
//                         SlidableAction(
//                           flex: 3,
//                           onPressed: (_) => deleteItem(allData[index].todoId),
//                           foregroundColor: Colors.red,
//                           icon: Icons.delete,
//                           label: 'Remove',
//                           autoClose: true,
//                         ),
//                       ],
//                     ),
//                     child: SizedBox(
//                       width: double.infinity,
//                       height: 110,
//                       child: Row(
//                         children: [
//                           Expanded(
//                             flex: 1,
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 IconButton(
//                                   onPressed: () => _FinalViewState.createTask(
//                                       allData[index].todoId),
//                                   icon: const Icon(
//                                     Icons.edit,
//                                     color: Colors.grey,
//                                   ),
//                                 ),
//                                 const Text(
//                                   "Edit",
//                                   style: TextStyle(color: Colors.grey),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Expanded(
//                             flex: 5,
//                             child: Card(
//                               shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(15)),
//                               color: Colors.deepPurpleAccent.withOpacity(0.5),
//                               margin: const EdgeInsets.symmetric(
//                                   horizontal: 8, vertical: 5),
//                               child: Padding(
//                                 padding:
//                                     const EdgeInsets.only(bottom: 12, left: 12),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   mainAxisAlignment: MainAxisAlignment.end,
//                                   children: [
//                                     Text(
//                                       allData[index].title,
//                                       style: const TextStyle(
//                                           color: Colors.white, fontSize: 30),
//                                     ),
//                                     Text(
//                                       allData[index].description,
//                                       style:
//                                           const TextStyle(color: Colors.white),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//       ],
//     );
//   }
// }
