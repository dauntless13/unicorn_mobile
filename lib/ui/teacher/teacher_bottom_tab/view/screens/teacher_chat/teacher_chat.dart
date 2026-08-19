import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:unicorn/core/widget/profile_avatar.dart';
import 'package:unicorn/ui/teacher/teacher_bottom_tab/view/screens/teacher_chat/techer_message_screen.dart';
import 'package:unicorn/core/widget/empty_state.dart';

import '../../../../../../service/session/session_helper.dart';
import '../../../../../common_screens/chat/view/message_screen.dart';
import 'controller/teacher_controller.dart';

class TeacherChat extends StatefulWidget {
  TeacherChat({super.key});

  @override
  State<TeacherChat> createState() => _TeacherChatState();
}

class _TeacherChatState extends State<TeacherChat> {
  TextEditingController _searchController = TextEditingController();
  String searchText = "";
  bool isLight(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light;

  // ── Fetch all chats where teacher is a participant ─────────────────────
  Stream<QuerySnapshot> getTeacherChats(String teacherId) {
    return FirebaseFirestore.instance
        .collection("chats")
        .where("participants", arrayContains: teacherId)
        .orderBy("lastMessageTimeMs", descending: true)
        .snapshots();
  }

  String getChatTypeTitle(int type) {
    switch (type) {
      case 1: return "Super Admin with Nursery".tr;
      case 2: return "Nursery with Teacher".tr;
      case 3: return "Nursery with Parent".tr;
      case 4: return "Parent with Teacher".tr;
      case 5: return "Nursery Group".tr;
      case 6: return "Teacher Group".tr;
      case 7: return "Parent Group".tr;
      default: return "Chats".tr;
    }
  }

  // ── Returns the OTHER participant's info depending on chat type ────────
  Map<String, String> _resolveReceiver({
    required Map<String, dynamic> data,
    required int type,
    required String currentUserId,
  }) {
    // GROUP chats → no single receiver, use group details
    if (type == 5 || type == 6 || type == 7) {
      return {
        "receiverId": "",
        "receiverName": data["groupName"] ?? "Group",
        "receiverImage": data["groupImage"] ?? "",
        "fcmToken": "",
      };
    }

    // For type 4 (Parent ↔ Teacher): teacher's receiver = parent
    // For type 2/3 (Nursery chats): if current user is teacher, receiver = nursery/parent
    // General rule: find who in participants is NOT the current user
    final participants = List<String>.from(data["participants"] ?? []);
    final receiverId =
    participants.firstWhere((id) => id != currentUserId, orElse: () => "");

    // Determine receiver's name/image by matching receiverId to known fields
    String receiverName = "";
    String receiverImage = "";

    if (receiverId == data["parentId"]) {
      receiverName = data["parentName"] ?? "";
      receiverImage = data["parentImage"] ?? "";
    } else if (receiverId == data["teacherId"]) {
      receiverName = data["teacherName"] ?? "";
      receiverImage = data["teacherImage"] ?? "";
    } else if (receiverId == data["nurseryId"]) {
      receiverName = data["nurseryName"] ?? "";
      receiverImage = data["nurseryImage"] ?? "";
    } else if (receiverId == data["superAdminId"]) {
      receiverName = data["superAdminName"] ?? "";
      receiverImage = data["superAdminImage"] ?? "";
    }

    // FCM token lives inside participantsTokens map
    final tokens = (data["participantsTokens"] as Map<String, dynamic>?) ?? {};
    final fcmToken = tokens[receiverId]?.toString() ?? "";

    return {
      "receiverId": receiverId,
      "receiverName": receiverName,
      "receiverImage": receiverImage,
      "fcmToken": fcmToken,
    };
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {

      loadTeacherData();
    });
  }

  String? teacherId;
  String? teacherName;
  String? teacherImage;

  void loadTeacherData() async {
    final loginResponse = await SessionHelper().getLoginResponse();
    setState(() {
      teacherId = loginResponse?.data?.user?.id;
      teacherName =
          '${loginResponse?.data?.user?.firstName} ${loginResponse?.data?.user?.lastName}'
              .trim();
      teacherImage = loginResponse?.data?.user?.profileLink;
    });
  }

  Future<void> saveUserFCM(String userId) async {
    String? token = await FirebaseMessaging.instance.getToken();
    await FirebaseFirestore.instance.collection("users").doc(userId).set({
      "fcmToken": token,
    }, SetOptions(merge: true));
  }

  // ── Format lastMessageTime for display ────────────────────────────────
  String _formatLastTime(dynamic ts) {
    if (ts == null) return "";
    try {
      final DateTime dt;
      if (ts is Timestamp) {
        dt = ts.toDate();
      } else if (ts is int) {
        dt = DateTime.fromMillisecondsSinceEpoch(ts);
      } else if (ts is DateTime) {
        dt = ts;
      } else {
        return "";
      }
      final now = DateTime.now();
      if (dt.year == now.year &&
          dt.month == now.month &&
          dt.day == now.day) {
        final h = dt.hour > 12
            ? dt.hour - 12
            : dt.hour == 0
            ? 12
            : dt.hour;
        final amPm = dt.hour >= 12 ? 'PM' : 'AM';
        final m = dt.minute.toString().padLeft(2, '0');
        return "$h:$m $amPm";
      }
      return "${dt.day}/${dt.month}";
    } catch (_) {
      return "";
    }
  }

  final TeacherController controller = Get.put(TeacherController());

  Widget _topBar(BuildContext context) {
    final light = isLight(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: light ? Colors.white : const Color(0xFF1C1C1E),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: light
                      ? const Color(0xFFE8E8E8)
                      : const Color(0xFF2C2C2E),
                ),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    searchText = value.toLowerCase();
                  });
                },
                style: TextStyle(
                  color: light ? Colors.black87 : Colors.white,
                ),
                decoration: InputDecoration(
                  fillColor: light ? Colors.white : const Color(0xFF1C1C1E),
                  hintText: "search_hint".tr,
                  hintStyle: TextStyle(
                    color: light ? Colors.grey.shade600 : Colors.grey.shade400,
                  ),
                  border: InputBorder.none,
                  icon: Icon(
                    Icons.search_rounded,
                    size: 20,
                    color: light ? Colors.grey.shade600 : Colors.grey.shade400,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          _iconBox(
            context,
            Icons.add,
            onTap: () => showParentListBottomSheet(context),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final light = isLight(context);

    return Scaffold(
      backgroundColor:
      light ? const Color(0xFFF5F5F5) : const Color(0xFF0F0F0F),
      body: SafeArea(
        child: Column(
          children: [
            _topBar(context),
            Expanded(
              child: teacherId == null
                  ? const Center(child: CircularProgressIndicator())
                  : StreamBuilder<QuerySnapshot>(
                stream: getTeacherChats(teacherId!),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                        child: CircularProgressIndicator());
                  }

                  if (snapshot.data!.docs.isEmpty) {
                    return const Center(child: EmptyState());
                  }

                  final allChats = snapshot.data!.docs.toList();

                  final chats = allChats.where((chat) {
                    final data = chat.data() as Map<String, dynamic>;

                    final name = (data["groupName"] ??
                        data["parentName"] ??
                        data["teacherName"] ??
                        data["nurseryName"] ??
                        "")
                        .toString()
                        .toLowerCase();

                    final message = (data["lastMessage"] ?? "")
                        .toString()
                        .toLowerCase();

                    return name.contains(searchText) ||
                        message.contains(searchText);
                  }).toList();

                  // Group by type
                  Map<int, List<QueryDocumentSnapshot>> groupedChats = {};
                  for (var chat in chats) {
                    final data = chat.data() as Map<String, dynamic>;
                    int type = data["type"] ?? 0;
                    groupedChats.putIfAbsent(type, () => []).add(chat);
                  }
                  final light = isLight(context);
                  return ListView(
                    padding: const EdgeInsets.all(16),
                    children: groupedChats.entries.map((entry) {
                      int type = entry.key;
                      List<QueryDocumentSnapshot> typeChats =
                          entry.value;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                            const EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              getChatTypeTitle(type),
                              style:   TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color:light ? Colors.black : Colors.white
                              ),
                            ),
                          ),
                          ...typeChats.map((chat) {
                            final data =
                            chat.data() as Map<String, dynamic>;

                            // ── Display name / image ──────────────
                            String displayName;
                            String displayImage;
                            if (type == 5 || type == 6 || type == 7) {
                              displayName =
                                  data["groupName"] ?? "Group";
                              displayImage =
                                  data["groupImage"] ?? "";
                            } else {
                              // For personal chats, show the OTHER user
                              final receiver = _resolveReceiver(
                                data: data,
                                type: type,
                                currentUserId: teacherId!,
                              );
                              displayName =
                                  receiver["receiverName"] ?? "";
                              displayImage =
                                  receiver["receiverImage"] ?? "";
                            }

                            final lastMessage =
                                data["lastMessage"] ?? "";
                            final time = _formatLastTime(
                                data["lastMessageTime"] ??
                                    data["updatedAt"] ??
                                    data["lastMessageTimeMs"] ??
                                    data["updatedAtMs"]);

                            // ── Unread count for current teacher ──
                            final unreadMap = (data["unreadCount"]
                            as Map<String, dynamic>?) ??
                                {};
                            final unread =
                            (unreadMap[teacherId!] ?? 0) as int;

                            // ── Sent by me? ───────────────────────
                            final lastSenderId =
                                data["lastSenderId"] ?? "";
                            final hasCheck =
                                lastSenderId == teacherId;

                            // ── Receiver info for navigation ──────
                            final receiver = _resolveReceiver(
                              data: data,
                              type: type,
                              currentUserId: teacherId!,
                            );

                            return _chatTile(
                              context,
                              {
                                "chatId": chat.id,
                                "name": displayName,
                                "image": displayImage,
                                "message": lastMessage,
                                "time": time,
                                "unreadCount": unread,
                                "lastSenderId": data["lastSenderId"] ?? "",
                                "lastMessageStatus": data["lastMessageStatus"] ?? "sent",
                                // ── Navigation args ──────────────
                                "receiverId":
                                receiver["receiverId"] ?? "",
                                "receiverName":
                                receiver["receiverName"] ?? "",
                                "receiverImage":
                                receiver["receiverImage"] ?? "",
                                "fcmToken":
                                receiver["fcmToken"] ?? "",
                                "isOnline": false,
                                "type": type,
                              },
                            );
                          }).toList(),
                        ],
                      );
                    }).toList(),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _iconBox(BuildContext context, IconData icon, {VoidCallback? onTap}) {
    final light = isLight(context);

    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: light ? Colors.grey.shade300 : Colors.grey.shade700,
        ),
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(icon, size: 18,
            color: light ? Colors.black : Colors.white),
        onPressed: onTap,
      ),
    );
  }
  Widget _buildTickIcon(Map<String, dynamic> chat, String currentUserId) {
    final lastSenderId = chat['lastSenderId'] ?? '';

    debugPrint("━━━━━━━━━━━━━━━━━━━━━━━━━━");
    debugPrint("📩 CHAT DEBUG START");

    debugPrint("👤 Current User ID: $currentUserId");
    debugPrint("🧑 Last Sender ID: $lastSenderId");

    // 🔍 Check if message is mine
    if (lastSenderId != currentUserId) {
      debugPrint("❌ Not my message → No tick");
      debugPrint("━━━━━━━━━━━━━━━━━━━━━━━━━━");
      return const SizedBox();
    }

    debugPrint("✅ My message → show tick");

    final status = chat['lastMessageStatus'] ?? 'sent';

    debugPrint("📊 Last Message Status: $status");

    if (status == 'seen') {
      debugPrint("🔵 STATUS = SEEN (BLUE DOUBLE TICK)");
      debugPrint("━━━━━━━━━━━━━━━━━━━━━━━━━━");
      return const Icon(Icons.done_all, size: 16, color: Color(0xFF34B7F1));
    } else if (status == 'delivered') {
      debugPrint("⚪ STATUS = DELIVERED (GREY DOUBLE TICK)");
      debugPrint("━━━━━━━━━━━━━━━━━━━━━━━━━━");
      return const Icon(Icons.done_all, size: 16, color: Colors.grey);
    } else {
      debugPrint("✓ STATUS = SENT (SINGLE TICK)");
      debugPrint("━━━━━━━━━━━━━━━━━━━━━━━━━━");
      return const Icon(Icons.check, size: 16, color: Colors.grey);
    }
  }
  // ================= CHAT TILE =================
  Widget _chatTile(BuildContext context, Map<String, dynamic> chat) {
    final light = isLight(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          extentRatio: 0.22,
          children: [
            SlidableAction(
              onPressed: (_) {},
              backgroundColor:
              light ? const Color(0xFFFFE5E5) : const Color(0xFF3A1E1E),
              foregroundColor: Colors.red,
              icon: Icons.delete_outline,
              borderRadius: BorderRadius.circular(14),
            ),
          ],
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Get.to(
                  () => const AllMessageScreen(),
              arguments: {
                "chatId": chat["chatId"] ?? "",
                "receiverId": chat["receiverId"] ?? "",
                "receiverName": chat["receiverName"] ?? chat["name"] ?? "",
                "receiverImage":
                chat["receiverImage"] ?? chat["image"] ?? "",
                "fcmToken": chat["fcmToken"] ?? "",
                "isOnline": chat["isOnline"] ?? false,
                "chatType": chat["type"] ?? 0,
              },
            )?.then((value) {
              _buildTickIcon(chat, teacherId!);
            },);
          },
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: light ? Colors.white : const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                ProfileAvatar(
                  radius: 26,
                  imageUrl: chat['image'],
                  backgroundColor: Colors.grey.shade300,
                  iconColor: Colors.white,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              chat['name'] ?? "",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color:
                                light ? Colors.black87 : Colors.white,
                              ),
                            ),
                          ),
                          Text(
                            chat['time'] ?? "",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          _buildTickIcon(chat, teacherId!),
                          Expanded(
                            child: Text(
                              chat['message'] ?? "",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 14, color: Colors.grey[500]),
                            ),
                          ),
                          if ((chat['unreadCount'] ?? 0) > 0)
                            Container(
                              margin: const EdgeInsets.only(left: 10),
                              width: 22,
                              height: 22,
                              decoration: const BoxDecoration(
                                color: Color(0xFF4A5BF6),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  chat['unreadCount'].toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showParentListBottomSheet(BuildContext context) async {
    await controller.getParentListing(context);

    final light = Theme.of(context).brightness == Brightness.light;
    final searchController = TextEditingController();

    // ── Tokens ──────────────────────────────────────────────────
    const primary      = Color(0xFF2D5A8E);
    const primaryLight = Color(0xFF4A90D9);
    const accent       = Color(0xFFFFAA00);
    const successGreen = Color(0xFF27AE60);

    final bgColor      = light ? Colors.white           : const Color(0xFF0F0F12);
    final surfaceColor = light ? const Color(0xFFF4F6FA) : const Color(0xFF1A1A20);
    final borderColor  = light ? const Color(0xFFE8ECF2) : const Color(0xFF2A2A35);
    final txtPrimary   = light ? const Color(0xFF1B2C45) : Colors.white;
    final txtMuted     = light ? const Color(0xFF7A8BA6) : const Color(0xFF5A6A80);
    // ────────────────────────────────────────────────────────────

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return DraggableScrollableSheet(
          initialChildSize: 0.78,
          minChildSize: 0.45,
          maxChildSize: 0.95,
          expand: false,
          builder: (_, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius:
                const BorderRadius.vertical(top: Radius.circular(28)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(light ? 0.12 : 0.4),
                    blurRadius: 40,
                    offset: const Offset(0, -6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // ── Drag handle ──────────────────────────────
                  Padding(
                    padding: const EdgeInsets.only(top: 12, bottom: 0),
                    child: Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: borderColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),

                  // ── Header ───────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
                    child: Row(
                      children: [
                        // Icon badge
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [primary, primaryLight],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.person_add_alt_1_rounded,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'New Conversation'.tr,
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: txtPrimary,
                                letterSpacing: -0.3,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Select a parent to start chatting'.tr,
                              style: TextStyle(
                                fontSize: 12,
                                color: txtMuted,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            width: 34,
                            height: 34,
                            decoration: BoxDecoration(
                              color: surfaceColor,
                              shape: BoxShape.circle,
                              border: Border.all(color: borderColor),
                            ),
                            child: Icon(
                              Icons.close_rounded,
                              size: 16,
                              color: txtMuted,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ── Search bar ───────────────────────────────
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 18, 16, 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: surfaceColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: borderColor),
                      ),
                      child: TextField(
                        controller: searchController,
                        onChanged: (v) =>
                            controller.getParentListing(context, search: v),
                        style: TextStyle(
                          fontSize: 14,
                          color: txtPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Search by name...'.tr,
                          hintStyle:
                          TextStyle(fontSize: 14, color: txtMuted),
                          prefixIcon:
                          Icon(Icons.search_rounded, size: 20, color: txtMuted),
                          filled: false,
                          contentPadding:
                          const EdgeInsets.symmetric(vertical: 14),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),

                  // ── Divider + count row ───────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(children: [
                      Obx(() => Text(
                        "${controller.parentList.length} Parents",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: txtMuted,
                          letterSpacing: 0.4,
                        ),
                      )),
                    ]),
                  ),
                  const SizedBox(height: 8),
                  Divider(height: 1, color: borderColor),

                  // ── List ─────────────────────────────────────
                  Expanded(
                    child: Obx(() {
                      if (controller.parentList.isEmpty) {
                        return const Center(child: EmptyState());
                      }

                      return ListView.separated(
                        controller: scrollController,
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 12),
                        itemCount: controller.parentList.length,
                        separatorBuilder: (_, __) => Divider(
                          height: 1,
                          indent: 72,
                          color: borderColor,
                        ),
                        itemBuilder: (context, index) {
                          final parent = controller.parentList[index];
                          final name =
                          "${parent.firstName ?? ''} ${parent.lastName ?? ''}"
                              .trim();
                          final initials = _initials(
                              parent.firstName ?? "",
                              parent.lastName ?? "");
                          final color = _avatarColor(initials);
                          final hasPhoto =
                              (parent.profileLink ?? "").isNotEmpty;

                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4, vertical: 6),
                            child: Row(
                              children: [
                                // ── Avatar ──────────────────────
                                Stack(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(2),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: color.withOpacity(0.35),
                                            width: 2),
                                      ),
                                      child: ProfileAvatar(
                                        radius: 22,
                                        imageUrl: parent.profileLink,
                                        backgroundColor: color,
                                        iconColor: Colors.white,
                                        iconSize: 18,
                                      ),
                                    ),
                                    // online dot
                                    Positioned(
                                      bottom: 2,
                                      right: 2,
                                      child: Container(
                                        width: 10,
                                        height: 10,
                                        decoration: BoxDecoration(
                                          color: successGreen,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: bgColor, width: 1.5),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(width: 13),

                                // ── Name ────────────────────────
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        name.isEmpty ? "Unknown" : name,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: txtPrimary,
                                        ),
                                      ),
                                      if ((parent.email ?? "").isNotEmpty) ...[
                                        const SizedBox(height: 2),
                                        Text(
                                          parent.email!,
                                          style: TextStyle(
                                              fontSize: 11, color: txtMuted),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ],
                                  ),
                                ),

                                const SizedBox(width: 10),

                                // ── Chat button ─────────────────
                                GestureDetector(
                                  onTap: controller.creatingChatParentSlug.value ==
                                          (parent.parentSlug ?? "")
                                      ? null
                                      : () async {
                                    await controller.createChat(
                                      parentSlug:
                                      parent.parentSlug ?? "",
                                      context: context,
                                      parentImage:
                                      parent.profileLink ?? "",
                                      parentName:
                                      '${parent.firstName} ${parent.lastName}',
                                      teacherId: teacherId ?? "",
                                      teacherName: teacherName ?? "",
                                      teacherImage: teacherImage ?? "",
                                    );
                                    if (context.mounted) {
                                      Navigator.pop(context);
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [primary, primaryLight],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius:
                                      BorderRadius.circular(22),
                                      boxShadow: [
                                        BoxShadow(
                                          color:
                                          primary.withOpacity(0.28),
                                          blurRadius: 8,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        if (controller.creatingChatParentSlug.value ==
                                            (parent.parentSlug ?? ""))
                                          const SizedBox(
                                            width: 14,
                                            height: 14,
                                            child: CircularProgressIndicator(),
                                          )
                                        else
                                          const Icon(
                                            Icons.chat_bubble_rounded,
                                            color: Colors.white,
                                            size: 13,
                                          ),
                                        const SizedBox(width: 5),
                                        Flexible(
                                          child: Text(
                                            controller.creatingChatParentSlug.value ==
                                                    (parent.parentSlug ?? "")
                                                ? "Loading...".tr
                                                : "Chat".tr,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700,
                                              letterSpacing: 0.2,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  String _initials(String first, String last) {
    final f = first.isNotEmpty ? first[0].toUpperCase() : '';
    final l = last.isNotEmpty ? last[0].toUpperCase() : '';
    return '$f$l';
  }

  Color _avatarColor(String initials) {
    const colors = [
      Color(0xFF5B6EF5),
      Color(0xFF7C3FE4),
      Color(0xFF34C759),
      Color(0xFFFF9F0A),
      Color(0xFFFF3B30),
      Color(0xFF30B0C7),
    ];
    final idx =
    initials.isNotEmpty ? initials.codeUnitAt(0) % colors.length : 0;
    return colors[idx];
  }
}
