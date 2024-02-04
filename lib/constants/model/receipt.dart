import 'package:flutter/material.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

class Receipt {
  final String sender;
  final String senderCard;
  final String receiver;
  final String receiverCard;
  final String amount;
  final String code;
  final Jalali? date;
  final TimeOfDay? time;

  Receipt({
    required this.sender,
    required this.senderCard,
    required this.receiver,
    required this.receiverCard,
    required this.amount,
    required this.code,
    required this.date,
    required this.time,
  });

  Map<String, dynamic> toJson() {
    return {
      'sender': sender,
      'sender_card': senderCard,
      'receiver': receiver,
      'receiver_card': receiverCard,
      'amount': int.tryParse(amount),
      'code': code,
      'date':
          '${date?.formatter.wN.replaceFirst(' ', '‌‌')}، ${date?.formatter.d} ${date?.formatter.mN} ${date?.formatter.yyyy}',
      'time':
          '${time?.hour.toString().padLeft(2, "0")}:${time?.minute.toString().padLeft(2, "0")}'
    };
  }
}
