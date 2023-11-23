
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_provider/controller/provider_controller.dart';
import 'package:student_provider/db/student_model.dart';
import 'package:student_provider/ui/edit.dart';

class StudentSearch extends StatelessWidget {
   final StudentProvider controller;
  final Function(List<StudentProfile>) onSearchResultsUpdated; // Add this line

  StudentSearch({
    required this.controller,
    required this.onSearchResultsUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          onChanged: (newQuery) => controller.updateQuery(newQuery),
          decoration: InputDecoration(
            hintText: 'Search...',
            border: InputBorder.none,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              controller.clearQuery();
            },
          ),
        ],
      ),
      body: Consumer<StudentProvider>(
        builder: (context, provider, child) {
          return _buildSearchResults(controller.searchResults);
        },
      ),
    );
  }

  Widget _buildSearchResults(List<StudentProfile> searchResults) {
    if (searchResults.isEmpty) {
      return Center(
        child: Text('No data found'),
      );
    }

    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        StudentProfile student = searchResults[index];
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
        controller.onDeleteStudent(student, controller.students, (updatedStudents) {
          // You may need to update the state or fetch students again if needed
          controller.searchResults = updatedStudents;
          controller.notifyListeners(); // Ensure the UI updates
        });
      },
      onEdit: controller.onEdit,
    ),
  ),
);


          },
        );
      },
    );
  }
}
