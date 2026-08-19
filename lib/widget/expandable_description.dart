import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../core/widget/my_regular_text.dart';

class ExpandableDescription extends StatefulWidget {
  final String text;
  final int trimLines;
  final String seeMoreText;
  final String seeLessText;

  const ExpandableDescription({
    Key? key,
    required this.text,
    this.trimLines = 2,
    this.seeMoreText = 'Read more',
    this.seeLessText = 'Read less',
  }) : super(key: key);

  @override
  State<ExpandableDescription> createState() => _ExpandableDescriptionState();
}

class _ExpandableDescriptionState extends State<ExpandableDescription> {
  bool _isExpanded = false;

  get CommonFontSizeText => null;

  @override
  Widget build(BuildContext context) {
    if (widget.text.isEmpty) {
      return MyRegularText(
        label: 'No description provided.',
        fontSize: 14.sp,
        color: Colors.grey.shade700,
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        // 🔑 Proper textDirection fixes the previous crash
        final tp = TextPainter(
          text: TextSpan(text: widget.text, style: TextStyle(fontSize: 14)),
          maxLines: widget.trimLines,
          textDirection: Directionality.of(context),
        )..layout(maxWidth: constraints.maxWidth);

        final isOverflowing = tp.didExceedMaxLines;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyRegularText(
              label: widget.text,
              fontSize: 14,
              color: Colors.grey.shade700,
              align: TextAlign.justify,
              maxlines: _isExpanded ? null : widget.trimLines,
              overflow: _isExpanded
                  ? TextOverflow.visible
                  : TextOverflow.ellipsis,
            ),
            if (isOverflowing)
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: MyRegularText(
                    label: _isExpanded
                        ? widget.seeLessText
                        : widget.seeMoreText,

                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
