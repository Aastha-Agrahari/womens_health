import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final bool outlined;
  const AppButton({super.key, required this.label, this.onPressed, this.loading=false, this.outlined=false});

  @override Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: outlined
          ? OutlinedButton(
        onPressed: loading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          side: const BorderSide(color: AppColors.lavenderDeep),
          foregroundColor: AppColors.lavenderDeep,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        child: loading ? const _Loader(color: AppColors.lavenderDeep) : Text(label),
      )
          : ElevatedButton(
        onPressed: loading ? null : onPressed,
        child: loading ? const _Loader() : Text(label),
      ),
    );
  }
}

class _Loader extends StatelessWidget {
  final Color color;
  const _Loader({this.color = Colors.white});
  @override Widget build(_) => SizedBox(
      height: 20, width: 20,
      child: CircularProgressIndicator(strokeWidth: 2, color: color));
}