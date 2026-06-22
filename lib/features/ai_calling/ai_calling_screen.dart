import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../core/models/safezone_enums.dart';
import '../../core/theme/safezone_colors.dart';
import '../../shared/widgets/app_shell.dart';
import '../../shared/widgets/cyber_button.dart';
import '../../shared/widgets/glass_card.dart';

class AiCallingScreen extends StatelessWidget {
  const AiCallingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeZoneShell(
      title: 'AI Calling',
      selectedIndex: 0,
      role: UserRole.authority,
      child: ListView(
        children: [
          Text('AI EMERGENCY CALLING', style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 16),
          GlassCard(
            borderColor: SafeZoneColors.cyan.withOpacity(.3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.record_voice_over_rounded, color: SafeZoneColors.cyan, size: 42),
                const SizedBox(height: 16),
                Text(kIsWeb ? 'ElevenLabs ConvAI Web Support' : 'Native Mobile Voice Assistant', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 10),
                const Text(
                  'Agent ID: agent_8801kttn6txrem1v8gjy9m0g92w2\nWebhook: POST /api/ElevenLabsWebhook\nThe voice agent can create incidents with category, description, address, latitude, longitude, severity, and anonymous reporting state.',
                  style: TextStyle(color: SafeZoneColors.muted, height: 1.6),
                ),
                const SizedBox(height: 18),
                CyberButton(
                  label: kIsWeb ? 'Open Web Agent' : 'View Native Fallback',
                  icon: Icons.phone_in_talk_rounded,
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(kIsWeb ? 'Embed the ConvAI widget in Flutter Web host page.' : 'Use WebView or backend call orchestration on native mobile.')),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

