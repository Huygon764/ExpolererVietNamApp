import 'package:app_tourist_destination/data/FAQ.dart';
import 'package:flutter/material.dart';

void showFAQModal(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder:
        (context) => Container(
          height: MediaQuery.of(context).size.height * 0.8,
          padding: EdgeInsets.only(top: 8),
          child: FAQScreen(),
        ),
  );
}

class FAQScreen extends StatelessWidget {
  const FAQScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Thanh kéo ở trên cùng
        Container(
          width: 40,
          height: 5,
          margin: EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(10),
          ),
        ),

        // Tiêu đề
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Câu hỏi thường gặp',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),

        Divider(),

        // Danh sách câu hỏi
        Expanded(
          child: ListView.builder(
            itemCount: faqItems.length,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemBuilder: (context, index) {
              return FAQItem(
                question: faqItems[index]['question'] ?? '',
                answer: faqItems[index]['answer'] ?? '',
              );
            },
          ),
        ),
      ],
    );
  }
}

class FAQItem extends StatefulWidget {
  final String question;
  final String answer;

  const FAQItem({Key? key, required this.question, required this.answer})
    : super(key: key);

  @override
  _FAQItemState createState() => _FAQItemState();
}

class _FAQItemState extends State<FAQItem> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          setState(() {
            _expanded = !_expanded;
          });
        },
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.question,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Icon(
                    _expanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.blue,
                  ),
                ],
              ),
              if (_expanded) ...[
                SizedBox(height: 12),
                Text(
                  widget.answer,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
