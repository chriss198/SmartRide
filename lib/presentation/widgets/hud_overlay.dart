import 'package:flutter/material.dart';
import 'package:smartride/core/theme/app_theme.dart';
import 'package:smartride/domain/entities/profit_result.dart';

class HudOverlay extends StatelessWidget {
  const HudOverlay({
    super.key,
    required this.result,
    required this.destination,
  });

  final ProfitResult? result;
  final String destination;

  @override
  Widget build(BuildContext context) {
    final ok = result?.verdict ?? false;
    return Align(
      alignment: Alignment.topRight,
      child: Container(
        width: 220,
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.darkGrey.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(110),
          border: Border.all(color: AppTheme.brandOrange, width: 2),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(ok ? '✅' : '❌', style: const TextStyle(fontSize: 36)),
            Text(
              '\$${(result?.netProfit ?? 0).toStringAsFixed(0)}',
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            Text(
              destination,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
