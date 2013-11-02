#!/bin/bash

# default variables
def_rdir=0
def_force=1
def_confirm=0
def_tbox="~/.Trash"
def_tlist="~/.trashlist"

# Help
HELP="
Usage: trash [-rficClbv] [-t <trash_box>] <file/directory>

Arguments:
   -r              Remove directory (default: $def_rdir)
   -f              Remove w/o confirmation (default: $def_force)
   -i              Remove w/ confirmation (default: $def_confirm)
   -t              Use given trash box instead of ${TRASHBOX:-$def_tbox}
   -c              Clean up trash box (make it less than MAXTRASHBOXSIZE)
   -C              Clean up trash box (make it empty)
   -l              List up deleted files/directories in the trash box
   -b              Restore (turn Back) the file from the trash box
   -v              List up files/directories in trash box, too
   -h              Print this HELP and exit

To use trash, please specify following variables
in .bashrc or your setting file like:

export TRASHLIST=~/.trashlist # Where trash list is written
export TRASHBOX=~/.Trash # Where trash will be moved in
                         # (.Trash is Mac's trash box)
export MAXTRASHBOXSIZE=1024 # Max trash box size in MB
                            # Used for clean up
export MAXTRASHSIZE=\`echo \$MAXTRASHBOXSIZE \"*\" 0.1|bc -l|cut -d. -f1\`
    # Trashes larger than MAXTRASHBOXSIZE will be removed by 'rm' directly
"

# Initialize variables
rdir=$def_rdir
force=$def_rdir
confirm=$def_rdir
tbox=""
tlist=$def_tlist
clean=0
clean_full=0
list=0
back=0
verbose=0

# Get option
while getopts rfit:cClbvh OPT;do
  case $OPT in
    "r" ) rdir=1 ;;
    "f" ) force=1;confirm=0 ;;
    "i" ) confirm=1;force=1 ;;
    "t" ) tbox="$OPTARG" ;;
    "c" ) clean=1 ;;
    "C" ) clean_full=1 ;;
    "l" ) list=1 ;;
    "b" ) back=1 ;;
    "v" ) verbose=1 ;;
    "h" ) echo "$HELP" 1>&2;exit 0;;
    * ) echo "$HELP" 1>&2;exit 1;;
  esac
done
shift $(($OPTIND - 1))

# Set trash box/list
tbox="${tbox:-$TRASHBOX}"
if [ ! "$tbox" ];then
  echo "please set TRASHBOX"
  exit 1
fi
tlist="${TRASHLIST:-$tlist}"
touch $tlist

# Use more one depth directory to distinguish from other trash
# (especially for Mac's ~/.Trash case)
mytbox="$tbox/my_trash_box"

# Clean up the trash box
if [ $clean_full -eq 1 ];then
  rm -rf $mytbox
  rm -rf $tlist
  exit 0
elif [ $clean -eq 1 ];then
  if [ ! -d ${mytbox} ];then
    exit 0
  fi
  while [ 1 ];do
    trash_box_size=`du -ms ${mytbox} |awk '{print $1}'`
    if [ ${trash_box_size} -gt ${MAXTRASHBOXSIZE} ];then
      delete_dir=`ls -tr ${TRASHBOX} | head -1`
      rm -rf ${mytbox}/${delete_dir}
      sed -i.bak "\!${mybox}/${delete_dir}!d" $tlist
      rm -f $tlist.bak
    else
      exit 0
    fi
  done
fi

# List up deleted files/directories
if [ $list -eq 1 ] || [ $back -eq 1 ];then
  # Set verbose
  if [ $verbose -eq 1 ];then
    cutn=3 # Show also deleted file/directory position
  else
    cutn=2
  fi
  # Set reverse command
  if type tac >/dev/null 2>&1;then
    revlines=tac
  elif ! tail --version 2>/dev/null |grep -q GNU;then
    revlines="tail -r"
  else
    revlines=cat # can't revert...
  fi

  # List up trashes
  cat -n $tlist|$revlines|cut -d, -f1-$cutn|awk '{printf("%3d %s\n",$1,$2)}'

  if [ $back -ne 1 ];then
    exit 0
  fi

  # Choose from STDIN
  ntrashes=`wc $tlist|awk '{print $1}'`
  echo -n "choose trash number: "
  read nth

  if ! echo $nth|grep -q "^[0-9]\+$" || [ $nth -eq 0 ] || [ "$nth" -gt "$ntrashes" ];then
    echo "Wrong number was given"
    exit 1
  fi
  line=`sed -n ${nth}p $tlist`
  tinfo=(`echo ${line}|sed 's/,/ /g'`)
  origin_name_short=${tinfo[1]}
  trash_name_short=${tinfo[2]}
  origin_name=`sh -c "echo ${origin_name_short}"` # Expand ~
  trash_name=`sh -c "echo ${trash_name_short}"` # Expand ~
  if [ "$origin_name" = "" ] || [ "$trash_name" = "" ];then
    echo "Wrong number was given or $tlist was corrupted"
    exit 1
  elif [ ! -e "$trash_name" ];then
    echo "$trash_name_short doesn't exist, remove from the list"
    sed -i.bak "\!${trash_name_short}\$!d" $tlist
    rm -f $tlist.bak
    exit 1
  fi
  if [ $confirm -eq 1 ];then
    if [ -e "$origin_name" ];then
      echo -n "$origin_name_short exists. Do you want to overwrite from trash box? "
      read yes
      if ! [[ "$yes" =~ ^[yY] ]];then
        exit 0
      fi
    fi
  fi
  mv "$trash_name" "$origin_name"
  echo ${origin_name_short} was restored from  ${trash_name_short}
  sed -i.bak "\!${trash_name_short}\$!d" $tlist
  rm -f $tlist.bak
  exit 0
fi

# Check arguments
if [ "$#" -lt 1 ];then
  echo "$HELP" 1>&2;
  exit 1
fi

# Set rm flags
if [ $force -eq 1 ];then
  rmflag="-f"
else
  rmflag="-i"
fi
if [ $rdir -eq 1 ];then
  rmflag="$rmflag -r"
fi

# Set today's trash box
tboxtoday="$mytbox/`date +%Y%m%d`"
if [ ! -d $tboxtoday ];then
  mkdir -p $tboxtoday
fi

# Iterate on arguments
while [ "$#" -gt 0 ];do
  if [ ! -e "$1" ];then
    echo $1: No such file or directory
    if [ $force -ne 1 ];then
      exit 1
    fi
    shift
    continue
  fi
  trash_size=`du -ms "${1}" |awk '{print $1}'`
  if [ ${trash_size} -gt ${MAXTRASHSIZE} ];then
    echo $1 is larger than $MAXTRASHSIZE MB, then I delete it directly
    rm $rmflag $1
    shift
    continue
  fi

  if [ -d "$1" ] && [ $rdir -ne 1 ];then
    echo $1: is a directory, use "-r" for directory
    shift
    continue
  fi

  if [ $confirm -eq 1 ];then
    echo -n "remove ${1}? "
    read yes
    if ! [[ "$yes" =~ ^[yY] ]];then
      shift
      continue
    fi
  fi

  origin_name=`echo $(cd "$(dirname $1)";pwd -P)/$(basename $1)`
  name=`echo $1 | sed -e "s|/$||" | sed -e "s|.*/||"`
  trash_head=${tboxtoday}/${name}
  trash_name=${trash_head}
  i=1
  while true;do
    if [ -e ${trash_name} ];then
      trash_name=${trash_head}.${i}
      i=`expr ${i} + 1`
    else
      break
    fi
  done

  mv "$origin_name" "$trash_name"
  origin_name_short="${origin_name/#$HOME/~}"
  trash_name_short="${trash_name/#$HOME/~}"
  echo $origin_name_short was moved to $trash_name_short
  mv $tlist $tlist.bak
  echo "`date +%Y%m%d-%H-%M-%S`,$origin_name_short,$trash_name_short" > $tlist
  cat $tlist.bak >> $tlist
  rm -f $tlist.bak
  shift
done
