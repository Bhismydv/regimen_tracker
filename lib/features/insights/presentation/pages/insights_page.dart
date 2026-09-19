import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:regimen_tracker/domain/entities/regimen_insight.dart';
import 'package:regimen_tracker/domain/services/insight_analyzer.dart';
import 'package:regimen_tracker/features/insights/presentation/cubit/insights_cubit.dart';
import 'package:regimen_tracker/features/insights/presentation/cubit/insights_state.dart';

class InsightsPage extends StatefulWidget {
  final InsightsCubit cubit;

  const InsightsPage({super.key, required this.cubit});

  @override
  State<InsightsPage> createState() => _InsightsPageState();
}

class _InsightsPageState extends State<InsightsPage> {
  @override
  void initState() {
    super.initState();
    widget.cubit.loadInsights();
  }

  @override
  void dispose() {
    widget.cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.cubit,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Routine insights'),
          actions: [
            IconButton(
              tooltip: 'Recalculate insights',
              onPressed: widget.cubit.loadInsights,
              icon: const Icon(Icons.refresh),
            ),
          ],
        ),
        body: BlocBuilder<InsightsCubit, InsightsState>(
          builder: (context, state) {
            return switch (state) {
              InsightsInitial() || InsightsLoading() => const Center(
                child: CircularProgressIndicator(),
              ),
              InsightsFailure(:final message) => _InsightsError(
                message: message,
                onRetry: widget.cubit.loadInsights,
              ),
              InsightsLoaded(:final report) => _InsightsContent(report: report),
            };
          },
        ),
      ),
    );
  }
}

class _InsightsContent extends StatelessWidget {
  final InsightReport report;

  const _InsightsContent({required this.report});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _DataSummary(report: report),
        const SizedBox(height: 16),
        if (!report.hasMinimumData)
          _MessageCard(
            icon: Icons.hourglass_bottom,
            title: 'Keep logging',
            message:
                'Add ${report.logsNeeded} more daily log${report.logsNeeded == 1 ? '' : 's'} '
                'before delayed patterns are calculated.',
          )
        else if (report.scoredLogCount < InsightAnalyzer.minimumPairs)
          const _MessageCard(
            icon: Icons.score_outlined,
            title: 'More outcome scores needed',
            message:
                'Record irritation or oiliness regularly so habits can be compared with outcomes.',
          )
        else if (report.insights.isEmpty)
          const _MessageCard(
            icon: Icons.search,
            title: 'No stable pattern yet',
            message:
                'Your current data does not show a strong, repeatable association. Keep logging consistently.',
          )
        else ...[
          Text(
            'Patterns detected',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          ...report.insights.map((insight) => _InsightCard(insight: insight)),
        ],
        const SizedBox(height: 16),
        const _MessageCard(
          icon: Icons.info_outline,
          title: 'How to read this',
          message:
              'Insights compare your own logged habits and scores across 0–3 day delays. '
              'They show associations, not medical diagnoses or proof that a habit caused an outcome.',
        ),
      ],
    );
  }
}

class _DataSummary extends StatelessWidget {
  final InsightReport report;

  const _DataSummary({required this.report});

  @override
  Widget build(BuildContext context) {
    final progress = (report.logCount / InsightReport.minimumLogs).clamp(
      0.0,
      1.0,
    );
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Data coverage',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(value: progress),
            const SizedBox(height: 8),
            Text(
              '${report.logCount} daily logs · ${report.scoredLogCount} with outcome scores',
            ),
          ],
        ),
      ),
    );
  }
}

class _InsightCard extends StatelessWidget {
  final RegimenInsight insight;

  const _InsightCard({required this.insight});

  @override
  Widget build(BuildContext context) {
    final isAssociation = insight.kind == InsightKind.habitAssociation;
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          child: Icon(isAssociation ? Icons.hub_outlined : Icons.trending_up),
        ),
        title: Text(insight.title),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(insight.description),
        ),
        isThreeLine: true,
      ),
    );
  }
}

class _MessageCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;

  const _MessageCard({
    required this.icon,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(message),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InsightsError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _InsightsError({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }
}
