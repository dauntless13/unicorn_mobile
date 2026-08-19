import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unicorn/core/widget/profile_avatar.dart';
import 'message_controller.dart';
import 'package:unicorn/core/widget/empty_state.dart';

// =============================================================================
//  SHARED THEME TOKENS
// =============================================================================

class _GT {
  final bool light;
  const _GT(this.light);

  // Scaffold
  Color get scaffold     => light ? const Color(0xFFF4F6FA) : const Color(0xFF0A0A0E);

  // Header gradient
  List<Color> headerGradient(Color a, Color b) => [a, b];

  // Cards
  Color get card         => light ? Colors.white              : const Color(0xFF141418);
  Color get cardShadow   => light
      ? Colors.black.withOpacity(0.07)
      : Colors.black.withOpacity(0.35);

  // Dividers
  Color get divider      => light ? const Color(0xFFF0F2F5)   : const Color(0xFF1E1E26);

  // Text
  Color get txtPrimary   => light ? const Color(0xFF1A2332)   : Colors.white;
  Color get txtSecondary => light ? const Color(0xFF6B7A8D)   : const Color(0xFF5A6A80);

  // Stat icon bg
  Color iconBg(Color c)  => c.withOpacity(light ? 0.08 : 0.18);

  // Count badge bg
  Color badgeBg(Color c) => c.withOpacity(light ? 0.08 : 0.18);

  // inGroup badge
  Color get inGroupBg    => light
      ? const Color(0xFF27AE60).withOpacity(0.10)
      : const Color(0xFF27AE60).withOpacity(0.20);
  Color get notInBg      => light
      ? Colors.grey.withOpacity(0.10)
      : Colors.grey.withOpacity(0.18);
  Color get notInDot     => light ? Colors.grey.shade400 : Colors.grey.shade600;
  Color get notInTxt     => light ? Colors.grey.shade500 : Colors.grey.shade500;

  // Empty state icon
  Color get emptyIcon    => light ? Colors.grey.shade300 : const Color(0xFF2A2A38);

  // Nav button
  Color get navBtnBg     => Colors.white.withOpacity(light ? 0.18 : 0.12);
}

// =============================================================================
//  TEACHER GROUP SCREEN
// =============================================================================

class TeacherGroupScreen extends StatefulWidget {
  const TeacherGroupScreen({super.key});

  @override
  State<TeacherGroupScreen> createState() => _TeacherGroupScreenState();
}

class _TeacherGroupScreenState extends State<TeacherGroupScreen>
    with SingleTickerProviderStateMixin {
  final ChatController controller = Get.put(ChatController());
  late AnimationController _animCtrl;
  late Animation<double>   _fade;
  late Animation<Offset>   _slide;

  // Brand palette
  static const _primary      = Color(0xFF0D6E7F);
  static const _primaryLight = Color(0xFF1A9CB5);
  static const _accent       = Color(0xFF00D4AA);

  static const _avatarPalette = [
    Color(0xFF0D6E7F), Color(0xFF6C63FF),
    Color(0xFFFF6584), Color(0xFFFFB347),
    Color(0xFF43C6AC), Color(0xFFE96C6C),
  ];

  Color  _avatarColor(int i) => _avatarPalette[i % _avatarPalette.length];
  String _initials(String? name) {
    if (name == null || name.trim().isEmpty) return '?';
    return name.trim().split(' ')
        .map((e) => e.isNotEmpty ? e[0] : '').take(2).join().toUpperCase();
  }

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    _fade  = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero)
        .animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeOutCubic));
    Future.delayed(const Duration(milliseconds: 300), () {
      controller.getTeacherGroupUsers();
      _animCtrl.forward();
    });
  }

  @override
  void dispose() { _animCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final t = _GT(Theme.of(context).brightness == Brightness.light);
    return Scaffold(
      backgroundColor: t.scaffold,
      body: Column(children: [
        _buildHeader(t),
        Expanded(
          child: FadeTransition(
            opacity: _fade,
            child: SlideTransition(
              position: _slide,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(children: [
                  _buildStatsCard(t),
                  _buildMemberSection(t),
                  const SizedBox(height: 32),
                ]),
              ),
            ),
          ),
        ),
      ]),
    );
  }

  // ── Header ──────────────────────────────────────────────────
  Widget _buildHeader(_GT t) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [_primary, _primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
          child: Column(children: [
            // Nav row
            Row(children: [
              _NavBtn(icon: Icons.arrow_back_ios_new_rounded,
                  bg: t.navBtnBg, onTap: Get.back),
              const SizedBox(width: 10),
              const Text("Group Info",
                  style: TextStyle(color: Colors.white, fontSize: 17,
                      fontWeight: FontWeight.w700, letterSpacing: 0.3)),
            ]),
            const SizedBox(height: 24),
            // Avatar
            Container(
              width: 80, height: 80,
              decoration: BoxDecoration(
                color: Colors.white, shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: _primary.withOpacity(0.35),
                    blurRadius: 20, spreadRadius: 2,
                    offset: const Offset(0, 6))],
              ),
              child: const Center(child: Text("AT",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800,
                      color: _primary, letterSpacing: 1))),
            ),
            const SizedBox(height: 14),
            const Text("All Teacher Group",
                style: TextStyle(color: Colors.white, fontSize: 20,
                    fontWeight: FontWeight.w700, letterSpacing: 0.2)),
            const SizedBox(height: 6),
            Obx(() => _HeaderChip(
              label: "${controller.teacherList.length} Members",
              accent: _accent,
            )),
          ]),
        ),
      ),
    );
  }

  // ── Stats card ───────────────────────────────────────────────
  Widget _buildStatsCard(_GT t) {
    return Transform.translate(
      offset: const Offset(0, -10),
      child: Padding(
        padding: const EdgeInsets.only(left: 16,right : 16,top: 16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
          decoration: BoxDecoration(
            color: t.card,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: t.cardShadow,
                blurRadius: 20, offset: const Offset(0, 4))],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _StatItem(icon: Icons.group_rounded, label: "GROUP",
                  value: "Teacher", primary: _primary, t: t),
              _VDivider(t: t),
              Obx(() => _StatItem(
                icon: Icons.people_alt_rounded, label: "MEMBERS",
                value: "${controller.teacherList.length}",
                primary: _primary, t: t,
              )),
            ],
          ),
        ),
      ),
    );
  }

  // ── Member section ───────────────────────────────────────────
  Widget _buildMemberSection(_GT t) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: t.card,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: t.cardShadow,
              blurRadius: 16, offset: const Offset(0, 4))],
        ),
        child: Column(children: [
          // Header row
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 10),
            child: Row(children: [
              Container(
                width: 4, height: 18,
                decoration: BoxDecoration(
                    color: _accent,
                    borderRadius: BorderRadius.circular(4)),
              ),
              const SizedBox(width: 10),
              Text("Group Members",
                  style: TextStyle(fontSize: 15,
                      fontWeight: FontWeight.w700, color: t.txtPrimary)),
              const Spacer(),
              Obx(() => Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                    color: t.badgeBg(_primary),
                    borderRadius: BorderRadius.circular(20)),
                child: Text("${controller.teacherList.length}",
                    style: TextStyle(fontSize: 12,
                        fontWeight: FontWeight.w700, color: _primary)),
              )),
            ]),
          ),
          Divider(height: 1, thickness: 1, color: t.divider),

          // List
          Obx(() {
            if (controller.teacherList.isEmpty) {
              return _EmptyState(t: t);
            }
            return ListView.separated(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.teacherList.length,
              separatorBuilder: (_, __) =>
                  Divider(height: 1, thickness: 1,
                      color: t.divider, indent: 72),
              itemBuilder: (_, i) {
                final teacher = controller.teacherList[i];
                return _TeacherTile(
                  index: i,
                  name: teacher.name ?? "Unknown",
                  avatarColor: _avatarColor(i),
                  initials: _initials(teacher.name),
                  t: t,
                );
              },
            );
          }),
          const SizedBox(height: 8),
        ]),
      ),
    );
  }
}

// ── Teacher Tile ─────────────────────────────────────────────
class _TeacherTile extends StatefulWidget {
  final int index;
  final String name, initials;
  final Color avatarColor;
  final _GT t;

  const _TeacherTile({
    required this.index, required this.name,
    required this.initials, required this.avatarColor, required this.t,
  });

  @override
  State<_TeacherTile> createState() => _TeacherTileState();
}

class _TeacherTileState extends State<_TeacherTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double>  _fade;
  late Animation<Offset>  _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this,
        duration: const Duration(milliseconds: 400));
    _fade  = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0.06, 0), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    Future.delayed(Duration(milliseconds: 60 + widget.index * 45),
            () { if (mounted) _ctrl.forward(); });
  }
  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final t = widget.t;
    return FadeTransition(opacity: _fade,
      child: SlideTransition(position: _slide,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(children: [
            // Avatar ring
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: widget.avatarColor.withOpacity(0.3), width: 2),
              ),
              child: CircleAvatar(
                radius: 22, backgroundColor: widget.avatarColor,
                child: Text(widget.initials,
                    style: const TextStyle(color: Colors.white,
                        fontWeight: FontWeight.w700, fontSize: 13)),
              ),
            ),
            const SizedBox(width: 14),
            // Name / role
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.name,
                    style: TextStyle(fontSize: 14,
                        fontWeight: FontWeight.w600, color: t.txtPrimary)),
                const SizedBox(height: 2),
                Text("Teacher",
                    style: TextStyle(fontSize: 12, color: t.txtSecondary)),
              ],
            )),
            // Online dot
            Container(
              width: 8, height: 8,
              decoration: BoxDecoration(
                color: const Color(0xFF00D4AA),
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(
                    color: const Color(0xFF00D4AA).withOpacity(0.4),
                    blurRadius: 4, spreadRadius: 1)],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

// =============================================================================
//  PARENT GROUP SCREEN
// =============================================================================

class ParentGroupScreen extends StatefulWidget {
  const ParentGroupScreen({super.key});

  @override
  State<ParentGroupScreen> createState() => _ParentGroupScreenState();
}

class _ParentGroupScreenState extends State<ParentGroupScreen>
    with SingleTickerProviderStateMixin {
  final ChatController controller = Get.find<ChatController>();
  late AnimationController _animCtrl;
  late Animation<double>   _fade;
  late Animation<Offset>   _slide;

  // Brand palette
  static const _primary      = Color(0xFF2D5A8E);
  static const _primaryLight = Color(0xFF4A90D9);
  static const _accent       = Color(0xFFFFAA00);

  static const _avatarPalette = [
    Color(0xFF2D5A8E), Color(0xFFE05D5D),
    Color(0xFF43A899), Color(0xFF9B59B6),
    Color(0xFFE67E22), Color(0xFF27AE60),
  ];

  Color  _avatarColor(int i) => _avatarPalette[i % _avatarPalette.length];
  String _initials(String? name) {
    if (name == null || name.trim().isEmpty) return '?';
    return name.trim().split(' ')
        .map((e) => e.isNotEmpty ? e[0] : '').take(2).join().toUpperCase();
  }

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 650));
    _fade  = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0, 0.07), end: Offset.zero)
        .animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeOutCubic));
    Future.delayed(const Duration(milliseconds: 200), () {
      controller.getParentGroupUsers();
      _animCtrl.forward();
    });
  }

  @override
  void dispose() { _animCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final t = _GT(Theme.of(context).brightness == Brightness.light);
    return Scaffold(
      backgroundColor: t.scaffold,
      body: Column(children: [
        _buildHeader(t),
        Expanded(
          child: FadeTransition(
            opacity: _fade,
            child: SlideTransition(
              position: _slide,
              child: Obx(() {
                if (controller.isParentLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(children: [
                    _buildStatsCard(t),
                    _buildMemberSection(t),
                    const SizedBox(height: 32),
                  ]),
                );
              }),
            ),
          ),
        ),
      ]),
    );
  }

  // ── Header ──────────────────────────────────────────────────
  Widget _buildHeader(_GT t) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [_primary, _primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
          child: Column(children: [
            Row(children: [
              _NavBtn(icon: Icons.arrow_back_ios_new_rounded,
                  bg: t.navBtnBg, onTap: Get.back),
              const SizedBox(width: 10),
              const Text("Group Info",
                  style: TextStyle(color: Colors.white, fontSize: 17,
                      fontWeight: FontWeight.w700, letterSpacing: 0.3)),
            ]),
            const SizedBox(height: 22),
            Container(
              width: 80, height: 80,
              decoration: BoxDecoration(
                color: Colors.white, shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: _primary.withOpacity(0.4),
                    blurRadius: 22, spreadRadius: 2,
                    offset: const Offset(0, 6))],
              ),
              child: Center(child: Text("PG",
                  style: TextStyle(fontSize: 26,
                      fontWeight: FontWeight.w800, color: _primary,
                      letterSpacing: 1))),
            ),
            const SizedBox(height: 12),
            const Text("All Parent Group",
                style: TextStyle(color: Colors.white,
                    fontSize: 20, fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Obx(() => _HeaderChip(
              label: "${controller.parentList.length} Members",
              accent: _accent,
            )),
          ]),
        ),
      ),
    );
  }

  // ── Stats card ───────────────────────────────────────────────
  Widget _buildStatsCard(_GT t) {
    return Transform.translate(
      offset: const Offset(0, -18),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
          decoration: BoxDecoration(
            color: t.card,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: t.cardShadow,
                blurRadius: 18, offset: const Offset(0, 4))],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _StatItem(icon: Icons.group_rounded, label: "GROUP",
                  value: "Parent", primary: _primary, t: t),
              _VDivider(t: t),
              _StatItem(icon: Icons.shield_rounded, label: "ROLE",
                  value: "Guardian", primary: _primary, t: t),
              _VDivider(t: t),
              Obx(() => _StatItem(
                icon: Icons.people_alt_rounded, label: "MEMBERS",
                value: "${controller.parentList.length}",
                primary: _primary, t: t,
              )),
            ],
          ),
        ),
      ),
    );
  }

  // ── Member section ───────────────────────────────────────────
  Widget _buildMemberSection(_GT t) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: t.card,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: t.cardShadow,
              blurRadius: 16, offset: const Offset(0, 4))],
        ),
        child: Column(children: [
          // Header row
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 10),
            child: Row(children: [
              Container(
                width: 4, height: 18,
                decoration: BoxDecoration(
                    color: _accent,
                    borderRadius: BorderRadius.circular(4)),
              ),
              const SizedBox(width: 10),
              Text("Group Members",
                  style: TextStyle(fontSize: 15,
                      fontWeight: FontWeight.w700, color: t.txtPrimary)),
              const Spacer(),
              Obx(() => Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                    color: t.badgeBg(_primary),
                    borderRadius: BorderRadius.circular(20)),
                child: Text("${controller.parentList.length}",
                    style: TextStyle(fontSize: 12,
                        fontWeight: FontWeight.w700, color: _primary)),
              )),
            ]),
          ),
          Divider(height: 1, thickness: 1, color: t.divider),

          // List
          Obx(() {
            if (controller.parentList.isEmpty) {
              return _EmptyState(t: t);
            }
            return ListView.separated(padding: EdgeInsets.zero,

              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.parentList.length,
              separatorBuilder: (_, __) =>
                  Divider(height: 1, thickness: 1,
                      color: t.divider, indent: 72),
              itemBuilder: (_, i) {
                final parent = controller.parentList[i];
                return _ParentTile(
                  index: i,
                  name: parent.name,
                  email: parent.email,
                  profileLink: parent.profileLink,
                  inGroup: parent.inGroup ?? false,
                  avatarColor: _avatarColor(i),
                  initials: _initials(parent.name),
                  primary: _primary,
                  t: t,
                );
              },
            );
          }),
          const SizedBox(height: 8),
        ]),
      ),
    );
  }
}

// ── Parent Tile ───────────────────────────────────────────────
class _ParentTile extends StatefulWidget {
  final int index;
  final String? name, email, profileLink;
  final bool inGroup;
  final Color avatarColor, primary;
  final String initials;
  final _GT t;

  const _ParentTile({
    required this.index, required this.name, required this.email,
    required this.profileLink, required this.inGroup,
    required this.avatarColor, required this.initials,
    required this.primary, required this.t,
  });

  @override
  State<_ParentTile> createState() => _ParentTileState();
}

class _ParentTileState extends State<_ParentTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double>  _fade;
  late Animation<Offset>  _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this,
        duration: const Duration(milliseconds: 380));
    _fade  = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0.05, 0), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    Future.delayed(Duration(milliseconds: 60 + widget.index * 40),
            () { if (mounted) _ctrl.forward(); });
  }
  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final t = widget.t;
    final hasPhoto = (widget.profileLink ?? "").isNotEmpty;
    return FadeTransition(opacity: _fade,
      child: SlideTransition(position: _slide,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
          child: Row(children: [
            // Avatar
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: widget.avatarColor.withOpacity(0.3), width: 2),
              ),
              child: ProfileAvatar(
                radius: 22,
                imageUrl: widget.profileLink,
                backgroundColor: widget.avatarColor,
                iconColor: Colors.white,
                iconSize: 18,
              ),
            ),
            const SizedBox(width: 14),
            // Info
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.name ?? "Unknown",
                    style: TextStyle(fontSize: 14,
                        fontWeight: FontWeight.w600, color: t.txtPrimary)),
                if ((widget.email ?? "").isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(widget.email!,
                      style: TextStyle(fontSize: 11, color: t.txtSecondary),
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ],
            )),
            const SizedBox(width: 8),
            // inGroup badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
              decoration: BoxDecoration(
                color: widget.inGroup ? t.inGroupBg : t.notInBg,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Container(
                  width: 6, height: 6,
                  decoration: BoxDecoration(
                    color: widget.inGroup
                        ? const Color(0xFF27AE60) : t.notInDot,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  widget.inGroup ? "In Group" : "Not In",
                  style: TextStyle(
                    fontSize: 10, fontWeight: FontWeight.w600,
                    color: widget.inGroup
                        ? const Color(0xFF27AE60) : t.notInTxt,
                  ),
                ),
              ]),
            ),
          ]),
        ),
      ),
    );
  }
}

// =============================================================================
//  SHARED SMALL WIDGETS
// =============================================================================

class _NavBtn extends StatelessWidget {
  final IconData icon;
  final Color bg;
  final VoidCallback onTap;
  const _NavBtn({required this.icon, required this.bg, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: 38, height: 38,
      decoration: BoxDecoration(color: bg,
          borderRadius: BorderRadius.circular(12)),
      child: Icon(icon, color: Colors.white, size: 18),
    ),
  );
}

class _HeaderChip extends StatelessWidget {
  final String label;
  final Color accent;
  const _HeaderChip({required this.label, required this.accent});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
    decoration: BoxDecoration(
      color: accent.withOpacity(0.18),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: accent.withOpacity(0.55)),
    ),
    child: Text(label,
        style: const TextStyle(color: Colors.white,
            fontSize: 12, fontWeight: FontWeight.w600)),
  );
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label, value;
  final Color primary;
  final _GT t;
  const _StatItem({required this.icon, required this.label,
    required this.value, required this.primary, required this.t});

  @override
  Widget build(BuildContext context) => Column(children: [
    Container(
      width: 40, height: 40,
      decoration: BoxDecoration(
          color: t.iconBg(primary),
          borderRadius: BorderRadius.circular(12)),
      child: Icon(icon, color: primary, size: 20),
    ),
    const SizedBox(height: 8),
    Text(label, style: TextStyle(fontSize: 10, color: t.txtSecondary,
        fontWeight: FontWeight.w600, letterSpacing: 0.8)),
    const SizedBox(height: 2),
    Text(value, style: TextStyle(fontSize: 14,
        color: t.txtPrimary, fontWeight: FontWeight.w700)),
  ]);
}

class _VDivider extends StatelessWidget {
  final _GT t;
  const _VDivider({required this.t});
  @override
  Widget build(BuildContext context) =>
      Container(width: 1, height: 48, color: t.divider);
}

class _EmptyState extends StatelessWidget {
  final _GT t;
  const _EmptyState({required this.t});

  @override
  Widget build(BuildContext context) => const EmptyState();
}
