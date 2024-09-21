import 'package:mule_common/mule_common.dart';

class AddressException extends InternalException {
  AddressException({required super.code, required super.message});
}

class UpdateAddressException extends AddressException {
  UpdateAddressException({required super.code, required super.message});
}

class GetAddressException extends AddressException {
  GetAddressException({required super.code, required super.message});
}
