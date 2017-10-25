<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Index extends CI_Controller {

	public function __construct()
	{
		parent::__construct();
	}

    public function index()
    {
        tpl(get_defined_vars());
    }

    /**
     * PC登录（后台登录）
     */
    public function login()
    {
        tpl(get_defined_vars());
    }

    /**
     * 推广链接
     */
    public function invite()
    {
        global $_A;
        gourl('https://api.gengdian.net/#/invite?id='.intval($_A['segments'][3]));
    }

    /**
     * 测试租金
     */
    public function totalmoney()
    {
        global $_GPC;
        //
        if ($_GPC['act'] == 'submit') {
            $startDate = strtotime($_GPC['stime']);
            $endDate = strtotime($_GPC['etime']);
            if (date("Y", $startDate) == 1970) {
                json_error("计算失败：起租时间错误");
            }
            if (date("Y", $endDate) == 1970) {
                json_error("计算失败：归还时间错误");
            }
            if ($startDate > $endDate) {
                json_error("计算失败：起租时间 大于 归还时间");
            }
            $mesaage = '【计算成功】';
            $mesaage.= '<div style="font-size:12px;color:#666;line-height:20px;margin-bottom:10px;">每日0:00-10:00只算一个小时<br/>1小时内1元 | 1-3小时2元 | 3-5小时3元 | 1天最多9元</div>';
            //
            $this->load->library('cdbx');
            //相差的天数
            $diffDay = $this->cdbx->dayDiff($startDate, $endDate) + 1;
            $mesaage.= '租用共：'.$diffDay.'天<br/>';
            //第1天的时间
            $dayMinute = $this->cdbx->dayMinute($startDate, $endDate);
            $mesaage.= '第1天：'.$dayMinute.'分钟<br/>';
            //最后1天的时间
            if ($diffDay > 1) {
                $endMinute = $this->cdbx->lastDayMinute($endDate);
                $dayMinute+= $endMinute;
                $mesaage.= '第'.$diffDay.'天：'.$endMinute.'分钟<br/>';
            }
            //第1天和最后1天的租金
            $money = $this->cdbx->minuteMoney($dayMinute);
            if ($diffDay > 1) {
                $mesaage.= '第1+'.$diffDay.'天的租金：'.$money.'元<br/>';
            }else{
                $mesaage.= '第1天的租金：'.$money.'元<br/>';
            }
            //除去前后2天以外的租金
            if ($diffDay > 2) {
                $endmo = ($diffDay - 2) * $this->cdbx->dayMax;
                $money+= $endmo;
                $mesaage.= '第2~'.($diffDay-1).'天：'.$endmo.'元（共'.($diffDay - 2).'天）<br/>';
            }
            //
            $mesaage.= '总计：'.min($this->cdbx->totalMax, $money).'元';
            json_sure($mesaage);
        }
        tpl(get_defined_vars());
    }
}
