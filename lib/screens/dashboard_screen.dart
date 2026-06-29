import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/twist_provider.dart';
import '../models/redeem_option.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TwistProvider>().completeAllTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Twist Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<TwistProvider>().reset();
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
      body: Consumer<TwistProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading && provider.completedTasks.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('جاري إنجاز المهام...'),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // بطاقة الرصيد
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).colorScheme.primary,
                          Theme.of(context).colorScheme.secondary,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          '💰 الرصيد الحالي',
                          style: TextStyle(fontSize: 18, color: Colors.white70),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${provider.balance} كوينز',
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // حالة المهام
                if (provider.completedTasks.isNotEmpty) ...[
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.task_alt, color: Theme.of(context).colorScheme.primary),
                              const SizedBox(width: 8),
                              const Text(
                                'نتائج المهام',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ...provider.completedTasks.map((task) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Text('✅ $task'),
                          )),
                          if (provider.statusMessage.contains('الكوينز المكتسبة'))
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                provider.statusMessage,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // خيارات السحب
                if (provider.availableOptions.isNotEmpty) ...[
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.card_giftcard, color: Theme.of(context).colorScheme.primary),
                              const SizedBox(width: 8),
                              const Text(
                                'اختر الباقة المناسبة',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ...provider.availableOptions.asMap().entries.map((entry) {
                            final i = entry.key;
                            final option = entry.value;
                            return Card(
                              elevation: 2,
                              margin: const EdgeInsets.only(bottom: 8),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Theme.of(context).colorScheme.primary,
                                  child: Text('${i + 1}'),
                                ),
                                title: Text('${option.units} وحدة'),
                                subtitle: Text('التكلفة: ${option.cost} كوينز'),
                                trailing: ElevatedButton(
                                  onPressed: provider.isLoading
                                      ? null
                                      : () async {
                                          await provider.redeemUnits(option);
                                        },
                                  child: const Text('سحب'),
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ] else if (!provider.isLoading) ...[
                  const Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('⚠️ لا توجد باقات متاحة لرصيدك الحالي (أقل من 100 كوينز)'),
                    ),
                  ),
                ],

                if (provider.isLoading && provider.completedTasks.isNotEmpty)
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
