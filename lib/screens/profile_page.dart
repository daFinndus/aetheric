import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

// TODO: Finish this stuff here
class _ProfilePageState extends State<ProfilePage> {
  late String uid = _auth.currentUser!.uid;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final CollectionReference _userColl = _firestore.collection('users');
  late final DocumentReference _userDoc = _userColl.doc(uid);

  late final userStream = _userDoc.snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          StreamBuilder(
            stream: _userColl.doc(uid).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.data != null) {
                if (snapshot.hasData) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return const Center(child: Icon(Icons.error));
                  } else {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: _buildProfileColumn(snapshot.data!),
                    );
                  }
                }
              }
              return const CircularProgressIndicator();
            },
          ),
        ],
      ),
    );
  }

  _buildProfileColumn(DocumentSnapshot snapshot) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 64.0,
          child: snapshot['technical_data']['imageUrl'].isNotEmpty
              ? ClipOval(
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: snapshot['technical_data']['imageUrl'],
                    width: 128.0,
                    height: 128.0,
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                  ),
                )
              : const Icon(Icons.person),
        ),
      ],
    );
  }
}
