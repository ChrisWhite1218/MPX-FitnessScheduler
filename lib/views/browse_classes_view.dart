import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/class_model.dart';
import '../viewmodels/home_VM.dart';
import 'class_details_view.dart';

class BrowseClassesView extends StatelessWidget {
  const BrowseClassesView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<HomeViewModel>(context);

    return Scaffold(
      backgroundColor: const Color.fromRGBO(219, 238, 255, 1),
      appBar: AppBar(
        title: const Text("Browse Classes"),
        backgroundColor: const Color.fromRGBO(255, 184, 28, 1),
      ),
      body: vm.allClasses.isEmpty
          ? Center(
              child: Semantics(
                label: "No classes available",
                child: Text("No classes available"),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: vm.allClasses.length,
              itemBuilder: (context, index) {
                ClassModel c = vm.allClasses[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      )
                    ],
                  ),
                  child: Semantics(
                    label:
                        "${c.name}, Instructor: ${c.instructor}, Capacity: ${c.capacity} spots, Difficulty: ${c.points} points",
                    button: true,
                    child: ListTile(
                      title: Text(c.name,
                          style:
                              const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text("${c.instructor} - ${c.capacity} spots"),
                      trailing: Text("${c.points} pts",
                          style: const TextStyle(color: Colors.green)),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ClassDetailsView(classModel: c),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
