import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/home_VM.dart';
import '../views/class_details_view.dart';
import '../models/class_model.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_initialized) {
      final authVm = Provider.of<AuthViewModel>(context, listen: false);
      final homeVm = Provider.of<HomeViewModel>(context, listen: false);

      final user = authVm.userModel;

      if (user != null) {
        homeVm.loadClasses(user); 
      }

      _initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final authVm = Provider.of<AuthViewModel>(context);
    final homeVm = Provider.of<HomeViewModel>(context);
    final user = authVm.userModel;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          Semantics(
            label: 'Logout button',
            button: true,
            child: IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                await authVm.signOut();
                Navigator.of(context).pushReplacementNamed("/login");
              },
            ),
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
                  Row(
                    children: [
                      Semantics(
                        label: 'User avatar',
                        child: Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.person, size: 40, color: Colors.black54),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Semantics(
                            label: 'User display name',
                            child: Text(
                              user?.displayName ?? "User",
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Semantics(
                    header: true,
                    child: const Text(
                      "Upcoming Classes",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: homeVm.upcomingClasses.isEmpty
                        ? Semantics(
                            label: 'No upcoming classes',
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "None",
                                style: TextStyle(fontSize: 16, color: Colors.black54),
                              ),
                            ),
                          )
                        : Column(
                            children: homeVm.upcomingClasses.map((c) {
                              return Semantics(
                                label: 'Upcoming class ${c.name}',
                                hint: 'Tap to view details, long press to remove',
                                button: true,
                                child: GestureDetector(
                                  onLongPress: () {
                                    if (user != null) homeVm.removeClassFromUser(c.id, user);
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
                                ),
                              );
                            }).toList(),
                          ),
                  ),
                  const SizedBox(height: 32),
                  Semantics(
                    header: true,
                    child: const Text(
                      "Completed Classes",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: homeVm.completedClasses.isEmpty
                        ? Semantics(
                            label: 'No completed classes',
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "None",
                                style: TextStyle(fontSize: 16, color: Colors.black54),
                              ),
                            ),
                          )
                        : Column(
                            children: homeVm.completedClasses.map((c) {
                              return Semantics(
                                label: 'Completed class ${c.name}',
                                child: ListTile(
                                  title: Text(c.name),
                                  leading: const Icon(Icons.check_circle, color: Colors.green),
                                ),
                              );
                            }).toList(),
                          ),
                  ),
                ],
              ),
            ),
      bottomSheet: Semantics(
        label: 'Browse Classes button',
        button: true,
        child: Container(
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
              Navigator.of(context).pushNamed("/browse-classes");
            },
            child: const Text("Browse Classes"),
          ),
        ),
      ),
    );
  }
}
