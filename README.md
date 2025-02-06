# Aiyagari Model with Endogenous Grid Method

## Overview
This repository contains a MATLAB implementation of the Aiyagari (1994) model using the Endogenous Grid Method (EGM). The model features heterogeneous agents with idiosyncratic productivity shocks and incomplete markets.

## Model Features
- Heterogeneous agents with idiosyncratic productivity shocks
- Incomplete markets with borrowing constraints
- Endogenous interest rate determination
- Inelastic labor supply
- General equilibrium framework

## Technical Details
- Solution Method: Endogenous Grid Method (EGM)
- Productivity Process: AR(1) discretized using Tauchen method
- State Space: Continuous asset grid × discrete productivity states
- Numerical Features:
  - Linear interpolation for policy functions
  - Sparse matrix operations for transition dynamics
  - Efficient computation of stationary distribution

## Code Structure
```
.
├── aiyagari.m              # Main script
├── Functions/              # Utility functions
│   ├── getWeights.m       # Interpolation weights
│   ├── linInterp.m        # Linear interpolation
│   └── tauchen.m         # Discretization of AR(1)
└── Steady_State/          # Steady state computation
    ├── solveHH.m         # Household problem
    ├── dispSum.m         # Display results
    └── plotFigs.m        # Generate figures
```

## Usage
1. Clone the repository
2. Run `aiyagari.m` in MATLAB
3. Results will be displayed and figures will be generated automatically

## Model Parameters
- Risk aversion: 2.0
- Discount factor: 0.93
- Capital depreciation: 0.12
- Capital share: 0.36
- Productivity shock:
  - Persistence: 0.90
  - Volatility: 0.20

## References
- Aiyagari, S.R. (1994). "Uninsured Idiosyncratic Risk and Aggregate Saving." *Quarterly Journal of Economics*, 109(3), 659-684.
- Carroll, C.D. (2006). "The Method of Endogenous Gridpoints for Solving Dynamic Stochastic Optimization Problems." *Economics Letters*, 91(3), 312-320.

## License
This project is licensed under the MIT License - see the LICENSE file for details.