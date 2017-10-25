<?php

/**
 * 用户事件
 * Class Userevent
 */
class Userevent extends CI_Model
{

    public function __construct()
    {
        parent::__construct();
    }

    /**
     * 注册事件
     * @param $userid
     */
    public function reg($userid)
    {
        $this->sale($userid, 'reg');
    }

    /**
     * 登录事件
     * @param $userid
     */
    public function login($userid)
    {
        $this->sale($userid, 'login');
    }

    /**
     * 首次支付押金
     * @param $userid
     */
    public function first_pay($userid)
    {
        $this->sale($userid, 'first_pay');
    }

    /**
     * 每次支付押金
     * @param $userid
     */
    public function every_pay($userid)
    {
        $this->sale($userid, 'every_pay');
    }

    /**
     * 首次完成交易
     * @param $userid
     */
    public function first_complete($userid)
    {
        $this->sale($userid, 'first_complete');
    }

    /**
     * 每次完成交易
     * @param $userid
     */
    public function every_complete($userid)
    {
        $this->sale($userid, 'every_complete');
    }

    /**
     * 首次成功邀请
     * @param $userid
     */
    public function first_invite($userid)
    {
        $this->sale($userid, 'first_invite');
    }

    /**
     * 每次成功邀请
     * @param $userid
     */
    public function every_invite($userid)
    {
        $this->sale($userid, 'every_invite');
    }

    /**
     * 微信事件
     * @param $openid
     * @param $M
     */
    public function wxmessage($openid, $M)
    {

    }

    /** *****************************************************************/
    /** *****************************************************************/
    /** *****************************************************************/

    /**
     * 自动获得卡券
     * @param $userid
     * @param $type
     * @return bool|int
     */
    private function sale($userid, $type)
    {
        if (empty($userid) || empty($type)) {
            return false;
        }
        $user = db_getone(table('users'), array('id' => $userid));
        if (empty($user)) {
            return false;
        }
        $wheresql = "`status`='启用' AND `num`>0 AND `numcan`>0";
        $wheresql .= " AND`autoget` LIKE '%," . $type . ",%'";
        $lists = db_getall(table('sale'), $wheresql);
        if (empty($lists)) {
            return false;
        }
        $i = 0;
        $this->load->library('getui');
        foreach ($lists AS $sale) {
            if ($sale['end_type'] == 'fixed' && $sale['enddate'] < SYS_TIME) {
                continue;
            }
            $lwhere = array('userid' => $user['id'], 'saleid' => $sale['id']);
            if ($sale['numcan_type'] == 'day') {
                $lwhere['`indate`>='] = mktime(0, 0, 0, date('m'), date('d'), date('Y'));
            } elseif ($sale['numcan_type'] == 'week') {
                $lwhere['`indate`>='] = mktime(0, 0, 0, date('m'), date('d') - date('w') + 1, date('Y'));
            } elseif ($sale['numcan_type'] == 'month') {
                $lwhere['`indate`>='] = mktime(0, 0, 0, date('m'), 1, date('Y'));
            } elseif ($sale['numcan_type'] == 'year') {
                $lwhere['`indate`>='] = mktime(0, 0, 0, 1, 1, date('Y'));
            }
            $mysale = db_count(table('users_sale'), $lwhere);
            $autoget_num = min(min($sale['autoget_num'], $sale['numcan'] - $mysale), $sale['num']);
            if ($autoget_num > 0) {
                db_trans_start();
                for ($j = 0; $j < $autoget_num; $j++) {
                    db_insert(table('users_sale'), array('userid' => $user['id'], 'saleid' => $sale['id'], 'from' => 'event_' . $type, 'indate' => SYS_TIME));
                    db_update(table('sale'), array('num[-]' => 1), array('id' => $sale['id']));
                }
                //通知
                $this->getui->message(array(
                    'userid' => $user['id'],
                    'type' => "sale_" . $type,
                    'tobe' => 1,
                    'title' => '获得' . sale_name() . '通知',
                    'subtitle' => '恭喜您获得' . $autoget_num . '张' . sale_name(),
                    'content' => '恭喜您获得' . $autoget_num . '张' . sale_name(),
                    'indate' => SYS_TIME
                ));
                db_trans_complete();
            }
            $i++;
        }
        return $i;
    }
}

?>