// // ============================================================
// //  CONTROLLER SNIPPET  (add inside ChatController)
// // ============================================================
// //
// //  RxBool  isParentLoading = false.obs;
// //  RxList<ParentGroupUserListing> parentList = <ParentGroupUserListing>[].obs;
// //  Pagination? parentPagination;
// //  Group?     parentGroup;
// //
// //  Future<void> getParentGroupUsers() async {
// //    try {
// //      isParentLoading.value = true;
// //      final request = TeacherGroupUserListingRequest(lang: "en");
// //      final response = await ApiWorker().parentGroupUserListing(request, Get.context);
// //      if (response != null && response.data?.data != null) {
// //        parentList.assignAll(response.data!.data!);
// //        parentPagination = response.data!.pagination;
// //        parentGroup      = response.data!.group;
// //      }
// //    } catch (e) {
// //      debugPrint("ParentGroup Error ::: $e");
// //    } finally {
// //      isParentLoading.value = false;
// //    }
// //  }
// //
// // ============================================================
// //  FULL UI  –  parent_group_screen.dart
// // ============================================================
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'message_controller.dart';
//
// class ParentGroupScreen extends StatefulWidget {
//   const ParentGroupScreen({super.key});
//
//   @override
//   State<ParentGroupScreen> createState() => _ParentGroupScreenState();
// }
//
// class _ParentGroupScreenState extends State<ParentGroupScreen>
//     with SingleTickerProviderStateMixin {
//   final ChatController controller = Get.find<ChatController>();
//
//   late AnimationController _anim;
//   late Animation<double> _fade;
//   late Animation<Offset> _slide;
//
//   // ── Tokens ─────────────────────────────────────────────────
//   static const _primary = Color(0xFF2D5A8E);
//   static const _secondary = Color(0xFF4A90D9);
//   static const _accent = Color(0xFFFFAA00);
//   static const _surface = Color(0xFFF4F6FA);
//   static const _card = Colors.white;
//   static const _txtDark = Color(0xFF1B2C45);
//   static const _txtMuted = Color(0xFF7A8BA6);
//
//   static const _avatarPalette = [
//     Color(0xFF2D5A8E),
//     Color(0xFFE05D5D),
//     Color(0xFF43A899),
//     Color(0xFF9B59B6),
//     Color(0xFFE67E22),
//     Color(0xFF27AE60),
//   ];
//
//   // ───────────────────────────────────────────────────────────
//
//   @override
//   void initState() {
//     super.initState();
//     _anim = AnimationController(
//         vsync: this, duration: const Duration(milliseconds: 650));
//     _fade = CurvedAnimation(parent: _anim, curve: Curves.easeOut);
//     _slide = Tween<Offset>(begin: const Offset(0, 0.07), end: Offset.zero)
//         .animate(CurvedAnimation(parent: _anim, curve: Curves.easeOutCubic));
//
//     Future.delayed(const Duration(milliseconds: 200), () {
//       controller.getParentGroupUsers();
//       _anim.forward();
//     });
//   }
//
//   @override
//   void dispose() {
//     _anim.dispose();
//     super.dispose();
//   }
//
//   String _initials(String? name) {
//     if (name == null || name.trim().isEmpty) return '?';
//     final p = name.trim().split(' ');
//     return p.map((e) => e.isNotEmpty ? e[0] : '').take(2).join().toUpperCase();
//   }
//
//   Color _avatarColor(int i) => _avatarPalette[i % _avatarPalette.length];
//
//   // ── Build ───────────────────────────────────────────────────
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: _surface,
//       body: Column(
//         children: [
//           _Header(
//             primary: _primary,
//             secondary: _secondary,
//             accent: _accent,
//             controller: controller,
//           ),
//           Expanded(
//             child: FadeTransition(
//               opacity: _fade,
//               child: SlideTransition(
//                 position: _slide,
//                 child: Obx(() {
//                   if (controller.isParentLoading.value) {
//                     return const Center(
//                       child: CircularProgressIndicator(
//                         color: _primary,
//                         strokeWidth: 2.5,
//                       ),
//                     );
//                   }
//                   return _Body(
//                     controller: controller,
//                     initials: _initials,
//                     avatarColor: _avatarColor,
//                     primary: _primary,
//                     accent: _accent,
//                     txtDark: _txtDark,
//                     txtMuted: _txtMuted,
//                   );
//                 }),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // ── Header ────────────────────────────────────────────────────
// class _Header extends StatelessWidget {
//   final Color primary, secondary, accent;
//   final ChatController controller;
//
//   const _Header({
//     required this.primary,
//     required this.secondary,
//     required this.accent,
//     required this.controller,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [primary, secondary],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//       ),
//       child: SafeArea(
//         bottom: false,
//         child: Padding(
//           padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
//           child: Column(children: [
//             // nav
//             Row(children: [
//               _NavBtn(icon: Icons.arrow_back_ios_new_rounded, onTap: Get.back),
//               SizedBox(width: 8),
//               const Text("Group Info",
//                   style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 17,
//                       fontWeight: FontWeight.w700,
//                       letterSpacing: 0.3)),
//               // const Spacer(),
//               // _NavBtn(icon: Icons.more_vert_rounded, onTap: () {}),
//             ]),
//             const SizedBox(height: 22),
//             // avatar
//             Container(
//               width: 80,
//               height: 80,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 shape: BoxShape.circle,
//                 boxShadow: [
//                   BoxShadow(
//                       color: primary.withOpacity(0.4),
//                       blurRadius: 22,
//                       spreadRadius: 2,
//                       offset: const Offset(0, 6))
//                 ],
//               ),
//               child: Center(
//                 child: Text("PG",
//                     style: TextStyle(
//                         fontSize: 26,
//                         fontWeight: FontWeight.w800,
//                         color: primary,
//                         letterSpacing: 1)),
//               ),
//             ),
//             const SizedBox(height: 12),
//             const Text("All Parent Group",
//                 style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 20,
//                     fontWeight: FontWeight.w700)),
//             const SizedBox(height: 6),
//             Obx(() => _Chip(
//                   label: "${controller.parentList.length} Members",
//                   accent: accent,
//                 )),
//           ]),
//         ),
//       ),
//     );
//   }
// }
//
// class _NavBtn extends StatelessWidget {
//   final IconData icon;
//   final VoidCallback onTap;
//
//   const _NavBtn({required this.icon, required this.onTap});
//
//   @override
//   Widget build(BuildContext context) => GestureDetector(
//         onTap: onTap,
//         child: Container(
//           width: 38,
//           height: 38,
//           decoration: BoxDecoration(
//             color: Colors.white.withOpacity(0.15),
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: Icon(icon, color: Colors.white, size: 18),
//         ),
//       );
// }
//
// class _Chip extends StatelessWidget {
//   final String label;
//   final Color accent;
//
//   const _Chip({required this.label, required this.accent});
//
//   @override
//   Widget build(BuildContext context) => Container(
//         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
//         decoration: BoxDecoration(
//           color: accent.withOpacity(0.18),
//           borderRadius: BorderRadius.circular(20),
//           border: Border.all(color: accent.withOpacity(0.55)),
//         ),
//         child: Text(label,
//             style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 12,
//                 fontWeight: FontWeight.w600)),
//       );
// }
//
// // ── Body ──────────────────────────────────────────────────────
// class _Body extends StatelessWidget {
//   final ChatController controller;
//   final String Function(String?) initials;
//   final Color Function(int) avatarColor;
//   final Color primary, accent, txtDark, txtMuted;
//
//   const _Body({
//     required this.controller,
//     required this.initials,
//     required this.avatarColor,
//     required this.primary,
//     required this.accent,
//     required this.txtDark,
//     required this.txtMuted,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       physics: const BouncingScrollPhysics(),
//       child: Column(children: [
//         _StatsCard(
//             controller: controller,
//             primary: primary,
//             txtDark: txtDark,
//             txtMuted: txtMuted),
//         _MemberList(
//           controller: controller,
//           initials: initials,
//           avatarColor: avatarColor,
//           primary: primary,
//           accent: accent,
//           txtDark: txtDark,
//           txtMuted: txtMuted,
//         ),
//         const SizedBox(height: 32),
//       ]),
//     );
//   }
// }
//
// // ── Stats card ────────────────────────────────────────────────
// class _StatsCard extends StatelessWidget {
//   final ChatController controller;
//   final Color primary, txtDark, txtMuted;
//
//   const _StatsCard({
//     required this.controller,
//     required this.primary,
//     required this.txtDark,
//     required this.txtMuted,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Transform.translate(
//       offset: const Offset(0, -18),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         child: Container(
//           padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(20),
//             boxShadow: [
//               BoxShadow(
//                   color: Colors.black.withOpacity(0.07),
//                   blurRadius: 18,
//                   offset: const Offset(0, 4))
//             ],
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               _StatItem(
//                   icon: Icons.group_rounded,
//                   label: "GROUP",
//                   value: "Parent",
//                   primary: primary,
//                   txtDark: txtDark,
//                   txtMuted: txtMuted),
//               _Divider(),
//               Obx(() => _StatItem(
//                     icon: Icons.people_alt_rounded,
//                     label: "MEMBERS",
//                     value: "${controller.parentList.length}",
//                     primary: primary,
//                     txtDark: txtDark,
//                     txtMuted: txtMuted,
//                   )),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class _StatItem extends StatelessWidget {
//   final IconData icon;
//   final String label, value;
//   final Color primary, txtDark, txtMuted;
//
//   const _StatItem({
//     required this.icon,
//     required this.label,
//     required this.value,
//     required this.primary,
//     required this.txtDark,
//     required this.txtMuted,
//   });
//
//   @override
//   Widget build(BuildContext context) => Column(children: [
//         Container(
//           width: 40,
//           height: 40,
//           decoration: BoxDecoration(
//               color: primary.withOpacity(0.08),
//               borderRadius: BorderRadius.circular(12)),
//           child: Icon(icon, color: primary, size: 20),
//         ),
//         const SizedBox(height: 8),
//         Text(label,
//             style: TextStyle(
//                 fontSize: 10,
//                 color: txtMuted,
//                 fontWeight: FontWeight.w600,
//                 letterSpacing: 0.8)),
//         const SizedBox(height: 2),
//         Text(value,
//             style: TextStyle(
//                 fontSize: 14, color: txtDark, fontWeight: FontWeight.w700)),
//       ]);
// }
//
// class _Divider extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) =>
//       Container(width: 1, height: 48, color: Colors.grey.shade200);
// }
//
// // ── Member list ───────────────────────────────────────────────
// class _MemberList extends StatelessWidget {
//   final ChatController controller;
//   final String Function(String?) initials;
//   final Color Function(int) avatarColor;
//   final Color primary, accent, txtDark, txtMuted;
//
//   const _MemberList({
//     required this.controller,
//     required this.initials,
//     required this.avatarColor,
//     required this.primary,
//     required this.accent,
//     required this.txtDark,
//     required this.txtMuted,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: [
//             BoxShadow(
//                 color: Colors.black.withOpacity(0.05),
//                 blurRadius: 16,
//                 offset: const Offset(0, 4))
//           ],
//         ),
//         child: Column(children: [
//           // header row
//           Padding(
//             padding: const EdgeInsets.fromLTRB(18, 18, 18, 10),
//             child: Row(children: [
//               Container(
//                   width: 4,
//                   height: 18,
//                   decoration: BoxDecoration(
//                       color: accent, borderRadius: BorderRadius.circular(4))),
//               const SizedBox(width: 10),
//               Text("Group Members",
//                   style: TextStyle(
//                       fontSize: 15,
//                       fontWeight: FontWeight.w700,
//                       color: txtDark)),
//               const Spacer(),
//               Obx(() => Container(
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//                     decoration: BoxDecoration(
//                         color: primary.withOpacity(0.08),
//                         borderRadius: BorderRadius.circular(20)),
//                     child: Text("${controller.parentList.length}",
//                         style: TextStyle(
//                             fontSize: 12,
//                             fontWeight: FontWeight.w700,
//                             color: primary)),
//                   )),
//             ]),
//           ),
//           const Divider(height: 1, thickness: 1, color: Color(0xFFF0F2F5)),
//
//           // list
//           Obx(() {
//             if (controller.parentList.isEmpty) {
//               return _EmptyState(txtMuted: txtMuted);
//             }
//             return ListView.separated(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               itemCount: controller.parentList.length,
//               separatorBuilder: (_, __) => const Divider(
//                   height: 1,
//                   thickness: 1,
//                   color: Color(0xFFF0F2F5),
//                   indent: 72),
//               itemBuilder: (_, i) {
//                 final parent = controller.parentList[i];
//                 return _ParentTile(
//                   index: i,
//                   name: parent.name,
//                   email: parent.email,
//                   profileLink: parent.profileLink,
//                   inGroup: parent.inGroup ?? false,
//                   avatarColor: avatarColor(i),
//                   initials: initials(parent.name),
//                   primary: primary,
//                   txtDark: txtDark,
//                   txtMuted: txtMuted,
//                 );
//               },
//             );
//           }),
//           const SizedBox(height: 8),
//         ]),
//       ),
//     );
//   }
// }
//
// class _EmptyState extends StatelessWidget {
//   final Color txtMuted;
//
//   const _EmptyState({required this.txtMuted});
//
//   @override
//   Widget build(BuildContext context) => Padding(
//         padding: const EdgeInsets.symmetric(vertical: 40),
//         child: Column(children: [
//           Icon(Icons.people_outline_rounded,
//               size: 48, color: Colors.grey.shade300),
//           const SizedBox(height: 12),
//           Text("No members yet",
//               style: TextStyle(
//                   color: txtMuted, fontSize: 14, fontWeight: FontWeight.w500)),
//         ]),
//       );
// }
//
// // ── Parent Tile ───────────────────────────────────────────────
// class _ParentTile extends StatefulWidget {
//   final int index;
//   final String? name, email, profileLink;
//   final bool inGroup;
//   final Color avatarColor, primary, txtDark, txtMuted;
//   final String initials;
//
//   const _ParentTile({
//     required this.index,
//     required this.name,
//     required this.email,
//     required this.profileLink,
//     required this.inGroup,
//     required this.avatarColor,
//     required this.initials,
//     required this.primary,
//     required this.txtDark,
//     required this.txtMuted,
//   });
//
//   @override
//   State<_ParentTile> createState() => _ParentTileState();
// }
//
// class _ParentTileState extends State<_ParentTile>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _ctrl;
//   late Animation<double> _fade;
//   late Animation<Offset> _slide;
//
//   @override
//   void initState() {
//     super.initState();
//     _ctrl = AnimationController(
//         vsync: this, duration: const Duration(milliseconds: 380));
//     _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
//     _slide = Tween<Offset>(
//       begin: const Offset(0.05, 0),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
//
//     Future.delayed(Duration(milliseconds: 60 + widget.index * 40), () {
//       if (mounted) _ctrl.forward();
//     });
//   }
//
//   @override
//   void dispose() {
//     _ctrl.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return FadeTransition(
//       opacity: _fade,
//       child: SlideTransition(
//         position: _slide,
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
//           child: Row(children: [
//             // avatar
//             Container(
//               padding: const EdgeInsets.all(2),
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 border: Border.all(
//                     color: widget.avatarColor.withOpacity(0.3), width: 2),
//               ),
//               child:
//                   widget.profileLink != null && widget.profileLink!.isNotEmpty
//                       ? CircleAvatar(
//                           radius: 22,
//                           backgroundImage: NetworkImage(widget.profileLink!),
//                           backgroundColor: widget.avatarColor,
//                         )
//                       : CircleAvatar(
//                           radius: 22,
//                           backgroundColor: widget.avatarColor,
//                           child: Text(widget.initials,
//                               style: const TextStyle(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.w700,
//                                   fontSize: 13)),
//                         ),
//             ),
//             const SizedBox(width: 14),
//             // info
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(widget.name ?? "Unknown",
//                       style: TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w600,
//                           color: widget.txtDark)),
//                   if (widget.email != null && widget.email!.isNotEmpty) ...[
//                     const SizedBox(height: 2),
//                     Text(widget.email!,
//                         style: TextStyle(fontSize: 11, color: widget.txtMuted),
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis),
//                   ],
//                 ],
//               ),
//             ),
//             const SizedBox(width: 8),
//             // inGroup badge
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
//               decoration: BoxDecoration(
//                 color: widget.inGroup
//                     ? const Color(0xFF27AE60).withOpacity(0.1)
//                     : Colors.grey.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: Row(mainAxisSize: MainAxisSize.min, children: [
//                 Container(
//                   width: 6,
//                   height: 6,
//                   decoration: BoxDecoration(
//                     color: widget.inGroup
//                         ? const Color(0xFF27AE60)
//                         : Colors.grey.shade400,
//                     shape: BoxShape.circle,
//                   ),
//                 ),
//                 const SizedBox(width: 4),
//                 Text(
//                   widget.inGroup ? "In Group" : "Not In",
//                   style: TextStyle(
//                     fontSize: 10,
//                     fontWeight: FontWeight.w600,
//                     color: widget.inGroup
//                         ? const Color(0xFF27AE60)
//                         : Colors.grey.shade500,
//                   ),
//                 ),
//               ]),
//             ),
//           ]),
//         ),
//       ),
//     );
//   }
// }
