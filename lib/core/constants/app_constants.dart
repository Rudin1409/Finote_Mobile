import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SourceOfFund {
  final String value;
  final String label;
  final IconData icon;

  const SourceOfFund({
    required this.value,
    required this.label,
    required this.icon,
  });
}

class Category {
  final String value;
  final String label;
  final IconData icon;
  final String type; // 'income', 'expense', 'all'

  const Category({
    required this.value,
    required this.label,
    required this.icon,
    required this.type,
  });
}

class AppConstants {
  static const List<SourceOfFund> sourcesOfFunds = [
    SourceOfFund(value: 'cash', label: 'Tunai', icon: Icons.wallet),
    SourceOfFund(
        value: 'bank',
        label: 'Bank',
        icon: FontAwesomeIcons.buildingColumns), // Landmark equivalent
    SourceOfFund(
        value: 'digital-wallet',
        label: 'Dompet Digital',
        icon: Icons.smartphone),
  ];

  static const List<Category> categories = [
    // Expenses
    Category(
        value: 'staple_needs',
        label: 'Kebutuhan Pokok',
        icon: Icons.home,
        type: 'expense'),
    Category(
        value: 'education',
        label: 'Pendidikan',
        icon: FontAwesomeIcons.bookOpen,
        type: 'expense'),
    Category(
        value: 'transportation',
        label: 'Transportasi',
        icon: Icons.directions_car,
        type: 'expense'),
    Category(
        value: 'communication',
        label: 'Komunikasi & Internet',
        icon: Icons.wifi,
        type: 'expense'),
    Category(
        value: 'personal_needs',
        label: 'Kebutuhan Pribadi',
        icon: Icons.person,
        type: 'expense'),
    Category(
        value: 'health',
        label: 'Kesehatan',
        icon: FontAwesomeIcons.stethoscope,
        type: 'expense'),
    Category(
        value: 'entertainment',
        label: 'Hiburan & Sosial',
        icon: Icons.celebration,
        type: 'expense'), // PartyPopper equivalent
    Category(
        value: 'gift_out',
        label: 'Hadiah',
        icon: FontAwesomeIcons.gift,
        type: 'expense'),
    Category(
        value: 'debt_payment',
        label: 'Pembayaran Hutang',
        icon: FontAwesomeIcons.handHoldingDollar,
        type: 'expense'), // HandCoins equivalent

    // Income
    Category(
        value: 'pocket_money',
        label: 'Saku',
        icon: Icons.wallet,
        type: 'income'),
    Category(
        value: 'salary',
        label: 'Gaji',
        icon: FontAwesomeIcons.briefcase,
        type: 'income'),
    Category(
        value: 'investment',
        label: 'Investasi',
        icon: FontAwesomeIcons.arrowTrendUp,
        type: 'income'),
    Category(
        value: 'gift_in',
        label: 'Hadiah',
        icon: FontAwesomeIcons.award,
        type: 'income'),
    Category(
        value: 'other_income',
        label: 'Lain-lain',
        icon: Icons.more_horiz,
        type: 'income'),

    // Shared
    Category(
        value: 'transfer',
        label: 'Transfer Dana',
        icon: Icons.repeat,
        type: 'all'),
    Category(
        value: 'other',
        label: 'Lain-lain',
        icon: Icons.more_horiz,
        type: 'all'),
  ];
}
