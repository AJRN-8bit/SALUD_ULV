import 'package:flutter/material.dart';
import 'package:salud_ulv_app/src/core/models/user.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/themes/spacers.dart';


enum RowOrientation { horizontal, vertical }

class CustomListView extends StatelessWidget {
  final List<Widget> widgets;
  final RowOrientation orientation;
  final double? spacing;
  final double? runSpacing;
  final bool scrollable;
  final EdgeInsetsGeometry padding;
  final CrossAxisAlignment crossAxisAlignment;
  final WrapAlignment wrapAlignment;
  final bool addContentPadding;
  final int lines;

  const CustomListView({
    super.key,
    required this.widgets,
    this.orientation = RowOrientation.horizontal,
    this.spacing = 20,
    this.runSpacing,
    this.scrollable = true,
    this.padding = EdgeInsets.zero,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.wrapAlignment = WrapAlignment.start,
    this.addContentPadding = false,
    this.lines = 1,
  }) : assert(lines > 0, 'lines debe ser al menos 1');

  @override
  Widget build(BuildContext context) {
    if (widgets.isEmpty) return const SizedBox.shrink();

    final _spacing = spacing ?? context.spacing.md;
    final _runSpacing = runSpacing ?? _spacing;
    final isHorizontal = orientation == RowOrientation.horizontal;

    Widget buildSingleLine(List<Widget> lineWidgets) {
      final spacedWidgets = <Widget>[];
      for (int i = 0; i < lineWidgets.length; i++) {
        spacedWidgets.add(lineWidgets[i]);
        if (i != lineWidgets.length - 1) {
          spacedWidgets.add(
            isHorizontal
                ? SizedBox(width: _spacing)
                : SizedBox(height: _spacing),
          );
        }
      }

      if (scrollable) {
    final flex = isHorizontal
        ? Row(
            crossAxisAlignment: crossAxisAlignment,
            mainAxisSize: MainAxisSize.min,
            children: spacedWidgets,
          )
        : Column(
            crossAxisAlignment: crossAxisAlignment,
            mainAxisSize: MainAxisSize.min,
            children: spacedWidgets,
          );

    return SingleChildScrollView(
      scrollDirection: isHorizontal ? Axis.horizontal : Axis.vertical,

      clipBehavior: Clip.hardEdge,

      padding: !addContentPadding
        ? EdgeInsets.zero
        : isHorizontal 
              ? EdgeInsets.symmetric(vertical: _spacing * 1.5 , horizontal: 4)
              : EdgeInsets.symmetric(horizontal: _spacing , vertical: 4),
      child: flex,
    );
  }

      return Wrap(
        direction: isHorizontal ? Axis.horizontal : Axis.vertical,
        spacing: _spacing,
        runSpacing: _spacing,
        alignment: wrapAlignment,
        crossAxisAlignment: isHorizontal
            ? WrapCrossAlignment.center
            : WrapCrossAlignment.start,
        children: lineWidgets,
      );
    }

    Widget content;

    if (lines <= 1) {
      // Caso por defecto: una sola línea, igual que antes.
      content = buildSingleLine(widgets);
    } else {
      // Reparte los widgets en `lines` grupos, en orden, y apila
      // cada grupo como su propia línea independiente en el eje
      // cruzado (Column de Rows si es horizontal, Row de Columns
      // si es vertical).
      final perLine = (widgets.length / lines).ceil();
      final chunks = <List<Widget>>[];

      for (int i = 0; i < widgets.length; i += perLine) {
        chunks.add(
          widgets.sublist(i, (i + perLine).clamp(0, widgets.length)),
        );
      }

      final lineWidgets = <Widget>[];
      for (int i = 0; i < chunks.length; i++) {
        lineWidgets.add(buildSingleLine(chunks[i]));
        if (i != chunks.length - 1) {
          lineWidgets.add(
            isHorizontal
                ? SizedBox(height: _runSpacing)
                : SizedBox(width: _runSpacing),
          );
        }
      }

      content = isHorizontal
          ? Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: crossAxisAlignment,
              children: lineWidgets,
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: crossAxisAlignment,
              children: lineWidgets,
            );
    }

    return Padding(
      padding: padding,
      child: content,
    );
  }
}







class MembersList extends StatelessWidget {
  final List<User> members;

  const MembersList({
    super.key,
    required this.members,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      // physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(context.spacing.md),
      itemCount: members.length,
      itemBuilder: (context, index) {
        final user = members[index];

        return ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 4,
          ),

          leading: const CircleAvatar(
            child: Icon(Icons.person),
          ),

          title: Text(
            '${user.firstname ?? ''} ${user.surname ?? ''} ${user.lastname ?? ''}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

          subtitle: Text(
            user.userCode ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        );
      },
    );
  }
}
