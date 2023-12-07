import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_tutorial/consts/consts.dart';
import 'package:firebase_tutorial/services/firestore_services.dart';
import 'package:firebase_tutorial/views/widgets_common/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: "Tin nhắn".text.color(darkFontGrey).fontFamily(semibold).make(),
      ),
      body: StreamBuilder(
        stream: FirestoreServices.getAllMessages(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: loadingIndicator(),
            );
          } else if (snapshot.data!.docs.isEmpty) {
            return Center(
              child:
                  "Chưa có tin nhắn!".text.color(darkFontGrey).makeCentered(),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
