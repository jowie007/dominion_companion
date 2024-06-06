import 'package:dominion_companion/components/expansion_expandable.dart';
import 'package:dominion_companion/model/expansion/expansion_model.dart';
import 'package:dominion_companion/services/expansion_service.dart';
import 'package:flutter/material.dart';

class LazyScrollViewExpansions extends StatefulWidget {
  const LazyScrollViewExpansions({super.key, required this.onChanged});

  final void Function() onChanged;

  @override
  State<LazyScrollViewExpansions> createState() =>
      _LazyScrollViewExpansionsState();
}

class _LazyScrollViewExpansionsState extends State<LazyScrollViewExpansions> {
  List<ExpansionModel> expansions = [];
  bool showLoadingIcon = true;
  bool disposed = false;
  int runCount = 0;

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      runCount++;
      loadExpansionRecursive(runCount);
    });
  }

  @override
  void dispose() {
    super.dispose();
    disposed = true;
  }

  void reloadData() {
    setState(() {
      runCount++;
      expansions = [];
      showLoadingIcon = true;
      loadExpansionRecursive(runCount);
    });
  }

  loadExpansionRecursive(int currentRunCount) async {
    if (!disposed && runCount == currentRunCount) {
      ExpansionService().getActiveExpansionByPosition(expansions.length).then(
            (element) => {
              if (!disposed && runCount == currentRunCount)
                {
                  setState(
                    () {
                      if (element != null) {
                        expansions.add(element);
                        loadExpansionRecursive(currentRunCount);
                      } else {
                        showLoadingIcon = false;
                      }
                    },
                  ),
                },
            },
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 64),
        child: Column(
          children: [
            ...expansions
                .map<Widget>((e) => ExpansionExpandable(
                      expansion: e,
                      onChanged: () => {widget.onChanged()},
                      onReload: reloadData,
                    ))
                .toList(),
            showLoadingIcon
                ? Padding(
                    padding: EdgeInsets.fromLTRB(0, expansions.isEmpty ? 16 : 0,
                        0, expansions.isEmpty ? 16 : 0),
                    child: const Center(child: CircularProgressIndicator()))
                : Container()
          ],
        ),
      ),
    );
  }
}
