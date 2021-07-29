import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ChartListData {

  // int touchedIndex;



  List<PieChartSectionData> getData(touchedIndex) {
      return List.generate(4, (i) {
        final isTouched = i == touchedIndex;

        switch(i) {
          case 0 :
            return PieChartSectionData(
                value: 25,
                title: '25%',
                color: Colors.amber,
            );
          case 1:
            return PieChartSectionData(
              value: 25,
              title: '25%',
              color: Colors.blueAccent
            );
          case 2:
            return PieChartSectionData(
              value: 25,
              title: '25%',
              color: Colors.redAccent
            );
          case 3:
            return PieChartSectionData(
              value: 25,
              title: '25%',
              color: Colors.greenAccent
            );
          default:
            print('Error in chart');
        }

      });
  }

}