import 'package:week5/core/models/student.dart';
import 'package:week5/features/students/logic/data/repositories/students_repository.dart';

class GetStudentsUseCase {
  const GetStudentsUseCase({this.repository = const StudentsRepositoryImpl()});

  final StudentsRepository repository;

  List<Student> call() => repository.getStudents();
}
