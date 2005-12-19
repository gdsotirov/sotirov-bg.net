/* Function printf(format_string,arguments...)
 * Javascript emulation of the C printf function (modifiers and argument types
 *    "p" and "n" are not supported due to language restrictions)
 *
 * Copyright 2003 K&L Productions. All rights reserved
 * http://www.klproductions.com
 *
 * Terms of use: This function can be used free of charge IF this header is not
 *               modified and remains with the function code.
 *
 * Legal: Use this code at your own risk. K&L Productions assumes NO resposibility
 *        for anything.
 ********************************************************************************/

/* Modified by Georgi D. Sotirov <gdsotirov@dir.bg>
 *
 * 2005-12-04 Added support for %% which should escape % character
 */

function sprintf(fstring) {
  var pad = function(str, ch, len) {
    var ps = '';
    for ( var i = 0; i < Math.abs(len); ++i )
      ps += ch;
    return len > 0 ? str + ps : ps + str;
  }

  var processFlags = function(flags,width,rs,arg) {
    var pn = function(flags,arg,rs) {
      if ( arg >= 0) {
        if ( flags.indexOf(' ') >= 0 )
          rs = ' ' + rs;
        else if ( flags.indexOf('+') >= 0 )
          rs = '+' + rs;
      }
      else
        rs = '-' + rs;
      return rs;
    }

    var iWidth = parseInt(width, 10);

    if ( width.charAt(0) == '0' ) {
      var ec = 0;
      if ( flags.indexOf(' ') >= 0 || flags.indexOf('+') >= 0 )
        ec++;
      if ( rs.length < (iWidth - ec) )
        rs = pad(rs, '0', rs.length - (iWidth - ec));
      return pn(flags, arg, rs);
    }

    rs = pn(flags, arg, rs);

    if ( rs.length < iWidth ) {
      if ( flags.indexOf('-') < 0)
        rs = pad(rs, ' ', rs.length - iWidth);
      else
        rs = pad(rs, ' ', iWidth - rs.length);
    }
    return rs;
  }

  var converters = new Array();

  converters['c'] = function(flags, width, precision, arg) {
    if ( typeof(arg) == 'number' )
      return String.fromCharCode(arg);
    if ( typeof(arg) == 'string' )
      return arg.charAt(0);
    return '';
  }

  converters['d'] = function(flags, width, precision, arg) {
    return converters['i'](flags, width, precision, arg);
  }

  converters['u'] = function(flags, width, precision, arg) {
    return converters['i'](flags, width, precision, Math.abs(arg));
  }

  converters['i'] = function(flags, width, precision, arg) {
    var iPrecision = parseInt(precision);
    var rs = ((Math.abs(arg)).toString().split('.'))[0];
    if ( rs.length < iPrecision)
      rs = pad(rs, ' ', iPrecision - rs.length);
    return processFlags(flags, width, rs, arg);
  }

  converters['E'] = function(flags, width, precision, arg) {
    return (converters['e'](flags, width, precision, arg)).toUpperCase();
  }

  converters['e'] =  function(flags, width, precision, arg) {
    iPrecision = parseInt(precision);
    if ( isNaN(iPrecision) )
      iPrecision = 6;
    rs = (Math.abs(arg)).toExponential(iPrecision);
    if ( rs.indexOf('.') < 0 && flags.indexOf('#') >= 0 )
      rs = rs.replace(/^(.*)(e.*)$/,'$1.$2');
    return processFlags(flags,width,rs,arg);
  }

  converters['f'] = function(flags, width, precision, arg) {
    iPrecision = parseInt(precision);
    if ( isNaN(iPrecision) )
      iPrecision = 6;
    rs = (Math.abs(arg)).toFixed(iPrecision);
    if ( rs.indexOf('.') < 0 && flags.indexOf('#') >= 0 )
      rs = rs + '.';
    return processFlags(flags, width, rs, arg);
  }

  converters['G'] = function(flags, width, precision, arg) {
    return (converters['g'](flags, width, precision, arg)).toUpperCase();
  }

  converters['g'] = function(flags, width, precision, arg) {
    iPrecision = parseInt(precision);
    absArg = Math.abs(arg);
    rse = absArg.toExponential();
    rsf = absArg.toFixed(6);
    if( !isNaN(iPrecision) ) {
      rsep = absArg.toExponential(iPrecision);
      rse = rsep.length < rse.length ? rsep : rse;
      rsfp = absArg.toFixed(iPrecision);
      rsf = rsfp.length < rsf.length ? rsfp : rsf;
    }
    if ( rse.indexOf('.') < 0 && flags.indexOf('#') >= 0 )
      rse = rse.replace(/^(.*)(e.*)$/,'$1.$2');
    if ( rsf.indexOf('.') < 0 && flags.indexOf('#') >= 0 )
      rsf = rsf + '.';
    rs = rse.length < rsf.length ? rse : rsf;
    return processFlags(flags, width, rs, arg);
  }

  converters['o'] = function(flags, width, precision, arg) {
    var iPrecision = parseInt(precision);
    var rs = Math.round(Math.abs(arg)).toString(8);
    if ( rs.length < iPrecision)
      rs = pad(rs, ' ', iPrecision - rs.length);
    if ( flags.indexOf('#') >= 0)
      rs = '0' + rs;
    return processFlags(flags,width,rs,arg); 
  }

  converters['X'] = function(flags, width, precision, arg) {
    return (converters['x'](flags, width, precision, arg)).toUpperCase();
  }

  converters['x'] = function(flags, width, precision, arg) {
    var iPrecision = parseInt(precision);
    arg = Math.abs(arg);
    var rs = Math.round(arg).toString(16);
    if ( rs.length < iPrecision)
      rs = pad(rs, ' ', iPrecision - rs.length);
    if ( flags.indexOf('#') >= 0)
      rs = '0x' + rs;
    return processFlags(flags,width,rs,arg); 
  }

  converters['s'] = function(flags, width, precision, arg) {
    var iPrecision = parseInt(precision);
    var rs = arg;
    if ( rs.length > iPrecision)
      rs = rs.substring(0, iPrecision);
    return processFlags(flags,width,rs,0);
  }

  converters['%'] = function(flags, width, precision, arg) {
    return '%';
  }

  var fpRE = /([^%]*)%([-+ #]*)(\d*)\.?(\d*)([cdieEfFgGosuxX%])([^%]*)/g;
  var retstr = "";
  var index = 1;

  while ( fps = fpRE.exec(fstring) ) {
    if ( arguments[index] || fps[5] == '%' )
      retstr += converters[fps[5]](fps[2], fps[3], fps[4], arguments[index]);
    retstr = fps[1] + retstr + fps[6];
    if ( fps[5] != '%' )
      ++index;
  }
  if (index != 1)
    return retstr;
  else
    return fstring;
}
