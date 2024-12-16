import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'firebase_options.dart';

class ChatScreen extends StatefulWidget {
  final String currentUserRole; // 'buyer' or 'seller'

   const ChatScreen({Key? key, required this.currentUserRole}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _controller = TextEditingController();
  double _currentPrice = 1000.0; // Seller's initial price
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _fetchMessages();
  }

  // Fetch messages from Firestore
  void _fetchMessages() async {
    final snapshots = await _firestore.collection('negotiations').get();
    setState(() {
      _messages.clear();
      for (var doc in snapshots.docs) {
        final data = doc.data();
        _messages.add(ChatMessage(
          senderId: data['senderId'],
          message: data['message'],
          proposedPrice: (data['proposedPrice'] as num).toDouble(),
          isApproved: data['isApproved'],
        ));
      }
    });
  }

  // Function to send the price proposal to Firestore
  void _sendProposal(double price) async {
    final message = ChatMessage(
      senderId: widget.currentUserRole,
      message: 'Proposed price: \$${price.toStringAsFixed(2)}',
      proposedPrice: price,
    );

    await _firestore.collection('negotiations').add({
      'senderId': message.senderId,
      'message': message.message,
      'proposedPrice': message.proposedPrice,
      'isApproved': null,
    });

    setState(() {
      _messages.add(message);
    });
  }

  // Function to approve the proposed price (only for the seller)
  void _approvePrice(int index) async {
    if (widget.currentUserRole == 'seller') {
      final docRef = await _getDocRef(_messages[index]);
      await docRef.update({'isApproved': true});

      setState(() {
        _messages[index] = ChatMessage(
          senderId: _messages[index].senderId,
          message: _messages[index].message,
          proposedPrice: _messages[index].proposedPrice,
          isApproved: true,
        );
        _currentPrice = _messages[index].proposedPrice!;
      });
    }
  }

  // Function to reject the proposed price (only for the seller)
  void _rejectPrice(int index) async {
    if (widget.currentUserRole == 'seller') {
      final docRef = await _getDocRef(_messages[index]);
      await docRef.update({'isApproved': false});

      setState(() {
        _messages[index] = ChatMessage(
          senderId: _messages[index].senderId,
          message: _messages[index].message,
          proposedPrice: _messages[index].proposedPrice,
          isApproved: false,
        );
      });
    }
  }

  // Helper function to find the Firestore document reference
  Future<DocumentReference> _getDocRef(ChatMessage message) async {
    final querySnapshot = await _firestore
        .collection('negotiations')
        .where('senderId', isEqualTo: message.senderId)
        .where('message', isEqualTo: message.message)
        .where('proposedPrice', isEqualTo: message.proposedPrice)
        .get();

    return querySnapshot.docs.first.reference;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Negotiation Chat')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return ListTile(
                  title: Text(message.message),
                  subtitle: message.isApproved == null
                      ? (widget.currentUserRole == 'seller'
                          ? Row(
                              children: [
                                ElevatedButton(
                                  onPressed: () => _approvePrice(index),
                                  child: Text('Approve'),
                                ),
                                SizedBox(width: 8),
                                ElevatedButton(
                                  onPressed: () => _rejectPrice(index),
                                  child: Text('Reject'),
                                ),
                              ],
                            )
                          : null) // No approve/reject buttons for the buyer
                      : Text(
                          message.isApproved == true
                              ? 'Approved'
                              : 'Rejected',
                          style: TextStyle(
                            color: message.isApproved == true
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  'Current Price: \$${_currentPrice.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Enter proposed price',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () {
                        final input = double.tryParse(_controller.text.trim());
                        if (input != null && input > 0) {
                          _sendProposal(input);
                          _controller.clear();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Please enter a valid price'),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String senderId;
  final String message;
  final double? proposedPrice;
  final bool? isApproved;

  ChatMessage({
    required this.senderId,
    required this.message,
    this.proposedPrice,
    this.isApproved,
  });
}
