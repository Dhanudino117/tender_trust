import 'package:flutter/material.dart';
import 'landing_page.dart';

class WelcomePage extends StatelessWidget {
	const WelcomePage({super.key});

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);

		return Scaffold(
			body: SafeArea(
				child: Container(
					width: double.infinity,
					padding: const EdgeInsets.symmetric(horizontal: 24),
					decoration: BoxDecoration(
						gradient: LinearGradient(
							colors: [theme.colorScheme.primary, theme.colorScheme.secondary],
							begin: Alignment.topLeft,
							end: Alignment.bottomRight,
						),
					),
					child: Column(
						mainAxisAlignment: MainAxisAlignment.center,
						crossAxisAlignment: CrossAxisAlignment.center,
						children: [
							Container(
								padding: const EdgeInsets.all(18),
								decoration: BoxDecoration(
									color: Colors.white.withValues(alpha: 0.9),
									borderRadius: BorderRadius.circular(14),
								),
								child: const Icon(
									Icons.child_care_rounded,
									size: 64,
									color: Colors.white,
								),
							),
							const SizedBox(height: 22),
							const Text(
								'Welcome to TenderTrust',
								textAlign: TextAlign.center,
								style: TextStyle(
									color: Colors.white,
									fontSize: 28,
									fontWeight: FontWeight.w900,
								),
							),
							const SizedBox(height: 12),
							Text(
								'Childcare you can trust — find verified caregivers and stay connected during sessions.',
								textAlign: TextAlign.center,
								style: TextStyle(
color: Colors.white.withValues(alpha: 0.9),									fontSize: 14,
								),
							),
							const SizedBox(height: 28),
							SizedBox(
								width: 260,
								child: FilledButton(
									onPressed: () {
										Navigator.of(context).pushReplacement(
											MaterialPageRoute(
												builder: (_) => const TenderTrustLandingPage(),
											),
										);
									},
									child: const Padding(
										padding: EdgeInsets.symmetric(vertical: 12),
										child: Text('Get Started', style: TextStyle(fontSize: 16)),
									),
								),
							),
							const SizedBox(height: 12),
							TextButton(
								onPressed: () {
									// Placeholder: future auth flow
								},
								child: const Text(
									'Sign in',
									style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w600),
								),
							),
						],
					),
				),
			),
		);
	}
}

