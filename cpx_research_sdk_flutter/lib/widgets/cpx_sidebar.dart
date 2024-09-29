/*
 * cpx_sidebar.dart
 * CPX Research
 *
 * Created by Dennis Kossmann on 18.7.2021.
 * Copyright © 2021. All rights reserved.
 */

import 'package:cpx_research_sdk_flutter/cpx_controller.dart';
import 'package:cpx_research_sdk_flutter/enumerations/cpx_widget_type.dart';
import 'package:cpx_research_sdk_flutter/model/cpx_style.dart';
import 'package:cpx_research_sdk_flutter/utils/cpx_network_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CPXSidebar extends StatelessWidget {
  final CPXStyle style;

  CPXSidebar(this.style);

  @override
  Widget build(BuildContext context) => Align(
        alignment: style.position.alignment,
        child: InkWell(
          onTap: () {
            HapticFeedback.selectionClick();
            CPXController.controller
                .showBrowser(singleSurvey: style.singleSurvey);
          },
          child: Image(
            image: NetworkImage(
              CPXNetworkService()
                  .getCPXImage(
                      type: CPXWidgetType.side,
                      position: style.position.key,
                      style: style)
                  .toString(),
            ),
            fit: BoxFit.cover,
          ),
        ),
      );
}
