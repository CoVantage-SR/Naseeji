// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class WalletBalanceCard extends StatelessWidget {
  final double available;
  final double pending;
  final double frozen;
  final VoidCallback? onWithdraw;

  const WalletBalanceCard({
    super.key,
    required this.available,
    required this.pending,
    required this.frozen,
    this.onWithdraw,
  });

  @override
  Widget build(BuildContext context) {
    final availableStr = available.toStringAsFixed(2);
    final pendingStr = pending.toStringAsFixed(2);
    final frozenStr = frozen.toStringAsFixed(2);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF002080),
            Color(0xFF0040E0),
          ],
          begin: Alignment.bottomRight,
          end: Alignment.topLeft,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0040E0).withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'الرصيد المتاح للسحب',
            textAlign: TextAlign.right,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                'جنيه',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.surface,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 6),
              Text(
                availableStr,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.surface,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          const Divider(color: Colors.white24, height: 1),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildBalanceDetailItem('الرصيد المجمد', frozenStr),
              Container(width: 1, height: 35, color: Colors.white24),
              _buildBalanceDetailItem('الرصيد المعلق', pendingStr),
            ],
          ),
          if (onWithdraw != null) ...[
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: onWithdraw,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.surface,
                foregroundColor: const Color(0xFF0040E0),
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.account_balance_wallet_outlined, size: 18),
                  SizedBox(width: 8),
                  Text(
                    'طلب سحب رصيد للبنك',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBalanceDetailItem(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 11,
            ),
          ),
          SizedBox(height: 4),
          Text(
            '$value جنيه',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

