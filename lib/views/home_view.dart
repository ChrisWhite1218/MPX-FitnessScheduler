import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/home_VM.dart';
import '../views/class_details_view.dart';
import '../models/class_model.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final authVm = Provider.of<AuthViewModel>(context);
    final homeVm = Provider.of<HomeViewModel>(context);

    final user = authVm.userModel;

    // Load classes once when the view builds
    if (user != null && !homeVm.loading && homeVm.upcomingClasses.isEmpty) {
      homeVm.loadClasses(user);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authVm.signOut();
              Navigator.of(context).pushReplacementNamed("/login");
            },
          )
        ],
      ),
      body: homeVm.loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // -------- HEADER: profile + name + points ----------
                  Row(
                    children: [
                      // Profile photo placeholder
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.person, size: 40, color: Colors.black54),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user?.displayName ?? "User",
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Points: ${user?.points ?? 0}",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // -------- UPCOMING CLASSES ----------
                  const Text(
                    "Upcoming Classes",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2)
                        )
                      ],
                    ),
                    child: Column(
                      children: homeVm.upcomingClasses.map((c) {
                        return GestureDetector(
                          onLongPress: () {
                            if (user != null) {
                              homeVm.removeClassFromUser(c.id, user);
                            }
                          },
                          child: ListTile(
                            title: Text(c.name),
                            leading: const Icon(Icons.event),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ClassDetailsView(classModel: c),
                                ),
                              );
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // -------- COMPLETED CLASSES ----------
                  const Text(
                    "Completed Classes",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2)
                        )
                      ],
                    ),
                    child: Column(
                      children: homeVm.completedClasses.map((c) {
                        return ListTile(
                          title: Text(c.name),
                          leading: const Icon(Icons.check_circle, color: Colors.green),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),

      // -------- BOTTOM BANNER ----------
      bottomSheet: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 18),
            textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () {
            // Navigate to the "Browse Classes" page
            Navigator.of(context).pushNamed("/browse-classes");
          },
          child: const Text("Browse Classes"),
        ),
      ),
    );
  }
}
