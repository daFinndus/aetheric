import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:aetheric/services/chat/elements/contact_page.dart';

// This is the tile displayed for each contact in the chat page
class ContactTile extends StatefulWidget {
  final String receiverUid;
  final String chatId;

  const ContactTile({
    super.key,
    required this.receiverUid,
    required this.chatId,
  });

  @override
  State<ContactTile> createState() => _ContactTileState();
}

class _ContactTileState extends State<ContactTile> {
  String receiverUsername = '';
  String receiverImageUrl = '';

  String lastMessage = '';
  DateTime timeMessage = DateTime(1970, 1, 1);

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final CollectionReference _userColl = _firestore.collection('users');

  @override
  void initState() {
    super.initState();

    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => _routeContactPage(context),
      leading: CircleAvatar(
        radius: 24.0,
        child: receiverImageUrl.isNotEmpty
            ? ClipOval(
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: receiverImageUrl,
                  width: 48.0,
                  height: 48.0,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(
                    Icons.error,
                  ),
                ),
              )
            : const Icon(Icons.person),
      ),
      title: Text(
        receiverUsername,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(lastMessage == '' ? 'No messages yet' : lastMessage),
      trailing: SizedBox(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              lastMessage == ''
                  ? ''
                  : '${timeMessage.hour < 10 ? '0' : ''}${timeMessage.hour}:${timeMessage.minute < 10 ? '0' : ''}${timeMessage.minute}',
              style: const TextStyle(fontSize: 12.0),
            ),
          ],
        ),
      ),
    );
  }

  // Function for retrieving the data of the receiver
  _getData() async {
    final DocumentSnapshot data = await _userColl.doc(widget.receiverUid).get();

    if (data.exists) {
      setState(() {
        receiverUsername = data.get('personal_data')['username'];
        receiverImageUrl = data.get('personal_data')['imageUrl'];
      });
    }
  }

  // This function seems to work 50/50
  // It does redirect but when hitting the go backwards arrow, it directs to the wrong page
  _routeContactPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ContactPage(
          receiverUid: widget.receiverUid,
          chatId: widget.chatId,
        ),
      ),
    );
  }
}
