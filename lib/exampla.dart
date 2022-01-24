import 'dart:convert';
import 'package:ecdsa/ecdsa.dart';
import 'package:elliptic/elliptic.dart';
class ObstructionumNumerus {
  final List<int> numerus;
  Map<String, dynamic> toJson() => {
    'numerus': numerus
  };
  ObstructionumNumerus.fromJson(Map<String, dynamic> jsoschon): numerus = List<int>.from(jsoschon['numerus']);
}
class KeyPair {
  late String private;
  late String public;
  KeyPair() {
    final ec = getP256();
    final key = ec.generatePrivateKey();
    private = key.toHex();
    public = key.publicKey.toHex();
  }
}
class SubmittereRationem {
  final int zeros;
  final String publicaClavis;
  SubmittereRationem.fromJson(Map<String, dynamic> jsoschon):
  zeros = jsoschon['zeros'],
  publicaClavis = jsoschon['publicaClavis'];
}
class SubmittereTransaction {
  final int zeros;
  final String from;
  final String to;
  final BigInt nof;
  SubmittereTransaction(this.zeros, this.from, this.to, this.nof);
  SubmittereTransaction.fromJson(Map<String, dynamic> jsoschon):
      zeros = jsoschon['zeros'],
      from = jsoschon['from'],
      to = jsoschon['to'],
      nof = BigInt.parse(jsoschon['nof']);
}
class RemoveTransaction {
  final bool liber;
  final String transactionId;
  final String publicaClavis;
  RemoveTransaction(this.liber, this.transactionId, this.publicaClavis);
  RemoveTransaction.fromJson(Map<String, dynamic> jsoschon):
      liber = jsoschon['liber'],
      transactionId = jsoschon['transactionId'],
      publicaClavis = jsoschon['publicaClavis'];
}