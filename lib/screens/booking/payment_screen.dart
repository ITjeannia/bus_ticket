import 'package:flutter/material.dart';

import '../../data/app_exception.dart';
import '../../data/auth_service.dart';
import '../../data/booking_repository.dart';
import '../../data/mock_data.dart';
import '../../models/payment_method.dart';
import '../../models/trip.dart';
import '../../routes/app_routes.dart';
import '../../routes/main_tabs.dart';
import '../../constants/app_strings.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';
import '../../utils/formatters.dart';
import '../../utils/validators.dart';
import '../../widgets/alert_banner.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/option_tile.dart';
import '../../widgets/primary_button.dart';
import 'widgets/price_summary_card.dart';

/// Maquettes 06 (normal), 06b (refusé), 06c (en cours).
class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key, required this.trip, required this.seats});

  final Trip trip;
  final List<int> seats;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late final _accountController = TextEditingController(
    text: AuthService.instance.currentUser.value?.phone ?? '',
  );
  final _fieldKey = GlobalKey();
  PaymentMethod _method = PaymentMethod.mobileMoney;
  bool _isPaying = false;
  bool _wasRefused = false;
  String? _fieldError;

  int get _total => widget.trip.price * widget.seats.length + MockData.serviceFee;

  @override
  void dispose() {
    _accountController.dispose();
    super.dispose();
  }

  void _selectMethod(PaymentMethod method) => setState(() {
        _method = method;
        _fieldError = null;
        _accountController.text = method == PaymentMethod.mobileMoney
            ? AuthService.instance.currentUser.value?.phone ?? ''
            : '';
      });

  Future<void> _pay() async {
    final error = _method == PaymentMethod.mobileMoney
        ? Validators.phone(_accountController.text)
        : Validators.cardNumber(_accountController.text);
    setState(() => _fieldError = error);
    if (error != null) return;

    setState(() {
      _isPaying = true;
      _wasRefused = false;
    });
    try {
      final booking = await BookingRepository.instance.pay(
        trip: widget.trip,
        seats: widget.seats,
        passengerName: AuthService.instance.currentUser.value?.fullName ?? '',
        method: _method,
        accountNumber: _accountController.text,
      );
      if (!mounted) return;
      MainTabs.current.value = MainTabs.tickets;
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.ticket,
        ModalRoute.withName(AppRoutes.main),
        arguments: booking,
      );
    } on AppException catch (e) {
      setState(() {
        _wasRefused = true;
        _fieldError = e.message;
      });
      _revealField();
    } finally {
      if (mounted) setState(() => _isPaying = false);
    }
  }

  /// Fait défiler jusqu'au champ pour que son message d'erreur soit visible.
  void _revealField() => WidgetsBinding.instance.addPostFrameCallback((_) {
        final fieldContext = _fieldKey.currentContext;
        if (fieldContext != null && fieldContext.mounted) {
          Scrollable.ensureVisible(fieldContext, alignment: 0.5, duration: const Duration(milliseconds: 300));
        }
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Paiement')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        children: [
          if (_wasRefused) ...[
            const AlertBanner.error(
              'Paiement refusé. Vérifiez vos informations ou choisissez un autre moyen de paiement.',
            ),
            const SizedBox(height: AppSpacing.md - 4),
          ],
          PriceSummaryCard(trip: widget.trip, seats: widget.seats, serviceFee: MockData.serviceFee),
          const SizedBox(height: AppSpacing.lg),
          const Text('Moyen de paiement', style: AppTextStyles.title),
          const SizedBox(height: AppSpacing.md),
          for (final method in PaymentMethod.values) ...[
            OptionTile(
              label: method.label,
              description: method.description,
              icon: method.icon,
              selected: method == _method,
              enabled: !_isPaying,
              onTap: () => _selectMethod(method),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
          AppTextField(
            key: _fieldKey,
            label: _method.fieldLabel,
            hint: _method.fieldHint,
            controller: _accountController,
            prefixIcon: _method.fieldIcon,
            keyboardType: TextInputType.phone,
            enabled: !_isPaying,
            errorText: _fieldError,
            onChanged: (_) => setState(() => _fieldError = null),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.sm, AppSpacing.md, AppSpacing.sm),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              PrimaryButton(
                label: _wasRefused ? 'Réessayer le paiement' : 'Payer ${Formatters.price(_total)}',
                loadingLabel: 'Paiement en cours…',
                isLoading: _isPaying,
                onPressed: _pay,
              ),
              const SizedBox(height: AppSpacing.md - 4),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lock_outline, size: 16, color: AppColors.textSecondary),
                  SizedBox(width: AppSpacing.xs),
                  Flexible(child: Text(AppStrings.securePayment, style: AppTextStyles.small)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
