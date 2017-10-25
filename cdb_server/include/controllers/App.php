<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class App extends CI_Controller {

	public function __construct()
	{
		parent::__construct();
	}

    public function index()
    {
        gourl('https://api.gengdian.net/#/app');
    }
}
