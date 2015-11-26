# ANDSM 
Automated Nonlinear Dynamic System Modeling

ANDSM automatically generates nonlinear dynamical models from input-state-output training data
into a state-space format

<img src="fig/system.png" alt="system" align="middle" height="100"/>

The generated models are guaranteed passive and optionally incrementally stable.
The passivity property ensures that the models do not generate numerical energy,
hence, suited for modeling nonlinear circuit networks (including active and passive), 
arterial (cardiovascular) networks, and potentially all systems that can be 
represented as circuits or bond graphs.


## Algorithm 

The underlying algorithm is a convex optimization program constrained by specially 
forged sum-of-squares (of-polynomials) constraints. 
These constraints theoretically guarantee that all feasible solutions within
the set preserve desired system properties, such as passivity and incremental stability.
Solving such an optimization problem essentially looks for a model whose
parameters minimize against the training data,
while at the same time every candidate models along the search path
possess the system properties of interest.
 
Details and theories can be referred to [here](http://feature.space/doc/hsiao_thesis.pdf).


## Installation and Dependencies

ANDSM utilizes [YALMIP](http://users.isy.liu.se/johanl/yalmip/) to transform SOS optimization problems 
into semidefinite progromming (SDP) problems. 
The resulting SDP problems are then resolved by [MOSEK](https://www.mosek.com/).
The instructions of installing YALMIP, MOSEK, and ANDSM are described [here](INSTALL.md).


## Usage
API
Please see [demo](andsm_demo.m) for more detailed examples.
