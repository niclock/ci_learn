<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Users extends CI_Controller {

	public function __construct()
	{
		parent::__construct();
	}

    public function _remap()
    {
        global $_A;
        if ($_A['segments'][2]) {
            gourl(url('users').'?s='.$_A['segments'][2]);
        }
        tpl('index', get_defined_vars());
    }
}
