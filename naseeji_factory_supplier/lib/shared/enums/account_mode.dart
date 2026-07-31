enum AccountMode {
  real,
  demo;

  bool get isDemo => this == AccountMode.demo;
  bool get isReal => this == AccountMode.real;
}

