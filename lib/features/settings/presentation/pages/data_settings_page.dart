import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:regimen_tracker/app/di/app_container.dart';
import 'package:regimen_tracker/core/storage/local_data_service.dart';
import 'package:share_plus/share_plus.dart';

class DataSettingsPage extends StatefulWidget {
  final AppContainer container;
  final LocalDataService? dataService;

  const DataSettingsPage({
    super.key,
    required this.container,
    this.dataService,
  });

  @override
  State<DataSettingsPage> createState() => _DataSettingsPageState();
}

class _DataSettingsPageState extends State<DataSettingsPage> {
  late final LocalDataService dataService;
  StorageReport? report;
  BackupResult? latestBackup;
  String? errorMessage;
  bool isLoading = true;
  bool isCleaning = false;
  bool isExporting = false;

  @override
  void initState() {
    super.initState();
    dataService =
        widget.dataService ??
        LocalDataService(
          logRepository: widget.container.logRepository,
          habitRepository: widget.container.habitRepository,
        );
    loadReport();
  }

  Future<void> loadReport() async {
    if (mounted) {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });
    }
    try {
      final nextReport = await dataService.inspectStorage();
      if (!mounted) return;
      setState(() {
        report = nextReport;
        isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
        errorMessage = 'Could not inspect local storage: $error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data & about'),
        actions: [
          IconButton(
            tooltip: 'Refresh storage report',
            onPressed: isLoading ? null : loadReport,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) return const Center(child: CircularProgressIndicator());
    if (errorMessage case final message?) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(message, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: loadReport,
                icon: const Icon(Icons.refresh),
                label: const Text('Try again'),
              ),
            ],
          ),
        ),
      );
    }

    final storage = report!;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Local storage', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _DataRow(
                  label: 'Tracked images',
                  value:
                      '${storage.imageCount} · ${formatBytes(storage.imageBytes)}',
                ),
                _DataRow(
                  label: 'ZIP backups',
                  value:
                      '${storage.backupCount} · ${formatBytes(storage.backupBytes)}',
                ),
                _DataRow(
                  label: 'Unreferenced files',
                  value:
                      '${storage.orphanCount} · ${formatBytes(storage.orphanBytes)}',
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          key: const Key('cleanup-orphans-button'),
          onPressed: storage.orphanCount == 0 || isCleaning
              ? null
              : confirmCleanup,
          icon: isCleaning
              ? const SizedBox.square(
                  dimension: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.cleaning_services_outlined),
          label: Text(
            storage.orphanCount == 0
                ? 'No orphaned images'
                : 'Recover ${formatBytes(storage.orphanBytes)}',
          ),
        ),
        const SizedBox(height: 24),
        Text('Backup', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        const Text(
          'Creates a portable ZIP containing a versioned JSON manifest and every image referenced by your logs.',
        ),
        const SizedBox(height: 12),
        FilledButton.icon(
          key: const Key('create-backup-button'),
          onPressed: isExporting ? null : createBackup,
          icon: isExporting
              ? const SizedBox.square(
                  dimension: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.archive_outlined),
          label: Text(isExporting ? 'Creating backup…' : 'Create ZIP backup'),
        ),
        if (latestBackup case final backup?) ...[
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Backup created · ${formatBytes(backup.bytes)} · ${backup.imageCount} images',
                  ),
                  const SizedBox(height: 8),
                  SelectionArea(child: Text(backup.path)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        onPressed: () => copyPath(backup.path),
                        icon: const Icon(Icons.copy),
                        label: const Text('Copy path'),
                      ),
                      Builder(
                        builder: (buttonContext) => FilledButton.icon(
                          key: const Key('export-backup-button'),
                          onPressed: () =>
                              exportBackup(buttonContext, backup.path),
                          icon: const Icon(Icons.ios_share),
                          label: const Text('Export ZIP'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
        const SizedBox(height: 24),
        Text('About your data', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        const Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Regimen Tracker 1.0.0+1'),
                SizedBox(height: 8),
                Text(
                  'Your database, photos, analysis, and backups stay in this app’s local documents directory. '
                  'The app does not upload them to a server.',
                ),
                SizedBox(height: 8),
                Text(
                  'Insights describe associations in your own logs and are not medical advice or a diagnosis.',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> confirmCleanup() async {
    final currentReport = report;
    if (currentReport == null || currentReport.orphanCount == 0) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete unreferenced images?'),
        content: Text(
          'This permanently deletes ${currentReport.orphanCount} file${currentReport.orphanCount == 1 ? '' : 's'} '
          'not referenced by any daily log and recovers ${formatBytes(currentReport.orphanBytes)}.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    setState(() => isCleaning = true);
    try {
      final result = await dataService.deleteOrphanedImages();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Deleted ${result.deletedFiles} files and recovered ${formatBytes(result.recoveredBytes)}.',
          ),
        ),
      );
      await loadReport();
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not clean up images: $error')),
      );
    } finally {
      if (mounted) setState(() => isCleaning = false);
    }
  }

  Future<void> createBackup() async {
    setState(() => isExporting = true);
    try {
      final backup = await dataService.createBackup();
      if (!mounted) return;
      setState(() => latestBackup = backup);
      await loadReport();
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not create backup: $error')),
      );
    } finally {
      if (mounted) setState(() => isExporting = false);
    }
  }

  Future<void> copyPath(String path) async {
    await Clipboard.setData(ClipboardData(text: path));
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Backup path copied')));
  }

  Future<void> exportBackup(BuildContext buttonContext, String path) async {
    final box = buttonContext.findRenderObject() as RenderBox?;
    try {
      await SharePlus.instance.share(
        ShareParams(
          title: 'Regimen Tracker backup',
          subject: 'Regimen Tracker backup',
          files: [XFile(path, mimeType: 'application/zip')],
          sharePositionOrigin: box == null
              ? null
              : box.localToGlobal(Offset.zero) & box.size,
        ),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not export backup: $error')),
      );
    }
  }

  String formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    final kilobytes = bytes / 1024;
    if (kilobytes < 1024) return '${kilobytes.toStringAsFixed(1)} KB';
    final megabytes = kilobytes / 1024;
    if (megabytes < 1024) return '${megabytes.toStringAsFixed(1)} MB';
    return '${(megabytes / 1024).toStringAsFixed(2)} GB';
  }
}

class _DataRow extends StatelessWidget {
  final String label;
  final String value;

  const _DataRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
