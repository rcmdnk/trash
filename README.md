trash
=====

Remove Command using a trash box.

`rm` command removes files/directories from the disk and they are not recoverable.
It is stressful because we are used to benefit from the trash box on a GUI system, Windows, Mac, Linux, etc..

`trash` command brings you the removal command with recoverable files/directories.

:white_check_mark: current version requires [sentaku](https://github.com/rcmdnk/sentaku).

If you use Homebrew or cURL to insatll, sentaku will be installed automatically, too.

If you install the script directly, please install sentaku or use
[standalone version](https://github.com/rcmdnk/trash/tree/standalone)
(standalone version could be obsolete).

# Installation

On Mac, you can install scripts by [Homebrew](https://github.com/mxcl/homebrew):

    $ brew tap rcmdnk/rcmdnkpac
    $ brew install rcmdnk-trash

If you have [brew-file](https://github.com/rcmdnk/homebrew-file), add following lines to Brewfile:

    tap 'rcmdnk/rcmdnkpac'
    brew 'rcmdnk-trash'

then, do:

    $ brew file install

Or if you write like:

    tapall 'rcmdnk/rcmdnkpac'

and do `brew file install`, you will have all useful scripts in
[rcmdnkpac](https://github.com/rcmdnk/homebrew-rcmdnkpac).

You can also use an install script on the web like:

    $ curl -fsSL https://raw.github.com/rcmdnk/trash/install/install.sh| sh

This will install scripts to `/usr/bin`
and you may be asked root password.

If you want to install other directory, do like:

    $ curl -fsSL https://raw.github.com/rcmdnk/trash/install/install.sh|  prefix=~/usr/local/ sh

Or, simply download the script and set where you like.

:warning: Install [sentaku](https://github.com/rcmdnk/sentaku), too
if you download directly.

# Usage

    # Help
    Usage: trash [-rficClbVv] [-v <verbose level>] [-t <trash_box>] <file/directory>
    
    Arguments:
       -r              Remove directory (default: $rdir)
       -f              Remove w/o confirmation (default: $force)
       -i              Remove w/ confirmation (default: $confirm)
       -t <trash_box>  Use given trash box instead of $tbox
       -c              Clean up trash box (make it less than MAXTRASHBOXSIZE)
       -C              Clean up trash box (make it empty)
       -l              List up deleted files/directories in the trash box
       -b              Restore (turn Back) the file from the trash box
       -v <level>      Verbose level for list view
                       0 : Only original location (default).
                       1 : With Delete date-time (yyyymdd-hh:mm).
                       2 : With Current location (in the trash box).
       -V              Show version
       -h              Show help
    
    To use trash, please specify following variables
    in .bashrc or your setting file like (these rh values are default):
    
    At restore mode, you can use following keys (based on vim move):
     <n>   : (any numb), set n for move
     j     : n-down (if n is not defined, 1 down)
     ^D    : Half page down
     ^F    : Page down
     k     : n-up   (if n is not defined, 1 up)
     ^U    : Half page up
     ^B    : Page up
     gg    : Go to top    (if n is defined, go to n)
     G     : Go to bottom (if n is defined, go to n)
     d     : Delete
     s     : Show details
     /     : Search mode
     Enter : Select to bring back to the original place, and quit
     h     : Select to copy it to current directory, and quit
     q     : Quit
    
    export TRASHLIST=~/.trashlist # Where trash list is written
    export TRASHBOX=~/.Trash # Where trash will be moved in
                             # (.Trash is Mac's trash box)
    export MAXTRASHBOXSIZE=1024 # Max trash box size in MB
                                # Used for clean up
    export MAXTRASHSIZE=\`echo \$MAXTRASHBOXSIZE \"*\" 0.1|bc -l|cut -d. -f1\`
        # Trashes larger than MAXTRASHBOXSIZE will be removed by 'rm' directly
    "

# Tips

## Alias

Following alias is useful to use trash:

    alias del="trash -r"

## Clean up

You may be want to clean up trash box regularly to keep the box not too much.

To clean up regularly, first please set `MAXTRASHBOXSIZE` as described
in above help.

Then, `trash -c` will clean up the trash box until it becomes less than `MAXTRASHSIZE`.

You can set it as a cron job like:

    0 1 * * * /path/to/trash -c

to execute every night (1am, 00min).
    

In addition, you can empty your trash box for trash by

    $ trash -C

# References

* [rm -rfのプロテクト、コマンドラインでのゴミ箱](http://rcmdnk.github.io/blog/2013/04/23/computer-bash-linux-mac/)

* [コマンドラインで使うゴミ箱コマンド](http://rcmdnk.github.io/blog/2014/01/12/computer-bash/)
