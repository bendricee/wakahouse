enum UserType { tenant, landlord }

enum VerificationStatus { pending, approved, rejected, notSubmitted }

enum ApprovalStatus { pending, approved, rejected }

class UserSession {
  final String userId;
  final String name;
  final String email;
  final UserType userType;
  final ApprovalStatus approvalStatus;
  final VerificationStatus verificationStatus;
  final DateTime? lastLogin;

  UserSession({
    required this.userId,
    required this.name,
    required this.email,
    required this.userType,
    this.approvalStatus = ApprovalStatus.pending,
    this.verificationStatus = VerificationStatus.notSubmitted,
    this.lastLogin,
  });

  bool get isLandlordApproved => 
      userType == UserType.landlord && approvalStatus == ApprovalStatus.approved;

  bool get canAccessLandlordFeatures => 
      userType == UserType.landlord && approvalStatus == ApprovalStatus.approved;

  bool get needsApproval => 
      userType == UserType.landlord && approvalStatus == ApprovalStatus.pending;
}
