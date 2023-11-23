import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_provider/controller/provider_controller.dart';
import 'package:student_provider/ui/home.dart';


class AddScreenProvider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final StudentProvider controller = Provider.of<StudentProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Editor'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => controller.pickImage(),
                child: Consumer<StudentProvider>(
                  builder: (context, controller, child) {
                    return controller.imagePath.isNotEmpty
                        ? CircleAvatar(
                            radius: 50.0,
                            child: Image.file(File(controller.imagePath)),
                          )
                        : CircleAvatar(
                            radius: 50.0,
                            child: Icon(Icons.camera),
                          );
                  },
                ),
              ),
              SizedBox(height: 20.0),
              TextField(
                onChanged: (value) => controller.id = int.parse(value),
                decoration: InputDecoration(labelText: 'ID'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                onChanged: (value) => controller.name = value,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                onChanged: (value) => controller.age = int.parse(value),
                decoration: InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                onChanged: (value) => controller.phone = value,
                decoration: InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
              ),
              TextField(
                onChanged: (value) => controller.address = value,
                decoration: InputDecoration(labelText: 'Address'),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () async {
                  controller.addStudent();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
