import 'package:flutter/material.dart';
import 'package:flutter_application_1/AddressFormPage.dart';
import 'package:flutter_application_1/Models/address.dart';

class AddressDetailPage extends StatefulWidget {
  final int id;

  const AddressDetailPage({super.key, required this.id});

  @override
  State<AddressDetailPage> createState() => _AddressDetailPageState();
}

class _AddressDetailPageState extends State<AddressDetailPage> {
  Address? address;
  final _formKey = GlobalKey<FormState>();

  String addressLine1 = '';
  String city = '';
  String stateProvince = '';
  String countryRegion = '';
  String postalCode = '';

  @override
  void initState() {
    super.initState();
    loadAddressDetail();
  }

  Future<void> loadAddressDetail() async {
    try {
      final detail = await apiService.getAddressById(widget.id);
      print("Gelen veri: $detail");
      if (detail != null) {
        setState(() {
          address = detail;
          addressLine1 = detail.addressLine1;
          city = detail.city;
          stateProvince = detail.stateProvince;
          countryRegion = detail.countryRegion;
          postalCode = detail.postalCode;
        });
      } else {
        print("Adres bulunamadı!");
      }
    } catch (e) {
      print("Detay hatası: $e");
    }
  }

  Future<void> updateAddress() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Address updatedAddress = Address(
        addressID: address!.addressID,
        addressLine1: addressLine1,
        city: city,
        stateProvince: stateProvince,
        countryRegion: countryRegion,
        postalCode: postalCode,
      );

      try {
        await apiService.updateAddress(widget.id, updatedAddress);
        Navigator.pop(context, true);
      } catch (e) {
        print("Adres güncellenemedi: $e");
        Navigator.pop(context, false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("ID: ${widget.id} Detayları")),
      body: address == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      initialValue: addressLine1,
                      decoration: const InputDecoration(labelText: "Address Line 1"),
                      validator: (value) => value!.isEmpty ? 'Adres satırı boş olamaz' : null,
                      onSaved: (value) => addressLine1 = value!,
                    ),
                    TextFormField(
                      initialValue: city,
                      decoration: const InputDecoration(labelText: "City"),
                      validator: (value) => value!.isEmpty ? 'Şehir boş olamaz' : null,
                      onSaved: (value) => city = value!,
                    ),
                    TextFormField(
                      initialValue: stateProvince,
                      decoration: const InputDecoration(labelText: "State/Province"),
                      validator: (value) => value!.isEmpty ? 'Eyalet/il boş olamaz' : null,
                      onSaved: (value) => stateProvince = value!,
                    ),
                    TextFormField(
                      initialValue: countryRegion,
                      decoration: const InputDecoration(labelText: "Country/Region"),
                      validator: (value) => value!.isEmpty ? 'Ülke/Bölge boş olamaz' : null,
                      onSaved: (value) => countryRegion = value!,
                    ),
                    TextFormField(
                      initialValue: postalCode,
                      decoration: const InputDecoration(labelText: "Postal Code"),
                      validator: (value) => value!.isEmpty ? 'Posta kodu boş olamaz' : null,
                      onSaved: (value) => postalCode = value!,
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: updateAddress,
                      child: const Text("Adres Güncelle"),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
