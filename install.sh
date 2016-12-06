#!/usr/bin/env bash
scripts=(https://raw.github.com/rcmdnk/trash/master/bin/trash)
scripts_dep=(https://raw.github.com/rcmdnk/sentaku/master/bin/sentaku)
if [ x"$prefix" = x ];then
  prefix=/usr/local
fi

prefix=`echo $prefix|sed 's|--prefix=||'|sed "s|^~|$HOME|"|sed "s|^\.|$(pwd)|"`

echo
echo "###############################################"
echo "Install to $prefix/bin"
echo "###############################################"
echo
sudo=""
if [ -d $prefix/bin ];then
  touch $prefix/bin/.install.test >& /dev/null
  if [ $? -ne 0 ];then
    sudo=sudo
  else
    rm -f $prefix/bin/.install.test
  fi
else
  mkdir -p $prefix/bin>&  /dev/null
  if [ $? -ne 0 ];then
    sudo mkdir -p $prefix/bin
    sudo=sudo
  fi
fi

for s in ${scripts[@]};do
  sname=`basename $s`
  echo Intalling ${sname}...
  $sudo curl -fsSL -o $prefix/bin/$sname $s
  $sudo chmod 755 $prefix/bin/$sname
done

for s in ${scripts_dep[@]};do
  sname=`basename $s`
  if ! type $sname >& /dev/null;then
    echo Intalling ${sname}...
    $sudo curl -fsSL -o $prefix/bin/$sname $s
    $sudo chmod 755 $prefix/bin/$sname
  fi
done
