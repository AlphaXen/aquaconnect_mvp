import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// The blue "AI 정리 소견" box on Home/AllReport/ReportDetail/SharedReportWeb.
/// See `ReportGenerator` doc-comment for why this is rule-based, not an LLM.
class AiInsightCard extends StatelessWidget {
  const AiInsightCard({
    super.key,
    required this.title,
    required this.bullets,
    this.paragraph,
  });

  final String title;
  final List<String> bullets;
  final String? paragraph;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.brandTintStrong,
        border: Border.all(color: AppColors.brandTintBorder),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome, size: 16, color: AppColors.brandDark),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: AppColors.brandDark),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (paragraph != null)
            Text(paragraph!, style: const TextStyle(fontSize: 12, color: AppColors.brandInk, height: 1.5)),
          if (bullets.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: bullets
                  .map(
                    (b) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('•  ', style: TextStyle(fontSize: 12.5, color: AppColors.brandInk)),
                          Expanded(
                            child: Text(
                              b,
                              style: const TextStyle(fontSize: 12.5, color: AppColors.brandInk, height: 1.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.only(top: 8),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: AppColors.brandTintBorder)),
            ),
            child: const Text(
              'AI는 기록·이미지·환경 변화의 이상징후를 정리해 보여줍니다. 최종 진단과 처방은 수산질병관리원이 수행합니다.',
              style: TextStyle(fontSize: 10.5, color: AppColors.brandInkFaint, fontStyle: FontStyle.italic, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}
