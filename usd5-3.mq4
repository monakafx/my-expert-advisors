//+------------------------------------------------------------------+
//|                                                       usd5-3.mq4 |
//|                                                         monakafx |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "monakafx"
#property link      ""
#property version   "1.00"
#property strict

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick() {
    // 最新のローソクが発生直後でない場合、何もしない
    if( !isNewCandle() ) { return; }
    
    double sma25_4h = iMA(NULL, PERIOD_H4, 25, 0, 0, 0, 0);

    // U: 陽線
    // L: 陰線
    // UUUL とローソク足が並んでいるか確認する
    if( isLower(1) && isUpper(2) && isUpper(3) && isUpper(4) ) {
        // 売り
        
        // 4時間足がSMA25より下かチェック
        if( sma25_4h <= iHigh(NULL, PERIOD_H4, 0) ) return;
        
        // 3本のローソク足に10pips以上の長さのものが含まれていないか確認する
        if( getCandleLen(2) >= 0.1
            || getCandleLen(3) >= 0.1
            || getCandleLen(4) >= 0.1 ) return;
        
        // 直近10本のローソク足の安値高値がSMA25と20pips以上乖離していないことを確認する
        if( isDis20pips() ) return;
        
        OrderSend( NULL, OP_SELL, 1, Bid, 3, Bid + 0.25, Bid - 0.05, "SELL", 0, 0, Red );      
    } else
    // LLLU とローソク足が並んでいるか確認する
    if( isUpper(1) && isLower(2) && isLower(3) && isLower(4) ) {
        // 買い
        
        // 4時間足がSMA25より上かチェック
        if( sma25_4h >= iLow(NULL, PERIOD_H4, 0) ) return;
        
        // 3本のローソク足に10pips以上の長さのものが含まれていないか確認する
        if( getCandleLen(2) >= 0.1
            || getCandleLen(3) >= 0.1
            || getCandleLen(4) >= 0.1 ) return;
        
        // 直近10本のローソク足の安値高値がSMA25と20pips以上乖離していないことを確認する
        if( isDis20pips() ) return;
        
        OrderSend( NULL, OP_BUY, 1, Ask, 3, Ask - 0.25, Ask + 0.05, "BUY", 0, 0, Blue ); 
    }
}
//+------------------------------------------------------------------+

// 最新のバーが発生した直後か？
bool isNewCandle() {
    return Volume[0] == 1;
}

// 指定したインデックスが陽線・陰線か判定する
bool isUpper(int index) {
    return Open[index] < Close[index];
}
bool isLower(int index) {
    return Open[index] > Close[index];
}

// 指定したインデックスのローソク足の長さを取得する
double getCandleLen(int index) {
    return High[index] - Low[index];
}

// 直近10本のローソク足の安値高値がSMA25と20pips以上乖離しているか確認する
bool isDis20pips() {
    for(int i = 0; i < 10; ++i) {
        int time = i + 1;
        double sma25 = iMA(NULL, 0, 25, 0, 0, 0, time);
        if( MathAbs(sma25 - High[time]) >=20 || MathAbs(sma25 - Low[time]) >=20 ) return true;
    }
    
    return false;
}
