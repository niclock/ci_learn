<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Pages extends CI_Controller
{

    public function __construct()
    {
        parent::__construct();
    }

    public function _remap()
    {
        global $_A;
        $segments = implode(DIRECTORY_SEPARATOR, $_A['segments']);
        $tpl_path = BASE_PATH . 'templates' . DIRECTORY_SEPARATOR . BASE_TEMP . DIRECTORY_SEPARATOR . $segments . '.tpl';
        if (!file_exists($tpl_path)) {
            page_tis();
        }
        $export = '$A.export.'.implode('_', $_A['segments']);
        the_user();
        tpl(leftdelete($segments, "pages" . DIRECTORY_SEPARATOR), get_defined_vars());
    }
}
