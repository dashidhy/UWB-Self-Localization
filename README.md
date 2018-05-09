# Undergraduate_Thesis
My repo for my undergraduate thesis at THU. I propose a self-localization strategy for sensor networks based on MDS initialization，Adam optimization and ICP aligning. It works well for both static and dynamic networks in simulations. 

## Static network localization

### 2D space (10mx10m map):
<div align=center><img src="https://github.com/dashidhy/Undergraduate_Thesis/raw/master/figures/sim_2D_50_10.svg?sanitize=true"/></div>

### 3D space (10mx10mx10m map):
<div align=center><img src="https://github.com/dashidhy/Undergraduate_Thesis/raw/master/figures/sim_3D_50_10.svg?sanitize=true"/></div>

### Algorithm performance:

<div align=center><img src="https://github.com/dashidhy/Undergraduate_Thesis/raw/master/figures/Time.svg?sanitize=true"/></div>

<div align=center><img src="https://github.com/dashidhy/Undergraduate_Thesis/raw/master/figures/Bias_node.svg?sanitize=true"/></div>

## Very large scale network (100~1000 nodes)

###  In 100mx100m map:

<div align=center><img src="https://github.com/dashidhy/Undergraduate_Thesis/raw/master/figures/sim_2D_Dis_1000_10_r40.svg?sanitize=true"/></div>

---

## Dynamic network localization

### Without noise:

<div align=center><img src="https://github.com/dashidhy/Undergraduate_Thesis/raw/master/videos/Dynamic_Network_Simulation_without_noise.gif"/></div>

### With noise:

<div align=center><img src="https://github.com/dashidhy/Undergraduate_Thesis/raw/master/videos/Dynamic_Network_Simulation_with_noise.gif"/></div>

### Add a naive Kalman Filter:

<div align=center><img src="https://github.com/dashidhy/Undergraduate_Thesis/raw/master/videos/Dynamic_Network_Simulation_Kalman.gif"/></div>

