import 'backend_link/main.dart' as graphql;
import 'package:flutter/material.dart';

class Scene implements CustomPainter {
  Scene() {}

  @override
  void addListener(listener) {}

  @override
  bool hitTest(Offset position) {
    print('hittest');
  }

  @override
  void paint(Canvas canvas, Size size) {
    print(size);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

  @override
  void removeListener(listener) => null;

  @override
  get semanticsBuilder => null;

  @override
  bool shouldRebuildSemantics(covariant CustomPainter oldDelegate) => false;
}


 /*
    scene = Scene(<options>)
    candles = list()
    formattedCandles = [{time: <timestamp>, open: <double>, high: <double>, low: <double>, close: <double> }]
    candleGraph = scene.addCandles(formattedCandles)
    line = scene.addLine(xStart: <timestamp>, yStart: <double>, xEnd: <timestamp>, yEnd: <timestamp>)
    
    scene = Scene()
    candles = list()
    List formattedCandles = [{time: <timestamp>, open: <double>, high: <double>, low: <double>, close: <double> }]
    candleLayer = CandleLayer(formattedCandles)
    scene.add(candleLayer)
    lineLayer = LineLayer(xStart: <timestamp>, yStart: <double>, xEnd: <timestamp>, yEnd: <timestamp>)
    scene.add(lineLayer)

    Layer {
      draw(c)
      hitTest()
      zindex: <double>
    }

    CandleLayer: Layer {
      List candlesData
      List<CandleDrawable> candlesView

      CandleLayer(this.candle)
      
      draw(cursor) {
        candleView.reset()
        foreach candleData {
          cursor.next()
          candle = Geometry.buildCandle(cursor: <GraphCursor>, OHLC: <OHLC> ): CandleDrawable
          candleView.add(candle)
        }
      }
      
      hitTest(Offset) {
        foreach candleView {
          if candle.hittest(Offset) {
            return true
          }
        }
      }
    }

    Geometry {
      percentMarginLR = 3
      buildCandle(cursor: <Cursor>, OHLC: <OHLC>) {
      }

      makeBody() {
        LR = makeLeftRight(cursor)
        open = cursor.scene.yaxis.dataToPixel(OHLC.open)
        close = cursor.scene.yaxis.dataToPixel(OHLC.close)
        cursor.canvas.drawRect = 
      }

      makeBodyColor() {
        cursor.scene.theme.candle.up
      }

      makeLeftRight(cursor: <Cursor>) {
        cumuledMarginLR = 3% of cursor.column.width
        margin = cumuledMarginLR / 2
        candleWidth = cursor.column.width - marginLR
        left = cursor.column.left + margin
        right = cursor.column.right - margin

        return Offset(left, right)
      }

      Cursor {
        scene
        unit
        
      }
    }
    -
    */
