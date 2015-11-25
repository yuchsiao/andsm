# Installation

This document describes the installation of ANDSM and its dependencies MOSEK and YALMIP.

## Installing MOSEK

### Tested Versions

Version 7.1 (Revision 39), tested with Matlab R2014b and R2015b

### Download

MOSEK downloads can be found [here](https://www.mosek.com/resources/downloads).

### Setting up

Please refer to the full instruction [here](http://docs.mosek.com/7.0/toolbox/Installation.html).
For academic usage, a one-year license can be freely requested [here](https://www.mosek.com/resources/academic-license).

### Quick Instructions 

The installation on Mac, for example, is simply putting the downloaded mosek under user folder `~/`
and then putting the license file under `~/mosek/`.
Matlab can access MOSEK when the toolbox path is added
```matlab
addpath '~/mosek/7/toolbox/r2013a'
```

To check if Matlab has the correct access, type in Matlab
```matlab
>> mosekopt
```

A similar message as the following should be displayed 
```matlab
MOSEK Version 7.1.0.39 (Build date: 2015-10-6 11:19:28)
Copyright (c) 1998-2015 MOSEK ApS, Denmark. WWW: http://mosek.com
Platform: MACOSX/64-X86


For help type: help mosekopt.
```

## Installing YALMIP

### Tested Versions

`YALMIP R20150918`

### Download

See 'Latest release' and 'Previous releases' in [here](http://users.isy.liu.se/johanl/yalmip/pmwiki.php?n=Main.Download).

### Quick Instructions

Installing YALMIP is straightforward: simply adding all sub-directories under `yalmip` folder to the MATLAB path.
Then type `yalmiptest` to test solving the nominal problems (optional).


## Installing ANDSM

### Quick Instructions

First, git clone this project

`git clone https://github.com/yuchsiao/andsm.git`

Then adding all sub-directories under `andsm` folder to the MATLAB path.
The file `andsm_demo.m` can be used for the testing purpose.


