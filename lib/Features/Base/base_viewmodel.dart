import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:idealize_new_version/Core/Constants/config.dart';
import 'package:idealize_new_version/Core/Constants/routes.dart';
import 'package:idealize_new_version/Features/Base/base_model.dart';
import 'package:idealize_new_version/Features/Base/domain/entity/chat_entity.dart';
import 'package:idealize_new_version/app_repo.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

class BaseViewModel extends GetxController {
  late BaseModel _model;

  IO.Socket? socket;
  bool isConnect = false;

  RxBool aiIsResponding = false.obs;
  RxList<ChatEntity> chats = RxList<ChatEntity>([
    ChatEntity(text: 'Hi! how can I help you?', isMe: false),
  ]);

  final messageCtrl = TextEditingController();
  final scrollCtrl = ScrollController();

  BaseViewModel() {
    _model = BaseModel();
  }

  BaseModel get model => _model;

  void updateNavigationIndex(int index) {
    _model.updateNavigationIndex(index);
    update();
  }

  void openChatScreen() {
    Get.toNamed(AppRoutes().chatScreen);
  }

  void onTappedMoreButton() {
    // ignore: unused_result
    showModalActionSheet(
      context: Get.context!,
      actions: const [
        SheetAction(
          label: 'Clear Chat',
          isDestructiveAction: true,
          key: Key('clearChat'),
        ),
      ],
      isDismissible: true,
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          if (result == const Key('clearChat')) {
            chats.clear();
            chats.add(ChatEntity(text: 'Hi! how can I help you?', isMe: false));
          }
        }
      },
    );
  }

  void onTappedSendMessage() {
    if (messageCtrl.text.isNotEmpty) {
      debugPrint('Sending message: "${messageCtrl.text}"');
      chats.add(ChatEntity(text: messageCtrl.text, isMe: true));

      socket?.emit("sendMessage", {
        "message": messageCtrl.text,
      });

      messageCtrl.clear();
      aiIsResponding.value = true;

      scrollCtrl.animateTo(scrollCtrl.position.maxScrollExtent + 100,
          duration: const Duration(milliseconds: 300), curve: Curves.ease);
    }
  }

  Future<void> connectSocket() async {
    debugPrint('Connect to socket...');
    try {
      socket?.disconnect();
      socket = null;
      socket = IO.io(
          AppConfig().chatBotServer,
          OptionBuilder()
              .setTransports(["websocket"])
              .disableAutoConnect()
              .enableForceNew()
              .setExtraHeaders(
                  {'authorization': 'Bearer ${AppRepo().jwtToken}'})
              .build());

      socket?.on("unauthorized", (data) {
        isConnect = false;
      });

      socket?.on("error", (data) {
        // print('error: $data');
        debugPrint('Socket Error: $data');
        chats.add(ChatEntity(text: data, isMe: false));
        aiIsResponding.value = false;
      });

      socket?.on("receiveMessage", (data) {
        // print('receiveMessage: $data["message"]');
        debugPrint('Receive message: ${data["message"]}');
        chats.add(ChatEntity(text: data['message']['message'], isMe: false));
        if (data['message']['projects'] != null &&
            data['message']['projects'].isNotEmpty) {
          chats.add(ChatEntity(
              text: '', projects: data['message']['projects'], isMe: false));
        } else if (data['message']['users'] != null &&
            data['message']['users'].isNotEmpty) {
          chats.add(ChatEntity(
              text: '', users: data['message']['users'], isMe: false));
        }
        aiIsResponding.value = false;

        scrollCtrl.animateTo(scrollCtrl.position.maxScrollExtent + 100,
            duration: const Duration(milliseconds: 300), curve: Curves.ease);
      });

      socket?.onConnect((data) {
        debugPrint("connect");
        debugPrint('WebSocket Connected: ${socket?.id}');
        isConnect = true;
      });
      socket?.onDisconnect((data) {
        debugPrint("disconnect");
        debugPrint('WebSocket Disconnected');
        isConnect = false;
      });

      socket?.connect();
    } catch (x) {
      debugPrint('$x');
    }
  }

  // @override
  // void onReady() {
  //   super.onReady();
  //   // print('\n\n-------------');
  //   // debugPrint('token: ${AppRepo().jwtToken}');
  //   // debugPrint('refreshToken: ${AppRepo().jwtRefreshToken}');
  //   // print('-------------\n\n');
  // }
}
