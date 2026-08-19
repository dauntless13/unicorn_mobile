import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:unicorn/core/widget/empty_state.dart';
import 'package:unicorn/core/widget/profile_avatar.dart';
import '../../../../service/session/session_helper.dart';
import 'message_screen.dart';

class ParentChatScreen extends StatefulWidget {
  ParentChatScreen({super.key});

  @override
  State<ParentChatScreen> createState() => _ParentChatScreenState();
}

class _ParentChatScreenState extends State<ParentChatScreen> {
  TextEditingController _searchController = TextEditingController();
  String searchText = "";
  bool isLight(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light;

  String getChatTypeTitle(int type) {
    switch (type) {
      case 1: return "Super Admin with Nursery";
      case 2: return "Nursery with Teacher";
      case 3: return "Nursery with Parent";
      case 4: return "Parent with Teacher";
      case 5: return "Nursery Group";
      case 6: return "Teacher Group";
      case 7: return "Parent Group";
      default: return "Chats";
    }
  }

  Stream<QuerySnapshot> getChats() {
    if (parentId.isEmpty) return const Stream.empty();
    return FirebaseFirestore.instance
        .collection("chats")
        .where("participants", arrayContains: parentId)
        .orderBy("lastMessageTimeMs", descending: true)
        .snapshots();
  }

  @override
  void initState() {
    super.initState();
    loadParentData();
  }

  String parentId = '';

  void loadParentData() async {
    final loginResponse = await SessionHelper().getLoginResponse();
    setState(() {
      parentId = loginResponse?.data?.user?.id ?? '';
    });
  }

  // ── Returns the OTHER participant's info for a given chat ──────────────
  Map<String, String> _resolveReceiver({
    required Map<String, dynamic> data,
    required int type,
  }) {
    // GROUP chats
    if (type == 5 || type == 6 || type == 7) {
      return {
        "receiverId": "",
        "receiverName": data["groupName"] ?? "Group",
        "receiverImage": data["groupImage"] ?? "",
        "fcmToken": "",
      };
    }

    // Personal chats: find who in participants is NOT the current parent
    final participants = List<String>.from(data["participants"] ?? []);
    final receiverId =
    participants.firstWhere((id) => id != parentId, orElse: () => "");

    String receiverName = "";
    String receiverImage = "";

    if (receiverId == data["teacherId"]) {
      receiverName = data["teacherName"] ?? "";
      receiverImage = data["teacherImage"] ?? "";
    } else if (receiverId == data["nurseryId"]) {
      receiverName = data["nurseryName"] ?? "";
      receiverImage = data["nurseryImage"] ?? "";
    } else if (receiverId == data["superAdminId"]) {
      receiverName = data["superAdminName"] ?? "";
      receiverImage = data["superAdminImage"] ?? "";
    } else if (receiverId == data["parentId"]) {
      // Shouldn't happen for parent side, but safety fallback
      receiverName = data["parentName"] ?? "";
      receiverImage = data["parentImage"] ?? "";
    }

    // FCM token from participantsTokens map
    final tokens = (data["participantsTokens"] as Map<String, dynamic>?) ?? {};
    final fcmToken = tokens[receiverId]?.toString() ?? "";

    return {
      "receiverId": receiverId,
      "receiverName": receiverName,
      "receiverImage": receiverImage,
      "fcmToken": fcmToken,
    };
  }

  // ── Format lastMessageTime ─────────────────────────────────────────────
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

  @override
  Widget build(BuildContext context) {
    final light = isLight(context);

    return Scaffold(
      backgroundColor:
      light ? const Color(0xFFF5F5F5) : const Color(0xFF0F0F0F),
      body: SafeArea(
        child: Column(
          children: [
            _searchBar(context),
            Expanded(
              child: parentId.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : StreamBuilder<QuerySnapshot>(
                stream: getChats(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                        child: CircularProgressIndicator());
                  }

                  final allDocs = snapshot.data!.docs;

                  final docs = allDocs.where((doc) {
                    final data = doc.data() as Map<String, dynamic>;

                    final receiver = _resolveReceiver(
                      data: data,
                      type: data["type"] ?? 0,
                    );

                    String displayName;

                    if ((data["type"] ?? 0) == 5 ||
                        (data["type"] ?? 0) == 6 ||
                        (data["type"] ?? 0) == 7) {
                      displayName = (data["groupName"] ?? "").toString();
                    } else {
                      displayName = (receiver["receiverName"] ?? "").toString();
                    }

                    final name = displayName.toLowerCase();
                    final message = (data["lastMessage"] ?? "")
                        .toString()
                        .toLowerCase();

                    return name.contains(searchText) ||
                        message.contains(searchText);
                  }).toList();
                  if (docs.isEmpty) {
                    return const Center(child: EmptyState());
                  }

                  // Group by type
                  Map<int, List<QueryDocumentSnapshot>> groupedChats =
                  {};
                  for (var doc in docs) {
                    final data =
                    doc.data() as Map<String, dynamic>;
                    int type = data["type"] ?? 0;
                    groupedChats
                        .putIfAbsent(type, () => [])
                        .add(doc);
                  }

                  return ListView(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 12),
                    children: groupedChats.entries.map((entry) {
                      int type = entry.key;
                      List<QueryDocumentSnapshot> chats = entry.value;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10),
                            child: Text(
                              getChatTypeTitle(type),
                              style:   TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                  color:light ? Colors.black : Colors.white
                              ),
                            ),
                          ),
                          ...chats.map((doc) {
                            final data =
                            doc.data() as Map<String, dynamic>;

                            // ── Display name / image ────────────
                            final receiver = _resolveReceiver(
                              data: data,
                              type: type,
                            );

                            String displayName;
                            String displayImage;
                            if (type == 5 || type == 6 || type == 7) {
                              displayName =
                                  data["groupName"] ?? "Group";
                              displayImage =
                                  data["groupImage"] ?? "";
                            } else {
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

                            // ── Unread count for current parent ──
                            final unreadMap = (data["unreadCount"]
                            as Map<String, dynamic>?) ??
                                {};
                            final unread =
                            (unreadMap[parentId] ?? 0) as int;

                            // ── Sent by me? ─────────────────────
                            final lastSenderId =
                                data["lastSenderId"] ?? "";
                            final hasCheck =
                                lastSenderId == parentId;

                            return _chatTile(
                              context,
                              {
                                "chatId": doc.id,
                                "name": displayName,
                                "image": displayImage,
                                "message": lastMessage,
                                "time": time,
                                "unreadCount": unread,
                                "lastSenderId": data["lastSenderId"] ?? "",
                                "lastMessageStatus": data["lastMessageStatus"] ?? "sent",
                                // ── Navigation args ────────────
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

  // ================= SEARCH BAR =================
  Widget _searchBar(BuildContext context) {
    final light = isLight(context);

    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: Container(
        height: 44,
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
            hintText: "search_hint".tr,
            hintStyle: TextStyle(
              color: light ? Colors.grey.shade600 : Colors.grey.shade400,
            ),
            border: InputBorder.none,
            fillColor: light ? Colors.white : const Color(0xFF1C1C1E),
            prefixIcon: Icon( // ✅ FIXED
              Icons.search_rounded,
              size: 20,
              color: light ? Colors.grey.shade600 : Colors.grey.shade400,
            ),

            contentPadding: const EdgeInsets.symmetric(
              vertical: 0, // ✅ IMPORTANT (center vertically)
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildTickIcon(Map<String, dynamic> chat, String currentUserId) {
    final lastSenderId = chat['lastSenderId'] ?? '';

    if (lastSenderId != currentUserId) {
      return const SizedBox(width: 0); // keep layout stable
    }

    final status = chat['lastMessageStatus'] ?? 'sent';

    if (status == 'seen') {
      return const Padding(
        padding: EdgeInsets.only(right: 4),
        child: Icon(Icons.done_all, size: 16, color: Color(0xFF34B7F1)),
      );
    } else if (status == 'delivered') {
      return const Padding(
        padding: EdgeInsets.only(right: 4),
        child: Icon(Icons.done_all, size: 16, color: Colors.grey),
      );
    } else {
      return const Padding(
        padding: EdgeInsets.only(right: 4),
        child: Icon(Icons.check, size: 16, color: Colors.grey),
      );
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
          onTap: () {
            Get.to(
                  () => const AllMessageScreen(),
              arguments: {
                "chatId": chat["chatId"] ?? "",
                "receiverId": chat["receiverId"] ?? "",
                "receiverName":
                chat["receiverName"] ?? chat["name"] ?? "",
                "receiverImage":
                chat["receiverImage"] ?? chat["image"] ?? "",
                "fcmToken": chat["fcmToken"] ?? "",
                "isOnline": chat["isOnline"] ?? false,
                "chatType": chat["type"] ?? 0,
              },
            );
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
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              chat['name'] ?? "",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: light
                                    ? Colors.black87
                                    : Colors.white,
                              ),
                            ),
                          ),
                          Text(
                            chat['time'] ?? "",
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          _buildTickIcon(chat, parentId!),
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
}
