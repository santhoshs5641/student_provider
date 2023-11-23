import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_provider/controller/provider_controller.dart';
import 'package:student_provider/db/student_model.dart';
import 'package:student_provider/ui/add.dart';
import 'package:student_provider/ui/edit.dart';
import 'package:student_provider/ui/search.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch students when HomeScreen is first built
    Provider.of<StudentProvider>(context, listen: false).fetchStudents();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        actions: [
          IconButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StudentSearch(
                    controller: Provider.of<StudentProvider>(context),
                    onSearchResultsUpdated: (filteredResults) {
                      // Handle the updated search results here
                      // You might want to update the UI or perform other actions
                    },
                  ),
                ),
              );

              // Note: You can refresh the data here if needed
              Provider.of<StudentProvider>(context, listen: false).updateQuery("");
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20),
            Consumer<StudentProvider>(
              builder: (context, controller, child) {
                return controller.students.isEmpty
                    ? Text('No students available.')
                    : Expanded(
                        child: Consumer<StudentProvider>(
                          builder: (context, controller, child) {
                            return ListView.builder(
                              itemCount: controller.students.length,
                              itemBuilder: (context, index) {
                                StudentProfile student = controller.students[index];
                                return ListTile(
                                  title: Text(student.name),
                                  subtitle: Text(student.age.toString()),
                                  leading: CircleAvatar(
                                    backgroundImage: FileImage(File(student.imagePath)),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditProfileScreen(
                                          student: student,
                                          onDelete: () {
                                            controller.onDeleteStudent(
                                              student,
                                              controller.students,
                                              (updatedStudents) {
                                                // You may need to update the state or fetch students again if needed
                                                controller.searchResults = updatedStudents;
                                                controller.notifyListeners(); // Ensure the UI updates
                                              },
                                            );
                                          },
                                          onEdit: controller.onEdit,
                                        ),
                                      ),
                                    ).then((result) {
                                      // Handle the result if needed
                                      if (result == 'delete') {
                                        // You may need to update the state or fetch students again if needed
                                        controller.onDeleteStudent(
                                          student,
                                          controller.students,
                                          (updatedStudents) {
                                            controller.searchResults = updatedStudents;
                                            controller.notifyListeners();
                                          },
                                        );
                                      } else if (result == 'edit') {
                                        // You may need to update the state or fetch students again if needed
                                        controller.onEdit();
                                      }
                                    });
                                  },
                                );
                              },
                            );
                          },
                        ),
                      );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Use await to wait for the result from AddScreenProvider
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddScreenProvider()),
          );

          // Fetch students after adding a new student
          Provider.of<StudentProvider>(context, listen: false).fetchStudents();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
