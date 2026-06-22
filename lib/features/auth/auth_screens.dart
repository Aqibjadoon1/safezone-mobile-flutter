import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router.dart';
import '../../core/theme/safezone_colors.dart';
import '../../shared/widgets/cyber_button.dart';
import '../../shared/widgets/glass_card.dart';
import 'auth_controller.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _AuthFrame(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.shield_rounded, color: SafeZoneColors.safe, size: 70),
          const SizedBox(height: 18),
          Text('YOUR NEIGHBOURHOOD PROTECTED', textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 12),
          const Text('A mobile command system for incidents, FIRs, SOS alerts, and authority response.', textAlign: TextAlign.center, style: TextStyle(color: SafeZoneColors.muted)),
          const SizedBox(height: 24),
          CyberButton(label: 'Enter SafeZone', icon: Icons.arrow_forward_rounded, onPressed: () => context.go('/login')),
        ],
      ),
    );
  }
}

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _email = TextEditingController(text: 'resident@safezone.local');
  final _password = TextEditingController(text: 'password123');

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authControllerProvider);
    ref.listen(authControllerProvider, (previous, next) {
      if (next.user != null) context.goHomeFor(next.user!.role);
    });
    return _AuthFrame(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('SIGN IN', style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 8),
          const Text('Demo mode is active. Use any SafeZone demo account.', style: TextStyle(color: SafeZoneColors.muted)),
          const SizedBox(height: 24),
          TextField(controller: _email, decoration: const InputDecoration(labelText: 'Email or phone', prefixIcon: Icon(Icons.mail_rounded))),
          const SizedBox(height: 12),
          TextField(controller: _password, obscureText: true, decoration: const InputDecoration(labelText: 'Password', prefixIcon: Icon(Icons.lock_rounded))),
          if (auth.error != null) ...[
            const SizedBox(height: 12),
            Text(auth.error!, style: const TextStyle(color: SafeZoneColors.danger)),
          ],
          const SizedBox(height: 18),
          CyberButton(
            label: auth.loading ? 'Signing In' : 'Sign In',
            icon: Icons.login_rounded,
            expanded: true,
            onPressed: auth.loading ? null : () => ref.read(authControllerProvider.notifier).login(_email.text, _password.text),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              TextButton(onPressed: () => context.go('/forgot'), child: const Text('Forgot password')),
              const Spacer(),
              TextButton(onPressed: () => context.go('/register'), child: const Text('Create account')),
            ],
          ),
        ],
      ),
    );
  }
}

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authControllerProvider);
    ref.listen(authControllerProvider, (previous, next) {
      if (next.user != null) context.goHomeFor(next.user!.role);
    });
    return _AuthFrame(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('JOIN SAFEZONE', style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 18),
          TextField(controller: _name, decoration: const InputDecoration(labelText: 'Full name', prefixIcon: Icon(Icons.person_rounded))),
          const SizedBox(height: 12),
          TextField(controller: _email, decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.mail_rounded))),
          const SizedBox(height: 12),
          TextField(controller: _password, obscureText: true, decoration: const InputDecoration(labelText: 'Password', prefixIcon: Icon(Icons.lock_rounded))),
          if (auth.error != null) ...[
            const SizedBox(height: 12),
            Text(auth.error!, style: const TextStyle(color: SafeZoneColors.danger)),
          ],
          const SizedBox(height: 18),
          CyberButton(
            label: 'Create Account',
            icon: Icons.person_add_rounded,
            expanded: true,
            onPressed: () => ref.read(authControllerProvider.notifier).register(_name.text, _email.text, _password.text),
          ),
          const SizedBox(height: 12),
          TextButton(onPressed: () => context.go('/login'), child: const Text('Already have an account? Sign in')),
        ],
      ),
    );
  }
}

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();
    return _AuthFrame(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('RESET ACCESS', style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 12),
          const Text('Enter your email and SafeZone will send recovery instructions.', style: TextStyle(color: SafeZoneColors.muted)),
          const SizedBox(height: 18),
          TextField(controller: controller, decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.mail_rounded))),
          const SizedBox(height: 18),
          CyberButton(
            label: 'Send Reset Link',
            icon: Icons.send_rounded,
            expanded: true,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Recovery link queued in demo mode.')));
              context.go('/login');
            },
          ),
        ],
      ),
    );
  }
}

class _AuthFrame extends StatelessWidget {
  const _AuthFrame({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: SafeZoneColors.heroGradient),
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(painter: _AuthScanPainter()),
            ),
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 460),
                  child: GlassCard(child: child),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AuthScanPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final red = Paint()
      ..color = SafeZoneColors.danger.withOpacity(.08)
      ..strokeWidth = 2;
    final cyan = Paint()
      ..color = SafeZoneColors.cyan.withOpacity(.08)
      ..strokeWidth = 1;
    for (double y = 40; y < size.height; y += 96) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y + 60), cyan);
    }
    canvas.drawLine(Offset(size.width * .58, 0), Offset(size.width, size.height * .32), red);
    canvas.drawLine(Offset(0, size.height * .78), Offset(size.width * .42, size.height), red);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
