# EuropeanPG-Renewables



## Model Description

This code is developed to assess the dynamic stability of the continental European power grid. The underlying network model comprises **7,343** transmission lines, **3,809** buses (nodes), and **1,089** generators, including **470** renewable units such as available wind and solar power plants.

The grid topology is derived from a publicly available dataset [1], while information on wind and solar installations is obtained from [2]. Renewable generation data for Portugal, Spain, and France (collectively referred to as PSF region) reflect installations and capacities as of **June 2025**.

For power system analysis, we utilize widely adopted open-source tools, including the power flow solver MATPOWER [3] and a time-domain dynamic simulation framework as described in [1].

See the reference below for more details.

<img width="2440" height="1335" alt="Distribution_Reanewable" src="https://github.com/user-attachments/assets/e1699d23-5b87-453d-aa64-04e99f71c93d" />

*Figure 1: Geographic distribution of generator/load nodes in the continental European power grid.
The blue data points represent the locations of generator/load nodes from dataset [1], which was developed in 2018 and does not include wind or solar generators.
The red data points show the geographic distribution of wind and solar generators in the PSF region, based on dataset [2].*




## Energy Mix

### Conventional power generations:
All power sources other than wind and solar are categorized as conventional. The types of conventional power generations involved are summarized in Table 1.
The parameters and geographical locations of these generators are based on dataset [1].

### Wind and solar power generations:
Based on the location and capacity data provided in [2], a total of 87 photovoltaic units and 19,562 wind turbines in the PSF region have been integrated into the European power grid model.
All generation units are modeled using the second-order swing equation.
To reflect the low-inertia characteristics of wind and solar generators, a uniform inertia constant of 0.005 is assigned to them—approximately one-tenth of the minimum inertia constant among conventional power sources. The damping coefficient is uniformly set to 0.001.



<img width="3096" height="807" alt="图片5" src="https://github.com/user-attachments/assets/e7d3ff6c-a4a5-45a8-bb81-2b1bdd1418c8" />
*Table 1: This table lists the 13 types of power sources included in the grid model, along with their corresponding abbreviations.*








## Power Flow
Based on data provided by the power grid operators, we reconstructed the power generation profiles of Portugal [4], Spain [4], and France [5] on April 28, 2025, as shown in Figures 2a–2c.
To reflect this generation structure, we pre-adjusted the generator outputs and power flows so that the modeled power mix in the three countries matches the conditions observed on that date.
The adjusted generation structure in the grid model is shown in Figures 2d–2f.

<img width="2685" height="2090" alt="Energy_mix" src="https://github.com/user-attachments/assets/8b0e53cf-fe2f-4099-b6e8-032ab95a96f3" />

*Figure 2:
Panels a–c show the generation mix of Portugal, Spain, and France on April 28, 2025.
Portugal and Spain exhibit similar structures, with solar and wind power dominating their generation portfolios.
In contrast, nuclear power constitutes the dominant source in France.
Panels d–f illustrate the adjusted generation mix used in the grid model for the three countries.*


Under the above power flow conditions, the loading stress on the transmission network is shown in Figure 3.
The color of each transmission line represents the magnitude of power flow, while the arrows indicate its direction.
A notable observation is the significant stress on the interconnections between the Iberian Peninsula and continental Europe.
The power flow on these lines is directed from west to east, with an estimated power exchange between the two regions of approximately xx GW.


<img width="1000"  alt="Power_flow" src="https://github.com/user-attachments/assets/0cb0a3ae-b09b-448a-ab2b-24a6e036aad4" />








## Dynamic Analysis of the Power Grid

The dynamic behavior of the network is analyzed using the  `Dynamic_analysis.m` script. The dynamics of generation nodes are as follows: 

<img width="400" alt="image" src="https://github.com/user-attachments/assets/d08b51c4-6fb2-4c4c-a247-893cf6db4d7c" />

In the equations, $$M_i$$ denotes the inertia and $$D_i$$ denotes the damping coefficient.$$P_{i(0)}$$ denotes the mechanical power of node, $$P_{i(e)}$$ denotes the electric power of node, the imbalance between  $$P_{i(e)}$$ and  $$P_{i(0)}$$ caused by the disturbance is the driving factor behind the onset of power system oscillations and potential instability. $$delta_i$$ denotes the voltage phase angle of generator $$i$$, which serves as a key state variable characterizing the system’s dynamic behavior.

The dynamics of load nodes are as follows: 

<img width="3095" height="206" alt="eq1" src="https://github.com/user-attachments/assets/ed89ebad-fd57-458a-a53d-5f5073ec9b8f" />
<img width="3095" height="206" alt="eq2" src="https://github.com/user-attachments/assets/8723ce69-cb2f-4adf-858d-156d87059e8e" />

The power flow equations of the grid are as follows:




<img width="3095" height="267" alt="eq3" src="https://github.com/user-attachments/assets/81f0b555-6117-41af-a4c2-e81b703d8bdd" />

In the equation, $$B_{ij}$$​ denotes the imaginary part of the admittance of the transmission line between nodes 
$$i$$ and $$j$$, and $$V_i$$  represents the voltage magnitude at node $$i$$.


This code applies six initial disturbances across the Iberian Peninsula, with their locations and magnitudes derived from reference [6].
Details of the disturbances are provided in Table 1. The disturbances are applied to the electrical power injections at these six nodes, representing sudden power drops in the grid.



## Usage

- `PSF_renewable.mat` : Power grid data. Compatible with MATPOWER [7].

- `Dynamic_analysis.m` :  Code of time-domain simulation.

# License

This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

The full text of the GNU General Public License can be found in the file "LICENSE.txt".


## Reference
[1] Tyloo, M., Pagnier, L., & Jacquod, P. (2019). The key player problem in complex oscillator networks and electric power grids: Resistance centralities identify local vulnerabilities. Science Advances, 5(11), eaaw8359. https://doi.org/10.1126/sciadv.aaw8359

[2] OpenInfraMap contributors. (2024). OpenInfraMap – Infrastructure map of the world. Retrieved from https://openinframap.org (Accessed: 2025-07-03)

[3] Zimmerman, R. D., Murillo-Sánchez, C. E., & Thomas, R. J. (2011). MATPOWER: Steady-State Operations, Planning, and Analysis Tools for Power Systems Research and Education. IEEE Transactions on Power Systems, 26(1), 12–19. https://doi.org/10.1109/TPWRS.2010.2051168

[4] ENTSO-E. (2025, June). Iberian blackout on 28 April 2025. Internal communication.

[5] RTE France. eco2mix – Power generation by energy source. https://www.rte-france.com/en/eco2mix/power-generation-energy-source

[6] Comité para el Análisis de las Circunstancias que Concurrieron en la Crisis de Electricidad del 28 de Abril de 2025. (2025, June). Versión no confidencial del informe del comité para el análisis de las circunstancias que concurrieron en la crisis de electricidad del 28 de abril de 2025.




