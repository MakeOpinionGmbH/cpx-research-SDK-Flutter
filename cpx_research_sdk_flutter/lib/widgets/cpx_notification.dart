/*
 * cpx_notification.dart
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

class CPXNotification extends StatelessWidget {
  final CPXStyle style;

  CPXNotification(this.style);

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<bool>(
        valueListenable: CPXController.controller.isCPXNotificationDisplayed,
        builder: (context, isCPXNotificationDisplayed, child) =>
            isCPXNotificationDisplayed
                ? Align(
                    alignment: style.position.alignment,
                    child: InkWell(
                      onTap: () {
                        HapticFeedback.selectionClick();
                        CPXController.controller
                            .showBrowser(singleSurvey: style.singleSurvey);
                      },
                      child: Container(
                        width: style.width,
                        constraints: BoxConstraints(
                          minWidth: 1,
                          maxWidth: MediaQuery.of(context).size.width * 0.8,
                          minHeight: 1,
                          maxHeight: MediaQuery.of(context).size.height * 0.4,
                        ),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black54.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 3,
                              offset: Offset(0, 3),
                            ),
                          ],
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(style.roundedCorners),
                            bottomRight: Radius.circular(style.roundedCorners),
                          ),
                          color: Colors.transparent,
                        ),
                        child: Stack(
                          children: [
                            Image(
                              image: NetworkImage(CPXNetworkService()
                                  .getCPXImage(
                                      type: CPXWidgetType.notification,
                                      position: style.position.key,
                                      style: style)
                                  .toString()),
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                              right: 10,
                              top: 10,
                              child: IconButton(
                                alignment: Alignment.topRight,
                                icon: Icon(Icons.close),
                                color: style.textColor,
                                iconSize: style.textSize + 5,
                                onPressed: () {
                                  HapticFeedback.selectionClick();
                                  CPXController.controller.hideNotification();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : const SizedBox(),
      );
}
