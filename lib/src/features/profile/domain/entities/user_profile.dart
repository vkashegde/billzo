import 'package:equatable/equatable.dart';

enum MembershipType { free, premium, enterprise }

class UserProfile extends Equatable {
  final String id;
  final String name;
  final String? companyName;
  final String? email;
  final String? avatarUrl;
  final MembershipType membership;

  // Business Details
  final String? businessAddress;
  final String? taxId;
  final String currency;
  final String currencySymbol;

  // App Settings
  final bool emailNotifications;
  final bool pushNotifications;
  final bool twoFactorAuth;
  final String themeMode; // 'light', 'dark', 'auto'

  const UserProfile({
    required this.id,
    required this.name,
    this.companyName,
    this.email,
    this.avatarUrl,
    this.membership = MembershipType.free,
    this.businessAddress,
    this.taxId,
    this.currency = 'INR',
    this.currencySymbol = '₹',
    this.emailNotifications = true,
    this.pushNotifications = true,
    this.twoFactorAuth = false,
    this.themeMode = 'light',
  });

  String get membershipLabel {
    switch (membership) {
      case MembershipType.premium:
        return 'PREMIUM MEMBER';
      case MembershipType.enterprise:
        return 'ENTERPRISE';
      case MembershipType.free:
        return 'FREE PLAN';
    }
  }

  String get currencyDisplay =>
      '$currency ($currencySymbol) - ${_getCurrencyName()}';

  String _getCurrencyName() {
    switch (currency) {
      case 'USD':
        return 'US Dollar';
      case 'EUR':
        return 'Euro';
      case 'GBP':
        return 'British Pound';
      case 'INR':
        return 'Indian Rupee';
      default:
        return currency;
    }
  }

  UserProfile copyWith({
    String? id,
    String? name,
    String? companyName,
    String? email,
    String? avatarUrl,
    MembershipType? membership,
    String? businessAddress,
    String? taxId,
    String? currency,
    String? currencySymbol,
    bool? emailNotifications,
    bool? pushNotifications,
    bool? twoFactorAuth,
    String? themeMode,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      companyName: companyName ?? this.companyName,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      membership: membership ?? this.membership,
      businessAddress: businessAddress ?? this.businessAddress,
      taxId: taxId ?? this.taxId,
      currency: currency ?? this.currency,
      currencySymbol: currencySymbol ?? this.currencySymbol,
      emailNotifications: emailNotifications ?? this.emailNotifications,
      pushNotifications: pushNotifications ?? this.pushNotifications,
      twoFactorAuth: twoFactorAuth ?? this.twoFactorAuth,
      themeMode: themeMode ?? this.themeMode,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    companyName,
    email,
    avatarUrl,
    membership,
    businessAddress,
    taxId,
    currency,
    currencySymbol,
    emailNotifications,
    pushNotifications,
    twoFactorAuth,
    themeMode,
  ];
}
