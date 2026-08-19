import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:unicorn/service/api_service/api_worker.dart';
import '../../../../../../../translation/language_controller.dart';
import '../model/parent_listing/parent_listing_request.dart';
import '../model/parent_listing/parent_listing_response.dart';
import '../model/create_chat/create_chat_request.dart';
import '../model/teacher_chat_parent_listing/teacher_chat_parent_listing_request.dart';
import '../model/teacher_chat_parent_listing/teacher_chat_parent_listing_response.dart';

class TeacherController extends GetxController {
  final ApiWorker apiWorker = Get.put(ApiWorker());

  RxList<TeacherChatParentListing> parentList =
      <TeacherChatParentListing>[].obs;

  RxBool isLoading = false.obs;
  RxString creatingChatParentSlug = ''.obs;

  /// ================= Parent Listing =================
  Future<void> getParentListing(context, {String search = ""}) async {
    TeacherChatParentListingRequest request = TeacherChatParentListingRequest(
      lang: LanguageController.to.apiLanguage,
      search: search,
    );

    final response = await apiWorker.parentListing(request, context);

    if (response?.success == true) {
      parentList.value = response?.data?.data ?? [];
    }
  }

  /// ================= Create Chat =================
  // Future<void> createChat({
  //   required String parentSlug,
  //   required context,
  //   required String parentName,
  //   required String parentImage,
  //   required String teacherId,
  //   required String teacherName,
  //   required String teacherImage,
  // }) async {
  //
  //   CreateChatRequest request = CreateChatRequest(
  //     parentSlug: parentSlug,
  //     lang: LanguageController.to.apiLanguage,
  //   );
  //
  //   final response = await apiWorker.createChatApi(request, context);
  //
  //   if (response?.success == true) {
  //
  //     final data = response?.data;
  //
  //     String chatId = data?.chatId ?? "";
  //     String parentId = data?.parentId ?? "";
  //
  //     /// teacher token
  //     String? teacherToken = await FirebaseMessaging.instance.getToken();
  //
  //     /// parent token will update later when parent login
  //     String parentToken = "";
  //
  //     await FirebaseFirestore.instance.collection("chats").doc(chatId).set({
  //
  //       "chatId": chatId,
  //
  //       "createdAt": FieldValue.serverTimestamp(),
  //       "updatedAt": FieldValue.serverTimestamp(),
  //
  //       "lastMessage": "",
  //       "lastMessageTime": null,
  //       "lastMessageTimeMs": null,
  //       "lastSenderId": "",
  //
  //       /// nursery
  //       "nurseryId": data?.nurseryId,
  //       "nurseryName": '',
  //       "nurseryImage": '',
  //
  //       /// parent
  //       "parentId": parentId,
  //       "parentName": parentName,
  //       "parentImage": parentImage,
  //
  //       /// teacher
  //       "teacherId": teacherId,
  //       "teacherName": teacherName,
  //       "teacherImage": teacherImage,
  //
  //       /// super admin
  //       "superAdminId": '',
  //       "superAdminName": '',
  //       "superAdminImage": '',
  //
  //       /// participants (KEEP SAME STRUCTURE)
  //       "participants": [
  //         teacherId,
  //         parentId
  //       ],
  //
  //       /// NEW FIELD FOR PUSH
  //       "participantsTokens": {
  //         teacherId: teacherToken,
  //         parentId: parentToken
  //       },
  //
  //       "type": 4
  //     });
  //   }
  // }
  Future<void> createChat({
    required String parentSlug,
    required context,
    required String parentName,
    required String parentImage,
    required String teacherId,
    required String teacherName,
    required String teacherImage,
  }) async {
    creatingChatParentSlug.value = parentSlug;
    try {

      CreateChatRequest request = CreateChatRequest(
        parentSlug: parentSlug,
        lang: LanguageController.to.apiLanguage,
      );

      final response = await apiWorker.createChatApi(request, context);

      if (response?.success == true) {

        final data = response?.data;

        String parentId = data?.parentId ?? "";

      /// 🔹 Generate chatId
        String chatId = "${teacherId}_${parentId}";

      /// teacher token
        String? teacherToken = await FirebaseMessaging.instance.getToken();

      /// parent token (will update when parent login)
        String parentToken = "";

        final chatRef =
            FirebaseFirestore.instance.collection("chats").doc(chatId);

        /// check if chat already exists
        final doc = await chatRef.get();

        if (!doc.exists) {

          await chatRef.set({

          "chatId": chatId,

          "createdAt": FieldValue.serverTimestamp(),
          "updatedAt": FieldValue.serverTimestamp(),

          "lastMessage": "",
          "lastMessageTime": null,
          "lastMessageTimeMs": null,
          "lastSenderId": "",

          /// nursery
          "nurseryId": data?.nurseryId,
          "nurseryName": '',
          "nurseryImage": '',

          /// parent
          "parentId": parentId,
          "parentName": parentName,
          "parentImage": parentImage,

          /// teacher
          "teacherId": teacherId,
          "teacherName": teacherName,
          "teacherImage": teacherImage,

          /// super admin
          "superAdminId": '',
          "superAdminName": '',
          "superAdminImage": '',

          /// participants
          "participants": [
            teacherId,
            parentId
          ],

          /// tokens
          "participantsTokens": {
            teacherId: teacherToken,
            parentId: parentToken
          },

          "type": 4
          });
        }
      }
    } finally {
      creatingChatParentSlug.value = '';
    }
  }
}
