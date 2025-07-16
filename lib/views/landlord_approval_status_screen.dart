import 'package:flutter/material.dart';
import '../models/user_types.dart';

class LandlordApprovalStatusScreen extends StatelessWidget {
  final ApprovalStatus status;
  final String? rejectionReason;
  final String submissionDate;
  final String? reviewDate;

  const LandlordApprovalStatusScreen({
    super.key,
    required this.status,
    this.rejectionReason,
    required this.submissionDate,
    this.reviewDate,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Landlord Verification',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2D3748),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF2D3748)),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildStatusCard(),
            const SizedBox(height: 24),
            _buildTimelineCard(),
            const SizedBox(height: 24),
            _buildNextStepsCard(),
            if (status == ApprovalStatus.rejected) ...[
              const SizedBox(height: 24),
              _buildResubmitCard(context),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    Color statusColor;
    String statusText;
    String statusDescription;
    IconData statusIcon;

    switch (status) {
      case ApprovalStatus.pending:
        statusColor = const Color(0xFFFF9800);
        statusText = 'Under Review';
        statusDescription =
            'Your landlord application is being reviewed by our team.';
        statusIcon = Icons.access_time;
        break;
      case ApprovalStatus.approved:
        statusColor = const Color(0xFF7CB342);
        statusText = 'Approved!';
        statusDescription = 'Congratulations! You are now a verified landlord.';
        statusIcon = Icons.verified;
        break;
      case ApprovalStatus.rejected:
        statusColor = const Color(0xFFEF4444);
        statusText = 'Application Rejected';
        statusDescription =
            'Your application was not approved. Please see details below.';
        statusIcon = Icons.error;
        break;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(statusIcon, size: 40, color: statusColor),
          ),
          const SizedBox(height: 16),
          Text(
            statusText,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: statusColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            statusDescription,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF64748B),
              height: 1.5,
            ),
          ),
          if (status == ApprovalStatus.rejected && rejectionReason != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFEF4444).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFEF4444)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Rejection Reason:',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFEF4444),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    rejectionReason!,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFFEF4444),
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

  Widget _buildTimelineCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Application Timeline',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 16),
          _buildTimelineItem(
            'Application Submitted',
            submissionDate,
            Icons.upload_file,
            const Color(0xFF7CB342),
            isCompleted: true,
          ),
          _buildTimelineItem(
            'Under Review',
            status == ApprovalStatus.pending
                ? 'In Progress'
                : reviewDate ?? 'Completed',
            Icons.search,
            const Color(0xFFFF9800),
            isCompleted: status != ApprovalStatus.pending,
            isActive: status == ApprovalStatus.pending,
          ),
          _buildTimelineItem(
            status == ApprovalStatus.approved ? 'Approved' : 'Decision Made',
            status == ApprovalStatus.pending
                ? 'Pending'
                : reviewDate ?? 'Completed',
            status == ApprovalStatus.approved ? Icons.check_circle : Icons.info,
            status == ApprovalStatus.approved
                ? const Color(0xFF7CB342)
                : const Color(0xFFEF4444),
            isCompleted: status != ApprovalStatus.pending,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(
    String title,
    String date,
    IconData icon,
    Color color, {
    bool isCompleted = false,
    bool isActive = false,
    bool isLast = false,
  }) {
    return Row(
      children: [
        Column(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isCompleted || isActive
                    ? color
                    : const Color(0xFFE5E7EB),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 16,
                color: isCompleted || isActive
                    ? Colors.white
                    : const Color(0xFF9CA3AF),
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 32,
                color: isCompleted ? color : const Color(0xFFE5E7EB),
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isCompleted || isActive
                        ? const Color(0xFF2D3748)
                        : const Color(0xFF9CA3AF),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 14,
                    color: isCompleted || isActive
                        ? const Color(0xFF64748B)
                        : const Color(0xFF9CA3AF),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNextStepsCard() {
    String title;
    String description;
    List<String> steps;

    switch (status) {
      case ApprovalStatus.pending:
        title = 'What happens next?';
        description =
            'Our team is reviewing your application. Here\'s what to expect:';
        steps = [
          'Document verification (1-2 business days)',
          'Background check (1-2 business days)',
          'Final approval decision',
          'Email notification with results',
        ];
        break;
      case ApprovalStatus.approved:
        title = 'You\'re all set!';
        description = 'You can now access all landlord features:';
        steps = [
          'Create and manage property listings',
          'Communicate with potential tenants',
          'Access landlord dashboard and analytics',
          'Receive rental applications',
        ];
        break;
      case ApprovalStatus.rejected:
        title = 'Next Steps';
        description =
            'You can resubmit your application after addressing the issues:';
        steps = [
          'Review the rejection reason above',
          'Gather the required documents',
          'Update your profile information',
          'Resubmit your application',
        ];
        break;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(fontSize: 14, color: Color(0xFF64748B)),
          ),
          const SizedBox(height: 16),
          ...steps
              .map(
                (step) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: Color(0xFF7CB342),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          step,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF374151),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ],
      ),
    );
  }

  Widget _buildResubmitCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'Ready to resubmit?',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Make sure you\'ve addressed all the issues mentioned in the rejection reason.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Navigate back to edit profile or resubmission flow
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7CB342),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'Update Profile & Resubmit',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
