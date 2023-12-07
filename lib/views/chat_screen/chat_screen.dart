import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_tutorial/consts/consts.dart';
import 'package:firebase_tutorial/controller/chat_controller.dart';
import 'package:firebase_tutorial/services/firestore_services.dart';
import 'package:firebase_tutorial/views/chat_screen/components/sender_bubble.dart';
import 'package:firebase_tutorial/views/widgets_common/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ChatController());

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: "${controller.friendName}"
            .text
            .fontFamily(semibold)
            .color(darkFontGrey)
            .make(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Obx(
              () => controller.isLoading.value
                  ? Center(child: loadingIndicator())
                  : Expanded(
                      /// Tạo danh sách senderBubble
                      child: StreamBuilder(
                        stream: FirestoreServices.getChatMessages(
                            controller.chatDocId.toString()),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                              child: loadingIndicator(),
                            );
                          } else if (snapshot.data!.docs.isEmpty) {
                            return Center(
                              child: "Gửi tin nhắn..."
                                  .text
                                  .color(darkFontGrey)
                                  .make(),
                            );
                          } else {
                            return ListView(
                              children: snapshot.data!.docs
                                  .mapIndexed((currentValue, index) {
                                var data = snapshot.data!.docs[index];
                                return Align(
                                    alignment: data['uid'] == currentUser!.uid
                                        ? Alignment.centerRight
                                        : Alignment.centerLeft,
                                    child: senderBubble(data));
                              }).toList(),
                            );
                          }
                        },
                      ),
                    ),
            ),
            10.heightBox,

            /// Phần "Nhập và Gửi tin nhắn"
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: controller.msgController,
                    decoration: const InputDecoration(
                      /// border
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: textfieldGrey,
                        ),
                      ),

                      /// focused border
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: textfieldGrey,
                        ),
                      ),

                      /// hintText
                      hintText: "Viết tin nhắn ...",
                    ),
                  ),
                ),

                /// Icon gửi tin nhắn
                IconButton(
                    onPressed: () {
                      controller.sendMsg(controller.msgController.text);
                      controller.msgController.clear();
                    },
                    icon: const Icon(
                      Icons.send,
                      color: redColor,
                    ))
              ],
            )
                .box
                .height(80)
                .padding(const EdgeInsets.all(12))
                .margin(const EdgeInsets.only(bottom: 8))
                .make(),
          ],
        ),
      ),
    );
  }
}
