import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../data/models/cuenta_model.dart';
import '../../data/models/transaccion_model.dart';
import '../../data/repositories/cuenta_repository.dart';
import '../../data/repositories/transaccion_repository.dart';
import '../navigation/flyout_menu.dart';
import '../widgets/common_widgets.dart';

class TransferenciasPage extends StatefulWidget {
  const TransferenciasPage({super.key});

  @override
  State<TransferenciasPage> createState() => _TransferenciasPageState();
}

class _TransferenciasPageState extends State<TransferenciasPage> {
  final _formKey = GlobalKey<FormState>();
  final _cuentaRepository = CuentaRepository();
  final _transaccionRepository = TransaccionRepository();
  final _numeroDestinoController = TextEditingController();
  final _montoController = TextEditingController();
  final _descripcionController = TextEditingController();

  List<CuentaModel> _cuentas = [];
  CuentaModel? _cuentaOrigenSeleccionada;
  bool _isLoading = true;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _loadCuentas();
  }

  Future<void> _loadCuentas() async {
    setState(() => _isLoading = true);
    try {
      final cuentas = await _cuentaRepository.obtenerTodos();
      if (mounted) {
        setState(() {
          _cuentas = cuentas.where((c) => c.activa).toList();
          if (_cuentas.isNotEmpty) {
            _cuentaOrigenSeleccionada = _cuentas.first;
          }
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String? _validarNumeroDestino(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Ingrese el número de cuenta destino';
    }
    if (value.trim() == _cuentaOrigenSeleccionada?.numeroCuenta) {
      return 'No puede transferir a la misma cuenta';
    }
    return null;
  }

  String? _validarMonto(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Ingrese el monto a transferir';
    }
    final monto = double.tryParse(value);
    if (monto == null || monto <= 0) {
      return 'Monto inválido';
    }
    if (_cuentaOrigenSeleccionada != null &&
        monto > _cuentaOrigenSeleccionada!.saldo) {
      return 'Saldo insuficiente';
    }
    return null;
  }

  Future<void> _realizarTransferencia() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isProcessing = true);

    try {
      final monto = double.parse(_montoController.text);
      final cuentaOrigen = _cuentaOrigenSeleccionada!;

      final transaccion = TransaccionModel(
        cuentaId: cuentaOrigen.id!,
        tipo: TipoTransaccion.transferencia,
        monto: monto,
        descripcion: _descripcionController.text.isNotEmpty
            ? _descripcionController.text
            : 'Transferencia a ${_numeroDestinoController.text}',
        fecha: DateTime.now().toIso8601String(),
        estado: EstadoTransaccion.completada,
      );

      await _transaccionRepository.insertar(transaccion);

      final nuevoSaldo = cuentaOrigen.saldo - monto;
      await _cuentaRepository.actualizarSaldo(cuentaOrigen.id!, nuevoSaldo);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Transferencia realizada con éxito'),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
          ),
        );
        _numeroDestinoController.clear();
        _montoController.clear();
        _descripcionController.clear();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error al realizar la transferencia'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  @override
  void dispose() {
    _numeroDestinoController.dispose();
    _montoController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.menuTransferencias),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: const FlyoutMenu(),
      body: _isLoading
          ? const LoadingWidget(mensaje: 'Cargando cuentas...')
          : _cuentas.isEmpty
          ? const EmptyStateWidget(
              icon: Icons.account_balance_wallet_outlined,
              mensaje: AppStrings.estadoVacioCuentas,
            )
          : _buildForm(),
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.swap_horiz_rounded,
                          color: AppColors.primary,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Nueva Transferencia',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Cuenta de Origen',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<CuentaModel>(
                        value: _cuentaOrigenSeleccionada,
                        isExpanded: true,
                        items: _cuentas.map((cuenta) {
                          return DropdownMenuItem(
                            value: cuenta,
                            child: Text(
                              '${cuenta.numeroCuenta} - \$${cuenta.saldo.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _cuentaOrigenSeleccionada = value;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Número de Cuenta Destino',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _numeroDestinoController,
                    decoration: const InputDecoration(
                      hintText: 'Ingrese el número de cuenta',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    keyboardType: TextInputType.text,
                    validator: _validarNumeroDestino,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Monto a Transferir',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _montoController,
                    decoration: const InputDecoration(
                      hintText: '0.00',
                      prefixIcon: Icon(Icons.attach_money),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,2}'),
                      ),
                    ],
                    validator: _validarMonto,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Descripción (Opcional)',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _descripcionController,
                    decoration: const InputDecoration(
                      hintText: 'Agregue una referencia',
                      prefixIcon: Icon(Icons.note_outlined),
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isProcessing ? null : _realizarTransferencia,
                      child: _isProcessing
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Realizar Transferencia',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
