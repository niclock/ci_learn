<?php

class Cdbx
{
    var $totalMax   = 88;       //总计最高

    /** ***************************************************************************** */
    /** **************************现收费系统2017-06-16开始使用************************** */
    /** ***************************************************************************** */

    /**
     * 获取租用总费用
     * 每小时1元，24小时最高3元
     * @param int $startDate    开始借用时间戳
     * @param int $endDate      结束借用时间戳
     * @param int $saleTime     抵借用多少小时
     * @param string $type      设备类型
     * @return mixed
     */
    public function totalMoney($startDate, $endDate = 0, $saleTime = 0, $type = '')
    {
        if ($endDate == 0) {
            $endDate = SYS_TIME;
        }
        if ($endDate < $startDate) {
            $tmp = $startDate;
            $startDate = $endDate;
            $endDate = $tmp;
        }

        if ($type == '雨伞') {
            //雨伞免租金
            return 0;
        }

        $second = $endDate - $startDate;
        if ($second / 60 <= 30) {
            //30分钟前免费
            return 0;
        }

        $hour = ceil($second / 3600);


//        //抵时长 > 租用时长
//        if ($saleTime >= $hour) {
//            return 0;
//        }
//        //抵时长 >= 24小时
//        if ($saleTime >= 24) {
//            $saleDay = floor($saleTime / 24);
//            $hour-= $saleDay * 24;
//            $saleTime-= $saleDay * 24;
//        }
        //通过抵时长计算出优惠价钱
        $saleMoney = 0;

        if ($saleTime > 0) {
//            $firstDayHour = min(24, $hour);                         //第一天最多时间
//            $beforeMoney = min(3, $firstDayHour);                   //第一天的租金（用券前）
//            $afterMoney = min(3, $firstDayHour - $saleTime);        //第一天的租金（用券后）

              $diffHour=$hour-$saleTime;
            if(6>$diffHour&&$diffHour>0){
                $saleMoney = ceil($diffHour) ;                //计算出用券抵了多钱租金
            }elseif($diffHour>=6&&$diffHour<24){
                $saleMoney=6;
            }elseif ($diffHour>=24){
                $day = floor($diffHour / 24);
                $lastHour = floor($diffHour % 24);
                if($lastHour<6){
                    $saleMoney=$day*6+ $lastHour;
                }elseif ($lastHour>=6){
                    $saleMoney=$day*6+ 6;
                }
            }


        }


//        //
//        $money = 0;
//        if ($hour >= 24) {
//            //大于1天
//            $day = floor($hour / 24);
//            $hour-= $day * 24;
//            $money+= $day * 3;
//        }
//        $money+= min(3, $hour);
        //
        return min($this->totalMax, $saleMoney);
    }

    /** ***************************************************************************** */
    /** **************************原收费系统2017-06-16前使用*************************** */
    /** ***************************************************************************** */

    var $dayMax     = 9;        //一天最高9元

    /**
     * 获取租用总费用
     * @param int $startDate    开始借用时间戳
     * @param int $endDate      结束借用时间戳
     * @return mixed
     */
    public function __totalMoney($startDate, $endDate = 0)
    {
        if ($endDate == 0) {
            $endDate = SYS_TIME;
        }
        if ($endDate < $startDate) {
            $tmp = $startDate;
            $startDate = $endDate;
            $endDate = $tmp;
        }
        //相差的天数
        $dayDiff = $this->dayDiff($startDate, $endDate) + 1;
        //第1天的时间
        $dayMinute = $this->dayMinute($startDate, $endDate);
        //最后1天的时间
        if ($dayDiff > 1) {
            $dayMinute+= $this->lastDayMinute($endDate);
        }
        //第1天和最后1天的租金
        $money = $this->minuteMoney($dayMinute);
        //除去前后2天以外的租金
        if ($dayDiff > 2) {
            $money+= ($dayDiff - 2) * $this->dayMax;
        }
        //
        return min($this->totalMax, $money);
    }

    /**
     * 求两个时间戳之间相差的天数(自然天)
     * @param $date1
     * @param $date2
     * @return int
     */
    public function dayDiff($date1, $date2)
    {
        $second1 = strtotime(date("Y-m-d", $date1));
        $second2 = strtotime(date("Y-m-d", $date2));
        if ($second1 < $second2) {
            $tmp = $second2;
            $second2 = $second1;
            $second1 = $tmp;
        }
        return ($second1 - $second2) / 86400;
    }

    /**
     * 使用时长(分钟) 转 实际价格(元)
     * @param $minute
     * @return int
     */
    public function minuteMoney($minute)
    {
        if ($minute > 900) {
            //超过15小时 (因为0-10点只算1个小时所以1天最多15个小时)
            $day = floor($minute / 900);
            $money = $day * $this->dayMax;
            $money+= $this->minuteMoney($minute - ($day * 900));
        }elseif ($minute > 300) {
            //5-15小时
            $money = 3 + ceil(($minute - 300) / 60);
            $money = min($this->dayMax, $money);
        }elseif ($minute > 180) {
            //3-5小时
            $money = 3;
        }elseif ($minute > 60) {
            //1-3小时
            $money = 2;
        }elseif ($minute > 0) {
            //1小时内
            $money = 1;
        }else{
            //0（1秒都没有）
            $money = 0;
        }
        return $money;
    }

    /**
     * 计算1天用时（分钟）
     * @param int $startTime    开始的时间戳
     * @param int $endTime      结束的时间戳
     * @return int
     */
    public function dayMinute($startTime, $endTime)
    {
        //最后1秒的时间戳
        $endTime = min($endTime, strtotime(date("Y-m-d 24:00:00", $startTime)));
        //10点的时间戳
        $tenTime = strtotime(date("Y-m-d 10:00:00", $startTime));
        //
        if ($endTime < $tenTime) {
            //在10点之前结束
            $diffSecond = min(3600, $endTime - $startTime);
        }else{
            //在10点之后结束
            if ($startTime < $tenTime) {
                //在10点之前开始
                $diffSecond = $endTime - $tenTime;
                $diffSecond+= min(3600, $tenTime - $startTime);
            }else{
                //在10点之后开始
                $diffSecond = $endTime - $startTime;
            }
        }
        //
        return max(ceil($diffSecond / 60), 0);
    }

    /**
     * 获取最后一天的时间(分钟)
     * @param int $endTime      结束的时间戳
     * @return int
     */
    public function lastDayMinute($endTime)
    {
        return $this->dayMinute(strtotime(date("Y-m-d 00:00:00", $endTime)), $endTime);
    }

}