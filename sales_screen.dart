import 'package:flutter/material.dart';
import '../models/sales_model.dart';
import '../services/sales_service.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  final SalesService salesService = SalesService();

  final customerNameController = TextEditingController();
  final fishTypeController = TextEditingController();
  final quantitySoldController = TextEditingController();
  final priceController = TextEditingController();

  String saleDate = "";

  Future<void> selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2050),
    );

    if (pickedDate != null) {
      setState(() {
        saleDate = "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
      });
    }
  }

  Future<void> addSale() async {
    final sale = Sale(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      customerName: customerNameController.text,
      fishType: fishTypeController.text,
      quantitySold: quantitySoldController.text,
      price: priceController.text,
      saleDate: saleDate,
    );

    await salesService.addSale(sale);

    customerNameController.clear();
    fishTypeController.clear();
    quantitySoldController.clear();
    priceController.clear();

    if (!mounted) return;

    Navigator.pop(context);
  }

  void showAddSaleDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Sale"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: customerNameController,
                  decoration: const InputDecoration(labelText: "Customer Name"),
                ),

                TextField(
                  controller: fishTypeController,
                  decoration: const InputDecoration(labelText: "Fish Type"),
                ),

                TextField(
                  controller: quantitySoldController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Quantity Sold (Kg)",
                  ),
                ),

                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Price"),
                ),

                const SizedBox(height: 10),

                ElevatedButton(
                  onPressed: selectDate,
                  child: Text(saleDate.isEmpty ? "Select Date" : saleDate),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),

            ElevatedButton(onPressed: addSale, child: const Text("Save")),
          ],
        );
      },
    );
  }

  void showEditSaleDialog(Sale sale) {
    customerNameController.text = sale.customerName;
    fishTypeController.text = sale.fishType;
    quantitySoldController.text = sale.quantitySold;
    priceController.text = sale.price;
    saleDate = sale.saleDate;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Sale"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: customerNameController,
                  decoration: const InputDecoration(labelText: "Customer Name"),
                ),

                TextField(
                  controller: fishTypeController,
                  decoration: const InputDecoration(labelText: "Fish Type"),
                ),

                TextField(
                  controller: quantitySoldController,
                  decoration: const InputDecoration(
                    labelText: "Quantity Sold (Kg)",
                  ),
                ),

                TextField(
                  controller: priceController,
                  decoration: const InputDecoration(labelText: "Price"),
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
                await salesService.updateSale(
                  Sale(
                    id: sale.id,
                    customerName: customerNameController.text,
                    fishType: fishTypeController.text,
                    quantitySold: quantitySoldController.text,
                    price: priceController.text,
                    saleDate: saleDate,
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
        backgroundColor: Colors.purple,
        title: const Text(
          "Sales Management",
          style: TextStyle(color: Colors.white),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        onPressed: showAddSaleDialog,
        child: const Icon(Icons.add),
      ),

      body: StreamBuilder<List<Sale>>(
        stream: salesService.getSales(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final sales = snapshot.data!;

          if (sales.isEmpty) {
            return const Center(
              child: Text("No Sales Added Yet", style: TextStyle(fontSize: 18)),
            );
          }

          return ListView.builder(
            itemCount: sales.length,
            itemBuilder: (context, index) {
              final sale = sales[index];

              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.purple,
                    child: Icon(Icons.shopping_cart, color: Colors.white),
                  ),

                  title: Text(sale.customerName),

                  subtitle: Text(
                    "Fish Type: ${sale.fishType}\n"
                    "Quantity: ${sale.quantitySold} Kg\n"
                    "Price: Rs ${sale.price}\n"
                    "Date: ${sale.saleDate}",
                  ),

                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.orange),
                        onPressed: () {
                          showEditSaleDialog(sale);
                        },
                      ),

                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          await salesService.deleteSale(sale.id);
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
