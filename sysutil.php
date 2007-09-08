<?php
  /* System Utilities Script 0.2.1
   * Written by Georgi D. Sotirov <gdsotirov@dir.bg>
   * $Id: sysutil.php,v 1.3 2007/09/08 12:32:29 gsotirov Exp $
   */
  // Internationalization array
  $i18n_arr = array(
    'en' => array(
      'day' => "day",
      'days' => "days",
      'month' => "month",
      'months' => "months",
      'year' => "year",
      'years' => "years",
      'second' => "second",
      'seconds' => "seconds",
      'secsecs' => "second(s)",
      'minute' => "minute",
      'minutes' => "minutes",
      'hour' => "hour",
      'hours' => "hours",
      'uptime_msg' => "%s%s%s%d second(s)",
      'la_msg' => "%s %s %s (%s of %s processes running)",
      'mem_msg' => "%s of %s free",
      'inf_amnt_arr' => array(
        "<abbr title=\"Bytes\">B</abbr>",
        "<abbr title=\"Kilo Bytes\">KB</abbr>",
        "<abbr title=\"Mega Bytes\">MB</abbr>",
        "<abbr title=\"Giga Bytes\">GB</abbr>",
        "<abbr title=\"Tera Bytes\">TB</abbr>",
        "<abbr title=\"Peta Bytes\">PB</abbr>"
      ),
      'bit_unit_arr' => array(
        "bps" => "<abbr title=\"bits per second\">bps</abbr>",
        "kbps" => "<abbr title=\"Kilo bits per second\">Kbps</abbr>",
        "mbps" => "<abbr title=\"Mega bits per second\">Mbps</abbr>",
        "gbps" => "<abbr title=\"Giga bits per second\">Gbps</abbr>",
        "tbps" => "<abbr title=\"Tera bits per second\">Tbps</abbr>"
      )
    ),
    'bg' => array(
      'day' => "ден",
      'days' => "дни",
      'month' => "месец",
      'months' => "месеца",
      'year' => "година",
      'years' => "години",
      'second' => "секунда",
      'seconds' => "секунди",
      'secsecs' => "секунди",
      'minute' => "минута",
      'minutes' => "минути",
      'hour' => "час",
      'hours' => "часа",
      'uptime_msg' => "%s%s%s%d секунди",
      'la_msg' => "%s %s %s (%s от %s процеса се изпълняват)",
      'mem_msg' => "%s от %s свободни",
      'inf_amnt_arr' => array(
        "<abbr title=\"Байта\"><span lang=\"en\">Б</span></abbr>",
        "<abbr title=\"Кило Байта\">КБ</abbr>",
        "<abbr title=\"Мега Байта\">МБ</abbr>",
        "<abbr title=\"Гига Байта\">ГБ</abbr>",
        "<abbr title=\"Тера Байта\">ТБ</abbr>",
        "<abbr title=\"Пета Байта\">ПБ</abbr>"
      ),
      'bit_unit_arr' => array(
        "bps" => "<abbr title=\"бита за секунда\">бзс</abbr>",
        "kbps" => "<abbr title=\"Кило бита за секунда\">Кбзс</abbr>",
        "mbps" => "<abbr title=\"Мега бита за секунда\">Мбзс</abbr>",
        "gbps" => "<abbr title=\"Гига бита за секунда\">Гбзс</abbr>",
        "tbps" => "<abbr title=\"Тера бита за секунда\">Тбзс</abbr>"
      )
    )
  );

  /* Function   : i18n_msg
   * Description: get internationalized message based on the $I18N_LANG
   *              variable and a message identifier.
   */
  function i18n_msg($msg_id) {
    global $I18N_LANG;
    global $i18n_arr;

    if ( isset($i18n_arr[$I18N_LANG][$msg_id])) {
      return $i18n_arr[$I18N_LANG][$msg_id];
    }
    else {
      error_log("l10n error: LANG: $lang, message:'$s'");
      return "???";
    }
  }

  /* Function   : format_unit
   * Description: human readable unit format
   */
  function format_unit($unit, $format, $single_str_id, $multiple_str_id) {
    $single_str = i18n_msg($single_str_id);
    $multiple_str = i18n_msg($multiple_str_id);

    if ($unit == 0.0)
      return "";
    else if ($unit > 1.0)
      return sprintf("$format %s ", $unit, $multiple_str);
    else
      return sprintf("$format %s ", $unit, $single_str);
  }

  /* Function   : uptime
   * Description: format uptime string
   * Parameters : diff - difference in seconds
   */
  function uptime($diff) {
    $days = floor($diff/60/60/24);
    $days_str = format_unit($days, "%d", 'day', 'days');
    $diff -= $days*60*60*24;
    $hours = floor($diff/60/60);
    $hours_str = format_unit($hours, "%d", 'hour', 'hours');
    $diff -= $hours*60*60;
    $minutes = floor($diff/60);
    $minutes_str = format_unit($minutes, "%d", 'minute', 'minutes');
    $diff -= $minutes*60;
    return sprintf(i18n_msg('uptime_msg'), $days_str, $hours_str, $minutes_str, $diff);
  }

  /* Function   : loadavg
   * Description: get system load average
   */
  function loadavg() {
    $la = shell_exec("cat /proc/loadavg");
    $la_arr = explode(' ', $la);
    $p_arr = explode('/', $la_arr[3]);
    return sprintf(i18n_msg('la_msg'), $la_arr[0], $la_arr[1], $la_arr[2], $p_arr[0], $p_arr[1]);
  }

  /* Function   : sysup
   * Description: get system up since and up time
   */
  function sysup() {
    $up_arr = preg_split("/\s+/", trim(shell_exec("cat /proc/stat | grep -w btime")));
    $upsince = $up_arr[1];
    $uptime = time() - $upsince;
    $upsince_str = date("Y-m-d H:i:s T", $upsince);
    return array($upsince_str, uptime($uptime));
  }

  /* Function   : hr_mem
   * Description: Human readable memory format
   */
  function hr_mem($mem_in_bytes) {
    if ( !settype($mem_in_bytes, "float") )
      return "";
    $unit = 0;
    $unit_arr = i18n_msg('inf_amnt_arr');
    while ($mem_in_bytes > 1024) {
      $unit += 1;
      $mem_in_bytes = $mem_in_bytes / 1024;
    }
    return sprintf("%3.2f %s", $mem_in_bytes, $unit_arr[$unit]);
  }

  /* Function   : hr_bandw
   * Description: human readable bandwidth unit format
   */
  function hr_bandw($unit_id) {
    $unit_id_lower = strtolower($unit_id);
    $unit_arr = i18n_msg('bit_unit_arr');
    return $unit_arr[$unit_id_lower];
  }

  function meminfo() {
    $MAJMIN = trim(shell_exec("uname -r | awk -F. '{ print $1\".\"$2 }'"));
    if ($MAJMIN == "2.6") {
      $mi = trim(shell_exec("cat /proc/meminfo"));
      $mi_raw_arr = split("\n", $mi);
      for ($i = 0; $i < sizeof($mi_raw_arr); ++$i) {
        $info = preg_split("/\s+/", trim($mi_raw_arr[$i]));
        $mi_arr[trim($info[0], ":")] = $info[1];
      }
      $pm_free  = $mi_arr['MemFree'];
      $pm_total = $mi_arr['MemTotal'];
      $vm_free  = $mi_arr['SwapFree'];
      $vm_total = $mi_arr['SwapTotal'];
      //echo "pm_free = $pm_free, pm_total = $pm_total, vm_free = $vm_free, vm_total = $vm_total\n";

      $pm_str = sprintf(i18n_msg('mem_msg'), hr_mem($pm_free*1024), hr_mem($pm_total*1024));
      $vm_str = sprintf(i18n_msg('mem_msg'), hr_mem($vm_free*1024), hr_mem($vm_total*1024));
    }
    else if ($MAJMIN == "2.4") {
      $mi = shell_exec("cat /proc/meminfo");
      $mi_arr = split("\n", $mi);
      $pm_arr = preg_split("/\s+/", $mi_arr[1]);
      $vm_arr = preg_split("/\s+/", $mi_arr[2]);
      $pm_total = $pm_arr[1];
      //$pm_used = $pm_arr[2];
      $pm_free = $pm_arr[3];
      //$pm_shared = $pm_arr[4];
      //$pm_buffers = $pm_arr[5];
      //$pm_cached = $pm_arr[6];
      $vm_total = $vm_arr[1];
      //$vm_used = $vm_arr[2];
      $vm_free = $vm_arr[3];
      $pm_str = sprintf(i18n_msg('mem_msg'), hr_mem($pm_free), hr_mem($pm_total));
      $vm_str = sprintf(i18n_msg('mem_msg'), hr_mem($vm_free), hr_mem($vm_total));
    }
    else {
      $pm_str = "?";
      $vm_str = "?";
    }

    return array($pm_str, $vm_str);
  }

  function os_info() {
    $os = shell_exec("uname -o");
    return sprintf("%s", trim($os));
  }

  function kernel_info() {
    $kernel = shell_exec("uname -s");
    $kernel_rel = shell_exec("uname -r");
    return sprintf("%s %s", trim($kernel), trim($kernel_rel));
  }

  function mach_info() {
    $machine = shell_exec("uname -m");
    return sprintf("%s", trim($machine));
  }

  function cpu_info () {
    $cpu_ln = shell_exec("cat /proc/cpuinfo | grep 'model name'");
    $cpu_arr = preg_split("/:/", $cpu_ln);
    return sprintf("%s", trim($cpu_arr[1]));
  }

  function slack_ver() {
    $slack_ver = shell_exec("cat /etc/slackware-version");
    return sprintf("%s", trim($slack_ver));
  }
?>
