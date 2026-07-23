import 'package:flutter/material.dart';
import '../models/pond_model.dart';
import '../services/firebase_service.dart';

class PondScreen extends StatefulWidget {
  const PondScreen({super.key});

  @override
  State<PondScreen> createState() => _PondScreenState();
}

class _PondScreenState extends State<PondScreen> {
  final FirebaseService firebaseService = FirebaseService();

  final pondNameController = TextEditingController();
  final fishTypeController = TextEditingController();
  final fishQuantityController = TextEditingController();
  final feedTypeController = TextEditingController();
  final dailyFeedQuantityController = TextEditingController();

  Future<void> addPond() async {
    if (pondNameController.text.isEmpty ||
        fishTypeController.text.isEmpty ||
        fishQuantityController.text.isEmpty) {
      return;
    }

    final pond = Pond(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      pondName: pondNameController.text,
      fishType: fishTypeController.text,
      fishQuantity: fishQuantityController.text,
      feedType: feedTypeController.text,
      dailyFeedQuantity: dailyFeedQuantityController.text,
    );

    await firebaseService.addPond(pond);

    pondNameController.clear();
    fishTypeController.clear();
    fishQuantityController.clear();
    feedTypeController.clear();
    dailyFeedQuantityController.clear();

    if (!mounted) return;

    Navigator.pop(context);
  }

  void showAddPondDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Pond"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: pondNameController,
                  decoration: const InputDecoration(labelText: "Pond Name"),
                ),

                TextField(
                  controller: fishTypeController,
                  decoration: const InputDecoration(labelText: "Fish Type"),
                ),

                TextField(
                  controller: fishQuantityController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Fish Quantity"),
                ),

                TextField(
                  controller: feedTypeController,
                  decoration: const InputDecoration(labelText: "Feed Type"),
                ),

                TextField(
                  controller: dailyFeedQuantityController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Daily Feed Quantity",
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
            ElevatedButton(onPressed: addPond, child: const Text("Save")),
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
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Pond Management",
          style: TextStyle(color: Colors.white),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: showAddPondDialog,
        child: const Icon(Icons.add),
      ),

      body: StreamBuilder<List<Pond>>(
        stream: firebaseService.getPonds(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final ponds = snapshot.data!;

          if (ponds.isEmpty) {
            return const Center(
              child: Text("No Ponds Added Yet", style: TextStyle(fontSize: 18)),
            );
          }

          return ListView.builder(
            itemCount: ponds.length,
            itemBuilder: (context, index) {
              final pond = ponds[index];

              return Card(
                margin: const EdgeInsets.all(10),
                elevation: 5,
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.water, color: Colors.white),
                  ),

                  title: Text(
                    pond.pondName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),

                  subtitle: Text(
                    "Fish Type: ${pond.fishType}\n"
                    "Fish Quantity: ${pond.fishQuantity}\n"
                    "Feed Type: ${pond.feedType}\n"
                    "Daily Feed: ${pond.dailyFeedQuantity}",
                  ),

                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.orange),
                        onPressed: () {
                          pondNameController.text = pond.pondName;
                          fishTypeController.text = pond.fishType;
                          fishQuantityController.text = pond.fishQuantity;
                          feedTypeController.text = pond.feedType;
                          dailyFeedQuantityController.text =
                              pond.dailyFeedQuantity;

                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("Edit Pond"),

                                content: SingleChildScrollView(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextField(
                                        controller: pondNameController,
                                        decoration: const InputDecoration(
                                          labelText: "Pond Name",
                                        ),
                                      ),

                                      TextField(
                                        controller: fishTypeController,
                                        decoration: const InputDecoration(
                                          labelText: "Fish Type",
                                        ),
                                      ),

                                      TextField(
                                        controller: fishQuantityController,
                                        decoration: const InputDecoration(
                                          labelText: "Fish Quantity",
                                        ),
                                      ),

                                      TextField(
                                        controller: feedTypeController,
                                        decoration: const InputDecoration(
                                          labelText: "Feed Type",
                                        ),
                                      ),

                                      TextField(
                                        controller: dailyFeedQuantityController,
                                        decoration: const InputDecoration(
                                          labelText: "Daily Feed Quantity",
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Cancel"),
                                  ),

                                  ElevatedButton(
                                    onPressed: () async {
                                      await firebaseService.updatePond(
                                        Pond(
                                          id: pond.id,
                                          pondName: pondNameController.text,
                                          fishType: fishTypeController.text,
                                          fishQuantity:
                                              fishQuantityController.text,
                                          feedType: feedTypeController.text,
                                          dailyFeedQuantity:
                                              dailyFeedQuantityController.text,
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
                        },
                      ),

                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          await firebaseService.deletePond(pond.id);
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
