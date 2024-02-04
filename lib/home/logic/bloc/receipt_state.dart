part of 'receipt_bloc.dart';

sealed class ReceiptState {}

final class ReceiptInitial extends ReceiptState {}

class ReceiptSuccess extends ReceiptState {
  Uint8List image;
  ReceiptSuccess(this.image);
}

class ReceiptError extends ReceiptState {}
