import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/class_model.dart';

class ClassService {
  final CollectionReference classesRef =
      FirebaseFirestore.instance.collection('classes');

  Stream<List<ClassModel>> getAllClasses() {
    return classesRef.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => ClassModel.fromMap(doc.data() as Map<String, dynamic>)).toList());
  }

  Future<void> enrollUser(String classId, String userId) async {
    final classDoc = classesRef.doc(classId);

    await classDoc.update({
      'attendees': FieldValue.arrayUnion([userId])
    });
  }
}
