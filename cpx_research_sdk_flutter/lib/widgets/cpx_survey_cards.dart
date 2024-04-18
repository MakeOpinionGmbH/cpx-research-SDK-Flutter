import 'package:cpx_research_sdk_flutter/model/cpx_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../cpx_data.dart';


/// With [CPXSurveyCards] you can add the CPX Survey Cards
///
/// The [config] defines the style of the CPX Survey Cards
///
/// The [noSurveysWidget] will display the given parameter widget if there are no surveys available
///
/// The [hideIfEmpty] defines if the entire widget is hidden if there are no surveys to display
///
class CPXSurveyCards extends StatefulWidget {
  const CPXSurveyCards({Key? key, this.config, this.noSurveysWidget, this.hideIfEmpty = false}) : super(key: key);
  final CPXCardConfig? config;
  final Widget? noSurveysWidget;
  final bool hideIfEmpty;

  @override
  _CPXSurveyCardsState createState() => _CPXSurveyCardsState();
}

class _CPXSurveyCardsState extends State<CPXSurveyCards> {
  CPXData cpxData = CPXData.cpxData;
  List<Survey> surveys = [];
  late CPXCardConfig config;

  void onSurveyUpdate() {
    setState(() => surveys = cpxData.surveys.value != null ? cpxData.surveys.value! : []);
  }

  @override
  void initState() {
    cpxData.surveys.addListener(onSurveyUpdate);
    config = widget.config ?? CPXCardConfig();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    return surveys.isNotEmpty
        ? SizedBox(
            height: MediaQuery.of(context).size.width /
                    (orientation == Orientation.portrait
                        ? config.cardCount
                        : config.cardCount * 2.5) +
                30,
            child: GridView.builder(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              itemCount: surveys.length,
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                mainAxisSpacing: 5,
              ),
              itemBuilder: (BuildContext context, int index) {
                return CPXCard(surveys[index], config, cpxData.text.value);
              },
            ),
          )
        : widget.hideIfEmpty
            ? Container()
            : widget.noSurveysWidget ?? Text("No Surveys available");
  }
}

/// With [CPXCardConfig] you can style the CPX Survey Cards
///
/// The [accentColor] defines the color of the coin amount
///
/// The [cardBackgroundColor] defines the background color of the card
///
/// The [inactiveStarColor] defines the color of the inactive rating stars
///
/// The [starColor] defines the color of the active rating stars
///
/// The [textColor] defines the color of the duration of the survey
///
/// The [payoutColor] defines the color of the special reward, if available
///
/// The [cardCount] defines how many cards are displayed next to each other and has an impact on the width of the cards
///

class CPXCardConfig {
  final Color accentColor;
  final Color cardBackgroundColor;
  final Color inactiveStarColor;
  final Color starColor;
  final Color textColor;
  final Color payoutColor;
  final int cardCount;

  CPXCardConfig({
    this.accentColor = const Color(0xff41d7e5),
    this.cardBackgroundColor = Colors.white,
    this.inactiveStarColor = const Color(0xffdfdfdf),
    this.starColor = const Color(0xffffc400),
    this.textColor = Colors.black,
    this.payoutColor = Colors.red,
    this.cardCount = 3,
  });
}

class CPXCard extends StatelessWidget {
  const CPXCard(
    this.survey,
    this.config,
    this.cpxText, {
    Key? key,
  }) : super(key: key);

  final Survey survey;
  final CPXText? cpxText;
  final CPXCardConfig config;

  @override
  Widget build(BuildContext context) {
    Widget getStars() {
      List<Icon> list = <Icon>[];
      for (var i = 1; i <= 5; i++) {
        list.add(
          Icon(
            Icons.star,
            color: i <= survey.statisticsRatingAvg!
                ? config.starColor
                : config.inactiveStarColor,
          ),
        );
      }
      return new Row(children: list);
    }

    return Padding(
      padding: const EdgeInsets.all(2),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: config.cardBackgroundColor,
            foregroundColor: config.inactiveStarColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20))),
        onPressed: () {
          HapticFeedback.selectionClick();
          showBrowser(survey.id);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                survey.payoutOriginal != null ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Text(
                              survey.payoutOriginal ?? '?',
                              style: TextStyle(
                                color: config.textColor,
                                fontWeight: FontWeight.normal,
                                fontSize: 18,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ),
                          FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Text(
                              survey.payout!,
                              style: TextStyle(
                                color: config.payoutColor,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      )
                    : FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Text(
                          survey.payout!,
                          style: TextStyle(
                              color: config.accentColor, fontSize: 18),
                        ),
                      ),
                FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    cpxText != null ? cpxText!.currency_name_plural! : 'Coins',
                    style: TextStyle(color: config.accentColor),
                  ),
                ),
              ],
            ),
            FittedBox(
              fit: BoxFit.fitWidth,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.watch_later_outlined,
                    color: config.accentColor,
                    size: Theme.of(context).textTheme.subtitle1!.fontSize,
                  ),
                  SizedBox(width: 5),
                  Text(
                    '${survey.loi ?? ''} ${cpxText != null ? cpxText!.shortcurt_min : 'Mins'}',
                    style: TextStyle(color: config.textColor),
                  ),
                ],
              ),
            ),
            FittedBox(
              fit: BoxFit.fitWidth,
              child: getStars(),
            )
          ],
        ),
      ),
    );
  }
}
