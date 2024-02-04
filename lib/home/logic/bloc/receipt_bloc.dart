import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resid_saz/constants/api/api.dart';
import 'package:resid_saz/constants/model/receipt.dart';

part 'receipt_event.dart';
part 'receipt_state.dart';

class ReceiptBloc extends Bloc<ReceiptEvent, ReceiptState> {
  ReceiptBloc() : super(ReceiptInitial()) {
    on<MakeReceiptEvent>((event, emit) async {
      try {
        final responce = await dio.post(
          Api.make,
          data: event.receipt.toJson(),
          options: Options(
            responseType: ResponseType.bytes,
          ),
        );
        emit(ReceiptSuccess(responce.data));
      } catch (_) {
        emit(ReceiptError());
      }
    });
  }
}
