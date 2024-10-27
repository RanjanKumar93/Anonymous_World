import 'package:anonymous_world/screen/chat.dart';
import 'package:anonymous_world/state/auth/auth_bloc.dart';
import 'package:anonymous_world/state/home/home_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  String searchQuery = ''; // Store the search query
  String? currentUserUid;

  @override
  void initState() {
    super.initState();
    // Fetch users when the page loads
    BlocProvider.of<HomeBloc>(context).add(HomeEventFetchUsers());

    // Get the current user's UID from FirebaseAuth
    currentUserUid = FirebaseAuth.instance.currentUser?.uid;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is HomeStateLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (state is HomeStateLoaded) {
          // Filter users by search query
          List<String> filteredUsers = state.users
              .where((user) =>
                  user.toLowerCase().contains(searchQuery.toLowerCase()))
              .toList();

          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Anonymous World',
                textAlign: TextAlign.left,
              ),
              // centerTitle: true,
              actions: [
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    if (state is AuthStateLoading) {
                      return const Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 45, 0),
                        child: CircularProgressIndicator(),
                      );
                    }
                    return ElevatedButton.icon(
                        onPressed: () {
                          BlocProvider.of<AuthBloc>(context)
                              .add(AuthEventLogout());
                        }, // Add logout functionality
                        icon: const Icon(Icons.logout),
                        label: const Text('Logout'));
                  },
                ),
              ],
            ),
            body: Column(
              children: [
                // Display Current User's UID
                if (currentUserUid != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Your UID: $currentUserUid',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                // Search Bar
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: 'Search User by UID',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (query) {
                      setState(() {
                        searchQuery = query; // Update search query
                      });
                    },
                  ),
                ),
                // User List
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredUsers.length,
                    itemBuilder: (context, index) {
                      return Card(
                          child: ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChatScreen(
                                      uid1: currentUserUid!,
                                      uid2: filteredUsers[index],
                                    )),
                          );
                        },
                        title: Text(filteredUsers[index]), // Display UID
                      ));
                    },
                  ),
                ),
              ],
            ),
          );
        } else if (state is HomeStateError) {
          return const Scaffold(
            body: Center(child: Text('Error loading users')),
          );
        }
        return const SizedBox();
      },
    );
  }
}
