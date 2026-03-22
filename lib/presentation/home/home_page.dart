import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/router/app_router.dart';
import '../../data/models/cuenta_model.dart';
import '../../data/models/transaccion_model.dart';
import '../../data/repositories/cuenta_repository.dart';
import '../../data/repositories/transaccion_repository.dart';
import '../widgets/common_widgets.dart';
import '../navigation/flyout_menu.dart';

class HomePage extends StatefulWidget {
  final int initialIndex;

  const HomePage({super.key, this.initialIndex = 0});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CuentaRepository _cuentaRepository = CuentaRepository();
  final TransaccionRepository _transaccionRepository = TransaccionRepository();

  bool _isLoading = true;
  List<CuentaModel> _cuentas = [];
  List<TransaccionModel> _transacciones = [];
  double _saldoTotal = 0.0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    try {
      final cuentas = await _cuentaRepository.obtenerTodos();
      final transacciones = await _transaccionRepository.obtenerUltimas(5);

      final saldoTotal = cuentas
          .where((c) => c.activa)
          .fold(0.0, (sum, cuenta) => sum + cuenta.saldo);

      if (mounted) {
        setState(() {
          _cuentas = cuentas.where((c) => c.activa).toList();
          _transacciones = transacciones;
          _saldoTotal = saldoTotal;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appName),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: const FlyoutMenu(),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SaldoCard(
                saldoTotal: _saldoTotal,
                isLoading: _isLoading,
              ),
              const SizedBox(height: 8),
              _buildQuickAccess(),
              const SizedBox(height: 16),
              const SectionHeader(titulo: AppStrings.homeUltimasTransacciones),
              _buildTransacciones(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickAccess() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(titulo: AppStrings.homeAccesosRapidos),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: QuickAccessButton(
                  icon: Icons.account_balance_wallet_outlined,
                  label: AppStrings.menuCuentas,
                  color: AppColors.primary,
                  onTap: () => AppRouter.navigateTo(context, RouteNames.cuentas),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: QuickAccessButton(
                  icon: Icons.swap_horiz_outlined,
                  label: AppStrings.menuTransferencias,
                  color: AppColors.secondary,
                  onTap: () => AppRouter.navigateTo(context, RouteNames.transferencias),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: QuickAccessButton(
                  icon: Icons.person_outline,
                  label: AppStrings.menuPerfil,
                  color: AppColors.accent,
                  onTap: () => AppRouter.navigateTo(context, RouteNames.perfil),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTransacciones() {
    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.all(32),
        child: LoadingWidget(mensaje: 'Cargando transacciones...'),
      );
    }

    if (_transacciones.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(32),
        child: EmptyStateWidget(
          icon: Icons.receipt_long_outlined,
          mensaje: AppStrings.homeSinTransacciones,
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _transacciones.length,
      itemBuilder: (context, index) {
        final transaccion = _transacciones[index];
        final cuenta = _cuentas.cast<CuentaModel?>().firstWhere(
              (c) => c?.id == transaccion.cuentaId,
              orElse: () => null,
            );

        return TransaccionItem(
          transaccion: transaccion,
          cuenta: cuenta,
        );
      },
    );
  }
}
