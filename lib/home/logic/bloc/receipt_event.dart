part of 'receipt_bloc.dart';

sealed class ReceiptEvent {}

class MakeReceiptEvent extends ReceiptEvent{
  final Receipt receipt;

  MakeReceiptEvent(this.receipt);
}
