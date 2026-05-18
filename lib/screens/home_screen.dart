import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/equb_group.dart';
import '../providers/member_provider.dart';
import '../widgets/member_card.dart';
import '../widgets/stat_chip.dart';
import 'add_member_screen.dart';
import 'member_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  final EqubGroup group;
  const HomeScreen({super.key, required this.group});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MemberProvider>().fetchMembers(groupId: widget.group.id);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5DFA0),
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        color: const Color(0xFF4A7C59),
        onRefresh: () => context.read<MemberProvider>().fetchMembers(
          groupId: widget.group.id,
        ),
        child: Column(
          children: [
            _buildGroupBanner(),
            _buildSearchBar(),
            _buildStatsRow(),
            _buildRoundIndicator(),
            _buildFilterChips(),
            Expanded(child: _buildMemberList()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AddMemberScreen(groupId: widget.group.id),
          ),
        ),
        icon: const Icon(Icons.person_add_rounded),
        label: const Text(
          'Add Member',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color(0xFF4A7C59),
        foregroundColor: const Color(0xFFFFFFFF),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFFF5DFA0),
      elevation: 0,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Color(0xFF2C1F0E),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipOval(
            child: Image.asset(
              'assets/images/logo.jpg',
              width: 32,
              height: 32,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            'DIGITAL EQUB',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.8,
              color: Color(0xFF2C1F0E),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupBanner() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Text(
        widget.group.name,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF2C1F0E),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      child: TextField(
        controller: _searchController,
        onChanged: (val) => context.read<MemberProvider>().setSearchQuery(val),
        style: const TextStyle(color: Color(0xFF2C1F0E), fontSize: 14),
        decoration: InputDecoration(
          hintText: 'Quick Search...',
          hintStyle: const TextStyle(color: Color(0xFF8C7A5A), fontSize: 14),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: Color(0xFF5C4A2A),
            size: 20,
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(
                    Icons.clear_rounded,
                    color: Color(0xFF5C4A2A),
                    size: 18,
                  ),
                  onPressed: () {
                    _searchController.clear();
                    context.read<MemberProvider>().setSearchQuery('');
                  },
                )
              : null,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 16,
          ),
          filled: true,
          fillColor: const Color(0xFFFFFFFF).withValues(alpha: 0.65),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              color: const Color(0xFFD4A843).withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Color(0xFF4A7C59), width: 1.5),
          ),
        ),
      ),
    );
  }

  Widget _buildStatsRow() {
    return Consumer<MemberProvider>(
      builder: (context, provider, child) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            StatChip(
              label: 'Total People',
              value: '${provider.totalMembers}',
              icon: Icons.people_rounded,
              color: const Color(0xFF4A7C59),
            ),
            const SizedBox(width: 10),
            StatChip(
              label: 'Total Money',
              value: '${provider.totalMoney.toStringAsFixed(0)} ETB',
              icon: Icons.monetization_on_rounded,
              color: const Color(0xFF614521),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoundIndicator() {
    return Consumer<MemberProvider>(
      builder: (context, provider, child) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFAAA054),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.rotate_right_rounded,
                  color: Color(0xFFFFFFFF),
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  'Current Round: ${provider.currentRound}',
                  style: const TextStyle(
                    color: Color(0xFFFFFFFF),
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return Consumer<MemberProvider>(
      builder: (context, provider, child) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 2),
        child: Row(
          children: ['All', 'Paid', 'Not Paid'].map((filter) {
            final selected = provider.filterStatus == filter;
            Color chipColor = const Color(0xFF4A7C59);
            if (filter == 'Paid') chipColor = const Color(0xFF4A7C59);
            if (filter == 'Not Paid') chipColor = const Color(0xFFB85C38);
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () => provider.setFilter(filter),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: selected
                        ? chipColor
                        : const Color(0xFFFFFFFF).withValues(alpha: 0.55),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: selected
                          ? chipColor
                          : const Color(0xFFD4A843).withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    filter,
                    style: TextStyle(
                      color: selected
                          ? const Color(0xFFFFFFFF)
                          : const Color(0xFF5C4A2A),
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildMemberList() {
    return Consumer<MemberProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading && provider.allMembers.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF4A7C59)),
          );
        }

        if (provider.loadingState == LoadingState.error &&
            provider.allMembers.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.wifi_off_rounded,
                    color: Color(0xFFB85C38),
                    size: 52,
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Could not load members',
                    style: TextStyle(
                      color: Color(0xFF2C1F0E),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    provider.errorMessage,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF5C4A2A),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () =>
                        provider.fetchMembers(groupId: widget.group.id),
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        if (provider.members.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.group_off_rounded,
                  color: Color(0xFF8C7A5A),
                  size: 52,
                ),
                const SizedBox(height: 14),
                Text(
                  provider.searchQuery.isNotEmpty
                      ? 'No members match your search'
                      : 'No members yet.\nTap + to add the first member!',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF5C4A2A),
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 6, 16, 100),
          itemCount: provider.members.length,
          itemBuilder: (ctx, i) {
            final member = provider.members[i];
            return MemberCard(
              member: member,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MemberDetailScreen(memberId: member.id!),
                ),
              ),
              onMarkPaid: member.status == 'Not Paid'
                  ? () => provider.markAsPaid(member)
                  : null,
            );
          },
        );
      },
    );
  }
}
