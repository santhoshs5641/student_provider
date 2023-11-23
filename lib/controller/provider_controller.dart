import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:student_provider/db/functions/services.dart';
import 'package:student_provider/db/student_model.dart';

class StudentProvider with ChangeNotifier {
   late StudentService studentService;

  StudentProvider(Box<StudentProfile> studentBox) {
    // Initialize StudentService with the provided studentBox
    studentService = StudentService(studentBox);
    initControllers();
  }


  List<StudentProfile> students = [];
  String query = '';
  List<StudentProfile> searchResults = [];
  int id = 0;
  String name = '';
  int age = 0;
  String phone = '';
  String address = '';
  String imagePath = '';

  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      imagePath = pickedFile.path;
      notifyListeners();
    }
  }

  late TextEditingController nameController;
  late TextEditingController ageController;
  late TextEditingController phoneNumberController;
  late TextEditingController addressController;

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    phoneNumberController.dispose();
    addressController.dispose();
    super.dispose();
  }

  void initControllers() {
    nameController = TextEditingController();
    ageController = TextEditingController();
    phoneNumberController = TextEditingController();
    addressController = TextEditingController();
  }

  Future<void> fetchStudents() async {
    students = await studentService.getAllStudents();
    notifyListeners();
  }

  void onStudentDeleted(StudentProfile student) async {
    await studentService.deleteStudent(student.id);
    fetchStudents();
  }

  void onStudentAdded() {
    fetchStudents();
  }

  void clearQuery() {
    query = '';
    notifyListeners();
  }

  void updateQuery(String newQuery) {
    query = newQuery;
    filterResults();
  }

  void filterResults() {
    searchResults = students
        .where((student) => student.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    notifyListeners();
  }

  void onDeleteStudent(
    StudentProfile student,
    List<StudentProfile> students,
    Function(List<StudentProfile>) onSearchResultsUpdated,
  ) {
    students.remove(student);
    onSearchResultsUpdated(students);
  }

  void onEdit() {
    // Handle the edit operation if needed
  }

  void setInitialValues(StudentProfile student) {
    nameController.text = student.name;
    ageController.text = student.age.toString();
    phoneNumberController.text = student.phoneNumber;
    addressController.text = student.address;
  }

  void onSave(StudentProfile student, Function onEdit) {
    student.name = nameController.text;
    student.age = int.parse(ageController.text);
    student.phoneNumber = phoneNumberController.text;
    student.address = addressController.text;

    onEdit();
  }

  void addStudent() {
    // Assuming you have the required properties like id, name, age, etc.
    StudentProfile newStudent = StudentProfile(
      id: id,
      name: name,
      age: age,
      phoneNumber: phone,
      address: address,
      imagePath: imagePath,
      // ... (other properties)
    );

    studentService.addStudent(newStudent);

    // Clear the input fields after adding a student
    id = 0;
    name = '';
    age = 0;
    phone = '';
    address = '';

    // Fetch students to update the list
    fetchStudents();
  }
}
