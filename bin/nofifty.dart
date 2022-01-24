import 'dart:io';
import 'package:args/args.dart';
import 'package:nofifty/obstructionum.dart';
import 'package:nofifty/gladiator.dart';
import 'package:nofifty/transaction.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'dart:isolate';
import 'package:nofifty/utils.dart';
import 'dart:convert';
import 'package:nofifty/exampla.dart';
import 'package:nofifty/constantes.dart';
import 'package:nofifty/pera.dart';
import 'package:test/expect.dart';
void main(List<String> arguments) async {
    var parser = ArgParser();
    parser.addOption('publica-clavis');
    parser.addOption('p2p-portus', defaultsTo: '5151');
    parser.addOption('rpc-portus', defaultsTo: '1515');
    parser.addOption('internum-ip', mandatory: true);
    parser.addOption('novus', help: 'Do you want to start a new chain?', mandatory: true);
    parser.addOption('directory', help: 'where should we save the blocks', mandatory: true);
    ReceivePort receivePort = ReceivePort();
    var aschargs = parser.parse(arguments);
    final publicaClavis = aschargs['publica-clavis'];
    final String isNew = aschargs['novus'];
    final directory = aschargs['directory'];
    final rpc_portus = aschargs['rpc-portus'];
    final internum_ip = aschargs['internum-ip'];
    if(publicaClavis == null) {
        KeyPair kp = KeyPair();
        print('Quaeso te condite privatis ac publicis clavis');
        print('privatis clavis: ${kp.private}');
        print('publica clavis: ${kp.public}');
        exit(0);
    }
    Directory principalisDirectory = await Directory(directory).create( recursive: true );
    if(isNew == 'true' && principalisDirectory.listSync().isEmpty) {
      final obstructionum = Obstructionum.incipio(InterioreObstructionum.incipio(producentis: publicaClavis));
      await obstructionum.salvareIncipio(principalisDirectory);
    }
    List<Propter> rationem = [];
    List<Transaction> libreTxs = [];
    List<Transaction> fixumTxs = [];
    var app = Router();
    app.post('/obstructionum', (Request request) async {
        final ObstructionumNumerus obstructionumNumerus = ObstructionumNumerus.fromJson(json.decode(await request.readAsString()));
        File file = File(principalisDirectory.path + '/caudices_' + (obstructionumNumerus.numerus.length-1).toString() + '.txt');
        return Response.ok(await Utils.fileAmnis(file).elementAt(obstructionumNumerus.numerus[obstructionumNumerus.numerus.length-1]));
    });
    app.post('/submittere-rationem', (Request request) async {
        final SubmittereRationem submittereRationem = SubmittereRationem.fromJson(json.decode(await request.readAsString()));
        if(!await Pera.isPublicaClavisDefended(submittereRationem.publicaClavis, principalisDirectory)) {
            return Response.forbidden(json.encode({
                "message": "Publica clavis iam defendi"
            }));
        }
        ReceivePort acciperePortus = ReceivePort();
        InterioreRationem interioreRationem = InterioreRationem(submittereRationem.publicaClavis, submittereRationem.zeros, BigInt.zero);
        await Isolate.spawn(Propter.quaestum, List<dynamic>.from([interioreRationem, acciperePortus.sendPort]));
        acciperePortus.listen((propter) {
            rationem.add(propter);
        });
        return Response.ok("");
    });
    app.post('/submittere-libre-transaction', (Request request) async {
        final SubmittereTransaction unCalcTx = SubmittereTransaction.fromJson(json.decode(await request.readAsString()));
        if (await Pera.isPublicaClavisDefended(unCalcTx.to, principalisDirectory) && !await Pera.isProbationum(unCalcTx.to, principalisDirectory)) {
            return Response.forbidden(json.encode({
                "message": "accipientis non defenditur"
            }));
        }
        final InterioreTransaction tx = await Pera.novamRem(true, unCalcTx.zeros, unCalcTx.from, unCalcTx.nof, unCalcTx.to, libreTxs, principalisDirectory);
        ReceivePort acciperePortus = ReceivePort();
        await Isolate.spawn(Transaction.quaestum, List<dynamic>.from([tx, acciperePortus.sendPort]));
        acciperePortus.listen((transaction) {
            libreTxs.add(transaction);
            print('asjfhajsfh');
        });
        return Response.ok("");
    });
    app.get('/libre-transaction-stagnum', (Request request) async {
       return Response.ok(json.encode(libreTxs.map((e) => e.toJson()).toList()));
    });
    app.get('/defensiones/<gladiatorId>', (Request request, String gladiatorId) async {
        List<String> def = await Pera.maximeDefensiones(gladiatorId, principalisDirectory);
        return Response.ok(json.encode(def));
    });
    app.post('/mine-efectus', (Request request) async {
        Obstructionum priorObstructionum = await Utils.priorObstructionum(principalisDirectory);
        ReceivePort acciperePortus = ReceivePort();
        GladiatorOutput gladiatorOutput =
        GladiatorOutput(rationem.where((propter) => propter.interioreRationem.zeros >= priorObstructionum.interioreObstructionum.propterDifficultas).take(10).toList());
        libreTxs.add(Transaction('blockreward', InterioreTransaction(true, 0, [], [TransactionOutput(publicaClavis, Constantes.ObstructionumPraemium)], Utils.randomHex(32))));
        InterioreObstructionum interiore = InterioreObstructionum.efectus(
            propterDifficultas:
            (priorObstructionum.interioreObstructionum.gladiator.output?.rationem.length ?? 0) < Constantes.PerRationesObstructionum ?
                (priorObstructionum.interioreObstructionum.propterDifficultas) - 1 :
                priorObstructionum.interioreObstructionum.propterDifficultas + 1,
            transactionDifficultas:
            (priorObstructionum.interioreObstructionum.liberTransactions.length ?? 0)  < Constantes.TxCaudice ?
                priorObstructionum.interioreObstructionum.transactionDifficultas - 1 :
                priorObstructionum.interioreObstructionum.transactionDifficultas + 1,
            obstructionumDifficultas: await Obstructionum.utDifficultas(principalisDirectory),
            summaObstructionumDifficultas: await Obstructionum.utSummaDifficultas(principalisDirectory),
            obstructionumNumerus: await Obstructionum.utObstructionumNumerus(principalisDirectory),
            producentis: publicaClavis,
            priorProbationem: priorObstructionum.probationem,
            gladiator: Gladiator(null, gladiatorOutput, Utils.randomHex(32)),
            liberTransactions: libreTxs,
            fixumTransactions: []
        );
        if(interiore.transactionDifficultas.isNegative) interiore.transactionDifficultas = 0;
        if(interiore.propterDifficultas.isNegative) interiore.propterDifficultas = 0;
        await Isolate.spawn(Obstructionum.efectus, List<dynamic>.from([interiore, acciperePortus.sendPort]));
        GladiatorOutput go = interiore.gladiator.output ?? GladiatorOutput([]);
        rationem.removeWhere((element) => element.interioreRationem.zeros < priorObstructionum.interioreObstructionum.propterDifficultas ||
                go.rationem.contains(element));
        libreTxs.removeWhere(
                (element) => element.interioreTransaction.zeros < priorObstructionum.interioreObstructionum.transactionDifficultas ||
                interiore.liberTransactions.contains(element)
        );
        acciperePortus.listen((nuntius) async {
            Obstructionum obstructionum = nuntius;
            await obstructionum.salvare(principalisDirectory);

        });
        return Response.ok("");
    });
    var server = await io.serve(app, internum_ip, int.parse(rpc_portus));
}
