import 'package:flutter/material.dart';
import '../safe_lpg_skeleton.dart';
import '../../theme/app_theme.dart';

/// A pre-built shimmer skeleton that mirrors the Dashboard layout.
/// Drop in whenever real data is loading.
class LoadingSkeleton extends StatelessWidget {
  const LoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gas level card skeleton
          _skeletonCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SafeLPGSkeleton(width: 140, height: 14),
                    const SafeLPGSkeleton(width: 64, height: 22, borderRadius: 9999),
                  ],
                ),
                const SizedBox(height: 20),
                const Center(
                  child: SafeLPGSkeleton(width: 200, height: 100, borderRadius: 12),
                ),
                const SizedBox(height: 20),
                Row(
                  children: List.generate(4, (i) => Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      child: const SafeLPGSkeleton(width: double.infinity, height: 48, borderRadius: 12),
                    ),
                  )),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // System state card skeleton
          _skeletonCard(
            child: Row(
              children: [
                const SafeLPGSkeleton(width: 40, height: 40, borderRadius: 12),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      SafeLPGSkeleton(width: 80, height: 12),
                      SizedBox(height: 6),
                      SafeLPGSkeleton(width: 120, height: 18),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Quick actions skeleton
          Row(
            children: List.generate(3, (i) => Expanded(
              child: Container(
                margin: EdgeInsets.only(
                  left: i == 0 ? 0 : 6,
                  right: i == 2 ? 0 : 6,
                ),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [BoxShadow(color: Color(0x0F0F172A), blurRadius: 8)],
                ),
                child: Column(
                  children: const [
                    SafeLPGSkeleton(width: 40, height: 40, borderRadius: 12),
                    SizedBox(height: 10),
                    SafeLPGSkeleton(width: 56, height: 12),
                  ],
                ),
              ),
            )).toList(),
          ),
          const SizedBox(height: 12),

          // Recent activity card skeleton
          _skeletonCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    SafeLPGSkeleton(width: 120, height: 15),
                    SafeLPGSkeleton(width: 48, height: 13),
                  ],
                ),
                const SizedBox(height: 16),
                ...List.generate(3, (i) => Padding(
                  padding: const EdgeInsets.only(bottom: 14.0),
                  child: Row(
                    children: [
                      const SafeLPGSkeleton(width: 8, height: 8, borderRadius: 9999),
                      const SizedBox(width: 12),
                      const Expanded(child: SafeLPGSkeleton(width: double.infinity, height: 14)),
                      const SizedBox(width: 12),
                      const SafeLPGSkeleton(width: 52, height: 12),
                    ],
                  ),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _skeletonCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Color(0x0F0F172A), offset: Offset(0, 1), blurRadius: 8),
        ],
      ),
      child: child,
    );
  }
}
