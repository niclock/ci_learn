<?php

class Gps
{

	/**
	 * 根据两点间的经纬度计算距离
	 * @param $lat1
	 * @param $lng1
	 * @param $lat2
	 * @param $lng2
	 * @return float
	 */
	public function getDistance($lat1, $lng1, $lat2, $lng2)
	{
		$earthRadius = 6367000;
		$lat1 = ($lat1 * pi() ) / 180;
		$lng1 = ($lng1 * pi() ) / 180;
		$lat2 = ($lat2 * pi() ) / 180;
		$lng2 = ($lng2 * pi() ) / 180;
		$calcLongitude = $lng2 - $lng1;
		$calcLatitude = $lat2 - $lat1;
		$stepOne = pow(sin($calcLatitude / 2), 2) + cos($lat1) * cos($lat2) * pow(sin($calcLongitude / 2), 2);
		$stepTwo = 2 * asin(min(1, sqrt($stepOne)));
		$calculatedDistance = $earthRadius * $stepTwo;
		return round($calculatedDistance);
	}

	/**
	 * 格式化距离 米 千米
	 * @param $dis
	 * @return string
	 */
	public function distanceFormat($dis)
	{
		if ($dis > 1000) {
			return number_format(round($dis) / 1000, 2).'千米';
		}
		return $dis.'米';
	}

    /**
     * 百度坐标（BD09）转国测局坐标(火星坐标,GCJ02)
     * @param $lat
     * @param $lng
     * @return array
     */
    public static function BaiduToGcj02($lat, $lng)
    {
        if (empty($lat) || empty($lng)) {
            return array();
        }
        $apiurl = "http://apis.map.qq.com/ws/coord/v1/translate?locations=".$lat.",".$lng."&type=3&key=2HHBZ-DSP64-2YOUR-X3DJK-4GVHV-SGFOX";
        $result = @file_get_contents($apiurl);
        $json = json_decode($result, true);
        if ($json['status'] == 0) {
            return $json['locations'][0];
        }else{
            return array();
        }
    }
}
?>