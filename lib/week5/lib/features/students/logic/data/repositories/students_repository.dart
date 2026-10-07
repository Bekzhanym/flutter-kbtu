import 'package:week5/core/models/student.dart';
import 'package:week5/features/students/logic/data/datasources/students_local_source.dart';

abstract class StudentsRepository {
  List<Student> getStudents();
}

class StudentsRepositoryImpl implements StudentsRepository {
  const StudentsRepositoryImpl({this.source = const StudentsLocalSource()});

  final StudentsLocalSource source;

  @override
  List<Student> getStudents() => source.getAll();
}
