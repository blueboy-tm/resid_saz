import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:resid_saz/constants/api/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddressDialog extends StatefulWidget {
  const AddressDialog({super.key});

  @override
  State<AddressDialog> createState() => _AddressDialogState();
}

class _AddressDialogState extends State<AddressDialog> {
  final address = TextEditingController(text: dio.options.baseUrl);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: 300,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: address,
                textDirection: TextDirection.ltr,
                textAlign: TextAlign.left,
                decoration: const InputDecoration(
                  labelText: 'آدرس سرور',
                  prefixIcon: Icon(Icons.wifi),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  final db = await SharedPreferences.getInstance();
                  await db.setString('address', address.text);
                  dio.options.baseUrl = address.text;
                  if (mounted) {
                    context.pop();
                  }
                },
                child: const Text('ذخیره'),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
