class Institution {
  final String name;
  final List<String> emailDomains;

  Institution({
    required this.name,
    required this.emailDomains,
  });

  /// Validates if the given email belongs to this institution
  bool isValidEmail(String email) {
    if (!email.contains('@')) return false;
    final domain = email.split('@')[1];
    return emailDomains.contains(domain);
  }

  /// Returns a placeholder hint for email input (e.g., "example@hs-heilbronn.de")
  String get emailPlaceholder {
    if (emailDomains.isEmpty) return 'email@example.com';
    return 'example@${emailDomains.first}';
  }
}

/// Predefined institutions
/// TODO: SH : Update with real email domains once confirmed
class Institutions {
  static final List<Institution> all = [
    Institution(
      name: 'HHN - Hochschule Heilbronn',
      emailDomains: ['hs-heilbronn.de', 'stud.hs-heilbronn.de'],
    ),
    Institution(
      name: 'IPAI',
      emailDomains: ['ipai.de', 'stud.ipai.de'],
    ),
    Institution(
      name: 'Technische Universität München (TUM)',
      emailDomains: ['tum.de', 'stud.tum.de'],
    ),
    Institution(
      name: 'Heilbronn 42',
      emailDomains: ['42heilbronn.de', 'stud.42heilbronn.de'],
    ),
    Institution(
      name: 'DHBW',
      emailDomains: ['dhbw.de', 'stud.dhbw.de'],
    ),
    Institution(
      name: 'Fraunhofer ISI',
      emailDomains: ['isi.fraunhofer.de', 'stud.isi.fraunhofer.de'],
    ),
    Institution(
      name: 'Fraunhofer IAO',
      emailDomains: ['iao.fraunhofer.de', 'stud.iao.fraunhofer.de'],
    ),
  ];

  /// Get institution by name
  static Institution? getByName(String name) {
    try {
      return all.firstWhere((inst) => inst.name == name);
    } catch (e) {
      return null;
    }
  }

  /// Get all institution names for dropdown
  static List<String> get names => all.map((inst) => inst.name).toList();
}
