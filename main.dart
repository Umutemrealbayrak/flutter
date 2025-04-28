import 'package:flutter/material.dart';
import 'Models/address.dart';
import 'services/api_service.dart';
import 'AddressFormPage.dart';
import 'AddressDetailPage.dart'; // Güncelleme sayfasını import etmeyi unutma!

final ApiService apiService = ApiService(baseUrl: "https://localhost:7149");

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Address Filter',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Address> allAddresses = [];
  String filter = '';

  @override
  void initState() {
    super.initState();
    loadAddresses();
  }

  Future<void> loadAddresses() async {
    try {
      final data = await apiService.getAddresses();
      setState(() {
        allAddresses = data.cast<Address>();
      });
    } catch (e) {
      print("Veri çekme hatası: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = allAddresses.where((item) {
      return item.addressID.toString().contains(filter);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Address ID Listesi"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final created = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddressFormPage()),
              );
              if (created == true) loadAddresses();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'ID ile filtrele',
                border: OutlineInputBorder(),
              ),
              onChanged: (val) {
                setState(() {
                  filter = val;
                });
              },
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final created = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AddressFormPage()),
                  );
                  if (created == true) loadAddresses();
                },
                child: const Text(
                  'Yeni Adres Ekle',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: filtered.isEmpty
                  ? const Center(child: Text("Filtreye uyan adres yok."))
                  : ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final item = filtered[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          elevation: 4,
                          child: ListTile(
                            title: Text(
                              "ID: ${item.addressID}",
                              style: const TextStyle(fontSize: 18),
                            ),
                            trailing: const Icon(Icons.edit),
                            onTap: () async {
                              final updated = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => AddressDetailPage(id: item.addressID),
                                ),
                              );
                              if (updated == true) {
                                loadAddresses();
                              }
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
