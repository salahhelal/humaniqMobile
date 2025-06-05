import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/contract_provider.dart';
import '../models/contract.dart';

class ContractsScreen extends StatefulWidget {
  const ContractsScreen({super.key});

  @override
  State<ContractsScreen> createState() => _ContractsScreenState();
}

class _ContractsScreenState extends State<ContractsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // Fetch dynamic contracts from backend via provider
    Future.microtask(() => Provider.of<ContractProvider>(context, listen: false).fetchContracts());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contracts'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Active'),
            Tab(text: 'Archived'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddContractDialog(context),
        child: const Icon(Icons.add),
      ),
      body: Consumer<ContractProvider>(
        builder: (context, contractProvider, _) {
          if (contractProvider.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (contractProvider.error != null) {
            return Center(child: Text('Error: \\${contractProvider.error}'));
          }
          // Dynamic data: contracts from provider
          final contracts = contractProvider.contracts;
          final activeContracts = contracts.where((c) => c.status != 'archived').toList();
          final archivedContracts = contracts.where((c) => c.status == 'archived').toList();
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search contracts...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _ContractsList(contracts: activeContracts, search: _searchController.text),
                    _ContractsList(contracts: archivedContracts, search: _searchController.text),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _showAddContractDialog(BuildContext context) {
    final typeController = TextEditingController();
    final descController = TextEditingController();
    final startDateController = TextEditingController();
    final endDateController = TextEditingController();
    final provider = Provider.of<ContractProvider>(context, listen: false);
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Contract'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: typeController,
                decoration: const InputDecoration(
                  labelText: 'Contract Type',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: startDateController,
                decoration: const InputDecoration(
                  labelText: 'Start Date',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: endDateController,
                decoration: const InputDecoration(
                  labelText: 'End Date',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await provider.addContract({
                'type': typeController.text,
                'description': descController.text,
                'startDate': startDateController.text,
                'endDate': endDateController.text,
              }, 0);
              if (provider.error != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: ${provider.error}')),
                );
              } else {
                Navigator.pop(context);
              }
            },
            child: provider.loading ? const CircularProgressIndicator() : const Text('Create'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}

class _ContractsList extends StatelessWidget {
  final List<Contract> contracts;
  final String search;
  const _ContractsList({required this.contracts, required this.search});

  @override
  Widget build(BuildContext context) {
    List<Contract> filtered = contracts;
    if (search.isNotEmpty) {
      filtered = contracts.where((c) =>
        c.type.toLowerCase().contains(search.toLowerCase()) ||
        c.description.toLowerCase().contains(search.toLowerCase())
      ).toList();
    }
    if (filtered.isEmpty) {
      return const Center(child: Text('No contracts found.'));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final contract = filtered[index];
        return Card(
          child: ListTile(
            title: Text(contract.type),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Start Date: ${contract.startDate}'),
                Text('End Date: ${contract.endDate}'),
              ],
            ),
            trailing: PopupMenuButton(
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'view',
                  child: Text('View Details'),
                ),
                const PopupMenuItem(
                  value: 'download',
                  child: Text('Download PDF'),
                ),
                const PopupMenuItem(
                  value: 'archive',
                  child: Text('Archive'),
                ),
              ],
              onSelected: (value) async {
                final provider = Provider.of<ContractProvider>(context, listen: false);
                if (value == 'view') {
                  // Show contract details (could be a dialog or bottom sheet)
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Contract Details'),
                      content: Text('Type: ${contract.type}\nDescription: ${contract.description}\nStart: ${contract.startDate}\nEnd: ${contract.endDate}'),
                      actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))],
                    ),
                  );
                } else if (value == 'download') {
                  // Placeholder for download
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Download not implemented.')),
                  );
                } else if (value == 'archive') {
                  await provider.archiveContract(contract.id);
                  if (provider.error != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: ${provider.error}')),
                    );
                  }
                }
              },
            ),
          ),
        );
      },
    );
  }
}