import 'package:flutter/material.dart';
import 'package:messaging_app/commons/MyDrawer.dart';
import 'package:messaging_app/screens/ChatPage.dart';
import 'package:messaging_app/services/auth/auth_services.dart';
import 'package:messaging_app/services/chat/chat_services.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final ChatServices chatServices = ChatServices();
  final AuthServices authServices = AuthServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      drawer: const MyDrawer(),
      body: _userListBuild(),
    );
  }

  Widget _userListBuild() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: chatServices.getUsersStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print('Error: ${snapshot.error}');
          return const Center(child: Text("Error"));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          print('Loading...');
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          print('User data loaded: ${snapshot.data}');
          return ListView.separated(
            itemCount: snapshot.data!.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              color: Theme.of(context).colorScheme.secondary,
            ),
            itemBuilder: (context, index) {
              final userData = snapshot.data![index];
              return _userItemBuild(userData, context);
            },
          );
        } else {
          print('No users found');
          return const Center(child: Text("No users found"));
        }
      },
    );
  }

  Widget _userItemBuild(Map<String, dynamic> userData, BuildContext context) {
    String? name = userData['name'] as String?;
    String? uid = userData['uId'] as String?;
    String? email = userData['email'] as String?;

    print('User item: name=$name, uid=$uid, email=$email'); // Debug print

    if (name != null &&
        uid != null &&
        email != null &&
        email != authServices.getCurrentUser()!.email) {
      return ListTile(
        title: Text(
          name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        subtitle: Text(email),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                emailReciver: name,
                receivedId: uid,
              ),
            ),
          );
        },
      );
    } else {
      return Container();
    }
  }
}
