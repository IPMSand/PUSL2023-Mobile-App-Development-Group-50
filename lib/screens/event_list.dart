import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class EventListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Saved Events'), backgroundColor: Colors.greenAccent),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('events').orderBy('date').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No events found!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)));
          }

          return ListView(
            padding: EdgeInsets.all(10),
            children: snapshot.data!.docs.map((doc) {
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              DateTime eventDate = (data['date'] as Timestamp).toDate();

              return Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  contentPadding: EdgeInsets.all(12),
                  title: Text(data['title'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(data['note'], style: TextStyle(fontSize: 16, color: Colors.grey[700])),
                      SizedBox(height: 5),
                      Text(
                        'Date: ${DateFormat('yyyy-MM-dd').format(eventDate)}',
                        style: TextStyle(fontSize: 14, color: Colors.green[700]),
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteEvent(doc.id, context),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  void _deleteEvent(String eventId, BuildContext context) async {
    try {
      await FirebaseFirestore.instance.collection('events').doc(eventId).delete();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Event deleted')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error deleting event: $e')));
    }
  }
}