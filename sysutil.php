<?php
  /* System Utilities Script 0.3.0
   * Some functions are Slackware specific
   * Written by Georgi D. Sotirov <gdsotirov@dir.bg>
   */

  /**
   * @add Internationalization array is used for messages in different
   *      languages
   */
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
        "kbit/s" => "<abbr title=\"Kilo bits per second\">Kbps</abbr>",
        "Mbit/s" => "<abbr title=\"Mega bits per second\">Mbps</abbr>",
        "Gbit/s" => "<abbr title=\"Giga bits per second\">Gbps</abbr>"
      ),
      'ups' => array(
	"OL" => "On line (AC power)",
	"OB" => "On battery (DC power)",
        "LB" => "Low battery",
        "RB" => "Replace battery",
        "CHRG" => "Charging battery",
        "DISCHRG" => "Dischargin battery"
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
        "kbit/s" => "<abbr title=\"Кило бита за секунда\">Кбзс</abbr>",
        "Mbit/s" => "<abbr title=\"Мега бита за секунда\">Мбзс</abbr>",
        "Gbit/s" => "<abbr title=\"Гига бита за секунда\">Гбзс</abbr>",
      ),
      'ups' => array(
	"OL" => "На линия (мрежово захранване)",
	"OB" => "На батерия (без мрежово зхранване)",
        "LB" => "Слаба батерия",
        "RB" => "Батерия за смяна",
        "CHRG" => "Зарежда батерия",
        "DISCHRG" => "Разрежда батерия"
      )
    )
  );

  /**
   * @func i18n_msg
   * @desc get internationalized message based on the $I18N_LANG
   *       variable and a message identifier
   */
  function i18n_msg($msg_id) {
    global $I18N_LANG;
    global $i18n_arr;

    if ( isset($i18n_arr[$I18N_LANG][$msg_id])) {
      return $i18n_arr[$I18N_LANG][$msg_id];
    }
    else {
      error_log("l10n error: LANG: $I18N_LANG, message:'$msg_id'");
      return "???";
    }
  }

  /**
   * @func format_unit
   * @desc human readable unit format
   */
  function format_unit($unit, $format, $single_str_id, $multiple_str_id) {
    $single_str = i18n_msg($single_str_id);
    $multiple_str = i18n_msg($multiple_str_id);

    if ($unit == 0.0) {
      return "";
    }
    else if ($unit > 1.0) {
      return sprintf("$format %s ", $unit, $multiple_str);
    }
    else {
      return sprintf("$format %s ", $unit, $single_str);
    }
  }

  /**
   * @func uptime
   * @desc provides formatted uptime string
   * @param diff difference in seconds
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

  /**
   * @func loadavg
   * @desc get system load average
   */
  function loadavg() {
    $la = shell_exec("/usr/bin/cat /proc/loadavg");
    $la_arr = explode(' ', $la);
    $p_arr = explode('/', $la_arr[3]);
    return sprintf(i18n_msg('la_msg'), $la_arr[0], $la_arr[1], $la_arr[2], $p_arr[0], $p_arr[1]);
  }

  /**
   * @func sysup
   * @desc get system up since and up time
   */
  function sysup() {
    $up_arr = preg_split("/\s+/", trim(shell_exec("/usr/bin/cat /proc/stat | /usr/bin/grep -w btime")));
    $upsince = $up_arr[1];
    $uptime = time() - $upsince;
    $upsince_str = date("Y-m-d H:i:s T", $upsince);
    return array($upsince_str, uptime($uptime));
  }

  /**
   * @func hr_mem
   * @desc Human readable memory format
   */
  function hr_mem($mem_in_bytes) {
    if ( !settype($mem_in_bytes, "float") ) {
      return "";
    }
    $unit = 0;
    $unit_arr = i18n_msg('inf_amnt_arr');
    while ($mem_in_bytes > 1024) {
      $unit += 1;
      $mem_in_bytes = $mem_in_bytes / 1024;
    }
    return sprintf("%3.2f %s", $mem_in_bytes, $unit_arr[$unit]);
  }

  /**
   * @func hr_bandw
   * @desc human readable bandwidth unit format
   * @param unit_id Identifier of the result unit
   */
  function hr_bandw($unit_id) {
    $unit_id_lower = strtolower($unit_id);
    $unit_arr = i18n_msg('bit_unit_arr');
    return $unit_arr[$unit_id_lower];
  }

  /**
   * @func meminfo
   * @desc provides associative array with memory info
   */
  function meminfo() {
    $MAJMIN = trim(shell_exec("/usr/bin/uname -r | /usr/bin/awk -F. '{ print $1\".\"$2 }'"));

    if ($MAJMIN == "2.4") {
      $mi = shell_exec("/usr/bin/cat /proc/meminfo");
      $mi_arr = split("\n", $mi);
      $pm_arr = preg_split("/\s+/", $mi_arr[1]);
      $vm_arr = preg_split("/\s+/", $mi_arr[2]);

      $mi_arr['MemFree']   = $pm_arr[1];
      $mi_arr['MemTotal']  = $pm_arr[3];
      $mi_arr['SwapFree']  = $vm_arr[1];
      $mi_arr['SwapTotal'] = $vm_arr[3];
    }
    else {
      $mi = trim(shell_exec("/usr/bin/cat /proc/meminfo"));

      $mi_raw_arr = split("\n", $mi);

      for ($i = 0; $i < sizeof($mi_raw_arr); ++$i) {
        $info = preg_split("/\s+/", trim($mi_raw_arr[$i]));
        $mi_arr[trim($info[0], ":")] = $info[1];
      }
    }

    return $mi_arr;
  }

  function os_info() {
    $os = shell_exec("/usr/bin/uname -o");

    return sprintf("%s", trim($os));
  }

  function kernel_info() {
    $kernel = shell_exec("/usr/bin/uname -s");
    $kernel_rel = shell_exec("/usr/bin/uname -r");

    return sprintf("%s %s", trim($kernel), trim($kernel_rel));
  }

  function mach_info() {
    $machine = shell_exec("/usr/bin/uname -m");

    return sprintf("%s", trim($machine));
  }

  function cpu_info () {
    $cpu_ln = shell_exec("/usr/bin/cat /proc/cpuinfo | /usr/bin/grep 'model name'");
    $cpu_split = explode("\n", $cpu_ln);
    $cpu_arr = preg_split("/:/", $cpu_split[0]);

    return sprintf("%s", trim($cpu_arr[1]));
  }

  function slack_ver() {
    $slack_ver = shell_exec("/usr/bin/cat /etc/slackware-version");

    return sprintf("%s", trim($slack_ver));
  }

  /**
   * @func ups_charge
   * @desc The function reads the battery charge of NUT controlled UPS
   * @param name The name of the UPS device
   */
  function ups_charge($name) {
    $ups_charge = shell_exec("/usr/bin/upsc $name | /usr/bin/grep 'battery.charge:' | /usr/bin/awk -F: '{ print $2 }'");

    return sprintf("%s", trim($ups_charge));
  }

  /**
   * @func ups_charge
   * @desc The function reads the battery charge of NUT controlled UPS
   * @param name The name of the UPS device
   */
  function ups_power($name) {
    $ups_pwr = shell_exec("/usr/bin/upsc $name | /usr/bin/grep 'ups.status:' | /usr/bin/awk -F': ' '{ print $2 }'");
    $unit_arr = i18n_msg('ups');

    return sprintf("%s", $unit_arr[trim($ups_pwr)]);
  }

?>
