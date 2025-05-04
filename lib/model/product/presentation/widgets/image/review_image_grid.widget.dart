import 'package:flutter/material.dart';

class ReviewImageGridWidget extends StatefulWidget {
  final String url;
  final List<String> imageUrls;

  const ReviewImageGridWidget({
    super.key,
    required this.url,
    required this.imageUrls,
  });

  @override
  State<ReviewImageGridWidget> createState() => _ReviewImageGridWidgetState();
}

class _ReviewImageGridWidgetState extends State<ReviewImageGridWidget> {
  late String currentUrl;

  @override
  void initState() {
    super.initState();
    currentUrl = widget.url;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 350,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            width: 280,
            height: 280,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                currentUrl,
                fit: BoxFit.fill,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Visibility(
                visible: widget.imageUrls.indexOf(currentUrl) != 0,
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      int beforeIndex = widget.imageUrls.indexOf(currentUrl) - 1;
                      currentUrl = widget.imageUrls[beforeIndex];
                    });
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                  ),
                ),
              ),
              Text("${widget.imageUrls.indexOf(currentUrl) + 1}"),
              Visibility(
                visible: widget.imageUrls.indexOf(currentUrl) != widget.imageUrls.length - 1,
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      int nextIndex = widget.imageUrls.indexOf(currentUrl) + 1;
                      currentUrl = widget.imageUrls[nextIndex];
                    });
                  },
                  icon: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.black,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
