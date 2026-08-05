import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/supplier_credits.dart';
import '../../domain/repositories/credits_repository.dart';

class CreditsRepositoryImpl implements CreditsRepository {
  static const String _kWelcomeGranted = 'supplier_welcome_credits_granted';
  static const String _kCreditsBalance = 'supplier_credits_balance';
  static const String _kFreeProducts = 'supplier_free_products_remaining';
  static const String _kTrialEndDate = 'supplier_premium_trial_end_date';
  static const String _kBlueStatus = 'supplier_blue_verification_status';

  // In-memory cache
  SupplierCredits? _cache;

  @override
  Future<SupplierCredits> getCredits() async {
    if (_cache != null) return _cache!;

    final prefs = await SharedPreferences.getInstance();
    final welcomeGranted = prefs.getBool(_kWelcomeGranted) ?? false;
    
    if (!welcomeGranted) {
      // Uninitialized new supplier: grant 60 welcome credits immediately
      return grantWelcomePackage();
    }

    final balance = prefs.getInt(_kCreditsBalance) ?? 60;
    final freeProducts = prefs.getInt(_kFreeProducts) ?? 5;
    final trialStr = prefs.getString(_kTrialEndDate);
    final blueStatus = prefs.getString(_kBlueStatus) ?? 'none';

    DateTime? trialEnd;
    if (trialStr != null) {
      trialEnd = DateTime.tryParse(trialStr);
    }

    _cache = SupplierCredits(
      welcomeCreditsGranted: welcomeGranted,
      creditsBalance: balance,
      freeProductsRemaining: freeProducts,
      premiumTrialEndDate: trialEnd,
      blueVerificationStatus: blueStatus,
    );

    return _cache!;
  }

  @override
  Future<SupplierCredits> grantWelcomePackage() async {
    final prefs = await SharedPreferences.getInstance();
    final alreadyGranted = prefs.getBool(_kWelcomeGranted) ?? false;

    if (alreadyGranted && _cache != null) {
      return _cache!;
    }

    final trialEnd = DateTime.now().add(const Duration(days: 30));

    await prefs.setBool(_kWelcomeGranted, true);
    await prefs.setInt(_kCreditsBalance, 60);
    await prefs.setInt(_kFreeProducts, 5);
    await prefs.setString(_kTrialEndDate, trialEnd.toIso8601String());
    await prefs.setString(_kBlueStatus, 'none');

    _cache = SupplierCredits(
      welcomeCreditsGranted: true,
      creditsBalance: 60,
      freeProductsRemaining: 5,
      premiumTrialEndDate: trialEnd,
      blueVerificationStatus: 'none',
    );

    return _cache!;
  }

  @override
  Future<SupplierCredits?> consumeForProduct() async {
    final current = await getCredits();

    if (current.freeProductsRemaining > 0) {
      final updated = current.copyWith(
        freeProductsRemaining: current.freeProductsRemaining - 1,
      );
      await _save(updated);
      return updated;
    }

    // After first 5 products: costs 5 credits
    if (current.creditsBalance >= 5) {
      final updated = current.copyWith(
        creditsBalance: current.creditsBalance - 5,
      );
      await _save(updated);
      return updated;
    }

    // Insufficient credits
    return null;
  }

  @override
  Future<SupplierCredits?> consumeForVideo() async {
    final current = await getCredits();

    // Video costs 10 credits
    if (current.creditsBalance >= 10) {
      final updated = current.copyWith(
        creditsBalance: current.creditsBalance - 10,
      );
      await _save(updated);
      return updated;
    }

    // Insufficient credits
    return null;
  }

  @override
  Future<SupplierCredits> requestBlueVerification() async {
    final current = await getCredits();
    final updated = current.copyWith(blueVerificationStatus: 'pending');
    await _save(updated);
    return updated;
  }

  @override
  Future<SupplierCredits?> approveBlueVerification() async {
    final current = await getCredits();

    // Blue Verification costs 35 credits ONLY after approval
    if (current.creditsBalance >= 35) {
      final updated = current.copyWith(
        creditsBalance: current.creditsBalance - 35,
        blueVerificationStatus: 'approved',
      );
      await _save(updated);
      return updated;
    }

    return null;
  }

  @override
  Future<SupplierCredits> buyCredits(int count) async {
    final current = await getCredits();
    final updated = current.copyWith(
      creditsBalance: current.creditsBalance + count,
    );
    await _save(updated);
    return updated;
  }

  Future<void> _save(SupplierCredits credits) async {
    _cache = credits;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kWelcomeGranted, credits.welcomeCreditsGranted);
    await prefs.setInt(_kCreditsBalance, credits.creditsBalance);
    await prefs.setInt(_kFreeProducts, credits.freeProductsRemaining);
    if (credits.premiumTrialEndDate != null) {
      await prefs.setString(_kTrialEndDate, credits.premiumTrialEndDate!.toIso8601String());
    }
    await prefs.setString(_kBlueStatus, credits.blueVerificationStatus);
  }
}
