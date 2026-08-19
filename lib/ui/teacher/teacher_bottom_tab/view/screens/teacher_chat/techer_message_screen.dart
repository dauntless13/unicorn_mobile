import 'package:flutter/material.dart';

class Demo extends StatelessWidget {
  Demo({super.key});

  final chatController = TextEditingController();

  bool isLight(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light;

  @override
  Widget build(BuildContext context) {
    final light = isLight(context);

    final sentColor =
    light ? const Color(0xFFD9FDD3) : const Color(0xFF1F3D2B);
    final receivedColor =
    light ? Colors.white : const Color(0xFF1E1E1E);

    return Scaffold(
      backgroundColor:
      light ? Colors.white : const Color(0xFF0F0F0F),
      appBar: buildChatAppBar(context),
      body: Column(
        children: [
          Expanded(child: _messages(context, sentColor, receivedColor)),
          buildInputBar(context, chatController),
        ],
      ),
    );
  }

  // ================= APP BAR =================
  PreferredSizeWidget buildChatAppBar(BuildContext context) {
    final light = isLight(context);

    return AppBar(
      backgroundColor:
      light ? Colors.white : const Color(0xFF121212),
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      toolbarHeight: 70,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            _iconBox(
              context,
              Icons.arrow_back_ios_new,
              onTap: () => Navigator.pop(context),
            ),
            const SizedBox(width: 12),
            const CircleAvatar(
              radius: 20,
              backgroundColor: Color(0xFFF2A7A7),
              child: Icon(Icons.person, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Kaitlyn',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: light ? Colors.black : Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Last seen at 10.54PM',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            _iconBox(context, Icons.more_vert),
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
        icon: Icon(
          icon,
          size: 18,
          color: light ? Colors.black : Colors.white,
        ),
        onPressed: onTap,
      ),
    );
  }

  // ================= MESSAGES =================
  Widget _messages(
      BuildContext context, Color sent, Color received) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      children: [
        _sentText(context, 'I will write from Japan', '17:47', sent),
        _sentText(context, 'Good bye!', '17:47', sent),
        _sentText(context, 'Japan looks amazing!', '10:10', sent),
        _sentFile(context, 'IMG_0475', '2.4 MB · png', '10:15', sent),
        _receivedText(context, 'Hey where are you now ?', '11:40', received),
        _sentText(context, 'Good morning, In Chennai 😎', '11:43', sent),
        _receivedText(
            context, 'had breakfast? whats the special there', '11:45', received),
      ],
    );
  }

  // ================= TEXT BUBBLES =================
  Widget _sentText(BuildContext context, String text, String time, Color color) {
    return _bubble(context, text, time, color, true);
  }

  Widget _receivedText(
      BuildContext context, String text, String time, Color color) {
    return _bubble(context, text, time, color, false);
  }

  Widget _bubble(BuildContext context, String text, String time, Color color,
      bool sent) {
    final light = isLight(context);

    return Row(
      mainAxisAlignment:
      sent ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          constraints: const BoxConstraints(maxWidth: 260),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                text,
                style: TextStyle(
                  fontSize: 15,
                  color: light ? Colors.black : Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    ' ',
                    style: TextStyle(fontSize: 11),
                  ),
                  Text(
                    time,
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                  if (sent) ...[
                    const SizedBox(width: 4),
                    const Icon(Icons.done_all,
                        size: 16, color: Color(0xFF34B7F1)),
                  ]
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  // ================= FILE BUBBLE =================
  Widget _sentFile(BuildContext context, String name, String size, String time,
      Color color) {
    final light = isLight(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 220,
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color:
                      light ? Colors.white : const Color(0xFF2A2A2A),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(Icons.description_outlined),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name,
                            style:
                            const TextStyle(fontWeight: FontWeight.w600)),
                        Text(size,
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ================= INPUT BAR =================
  Widget buildInputBar(
      BuildContext context, TextEditingController controller) {
    final light = isLight(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(8, 6, 8, 10),
      decoration: BoxDecoration(
        color: light ? Colors.white : const Color(0xFF121212),
        border: Border(
          top: BorderSide(
              color: light ? Colors.grey.shade300 : Colors.grey.shade700),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.add, size: 26, color: Color(0xFF0C7189)),
              onPressed: () {},
            ),
            Expanded(
              child: TextField(
                controller: controller,
                style: TextStyle(
                  fontSize: 16,
                  color: light ? Colors.black : Colors.white,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor:
                  light ? Colors.white : const Color(0xFF1E1E1E),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(22),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.camera_alt_outlined,
                  size: 24, color: Color(0xFF0C7189)),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.mic,
                  size: 24, color: Color(0xFF0C7189)),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
