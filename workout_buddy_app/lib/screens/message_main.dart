import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'chat.dart';
import 'package:workout_buddy_app/services/style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({Key? key}) : super(key: key);

  void _handlePressed(types.User otherUser, BuildContext context) async {
    final room = await FirebaseChatCore.instance.createRoom(otherUser);

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChatPage(room: room, otheruser: otherUser),
      ),
    );
  }

  Future<DocumentSnapshot> getUser() {
    return FirebaseFirestore.instance
        .collection("appusers")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
  }

  Widget _buildAvatar(types.User user) {
    final color = getButtonColor();
    final hasImage = user.imageUrl != null;
    final name = user.firstName;

    return Container(
      margin: const EdgeInsets.only(right: 16),
      child: CircleAvatar(
        backgroundColor: hasImage ? Colors.transparent : color,
        backgroundImage: hasImage ? NetworkImage(user.imageUrl!) : null,
        radius: 20,
        child: !hasImage
            ? Text(
                name!.isEmpty ? '' : name[0].toUpperCase(),
                style: const TextStyle(color: Colors.white),
              )
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        title: const Text('Users'),
      ),
      body: StreamBuilder<List<types.User>>(
        stream: FirebaseChatCore.instance.users(),
        initialData: const [],
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(
                bottom: 200,
              ),
              child: const Text('No users'),
            );
          }

          return FutureBuilder(
            future: getUser(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> usersnapshot) {
              if (usersnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: SpinKitWave(
                    color: getButtonTextColor(),
                    size: 50.0,
                  ),
                );
              } else {
                List friendslist = usersnapshot.data!.get("Friends");
                if (friendslist.isEmpty) {
                  return const Text("No Friends");
                }
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final user = snapshot.data![index];
                    if (user.id != FirebaseAuth.instance.currentUser?.uid &&
                        friendslist.contains(user.firstName)) {
                      return GestureDetector(
                        onTap: () {
                          _handlePressed(user, context);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: Row(
                            children: [
                              _buildAvatar(user),
                              Text(user.firstName!),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                );
              }
            },
          );
        },
      ),
    );
  }
}
