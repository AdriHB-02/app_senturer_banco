import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../data/models/cuenta_model.dart';
import '../../data/models/transaccion_model.dart';
import '../../data/repositories/cuenta_repository.dart';
import '../../data/repositories/transaccion_repository.dart';
import '../navigation/flyout_menu.dart';
import '../widgets/common_widgets.dart';

class CuentasPage extends StatefulWidget {
  final int initialTabIndex;

  const CuentasPage({super.key, this.initialTabIndex = 0});

  @override
  State<CuentasPage> createState() => _CuentasPageState();
}

class _CuentasPageState extends State<CuentasPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final CuentaRepository _cuentaRepository = CuentaRepository();
  final TransaccionRepository _transaccionRepository = TransaccionRepository();

  bool _isLoadingCuentas = true;
  bool _isLoadingTransacciones = true;
  List<CuentaModel> _cuentas = [];
  List<TransaccionModel> _transacciones = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialTabIndex,
    );
    _loadData();
  }

  Future<void> _loadData() async {
    await Future.wait([_loadCuentas(), _loadTransacciones()]);
  }

  Future<void> _loadCuentas() async {
    setState(() => _isLoadingCuentas = true);
    try {
      final cuentas = await _cuentaRepository.obtenerTodos();
      if (mounted) {
        setState(() {
          _cuentas = cuentas.where((c) => c.activa).toList();
          _isLoadingCuentas = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingCuentas = false);
      }
    }
  }

  Future<void> _loadTransacciones() async {
    setState(() => _isLoadingTransacciones = true);
    try {
      final transacciones = await _transaccionRepository.obtenerUltimas(20);
      if (mounted) {
        setState(() {
          _transacciones = transacciones;
          _isLoadingTransacciones = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingTransacciones = false);
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _getTipoCuentaLabel(TipoCuenta tipo) {
    switch (tipo) {
      case TipoCuenta.ahorro:
        return 'Cuenta de Ahorro';
      case TipoCuenta.corriente:
        return 'Cuenta Corriente';
      case TipoCuenta.digital:
        return 'Cuenta Digital';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.menuCuentas),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: AppColors.primaryLight,
          indicatorColor: Colors.white,
          indicatorSize: TabBarIndicatorSize.tab,
          dividerColor: Colors.transparent,
          tabs: const [
            Tab(
              icon: Icon(Icons.credit_card_outlined),
              text: AppStrings.tabMisCuentas,
            ),
            Tab(
              icon: Icon(Icons.receipt_long_outlined),
              text: AppStrings.tabMovimientos,
            ),
          ],
        ),
      ),
      drawer: const FlyoutMenu(),
      body: TabBarView(
        controller: _tabController,
        children: [_buildTabMisCuentas(), _buildTabMovimientos()],
      ),
    );
  }

  Widget _buildTabMisCuentas() {
    if (_isLoadingCuentas) {
      return const LoadingWidget(mensaje: 'Cargando cuentas...');
    }

    if (_cuentas.isEmpty) {
      return const EmptyStateWidget(
        icon: Icons.account_balance_wallet_outlined,
        mensaje: AppStrings.estadoVacioCuentas,
      );
    }

    return RefreshIndicator(
      onRefresh: _loadCuentas,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _cuentas.length,
        itemBuilder: (context, index) {
          final cuenta = _cuentas[index];
          return _buildCuentaCard(cuenta);
        },
      ),
    );
  }

  Widget _buildCuentaCard(CuentaModel cuenta) {
    IconData tipoIcon;
    Color tipoColor;

    switch (cuenta.tipo) {
      case TipoCuenta.ahorro:
        tipoIcon = Icons.savings_outlined;
        tipoColor = AppColors.success;
        break;
      case TipoCuenta.corriente:
        tipoIcon = Icons.account_balance_outlined;
        tipoColor = AppColors.primary;
        break;
      case TipoCuenta.digital:
        tipoIcon = Icons.phone_android_outlined;
        tipoColor = AppColors.secondary;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: tipoColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(tipoIcon, color: tipoColor, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getTipoCuentaLabel(cuenta.tipo),
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        cuenta.numeroCuenta,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textHint,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Activa',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppColors.success,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Saldo disponible',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  '${cuenta.moneda} \$${cuenta.saldo.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabMovimientos() {
    if (_isLoadingTransacciones) {
      return const LoadingWidget(mensaje: 'Cargando movimientos...');
    }

    if (_transacciones.isEmpty) {
      return const EmptyStateWidget(
        icon: Icons.receipt_long_outlined,
        mensaje: AppStrings.estadoVacioTransacciones,
      );
    }

    return RefreshIndicator(
      onRefresh: _loadTransacciones,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: _transacciones.length,
        itemBuilder: (context, index) {
          final transaccion = _transacciones[index];
          final cuenta = _cuentas.cast<CuentaModel?>().firstWhere(
            (c) => c?.id == transaccion.cuentaId,
            orElse: () => null,
          );
          return TransaccionItem(transaccion: transaccion, cuenta: cuenta);
        },
      ),
    );
  }
}
