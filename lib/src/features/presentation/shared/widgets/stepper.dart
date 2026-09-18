import 'package:flutter/material.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/themes/themes.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/widgets/input_fields.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/widgets/text.dart';

class CustomStepper extends StatelessWidget {
  const CustomStepper({
    super.key,
    required this.currentStep,
    required this.stepTitles,
    required this.stepContent,
    required this.onContinue,
    required this.onCancel,
    this.isLoading = false,
    this.continueLabel,
  });

  final int currentStep;
  final List<String> stepTitles;
  final Widget stepContent;
  final VoidCallback onContinue;
  final VoidCallback? onCancel;
  final bool isLoading;
  final String? continueLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final fontSize = context.fonts;

    final isLastStep = currentStep == stepTitles.length - 1;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomStepIndicator(currentStep: currentStep, stepTitles: stepTitles),
        SizedBox(height: spacing.lg),

        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: KeyedSubtree(key: ValueKey(currentStep), child: stepContent),
        ),

        SizedBox(height: spacing.lg),

        Row(
          children: [
            if (currentStep > 0) ...[
              Expanded(
                child: OutlinedButton(
                  onPressed: onCancel,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: colors.border),
                    padding: EdgeInsets.symmetric(vertical: spacing.sm + 4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(spacing.radiusMd),
                    ),
                  ),
                  child: Text(
                    'Atrás',
                    style: TextStyle(
                      color: colors.textPrimary,
                      fontSize: fontSize.body,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              SizedBox(width: spacing.sm),
            ],
            Expanded(
              flex: 2,
              child: SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: isLoading ? null : onContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.primary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(spacing.radiusLg),
                    ),
                  ),
                  child: isLoading
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: colors.onPrimary,
                          ),
                        )
                      : Text(
                          continueLabel ??
                              (isLastStep ? 'Enviar' : 'Siguiente'),
                          style: TextStyle(
                            color: colors.textPrimary,
                            fontSize: fontSize.body,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class CustomStepIndicator extends StatelessWidget {
  const CustomStepIndicator({
    super.key,
    required this.currentStep,
    required this.stepTitles,
  });

  final int currentStep;
  final List<String> stepTitles;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final fontSize = context.fonts;

    return Row(
      children: List.generate(stepTitles.length, (index) {
        final isCompleted = index < currentStep;
        final isActive = index == currentStep;
        final isLast = index == stepTitles.length - 1;

        return Expanded(
          child: Row(
            children: [
              Column(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isCompleted || isActive
                          ? colors.primary
                          : colors.surface,
                      border: Border.all(
                        color: isCompleted || isActive
                            ? colors.primary
                            : colors.border,
                        width: 1.5,
                      ),
                    ),
                    child: Center(
                      child: isCompleted
                          ? Icon(Icons.check, size: context.iconSize.sm, color: colors.onPrimary)
                          : Text(
                              '${index + 1}',
                              style: TextStyle(
                                color: isActive
                                    ? colors.onPrimary
                                    : colors.textPrimary,
                                fontWeight: FontWeight.w600,
                                fontSize: fontSize.caption,
                              ),
                            ),
                    ),
                  ),

                  SizedBox(height: spacing.xs),

                  SizedBox(
                    width: 90,
                    child: CustomTextWidget(
                      label: stepTitles[index],
                      fontSize: fontSize.caption,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                      color: isActive ? colors.textPrimary : colors.onSecondary,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),

              if (!isLast)
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: 20,
                    ), // alinea con el centro del círculo
                    child: Container(
                      height: 2,
                      color: isCompleted ? colors.primary : colors.border,
                    ),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }
}
