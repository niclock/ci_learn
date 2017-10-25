<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Weixin extends CI_Controller {

    public function __construct()
    {
        parent::__construct();
    }

    /**
     * 微信接口
     */
    public function index()
    {
        $this->load->model('receive');
        $this->receive->receive();
    }
}
