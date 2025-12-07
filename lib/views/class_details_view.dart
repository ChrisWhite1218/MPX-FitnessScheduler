import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/class_model.dart';
import '../viewmodels/home_VM.dart';
import '../viewmodels/auth_viewmodel.dart';

class ClassDetailsView extends StatefulWidget {
  final ClassModel classModel;

  const ClassDetailsView({super.key, required this.classModel});

  @override
  State<ClassDetailsView> createState() => _ClassDetailsViewState();
}

class _ClassDetailsViewState extends State<ClassDetailsView> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final homeVm = Provider.of<HomeViewModel>(context);
    final authVm = Provider.of<AuthViewModel>(context, listen: false);
    final user = authVm.userModel;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text("User not logged in")),
      );
    }

    final formattedTime =
        DateFormat('EEEE, MMM d • h:mm a').format(widget.classModel.time);

    return Scaffold(
      appBar: AppBar(title: Text(widget.classModel.name)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.classModel.name,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "Instructor: ${widget.classModel.instructor}",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              "Time: $formattedTime",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              "Points: ${widget.classModel.points}",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              widget.classModel.description,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Text(
              "Capacity: ${widget.classModel.capacity}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: () async {
                      setState(() => isLoading = true);
                      try {
                        final user = Provider.of<AuthViewModel>(
                                context,
                                listen: false)
                            .userModel;
                        if (user == null) return;

                        final homeVm = Provider.of<HomeViewModel>(
                                context,
                                listen: false);

                        if (widget.classModel.attendees.contains(user.uid)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Already signed up')),
                          );
                        } else {
                          await homeVm.toggleEnrollment(
                              widget.classModel, user);
                            
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Signed up for class')),
                          );
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: $e')),
                        );
                      } finally {
                        setState(() => isLoading = false);
                      }
                    },
                    child: const Text('Sign Up'),
                  ),
          ],
        ),
      ),
    );
  }
}
