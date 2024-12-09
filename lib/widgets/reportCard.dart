import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReportCard extends StatefulWidget {
  final Map<String, dynamic> report;
  const ReportCard({super.key, required this.report});

  @override
  State<ReportCard> createState() => _ReportCardState();
}

class _ReportCardState extends State<ReportCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isExpanded = !isExpanded;
        });
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 8,
        shadowColor: Colors.black.withOpacity(0.3),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF4C51BF), Color(0xFF6B46C1)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                widget.report['complainant'],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Spacer(),
                              Icon(
                                widget.report['status'] == 'resolved'
                                    ? Icons.check_circle
                                    : Icons.pending,
                                color: widget.report['status'] == 'resolved'
                                    ? Colors.green
                                    : Colors.orange,
                                size: 24,
                              ),
                              SizedBox(
                                height: 8,
                                width: 4,
                              ),
                              Text(
                                widget.report['status'],
                                style: TextStyle(
                                  fontSize: 14,
                                  color: widget.report['status'] == 'resolved'
                                      ? Colors.green
                                      : Colors.orange,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Complaint: ${widget.report['complaint']}',
                            style:
                                TextStyle(fontSize: 14, color: Colors.white70),
                            maxLines: 2, // Limit the preview to 2 lines
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Reported: ${widget.report['reported_date']}',
                            style:
                                TextStyle(fontSize: 14, color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [],
                    ),
                  ],
                ),
                // Expanded section
                if (isExpanded)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(
                        color: Colors.white38,
                        thickness: 1,
                        height: 20,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Complaint: ${widget.report['complaint']}',
                        style: TextStyle(fontSize: 14, color: Colors.white70),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Reported Time: ${widget.report['reported_time']}',
                        style: TextStyle(fontSize: 14, color: Colors.white70),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Timestamp: ${_formatDate(widget.report['timestamp'])}',
                        style: TextStyle(fontSize: 14, color: Colors.white70),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper function to format the date
  String _formatDate(DateTime? dateTime) {
    if (dateTime == null) return 'Unknown';
    return DateFormat('MMMM d, yyyy')
        .format(dateTime); // e.g., "August 22, 2024"
  }
}
