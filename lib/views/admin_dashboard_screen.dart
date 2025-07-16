import 'package:flutter/material.dart';

enum DocumentType { nationalId, businessPermit, propertyOwnership }

class VerificationDocument {
  final String id;
  final String fileName;
  final DocumentType type;
  final String uploadDate;
  final String? imageUrl;

  VerificationDocument({
    required this.id,
    required this.fileName,
    required this.type,
    required this.uploadDate,
    this.imageUrl,
  });
}

class LandlordApplication {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String region;
  final String submissionDate;
  final List<VerificationDocument> documents;
  ApprovalStatus status;
  String? rejectionReason;
  String? reviewedBy;
  String? reviewDate;

  LandlordApplication({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.region,
    required this.submissionDate,
    required this.documents,
    this.status = ApprovalStatus.pending,
    this.rejectionReason,
    this.reviewedBy,
    this.reviewDate,
  });
}

enum ApprovalStatus { pending, approved, rejected }

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  List<LandlordApplication> _applications = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadApplications();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadApplications() {
    // Mock data for demonstration
    _applications = [
      LandlordApplication(
        id: '1',
        name: 'Jean-Baptiste Mbarga',
        email: 'jean.mbarga@email.com',
        phone: '+237 677 123 456',
        region: 'Yaoundé',
        submissionDate: '2024-01-15',
        documents: [
          VerificationDocument(
            id: '1',
            fileName: 'national_id.jpg',
            type: DocumentType.nationalId,
            uploadDate: '2024-01-15',
          ),
          VerificationDocument(
            id: '2',
            fileName: 'business_permit.pdf',
            type: DocumentType.businessPermit,
            uploadDate: '2024-01-15',
          ),
        ],
      ),
      LandlordApplication(
        id: '2',
        name: 'Marie Ngozi',
        email: 'marie.ngozi@email.com',
        phone: '+237 698 987 654',
        region: 'Douala',
        submissionDate: '2024-01-14',
        status: ApprovalStatus.approved,
        reviewedBy: 'Admin User',
        reviewDate: '2024-01-16',
        documents: [
          VerificationDocument(
            id: '3',
            fileName: 'id_card.jpg',
            type: DocumentType.nationalId,
            uploadDate: '2024-01-14',
          ),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Admin Dashboard',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2D3748),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicator: BoxDecoration(
            color: const Color(0xFF7CB342),
            borderRadius: BorderRadius.circular(8),
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorPadding: const EdgeInsets.all(4),
          labelColor: Colors.white,
          unselectedLabelColor: const Color(0xFF64748B),
          labelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          tabs: [
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.access_time, size: 16),
                  const SizedBox(width: 4),
                  Text('Pending (${_getPendingCount()})'),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_circle, size: 16),
                  const SizedBox(width: 4),
                  Text('Approved (${_getApprovedCount()})'),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.cancel, size: 16),
                  const SizedBox(width: 4),
                  Text('Rejected (${_getRejectedCount()})'),
                ],
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildApplicationsList(ApprovalStatus.pending),
          _buildApplicationsList(ApprovalStatus.approved),
          _buildApplicationsList(ApprovalStatus.rejected),
        ],
      ),
    );
  }

  int _getPendingCount() =>
      _applications.where((app) => app.status == ApprovalStatus.pending).length;

  int _getApprovedCount() => _applications
      .where((app) => app.status == ApprovalStatus.approved)
      .length;

  int _getRejectedCount() => _applications
      .where((app) => app.status == ApprovalStatus.rejected)
      .length;

  Widget _buildApplicationsList(ApprovalStatus status) {
    final filteredApplications = _applications
        .where((app) => app.status == status)
        .toList();

    if (filteredApplications.isEmpty) {
      return _buildEmptyState(status);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: filteredApplications.length,
      itemBuilder: (context, index) {
        return _buildApplicationCard(filteredApplications[index]);
      },
    );
  }

  Widget _buildEmptyState(ApprovalStatus status) {
    String message;
    IconData icon;

    switch (status) {
      case ApprovalStatus.pending:
        message = 'No pending applications';
        icon = Icons.inbox;
        break;
      case ApprovalStatus.approved:
        message = 'No approved applications';
        icon = Icons.check_circle_outline;
        break;
      case ApprovalStatus.rejected:
        message = 'No rejected applications';
        icon = Icons.cancel_outlined;
        break;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: const Color(0xFF9CA3AF)),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(fontSize: 16, color: Color(0xFF9CA3AF)),
          ),
        ],
      ),
    );
  }

  Widget _buildApplicationCard(LandlordApplication application) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: const Color(0xFF7CB342),
                child: Text(
                  application.name.substring(0, 1).toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      application.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                    Text(
                      application.email,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              _buildStatusBadge(application.status),
            ],
          ),
          const SizedBox(height: 12),
          _buildInfoRow(Icons.phone, application.phone),
          _buildInfoRow(Icons.location_on, application.region),
          _buildInfoRow(
            Icons.calendar_today,
            'Submitted: ${application.submissionDate}',
          ),
          const SizedBox(height: 12),
          _buildDocumentsList(application.documents),
          if (application.status == ApprovalStatus.pending) ...[
            const SizedBox(height: 16),
            _buildActionButtons(application),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusBadge(ApprovalStatus status) {
    Color color;
    String text;
    IconData icon;

    switch (status) {
      case ApprovalStatus.pending:
        color = const Color(0xFFFF9800);
        text = 'Pending';
        icon = Icons.access_time;
        break;
      case ApprovalStatus.approved:
        color = const Color(0xFF7CB342);
        text = 'Approved';
        icon = Icons.check_circle;
        break;
      case ApprovalStatus.rejected:
        color = const Color(0xFFEF4444);
        text = 'Rejected';
        icon = Icons.cancel;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(icon, size: 16, color: const Color(0xFF9CA3AF)),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(fontSize: 14, color: Color(0xFF64748B)),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentsList(List<VerificationDocument> documents) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Documents:',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: documents.map((doc) => _buildDocumentChip(doc)).toList(),
        ),
      ],
    );
  }

  Widget _buildDocumentChip(VerificationDocument document) {
    String typeText;
    IconData icon;

    switch (document.type) {
      case DocumentType.nationalId:
        typeText = 'National ID';
        icon = Icons.badge;
        break;
      case DocumentType.businessPermit:
        typeText = 'Business Permit';
        icon = Icons.business;
        break;
      case DocumentType.propertyOwnership:
        typeText = 'Property Ownership';
        icon = Icons.home;
        break;
    }

    return GestureDetector(
      onTap: () => _viewDocument(document),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFF7CB342).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF7CB342)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: const Color(0xFF7CB342)),
            const SizedBox(width: 4),
            Text(
              typeText,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF7CB342),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(LandlordApplication application) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => _rejectApplication(application),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFFEF4444),
              side: const BorderSide(color: Color(0xFFEF4444)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Reject'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: () => _approveApplication(application),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7CB342),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Approve'),
          ),
        ),
      ],
    );
  }

  void _viewDocument(VerificationDocument document) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Document: ${document.fileName}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.description, size: 48, color: Color(0xFF9CA3AF)),
                    SizedBox(height: 8),
                    Text(
                      'Document Preview',
                      style: TextStyle(color: Color(0xFF9CA3AF)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text('Uploaded: ${document.uploadDate}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _approveApplication(LandlordApplication application) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Approve Application'),
        content: Text(
          'Are you sure you want to approve ${application.name}\'s landlord application?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                application.status = ApprovalStatus.approved;
                application.reviewedBy = 'Admin User';
                application.reviewDate = DateTime.now().toString().substring(
                  0,
                  10,
                );
              });
              Navigator.pop(context);
              _showSnackBar('Application approved successfully!');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7CB342),
            ),
            child: const Text('Approve'),
          ),
        ],
      ),
    );
  }

  void _rejectApplication(LandlordApplication application) {
    final reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reject Application'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Provide a reason for rejecting ${application.name}\'s application:',
            ),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Enter rejection reason...',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (reasonController.text.isNotEmpty) {
                setState(() {
                  application.status = ApprovalStatus.rejected;
                  application.rejectionReason = reasonController.text;
                  application.reviewedBy = 'Admin User';
                  application.reviewDate = DateTime.now().toString().substring(
                    0,
                    10,
                  );
                });
                Navigator.pop(context);
                _showSnackBar('Application rejected.');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
            ),
            child: const Text('Reject'),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF7CB342),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
