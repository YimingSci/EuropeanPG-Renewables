# EuropeanPG-Renewables



## Model Description

This repository contains the dataset and analysis tools used to assess the dynamic stability of the continental European power grid, as introduced in [1].
The model incorporates **7,343** transmission lines, **3,809** buses, and **1,089** generators, including **470** renewable units representing available wind and solar installations.


The grid topology is derived from a publicly available dataset [2], while information on wind and solar installations is obtained from [3]. Renewable generation data for Portugal, Spain, and France (collectively referred to as PSF region) reflect installations and capacities as of **June 2025**.

For power system analysis, we utilize widely adopted open-source tools, including the power flow solver MATPOWER [4] and a time-domain dynamic simulation framework as described in [2].

See the reference below for more details.

<img width="2440" height="1335" alt="Distribution_Reanewable" src="https://github.com/user-attachments/assets/e1699d23-5b87-453d-aa64-04e99f71c93d" />

*Figure 1: Geographic distribution of generator/load nodes in the continental European power grid.
The blue data points represent the locations of generator/load nodes from dataset [2], which was developed in 2018 and does not include wind or solar generators.
The red data points show the geographic distribution of wind and solar generators in the PSF region, based on dataset [3].*




## Energy Mix

### Conventional power generations:
All power sources other than wind and solar are categorized as conventional. The types of conventional power generations involved are summarized in Table 1.
The parameters and geographical locations of these generators are based on dataset [2].

### Wind and solar power generations:
Based on the location and capacity data provided in [3], a total of 87 photovoltaic units and 19,562 wind turbines in the PSF region have been integrated into the European power grid model.
All generation units are modeled using the second-order swing equation.
To reflect the low-inertia characteristics of wind and solar generators, a uniform inertia constant of 0.005 is assigned to them—approximately one-tenth of the minimum inertia constant among conventional power sources. The damping coefficient is uniformly set to 0.001.



<img width="3096" height="807" alt="图片5" src="https://github.com/user-attachments/assets/e7d3ff6c-a4a5-45a8-bb81-2b1bdd1418c8" />
*Table 1: This table lists the 13 types of power sources included in the grid model, along with their corresponding abbreviations.*








## Power Flow
Based on data provided by the power grid operators, we reconstructed the power generation profiles of Portugal [5], Spain [5], and France [6] on April 28, 2025, as shown in Figures 2a–2c.
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
The main power flow on these lines is directed from west to east, with an estimated power exchange between the two regions of approximately xx GW.


<img width="1000"  alt="Power_flow" src="https://github.com/user-attachments/assets/0cb0a3ae-b09b-448a-ab2b-24a6e036aad4" />

*Figure 3: Distribution of power flows in the continental European grid*






## Dynamic Analysis of the Power Grid

The dynamic behavior of the network is analyzed using the  `Dynamic_analysis.m` script. The dynamics of generation nodes are as follows: 


<img width="4624" height="206" alt="eq1" src="https://github.com/user-attachments/assets/943001e3-17a8-46d1-a014-a000fdc249e2" />


In the equations, $$M_i$$ denotes the inertia and $$D_i$$ denotes the damping coefficient. $$P_{i(0)}$$ denotes the mechanical power of node, $$P_{i(e)}$$ denotes the electric power of node, the imbalance between  $$P_{i(e)}$$ and  $$P_{i(0)}$$ caused by the disturbance is the driving factor behind the onset of power system oscillations and potential instability. $$delta_i$$ denotes the voltage phase angle of generator $$i$$, which serves as a key state variable characterizing the system’s dynamic behavior.

The dynamics of load nodes are as follows: 


<img width="4624" height="206" alt="eq2" src="https://github.com/user-attachments/assets/dd48b578-ccd7-4da8-83d6-a50927187426" />


The power flow equations of the grid are as follows:

<img width="4624" height="283" alt="eq3" src="https://github.com/user-attachments/assets/34e11223-66af-477d-8d27-61a070c284f0" />

In the equation, $$B_{ij}$$​ denotes the imaginary part of the admittance of the transmission line between nodes 
$$i$$ and $$j$$, and $$V_i$$  represents the voltage magnitude at node $$i$$.


This code applies six initial disturbances across the Iberian Peninsula, with their locations and magnitudes derived from reference [7].
Details of the disturbances are provided in Table 1. The disturbances are applied to the electrical power injections at these six nodes, representing sudden power drops in the grid.

<img width="3095" height="806" alt="图片4" src="https://github.com/user-attachments/assets/864e42e9-dd0a-47b4-94cb-2000a0f2b612" />

*Table 2: Information on the locations and power loss of the initial disturbances. More than ten power loss events are grouped into six categories based on the disturbance locations, each named after a representative city. The Bus ID indicates the bus number of the simulated disturbance node, which can be cross-referenced with the bus numbers in `PSF_renewable.mat`*



## Usage

- `PSF_renewable.mat` : Power grid data. Provided in a format compatible with MATPOWER [4], with power flows pre-adjusted to match the generation profiles shown in Figures 2d–2f.
- `Dynamic_analysis.m` : Time-domain simulation code. This script includes fault initialization, parameter setup, and dynamic simulation procedures.

## License

This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

The full text of the GNU General Public License can be found in the file "LICENSE.txt".


## Reference

[1] Y. Wang, A. N. Montanaria, and A. E. Motter, “Rethinking the Green Power Grid,” *submitted for publication*.

[2] M. Tyloo, L. Pagnier, and P. Jacquod, “The key player problem in complex oscillator networks and electric power grids: Resistance centralities identify local vulnerabilities,” *Science Advances*, vol. 5, no. 11, eaaw8359, 2019. [https://doi.org/10.1126/sciadv.aaw8359](https://doi.org/10.1126/sciadv.aaw8359)

[3] OpenInfraMap contributors, *OpenInfraMap – Infrastructure map of the world*, 2024.
   [https://openinframap.org](https://openinframap.org) (accessed Jul. 3, 2025)

[4] R. D. Zimmerman, C. E. Murillo-Sánchez, and R. J. Thomas, “MATPOWER: Steady-State Operations, Planning, and Analysis Tools for Power Systems Research and Education,” *IEEE Trans. Power Syst.*, vol. 26, no. 1, pp. 12–19, 2011.
   [https://doi.org/10.1109/TPWRS.2010.2051168](https://doi.org/10.1109/TPWRS.2010.2051168)

[5] ENTSO-E, *Iberian blackout on 28 April 2025*, internal communication, Jun. 2025.
   [https://www.entsoe.eu/publications/blackout/28-april-2025-iberian-blackout/](https://www.entsoe.eu/publications/blackout/28-april-2025-iberian-blackout/)

[6] RTE France, *eco2mix – Power generation by energy source*.
   [https://www.rte-france.com/en/eco2mix/power-generation-energy-source](https://www.rte-france.com/en/eco2mix/power-generation-energy-source)

[7] Red Eléctrica de España, *Blackout in Spanish Peninsular Electrical System the 28th of April 2025*, Jun. 2025.
   [https://d1n1o4zeyfu21r.cloudfront.net/WEB\_Incident\_%2028A\_SpanishPeninsularElectricalSystem\_18june25.pdf](https://d1n1o4zeyfu21r.cloudfront.net/WEB_Incident_%2028A_SpanishPeninsularElectricalSystem_18june25.pdf)
