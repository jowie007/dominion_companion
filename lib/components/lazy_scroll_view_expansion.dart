import 'package:dominion_comanion/components/expansion_expandable.dart';
import 'package:dominion_comanion/model/expansion/expansion_model.dart';
import 'package:dominion_comanion/services/expansion_service.dart';
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

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadExpansionRecursive();
    });
  }

  loadExpansionRecursive() async {
    ExpansionService().getExpansionByPosition(expansions.length).then(
          (element) => {
            setState(
              () {
                if (element != null) {
                  setState(() {
                    expansions.add(element);
                  });
                  loadExpansionRecursive();
                } else {
                  setState(() {
                    showLoadingIcon = false;
                  });
                }
              },
            ),
          },
        );
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
                    expansion: e, onChanged: () => {widget.onChanged()}))
                .toList(),
            showLoadingIcon
                ? const Center(child: CircularProgressIndicator())
                : Container()
          ],
        ),
      ),
    );
  }
}