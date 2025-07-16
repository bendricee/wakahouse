import 'package:flutter/material.dart';

class TopEstateAgentScreen extends StatelessWidget {
  const TopEstateAgentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> topAgents = [
      {
        'rank': 1,
        'name': 'Amanda',
        'image': 'assets/images/agent_amanda.jpg',
        'rating': 5.0,
        'sales': 112,
      },
      {
        'rank': 2,
        'name': 'Anderson',
        'image': 'assets/images/agent_anderson.jpg',
        'rating': 4.9,
        'sales': 112,
      },
      {
        'rank': 3,
        'name': 'Samantha',
        'image': 'assets/images/agent_samantha.jpg',
        'rating': 4.9,
        'sales': 112,
      },
      {
        'rank': 4,
        'name': 'Andrew',
        'image': 'assets/images/agent_andrew.jpg',
        'rating': 4.9,
        'sales': 112,
      },
      {
        'rank': 5,
        'name': 'Michael',
        'image': 'assets/images/agent_michael.jpg',
        'rating': 4.9,
        'sales': 112,
      },
      {
        'rank': 6,
        'name': 'Tobi',
        'image': 'assets/images/agent_tobi.jpg',
        'rating': 4.9,
        'sales': 112,
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios,
                        color: Color(0xFF2D3748),
                        size: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
              ),
            ),

            // Title Section
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Top Estate Agent',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Find the best recommendations place to live',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Agents Grid
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: topAgents.length,
                  itemBuilder: (context, index) {
                    final agent = topAgents[index];
                    return _buildAgentCard(agent);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAgentCard(Map<String, dynamic> agent) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 20),
          
          // Rank Badge and Avatar
          Stack(
            children: [
              // Agent Avatar
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage(agent['image']),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              
              // Rank Badge
              Positioned(
                top: -5,
                left: -5,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: const Color(0xFF7CB342),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      '#${agent['rank']}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Agent Name
          Text(
            agent['name'],
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D3748),
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Rating and Sales
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.star,
                color: Color(0xFFFFC107),
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                agent['rating'].toString(),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF2D3748),
                ),
              ),
              const SizedBox(width: 12),
              const Icon(
                Icons.home,
                color: Color(0xFF9CA3AF),
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                '${agent['sales']} Sold',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF9CA3AF),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
