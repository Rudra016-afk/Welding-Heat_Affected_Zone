# 🔥 Welding Temperature Prediction Using PDE and FDM

<p align="center">
  <img src="https://img.shields.io/badge/MATLAB-R2023a-orange?style=for-the-badge&logo=mathworks"/>
  <img src="https://img.shields.io/badge/Method-FDM-green?style=for-the-badge"/>
  <img src="https://img.shields.io/badge/PDE-Heat%20Equation-red?style=for-the-badge"/>
  <img src="https://img.shields.io/badge/Export-CSV-blue?style=for-the-badge"/>
</p>

---

## 📌 Project Overview

This project simulates **2D transient heat transfer** during a welding process by numerically solving the heat conduction PDE using the **Explicit Finite Difference Method (FDM)** in MATLAB.

A **moving Gaussian heat source** travels along the plate, simulating the welding arc. The simulation computes the temperature distribution at every time step and exports a **sampled dataset** as a CSV file for further analysis.

---

## 🔬 Governing Equation

The 2D transient heat conduction equation:

$$\frac{\partial T}{\partial t} = \alpha\left(\frac{\partial^2 T}{\partial x^2} + \frac{\partial^2 T}{\partial y^2}\right) + Q(x,y,t)$$

Where:
- $T$ — Temperature field
- $t$ — Time (s)
- $\alpha$ — Thermal diffusivity (m²/s)
- $Q(x,y,t)$ — Moving Gaussian heat source (W/m³)

### 🔆 Moving Gaussian Heat Source

$$Q(x,y,t) = Q_0 \cdot \exp\left(-\frac{(x - v \cdot t)^2 + y^2}{\sigma^2}\right)$$

Where:
- $Q_0 = 800$ — Peak heat source intensity
- $v = 0.02$ m/s — Welding speed (arc moves along x-axis)
- $\sigma = 0.01$ — Gaussian spread parameter
- $v \cdot t$ — Arc position at time $t$

---

## 📐 Variables

| Symbol           | Description                               | Value / Unit          |
|------------------|-------------------------------------------|-----------------------|
| `Lx`, `Ly`       | Domain size in x and y directions         | 0.1 m × 0.1 m         |
| `nx`, `ny`       | Number of grid nodes                      | 40 × 40               |
| `dx`, `dy`       | Spatial step sizes                        | m                     |
| `dt`             | Time step size                            | 0.01 s                |
| `nt`             | Total number of time steps                | 150                   |
| `alpha` (α)      | Thermal diffusivity                       | 1×10⁻⁴ m²/s           |
| `r`              | FDM stability ratio (α·dt/dx²)            | ≤ 0.25                |
| `Q0`             | Peak heat source intensity                | 800 W/m³              |
| `v`              | Welding arc speed                         | 0.02 m/s              |
| `sigma` (σ)      | Gaussian heat source spread               | 0.01 m                |
| `T`              | Temperature field matrix                  | (nx × ny)             |
| `sampling_space` | Spatial sampling interval for dataset     | Every 4th node        |
| `sampling_time`  | Temporal sampling interval for dataset    | Every 5th time step   |

---

## 📘 Assumptions

- Uniform and isotropic material with constant thermal diffusivity $\alpha$
- No phase change, melting, or latent heat effects
- Convective and radiative surface losses are neglected
- Welding arc moves strictly along the x-axis at constant speed $v$
- Gaussian heat source profile accurately represents the welding arc
- Workpiece is initially at zero temperature ($T_0 = 0$)
- Insulated boundary conditions on all edges (zero-flux, Neumann)
- 2D domain — thickness effects are not considered

---

## 📐 FDM Discretization

The PDE is solved using the **explicit finite difference scheme**:

### Update Equation (Interior Nodes):

$$T_{i,j}^{n+1} = T_{i,j}^{n} + r\left(T_{i+1,j}^{n} + T_{i-1,j}^{n} + T_{i,j+1}^{n} + T_{i,j-1}^{n} - 4T_{i,j}^{n}\right) + \Delta t \cdot Q_{i,j}^{n}$$

Where the stability ratio is:

$$r = \frac{\alpha \cdot \Delta t}{\Delta x^2}$$

### Stability Criterion:

$$r \leq 0.25$$

> ⚠️ If this condition is violated, MATLAB throws an error:
> `'Reduce dt. Stability condition violated'`

### Boundary Conditions:

- All four edges are **implicitly insulated** — boundary nodes are not updated (zero-flux Neumann condition)
- **Initial condition**: $T(x,y,0) = 0$ everywhere

---

## 🗂️ Project Workflow

```
Define Domain Parameters (Lx, Ly, nx, ny, dx, dy)
                    ↓
     Define Time Parameters (dt, nt)
                    ↓
   Define Material & Heat Source Parameters
          (alpha, Q0, v, sigma)
                    ↓
       Check Stability Condition (r ≤ 0.25)
                    ↓
    Initialize Temperature Field (T = zeros)
                    ↓
┌──── Time Loop (n = 1 to nt) ──────────────────┐
│   Compute Arc Position  →  x_arc = v × t      │
│   Compute Q(x,y,t) using Gaussian formula      │
│   Apply Explicit FDM  →  Update T(i,j)         │
│   Store sampled data to dataset[ ]             │
└────────────────────────────────────────────────┘
                    ↓
         Post-Processing & Visualization
                    ↓
         Export dataset to CSV file
```

---

## ✨ Features

- 2D transient heat conduction simulation using explicit FDM
- Moving Gaussian welding arc along the x-axis
- Automatic stability check with error handling (CFL condition)
- Reduced dataset generation with configurable spatial and temporal sampling
- Surface plot, contour plot, HAZ visualization, and centerline temperature profile
- CSV dataset export for post-processing or further analysis

---

## 💻 MATLAB Implementation

The MATLAB script `welding_fdm_simulation.m` contains the following sections:

| Section               | Description                                        |
|-----------------------|----------------------------------------------------|
| `Domain Parameters`   | Grid size, node count, spatial steps               |
| `Time Parameters`     | Time step `dt` and total steps `nt`                |
| `Material Property`   | Thermal diffusivity `alpha`, stability ratio `r`   |
| `Heat Source Parameters` | Peak intensity `Q0`, speed `v`, spread `sigma` |
| `Initial Condition`   | Temperature initialized to zero                    |
| `Dataset Storage`     | Sampling intervals for reduced data export         |
| `Time Loop`           | FDM solver with Gaussian heat source at each step  |
| `Surface Plot`        | 3D temperature surface at final time step          |
| `Contour Plot`        | 2D isothermal contour map                          |
| `HAZ Visualization`   | `imagesc` heat map of temperature field            |
| `Centerline Plot`     | Temperature along plate mid-axis (y = Ly/2)        |
| `Export Dataset`      | Saves `[x, y, t, T]` data to CSV                  |

---

## 📈 Output

The script produces:

- **Surface Plot** — 3D interpolated surface of temperature field `T(x,y)` at the final time step
- **Contour Plot** — 20-level filled contour map showing isothermal lines
- **HAZ Visualization** — `imagesc` colour map highlighting the Heat Affected Zone
- **Centerline Temperature Plot** — Temperature profile along `y = Ly/2` across the full plate length
- **CSV File** — `welding_temperature_dataset_small.csv` with columns: `x | y | t | T`

---

## ▶️ How to Run

1. Clone the repository:
```bash
git clone https://github.com/your-username/welding-fdm-simulation.git
cd welding-fdm-simulation
```

2. Open MATLAB and navigate to the project folder.

3. Run the script:
```matlab
welding_fdm_simulation
```

4. Check the Command Window for:
```
Reduced dataset exported successfully
```

5. Find the exported dataset in the same directory:
```
welding_temperature_dataset_small.csv
```

---

## ⚙️ Key Parameters to Modify

```matlab
%% Domain
Lx = 0.1;      % Plate length in x (m)
Ly = 0.1;      % Plate length in y (m)
nx = 40;       % Grid nodes in x
ny = 40;       % Grid nodes in y

%% Time
dt = 0.01;     % Time step (s) — keep r ≤ 0.25
nt = 150;      % Total time steps

%% Material
alpha = 1e-4;  % Thermal diffusivity (m²/s)

%% Heat Source
Q0    = 800;   % Peak heat intensity (W/m³)
v     = 0.02;  % Welding speed (m/s)
sigma = 0.01;  % Gaussian spread (m)

%% Sampling
sampling_space = 4;   % Store every 4th grid point
sampling_time  = 5;   % Store every 5th time step
```

---

## 📁 File Structure

```
welding-fdm-simulation/
│
├── welding_fdm_simulation.m               # Main MATLAB simulation script
├── welding_temperature_dataset_small.csv  # Exported dataset [x, y, t, T]
├── README.md                              # Project documentation
└── results/
    ├── surface_plot.png                   # 3D temperature surface
    ├── contour_plot.png                   # Isothermal contour map
    ├── HAZ_visualization.png              # Heat affected zone image
    └── centerline_temperature.png         # Temperature along centerline
```

---

## 📊 Simulation Parameters Summary

| Parameter              | Value                                      |
|------------------------|--------------------------------------------|
| Domain Size            | 0.1 m × 0.1 m                              |
| Grid Resolution        | 40 × 40 nodes                              |
| Spatial Step (dx = dy) | ≈ 0.00256 m                                |
| Time Step (dt)         | 0.01 s                                     |
| Total Simulation Time  | 1.5 s (150 steps × 0.01 s)                 |
| Thermal Diffusivity    | 1×10⁻⁴ m²/s                                |
| Welding Speed          | 0.02 m/s                                   |
| Peak Heat Input        | 800 W/m³                                   |
| Stability Ratio (r)    | ≤ 0.25                                     |
| Dataset Sampling       | Every 4th node, every 5th time step        |

---



## 🚀 Applications

- Welding process simulation and parameter optimization
- Heat Affected Zone (HAZ) analysis and control
- Thermal stress and distortion prediction
- Automotive manufacturing — body panel and chassis welding
- Aerospace structures — fuselage and wing assembly
- Digital twin development for welding processes
- Academic study of numerical PDE methods (FDM)


## 📄 License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.
