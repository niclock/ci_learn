<?php

class Pexcel
{
    public function __construct()
    {
        include_once 'PHPExcel.php';
        include_once 'PHPExcel/IOFactory.php';
    }

    /**
     * @param string $expTitle      文件标题
     * @param array $expCellName    标题
     * @param array $expTableData   内容
     * @param array $otherData      其他数据
     */
    public function export($expTitle, $expCellName, $expTableData, $otherData)
    {
        $xlsTitle = $expTitle;
        $fileName = $xlsTitle.date('_YmdHi');
        $cellNum = count($expCellName);
        $dataNum = count($expTableData);

        $objPHPExcel = new PHPExcel();
        $cellName = array('A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z','AA','AB','AC','AD','AE','AF','AG','AH','AI','AJ','AK','AL','AM','AN','AO','AP','AQ','AR','AS','AT','AU','AV','AW','AX','AY','AZ');

        for($i=0;$i<$cellNum;$i++){
            $objPHPExcel->setActiveSheetIndex(0)->setCellValue($cellName[$i].'1', $expCellName[$i]);
        }

        $o = 3;
        for($i=0;$i<$dataNum;$i++){
            for($j=0;$j<$cellNum;$j++){
                $objPHPExcel->getActiveSheet()->setCellValueExplicit($cellName[$j].($i+2), $expTableData[$i][$j], PHPExcel_Cell_DataType::TYPE_STRING);
                //$objPHPExcel->getActiveSheet()->setCellValue($cellName[$j].($i+2), $expTableData[$i][$j]);
            }
            $o++;
        }

        foreach ($otherData AS $item) {
            $objPHPExcel->getActiveSheet()->mergeCells('A'.$o.':'.$cellName[$cellNum-1].$o);
            $objPHPExcel->setActiveSheetIndex(0)->setCellValue('A'.$o.'', $item);
            $o++;
        }

        header('pragma:public');
        header('Content-type:application/vnd.ms-excel;charset=utf-8;name="'.$xlsTitle.'.xls"');
        header("Content-Disposition:attachment;filename=$fileName.xls");//attachment新窗口打印inline本窗口打印

        $xlsWriter = new PHPExcel_Writer_Excel5($objPHPExcel);
        $xlsWriter->save('php://output');
        exit();
    }
}
?>