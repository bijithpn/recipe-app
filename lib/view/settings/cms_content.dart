import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class CMSContent extends StatefulWidget {
  final String title;
  final String content;
  const CMSContent({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  State<CMSContent> createState() => _CMSContentState();
}

class _CMSContentState extends State<CMSContent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          widget.title,
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
          child: HtmlWidget(widget.content),
        ),
      ),
    );
  }
}
