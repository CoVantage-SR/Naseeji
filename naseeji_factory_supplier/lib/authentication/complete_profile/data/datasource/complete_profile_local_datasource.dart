import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/company_model.dart';

abstract class CompleteProfileLocalDatasource {
  Future<void> cacheCompanyProfile(CompanyModel company);
  Future<CompanyModel?> getCachedCompanyProfile();
  Future<void> clearCachedCompanyProfile();
}

class CompleteProfileLocalDatasourceImpl
    implements CompleteProfileLocalDatasource {
  static const String _companyKey = 'cached_company_profile';
  final SharedPreferences? prefs;

  CompleteProfileLocalDatasourceImpl({this.prefs});

  @override
  Future<void> cacheCompanyProfile(CompanyModel company) async {
    final instance = prefs ?? await SharedPreferences.getInstance();
    final jsonStr = jsonEncode(company.toJson());
    await instance.setString(_companyKey, jsonStr);
  }

  @override
  Future<CompanyModel?> getCachedCompanyProfile() async {
    final instance = prefs ?? await SharedPreferences.getInstance();
    final jsonStr = instance.getString(_companyKey);
    if (jsonStr == null || jsonStr.isEmpty) return null;
    try {
      final map = jsonDecode(jsonStr) as Map<String, dynamic>;
      return CompanyModel.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> clearCachedCompanyProfile() async {
    final instance = prefs ?? await SharedPreferences.getInstance();
    await instance.remove(_companyKey);
  }
}
