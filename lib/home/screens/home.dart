import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:resid_saz/constants/model/receipt.dart';
import 'package:resid_saz/constants/utils/random.dart';
import 'package:resid_saz/home/logic/bloc/receipt_bloc.dart';
import 'package:resid_saz/home/widget/address_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Widget makeField({required String label, TextEditingController? controller}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
      ),
    );
  }

  final sender = TextEditingController();
  final senderCard = TextEditingController();
  final receiver = TextEditingController();
  final receiverCard = TextEditingController();
  final amount = TextEditingController();
  final code = TextEditingController();
  Jalali? date;
  TimeOfDay? time;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.small(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const AddressDialog(),
          );
        },
        child: const Icon(Icons.wifi),
      ),
      body: BlocListener<ReceiptBloc, ReceiptState>(
        listener: (context, state) {
          if (state is ReceiptError) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('ساخت رسید با خطا مواجه شد.'),
              ),
            );
          } else if (state is ReceiptSuccess) {
            context.push('/receipt', extra: state.image);
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  makeField(label: 'واریز کننده', controller: sender),
                  const SizedBox(height: 10),
                  makeField(label: 'شماره کارت', controller: senderCard),
                  const SizedBox(height: 10),
                  makeField(label: 'دریافت کننده', controller: receiver),
                  const SizedBox(height: 10),
                  makeField(label: 'شماره کارت', controller: receiverCard),
                  const SizedBox(height: 10),
                  makeField(label: 'مبلغ', controller: amount),
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: makeField(label: 'شماره مرجع', controller: code),
                      ),
                      const SizedBox(width: 15),
                      ElevatedButton(
                        onPressed: () {
                          code.text = createRandomID();
                        },
                        child: const Text('ساخت تصادفی'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Text('تاریخ:'),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () async {
                          date = await showPersianDatePicker(
                            context: context,
                            initialDate: Jalali.now(),
                            firstDate: Jalali(1384),
                            lastDate: Jalali(1500),
                          );
                          setState(() {});
                        },
                        child: const Text('انتخاب'),
                      ),
                      const SizedBox(width: 10),
                      Text(date?.formatFullDate() ?? ''),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Text('ساعت:'),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () async {
                          time = await showPersianTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          setState(() {});
                        },
                        child: const Text('انتخاب'),
                      ),
                      const SizedBox(width: 10),
                      Text(time?.format(context) ?? ''),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ReceiptBloc>().add(
                            MakeReceiptEvent(
                              Receipt(
                                sender: sender.text,
                                senderCard: senderCard.text,
                                receiver: receiver.text,
                                receiverCard: receiverCard.text,
                                amount: amount.text,
                                code: code.text,
                                date: date,
                                time: time,
                              ),
                            ),
                          );
                    },
                    child: const Text('مشاهده'),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
