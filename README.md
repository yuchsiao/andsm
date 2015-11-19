# ANDSM 
Automated Nonlinear Dynamic System Modeling

ANDSM 

$$
\begin{align*}
  & \phi(x,y) = \phi \left(\sum_{i=1}^n x_ie_i, \sum_{j=1}^n y_je_j \right)
  = \sum_{i=1}^n \sum_{j=1}^n x_i y_j \phi(e_i, e_j) = \\
  & (x_1, \ldots, x_n) \left( \begin{array}{ccc}
      \phi(e_1, e_1) & \cdots & \phi(e_1, e_n) \\
      \vdots & \ddots & \vdots \\
      \phi(e_n, e_1) & \cdots & \phi(e_n, e_n)
    \end{array} \right)
  \left( \begin{array}{c}
      y_1 \\
      \vdots \\
      y_n
    \end{array} \right)
\end{align*}
$$

## Dependencies

ANDSM utilizes YALMIP to formulate Sums-of-Squares (SOS) optimization problems into Semidefinite programming (SDP) problems,
which are then resolved by MOSEK.

### MOSEK

#### Tested Version

Version 7.1 (Revision 39), tested with Matlab R2014b and R2015b

#### Installation

Please refer to the instruction [here](http://docs.mosek.com/7.0/toolbox/Installation.html).
For academic usage, a one-year license can be freely requested [here](https://www.mosek.com/resources/academic-license).
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

### YALMIP

#### Installation


##  
