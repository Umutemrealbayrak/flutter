import 'package:flutter/material.dart';
import 'Models/address.dart';
import 'Services/api_service.dart';

final ApiService apiService = ApiService(baseUrl: "https://localhost:7149");

class AddressFormPage extends StatefulWidget {
  const AddressFormPage({super.key});

  @override
  _AddressFormPageState createState() => _AddressFormPageState();
}

class _AddressFormPageState extends State<AddressFormPage> {
  final _formKey = GlobalKey<FormState>();
  late int addressID; // Yeni adres için ID'yi alıyoruz, API sunucusu ID'yi döndürecek.
  late String addressLine1;
  late String city;
  late String stateProvince;
  late String countryRegion;
  late String postalCode;

  Future<void> submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Address newAddress = Address(
        addressID: addressID, // Yeni adres olduğu için ID'yi 0 alır, API sunucusu ID'yi döndürecek.
        addressLine1: addressLine1,
        city: city,
        stateProvince: stateProvince,
        countryRegion: countryRegion,
        postalCode: postalCode,
      );

      try {
        await apiService.createAddress(newAddress);
        Navigator.pop(context, true); // Yeni adres başarıyla eklendi
      } catch (e) {
        print("Adres eklenemedi: $e");
        Navigator.pop(context, false); // Hata durumunda false döndürebiliriz.
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Yeni Adres Ekle")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: "Address ID"),
                validator: (value) => value!.isEmpty ? 'Adres satırı boş olamaz' : null,
                onSaved: (value) => addressID = int.parse(value!),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Address Line 1"),
                validator: (value) => value!.isEmpty ? 'Adres satırı boş olamaz' : null,
                onSaved: (value) => addressLine1 = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "City"),
                validator: (value) => value!.isEmpty ? 'Şehir boş olamaz' : null,
                onSaved: (value) => city = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "State/Province"),
                validator: (value) => value!.isEmpty ? 'Eyalet/il boş olamaz' : null,
                onSaved: (value) => stateProvince = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Country/Region"),
                validator: (value) => value!.isEmpty ? 'Ülke/Bölge boş olamaz' : null,
                onSaved: (value) => countryRegion = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Postal Code"),
                validator: (value) => value!.isEmpty ? 'Posta kodu boş olamaz' : null,
                onSaved: (value) => postalCode = value!,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: submitForm,
                child: const Text("Adres Ekle"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
