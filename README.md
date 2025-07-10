# EuropeanPG-Renewables



# Model Description

This code develops a European power grid model that includes solar and wind generation. The model reconstructs the solar and wind generation systems across Portugal, Spain, and France (collectively referred to as PSF), using data available up to 2024.

To simulate a blackout scenario similar to the one that occurred on April 28, 2025, in the Iberian Peninsula, the model was pre-calibrated to reflect a comparable power flow condition.
The power grid dynamics are as follows: 

<img width="928" height="103" alt="image" src="https://github.com/user-attachments/assets/d08b51c4-6fb2-4c4c-a247-893cf6db4d7c" />

<img width="738" height="96" alt="image" src="https://github.com/user-attachments/assets/330aeab2-7dee-4999-9e9e-9e303ae6af13" />


In the equations, M_i denotes the inertia and D_i the damping coefficient of generator i. For solar and wind units, we use homogenized parameters with M_i=0.005 and D_i=0.001. For all other generators, the inertia and damping values are adopted from [1]. 
The power flow equations of the grid are as follows:

<img width="502" height="123" alt="image" src="https://github.com/user-attachments/assets/5f682f2e-75ef-4305-b138-afe1fdc13ffd" />

See the reference below for more details.

# Energy Mix

## Conventional power sources and transmission network:
We adopt the transmission system and conventional generation fleet from the model published in Science Advances [1], which was developed based on data from 2018 and does not include wind or solar generation.
Wind and solar power sources:

## Wind and solar power sources:
The newly added solar and wind units cover the entire PSF region, with data derived from OpenStreetMap [2]. A total of 87 solar units and 19, 562 wind units have been integrated into the model. Fig. 1 illustrates the geographical distribution of these added renewable sources.

<img width="2146" height="1203" alt="Distribution_Reanewable" src="https://github.com/user-attachments/assets/f8d13b92-0334-4e33-9f99-c8a83797e5cb" />



# Power Flow

We pre-adjusted the power flow to match conditions in the PSF region just before the April 28, 2025 blackout. Fig. 2a–2c show the generation and load structures of Portugal [3], Spain [3], and France [4] on that day.

Fig. 2d shows the generation mix (based on actual output), and Fig. 2e shows the load distribution. Wind and solar: 40.53 GW; conventional: 49.97 GW; total load: 80.10 GW.

Under the above power flow conditions, the stress on the transmission network is shown in Fig. 3. The color of each transmission line indicates the magnitude of power flow, while the arrows indicate its direction.


<img width="2459" height="2115" alt="Energy_mix" src="https://github.com/user-attachments/assets/ed807e48-cbbf-4dd6-b3a8-4caab77ac587" />


<img width="2144" height="1202" alt="Power_flow" src="https://github.com/user-attachments/assets/0cb0a3ae-b09b-448a-ab2b-24a6e036aad4" />


# Time-Domain Simulation with Disturbances

This code sets six initial disturbances on the Iberian Peninsula, with the locations and magnitudes based on reference [5]. The disturbance details are listed in Table 1. We selected four buses to observe the simulated April 28 blackout. Their locations are shown in Fig. 4a. Fig. 4b shows the frequency responses at these observation buses under disturbances matching the magnitude of the April 28 blackout. Fig. 4c shows the responses under disturbances at the same locations but with one-tenth of the original magnitude.

<img width="606" height="270" alt="image" src="https://github.com/user-attachments/assets/5dd2c363-db3b-43b7-94cf-65334b836729" />




# Usage

PSF_Renewable.mat: Power grid data. Compatible with MATPOWER [7].
Dynamic_analysis.m: Code of time-domain simulation.


# Reference
[1] Tyloo, M., Pagnier, L., & Jacquod, P. (2019). The key player problem in complex oscillator networks and electric power grids: Resistance centralities identify local vulnerabilities. Science Advances, 5(11), eaaw8359. https://doi.org/10.1126/sciadv.aaw8359
[2] OpenInfraMap contributors. (2024). OpenInfraMap – Infrastructure map of the world. Retrieved from https://openinframap.org (Accessed: 2025-07-03)
[3] ENTSO-E. (2025, June). Iberian blackout on 28 April 2025. Internal communication.
[4] RTE France. eco2mix – Power generation by energy source. https://www.rte-france.com/en/eco2mix/power-generation-energy-source
[5] Comité para el Análisis de las Circunstancias que Concurrieron en la Crisis de Electricidad del 28 de Abril de 2025. (2025, June). Versión no confidencial del informe del comité para el análisis de las circunstancias que concurrieron en la crisis de electricidad del 28 de abril de 2025.
[6] Rethink of Green Power Grid. [Details to be completed by the authors.]
[7] Zimmerman, R. D., Murillo-Sánchez, C. E., & Thomas, R. J. (2011). MATPOWER: Steady-State Operations, Planning, and Analysis Tools for Power Systems Research and Education. IEEE Transactions on Power Systems, 26(1), 12–19. https://doi.org/10.1109/TPWRS.2010.2051168
