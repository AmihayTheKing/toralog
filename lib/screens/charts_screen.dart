import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kosher_dart/kosher_dart.dart';
import 'package:tuple/tuple.dart';
import 'package:zman_limud_demo/models/learn_times_bucket.dart';
import 'package:zman_limud_demo/util/category.dart';
import 'package:zman_limud_demo/util/general_util.dart';

import '../providers/date_type_provider.dart';
import '../providers/learn_times_provider.dart';
import '../widgets/chart_line.dart';

class ChartsScreen extends ConsumerStatefulWidget {
  const ChartsScreen({super.key});

  @override
  _ChartsScreenState createState() => _ChartsScreenState();
}

class _ChartsScreenState extends ConsumerState<ChartsScreen> {
  late final double spacingForNumbersOnLeftSide;
  late final double _paddingOnTopOfChart;
  late final double _labelsHeight;
  DateTime _dateOfDisplayedData = DateTime.now();
  Category? _categoryOfDisplayedData;
  List<LearnTimesBucket<Category>> _currentShownDayBuckets = [];
  final PageController _dateChartPageController = PageController(
    initialPage: 0,
  );
  int _previousPageIndex = 0;

  bool get displayHorizontalLine =>
      _currentShownDayBuckets.any((bucket) => bucket.amount > 0);

  Map<Category, LearnTimesBucket<Category>> get categoryBuckets {
    return Map.fromEntries(
      Category.values.map(
        (category) => MapEntry(
          category,
          LearnTimesBucket<Category>.fromList(
            allLearnTimes: ref.watch(learnTimesProvider),
            whatIsCounted: category,
            filter: (learnTime) => learnTime.category == category,
          ),
        ),
      ), // map
    );
  }

  Map<DateTime, LearnTimesBucket<DateTime>> _currentWeekBuckets(DateTime date) {
    DateTime startOfWeek = date.subtract(
      Duration(days: date.weekday == 7 ? 0 : date.weekday),
    );

    Map<DateTime, LearnTimesBucket<DateTime>> returnedMap = {};
    for (var i = 0; i <= 6; i++) {
      DateTime currentDate = startOfWeek.copyWith(day: startOfWeek.day + i);

      returnedMap[currentDate.onlyDate] = LearnTimesBucket<DateTime>.fromList(
        allLearnTimes: ref.read(learnTimesProvider),
        whatIsCounted: currentDate.onlyDate,
        filter: (learnTime) => learnTime.date.compareDateOnly(currentDate),
      );
    }
    return returnedMap;
  }

  /// Returns a map of [Category] to a tuple containing:
  /// - an inner bucket
  /// - the percentage of its amount relative to the outer bucket.
  ///
  /// Both values are calculated together to avoid duplicate computation.
  Map<Category, Tuple2<LearnTimesBucket<Category>, double>>
      getInnerBucketsAndPrecentages(LearnTimesBucket<DateTime> bucket) {
    Map<Category, Tuple2<LearnTimesBucket<Category>, double>> returnedMap = {};

    for (var category in Category.values) {
      LearnTimesBucket<Category> tempBucket =
          LearnTimesBucket<Category>.fromList(
        allLearnTimes: bucket.learnTimes,
        whatIsCounted: category,
        filter: (learnTime) => learnTime.category == category,
      );
      returnedMap[category] = Tuple2(tempBucket,
          tempBucket.amount == 0 ? 0 : tempBucket.amount / bucket.amount);
    }
    return returnedMap;
  }

  int chartHeightLimitInHours<T>(List<LearnTimesBucket<T>> buckets) {
    final temp =
        buckets.reduce((a, b) => a.amount > b.amount ? a : b).amount.ceil();
    if (temp % 2 != 0) {
      return temp +
          1; // Ensure the largest amount is even for better chart display
    }
    return temp;
  }

  void changeDateChartData(
      DateTime date, List<LearnTimesBucket<Category>> currentShownDayBuckets) {
    setState(
      () {
        _dateOfDisplayedData = date;
        _currentShownDayBuckets = currentShownDayBuckets;
      },
    );
  }

  void onDateChartPageChanged(int index) {
    late DateTime newDate;
    if (_previousPageIndex - index > 0) {
      newDate = _dateOfDisplayedData.add(Duration(days: 7));
    } else {
      newDate = _dateOfDisplayedData.subtract(Duration(days: 7));
    }
    changeDateChartData(
      newDate,
      getInnerBucketsAndPrecentages(
        _currentWeekBuckets(newDate)[newDate.onlyDate]!,
      ).values.map((tuple) => tuple.item1).toList(),
    );
    _previousPageIndex = index;
    setState(() {});
  }

  void changeCategoryChartData(Category category) {
    setState(() {
      _categoryOfDisplayedData = category;
    });
  }

  Widget createChartLines(int largestAmount) {
    return Column(
      children: [
        // the two expandeds make the line in the top of the chart and
        // the middle of the chart
        Expanded(child: ChartLine(largestAmount)),
        Expanded(child: ChartLine(largestAmount / 2)),
        SizedBox(height: _labelsHeight),
      ],
    );
  }

  Widget createCategoryChartHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: getAdaptiveHeight(context, 4),
        horizontal: getAdaptiveWidth(context, 8),
      ),
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(
          categoryBuckets[_categoryOfDisplayedData]?.formattedAmount ?? '',
          style: TextStyle(
              fontSize: getAdaptiveHeight(context, 20),
              fontWeight: FontWeight.bold),
          textDirection: TextDirection.rtl,
        ),
      ),
    );
  }

  Widget createCategoryChart() {
    final largestCategoryAmount = chartHeightLimitInHours(
      categoryBuckets.values.toList(),
    );

    return Container(
      padding: EdgeInsets.only(
        bottom: getAdaptiveHeight(context, 8),
        left: getAdaptiveWidth(context, 8),
        right: getAdaptiveWidth(context, 8),
      ),
      height: getAdaptiveHeight(context, 180),
      width: double.infinity,
      child: Stack(
        children: [
          Positioned.fill(
            child: createChartLines(largestCategoryAmount),
          ),
          Positioned.fill(
            child: Column(
              children: [
                SizedBox(height: _paddingOnTopOfChart),
                Expanded(child: createCategoryChartBars(largestCategoryAmount)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget createCategoryChartBars(int largestCategoryAmount) {
    List<Widget> bars = [];

    for (final bucket in categoryBuckets.values) {
      bars.add(
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(10),
                  ),
                  onTap: () => changeCategoryChartData(bucket.whatIsCounted),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: getAdaptiveWidth(context, 4),
                    ),
                    child: FractionallySizedBox(
                      heightFactor: largestCategoryAmount == 0
                          ? 0
                          : bucket.amount / largestCategoryAmount,
                      alignment: Alignment.bottomCenter,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(8),
                          ),
                          color: categoryColors[bucket.whatIsCounted]!
                              .withOpacity(0.77),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: getAdaptiveHeight(context, 8),
              ),
              Text(
                categoryChartLabels[bucket.whatIsCounted]!,
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    bars.add(SizedBox(width: spacingForNumbersOnLeftSide));

    return Row(
      textDirection: TextDirection.rtl,
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.max,
      children: bars,
    );
  }

  Widget createDateChartHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: getAdaptiveHeight(context, 4),
        horizontal: getAdaptiveWidth(context, 8),
      ),
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(
          _currentWeekBuckets(
                  _dateOfDisplayedData)[_dateOfDisplayedData.onlyDate]!
              .formattedAmount,
          style: TextStyle(
              fontSize: getAdaptiveHeight(context, 20),
              fontWeight: FontWeight.bold),
          textDirection: TextDirection.rtl,
        ),
      ),
    );
  }

  Widget createDateChart() {
    final largestAmount = chartHeightLimitInHours(
      _currentWeekBuckets(_dateOfDisplayedData).values.toList(),
    );

    return SizedBox(
      height: getAdaptiveHeight(context, 180),
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: getAdaptiveHeight(context, 8),
          left: getAdaptiveWidth(context, 8),
          right: getAdaptiveWidth(context, 8),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: createChartLines(largestAmount),
            ),
            Positioned.fill(
              child: Column(
                children: [
                  SizedBox(height: _paddingOnTopOfChart),
                  Expanded(
                    child: Row(
                      children: [
                        SizedBox(width: spacingForNumbersOnLeftSide),
                        Expanded(
                          child: PageView.builder(
                              controller: _dateChartPageController,
                              onPageChanged: onDateChartPageChanged,
                              itemBuilder: (context, index) {
                                return createDateChartBars(
                                  _currentWeekBuckets(
                                    DateTime.now().subtract(
                                      Duration(days: index * 7),
                                    ),
                                  ).values.toList(),
                                );
                              }),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget createDateChartBars(List<LearnTimesBucket<DateTime>> buckets) {
    List<Widget> bars = [];

    for (final bucket in buckets) {
      final innerBucketAndFillPercentages =
          getInnerBucketsAndPrecentages(bucket);

      bars.add(
        Expanded(
          child: InkWell(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            onTap: () => changeDateChartData(
              bucket.whatIsCounted,
              innerBucketAndFillPercentages.values
                  .map((tuple) => tuple.item1)
                  .toList(),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: getAdaptiveWidth(context, 4),
                    ),
                    child: FractionallySizedBox(
                      heightFactor: chartHeightLimitInHours(buckets) == 0
                          ? 0
                          : bucket.amount / chartHeightLimitInHours(buckets),
                      alignment: Alignment.bottomCenter,
                      child: ClipRRect(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(8)),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            for (var category in Category.values)
                              innerBucketAndFillPercentages[category]!.item2 > 0
                                  ? Expanded(
                                      flex: (innerBucketAndFillPercentages[
                                                      category]!
                                                  .item2 *
                                              1000)
                                          .toInt(),
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          color: categoryColors[category]
                                              ?.withOpacity(0.77),
                                        ),
                                      ),
                                    )
                                  : Expanded(
                                      child: SizedBox.shrink(),
                                    ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: getAdaptiveHeight(context, 8)),
                SizedBox(
                  height: _labelsHeight -
                      getAdaptiveHeight(context,
                          16), // 8 because of the padding and 8 because of the sized box above
                  child: ref.watch(dateTypeProvider) == DateType.jewish
                      ? Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: getAdaptiveWidth(context, 4)),
                          child: Text(
                            JewishDate.fromDateTime(bucket.whatIsCounted)
                                .getFormattedDateForChart(),
                            style: TextStyle().copyWith(
                                fontSize: getAdaptiveHeight(context, 10)),
                            textDirection: TextDirection.rtl,
                            textAlign: TextAlign.center,
                          ),
                        )
                      : Text(
                          dateFormatForChart.format(bucket.whatIsCounted),
                          textAlign: TextAlign.center,
                        ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Row(
      textDirection: TextDirection.rtl,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: bars,
    );
  }

  Widget createDateChartFooter() {
    return Column(
      children: [
        if (displayHorizontalLine)
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: getAdaptiveWidth(context, 3)),
            child: Divider(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              thickness: 2,
            ),
          ),
        for (var bucket in _currentShownDayBuckets)
          if (bucket.amount > 0)
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: getAdaptiveHeight(context, 4),
                horizontal: getAdaptiveWidth(context, 8),
              ),
              child: Row(
                textDirection: TextDirection.rtl,
                children: [
                  CircleAvatar(
                    radius: getAdaptiveWidth(context, 8),
                    backgroundColor:
                        categoryColors[bucket.whatIsCounted]?.withOpacity(0.77),
                  ),
                  SizedBox(
                    width: getAdaptiveWidth(context, 8),
                  ),
                  Text(
                    '${categoryNames[bucket.whatIsCounted]}',
                    style: TextStyle(
                      fontSize: getAdaptiveHeight(context, 15),
                    ),
                  ),
                  Spacer(),
                  Text(
                    bucket.formattedAmount,
                    textDirection: TextDirection.rtl,
                  ),
                ],
              ),
            ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();

    _currentShownDayBuckets.addAll(
      getInnerBucketsAndPrecentages(
        _currentWeekBuckets(DateTime.now())[DateTime.now().onlyDate]!,
      ).values.map((tuple) => tuple.item1),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    spacingForNumbersOnLeftSide = getAdaptiveWidth(context, 24);
    _paddingOnTopOfChart = getAdaptiveHeight(context, 8);
    _labelsHeight = getAdaptiveHeight(context, 36);
  }

  @override
  void dispose() {
    _dateChartPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.only(
          bottom: getAdaptiveHeight(context, 90),
          top: getAdaptiveHeight(context, 10),
        ),
        children: [
          Card.filled(
            child: Column(
              children: [
                createCategoryChartHeader(),
                createCategoryChart(),
              ],
            ),
          ),
          Card.filled(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: getAdaptiveHeight(context, 4),
              ),
              child: Column(
                children: [
                  createDateChartHeader(),
                  createDateChart(),
                  createDateChartFooter(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
