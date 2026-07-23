import 'package:flutter/material.dart';
import '../models/feed_model.dart';
import '../services/feed_service.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final FeedService feedService = FeedService();

  final feedNameController = TextEditingController();
  final feedTypeController = TextEditingController();
  final quantityController = TextEditingController();
  final costController = TextEditingController();

  String purchaseDate = "";

  Future<void> selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2050),
    );

    if (pickedDate != null) {
      setState(() {
        purchaseDate =
            "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
      });
    }
  }

  Future<void> addFeed() async {
    final feed = Feed(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      feedName: feedNameController.text,
      feedType: feedTypeController.text,
      quantity: quantityController.text,
      cost: costController.text,
      purchaseDate: purchaseDate,
    );

    await feedService.addFeed(feed);

    feedNameController.clear();
    feedTypeController.clear();
    quantityController.clear();
    costController.clear();

    if (!mounted) return;

    Navigator.pop(context);
  }

  void showAddFeedDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Feed"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: feedNameController,
                  decoration: const InputDecoration(labelText: "Feed Name"),
                ),

                TextField(
                  controller: feedTypeController,
                  decoration: const InputDecoration(labelText: "Feed Type"),
                ),

                TextField(
                  controller: quantityController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Quantity (Kg)"),
                ),

                TextField(
                  controller: costController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Cost"),
                ),

                const SizedBox(height: 10),

                ElevatedButton(
                  onPressed: selectDate,
                  child: Text(
                    purchaseDate.isEmpty ? "Select Date" : purchaseDate,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),

            ElevatedButton(onPressed: addFeed, child: const Text("Save")),
          ],
        );
      },
    );
  }

  void showEditFeedDialog(Feed feed) {
    feedNameController.text = feed.feedName;
    feedTypeController.text = feed.feedType;
    quantityController.text = feed.quantity;
    costController.text = feed.cost;
    purchaseDate = feed.purchaseDate;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Feed"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: feedNameController,
                  decoration: const InputDecoration(labelText: "Feed Name"),
                ),

                TextField(
                  controller: feedTypeController,
                  decoration: const InputDecoration(labelText: "Feed Type"),
                ),

                TextField(
                  controller: quantityController,
                  decoration: const InputDecoration(labelText: "Quantity (Kg)"),
                ),

                TextField(
                  controller: costController,
                  decoration: const InputDecoration(labelText: "Cost"),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),

            ElevatedButton(
              onPressed: () async {
                await feedService.updateFeed(
                  Feed(
                    id: feed.id,
                    feedName: feedNameController.text,
                    feedType: feedTypeController.text,
                    quantity: quantityController.text,
                    cost: costController.text,
                    purchaseDate: purchaseDate,
                  ),
                );

                if (!mounted) return;

                Navigator.pop(context);
              },
              child: const Text("Update"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F8FC),

      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          "Feed Management",
          style: TextStyle(color: Colors.white),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: showAddFeedDialog,
        child: const Icon(Icons.add),
      ),

      body: StreamBuilder<List<Feed>>(
        stream: feedService.getFeeds(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final feeds = snapshot.data!;

          if (feeds.isEmpty) {
            return const Center(
              child: Text("No Feed Added Yet", style: TextStyle(fontSize: 18)),
            );
          }

          return ListView.builder(
            itemCount: feeds.length,
            itemBuilder: (context, index) {
              final feed = feeds[index];

              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.green,
                    child: Icon(Icons.food_bank, color: Colors.white),
                  ),

                  title: Text(feed.feedName),

                  subtitle: Text(
                    "Type: ${feed.feedType}\n"
                    "Qty: ${feed.quantity} Kg\n"
                    "Cost: Rs ${feed.cost}\n"
                    "Date: ${feed.purchaseDate}",
                  ),

                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.orange),
                        onPressed: () {
                          showEditFeedDialog(feed);
                        },
                      ),

                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          await feedService.deleteFeed(feed.id);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
