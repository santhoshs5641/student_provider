import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_provider/controller/provider_controller.dart';
import 'package:student_provider/db/student_model.dart';

class EditProfileScreen extends StatelessWidget {
  final StudentProfile student;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  EditProfileScreen({
    required this.student,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    // Use the provider instance passed through the constructor
    final StudentProvider controller =
        context.read<StudentProvider>();

    // Set initial values when the screen is created
    controller.setInitialValues(student);

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              // Add code here to delete the item from the database
              student.delete();
              onDelete();
              Navigator.pop(context); // Close the screen after deletion
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: controller.nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextFormField(
                controller: controller.ageController,
                decoration: InputDecoration(labelText: 'Age'),
              ),
              TextFormField(
                controller: controller.phoneNumberController,
                decoration: InputDecoration(labelText: 'Phone Number'),
              ),
              TextFormField(
                controller: controller.addressController,
                decoration: InputDecoration(labelText: 'Address'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Save the updated data using the controller
                  controller.onSave(student, onEdit);
                  Navigator.pop(context, true); // Close the screen after saving
                },
                child: Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
